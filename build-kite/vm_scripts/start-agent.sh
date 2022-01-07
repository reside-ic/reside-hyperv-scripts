#!/usr/bin/env bash
set -eu

## Login to vault with token
vault login -method=github

AS_AGENT="sudo -u buildkite-agent -H"

## Read docker info from vault and login
DOCKER_USERNAME=$(vault read -field=username secret/vimc-robot/dockerhub)
vault read -field=password secret/vimc-robot/dockerhub | \
  $AS_AGENT docker login -u $DOCKER_USERNAME --password-stdin

## Read buildkite agent token from vault and write into cfg
BUILDKITE_AGENT_TOKEN=$(vault read -field=token secret/buildkite/agent)
sudo sed -i "s/xxx/${BUILDKITE_AGENT_TOKEN}/g" /etc/buildkite-agent/buildkite-agent.cfg

# This is easier to do by
AGENT_SSH=~buildkite-agent/.ssh

mkdir -p $AGENT_SSH
vault read -field=public secret/vimc-robot/ssh > $AGENT_SSH/id_rsa.pub
vault read -field=private secret/vimc-robot/ssh > $AGENT_SSH/id_rsa
chmod 600 $AGENT_SSH/id_rsa
touch $AGENT_SSH/known_hosts
if ! grep -q '^github.com' $AGENT_SSH/known_hosts; then
    ssh-keyscan github.com >> $AGENT_SSH/known_hosts
fi

chown -R buildkite-agent.buildkite-agent $AGENT_SSH

# Add ssh key for authenticating with HIV servers
# (for running deployments via buildkite) on deployment agents
if [[ "$1" == "hint-deploy" ]]; then
  vault read -field=public secret/hiv/ssh > $AGENT_SSH/id_hiv.pub
  vault read -field=private secret/hiv/ssh > $AGENT_SSH/id_hiv
  chmod 600 $AGENT_SSH/id_hiv
fi

# NOTE: this is a fake email address for our robot account:
$AS_AGENT git config --global user.email "rich.fitzjohn+vimc@gmail.com"
$AS_AGENT git config --global user.name "vimc-robot"
$AS_AGENT git config --global push.default simple

# Add pipeline specific secrets to environment
HINT_CODECOV=$(vault read -field=token secret/hint/codecov)
MINT_CODECOV=$(vault read -field=token secret/mint/codecov)
ORDERLYWEB_CODECOV=$(vault read -field=token secret/vimc/orderly-web/codecov)
HINTR_CODECOV=$(vault read -field=token secret/hintr/codecov)
COMET_CODECOV=$(vault read -field=token secret/comet/codecov)
YOUTRACK_TOKEN=$(vault read -field=value secret/vimc-robot/youtrack-task-queue-token)
cat << EOF > /etc/buildkite-agent/hooks/environment
HINT_CODECOV=$HINT_CODECOV
MINT_CODECOV=$MINT_CODECOV
ORDERLYWEB_CODECOV=$ORDERLYWEB_CODECOV
HINTR_CODECOV=$HINTR_CODECOV
COMET_CODECOV=$COMET_CODECOV
export YOUTRACK_TOKEN=$YOUTRACK_TOKEN
EOF
cat << 'EOF' >> /etc/buildkite-agent/hooks/environment
export PATH=/var/lib/buildkite-agent/.local/bin:$PATH

if [[ "$BUILDKITE_PIPELINE_SLUG" == "hint" ]]; then
    CODECOV_TOKEN=$HINT_CODECOV
fi

if [[ "$BUILDKITE_PIPELINE_SLUG" == "mint" ]]; then
    CODECOV_TOKEN=$MINT_CODECOV
fi

if [[ "$BUILDKITE_PIPELINE_SLUG" == "orderly-web" ]]; then
    CODECOV_TOKEN=$ORDERLYWEB_CODECOV
fi

if [[ "$BUILDKITE_PIPELINE_SLUG" == "hintr" ]]; then
    CODECOV_TOKEN=$HINTR_CODECOV
fi

if [[ "$BUILDKITE_PIPELINE_SLUG" == "comet" ]]; then
    CODECOV_TOKEN=$COMET_CODECOV
fi

export CODECOV_TOKEN=$CODECOV_TOKEN
EOF

# Clean-up any remaining Docker containers after each job
cat >/etc/buildkite-agent/hooks/pre-exit <<'EOF'
docker rm --force $(docker ps --quiet) 2>/dev/null || true
EOF

TAG_STRING="tags=\"node-type=general,os=ubuntu,vmhost=$VMHOST_NAME,queue=$1\""
echo $TAG_STRING | sudo tee -a /etc/buildkite-agent/buildkite-agent.cfg

cat <<EOF > /etc/cron.daily/docker-cleanup
#!/usr/bin/env bash
docker system prune -af --volumes
docker rmi -f $(docker images -a -q)
EOF

chmod +x /etc/cron.daily/docker-cleanup

## Startup agent
sudo systemctl enable buildkite-agent && sudo systemctl start buildkite-agent

