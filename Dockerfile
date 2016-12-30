FROM node:7.3
MAINTAINER tgagor, https://github.com/tgagor

# EXPOSE 8080/tcp

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

COPY ./files/runsvdir-start /usr/local/sbin/runsvdir-start
RUN apt-get update \
  && apt-get install --yes --force-yes runit \
  && chmod +x /usr/local/sbin/runsvdir-start \
  && rm -rf /var/lib/apt/lists/*

COPY ./files/etc /etc

RUN npm install -g yo generator-hubot plugin \
  hubot-slack hubot-jenkins-slack hubot-jenkins \
  hubot-grafana

ENV HUBOT_HOME /opt/hubot
ENV HUBOT_NAME hu
ENV HUBOT_ADAPTER slack
ENV HUBOT_DESC "Helpful robot"
ENV HUBOT_OWNER "tgagor <tg@tg>"
ENV HUBOT_JENKINS_URL "http://localhost:8080"
ENV HUBOT_JENKINS_AUTH "user:password"
ENV HUBOT_GRAFANA_HOST "http://play.grafana.org"
ENV HUBOT_GRAFANA_API_KEY	"API key"
ENV HUBOT_GRAFANA_QUERY_TIME_RANGE "6h"
ENV HUBOT_SLACK_TOKEN "slack token"

# run it as unprivileged user
RUN groupadd -g 1100 hubot \
  && useradd -ms /bin/bash -u 1100 -g hubot -d "$HUBOT_HOME" hubot \
  && mkdir -p "$HUBOT_HOME" \
  && chown -R hubot:hubot "$HUBOT_HOME"

ENTRYPOINT ["/usr/local/sbin/runsvdir-start"]

USER hubot
WORKDIR $HUBOT_HOME

RUN cd "$HUBOT_HOME" \
  && yo hubot --owner="$HUBOT_OWNER" \
        --name="$HUBOT_NAME" \
        --description="$HUBOT_DESC" \
        --adapter="$HUBOT_ADAPTER" \
        --defaults

COPY ./files/external-scripts.json "$HUBOT_HOME"

# USER root

# ENTRYPOINT ["exec runsvdir -P /etc/service 'log: ...........................................................................................................................................................................................................................................................................................................................................................................................................'"]
