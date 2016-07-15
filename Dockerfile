### QNIBTerminal debian image
FROM qnib/d-supervisor

ENV TERM=xterm \
    BOOTSTRAP_CONSUL=false \
    CONSUL_VER=0.6.4 \
    CONSUL_CLI_VER=0.2.0 \
    CT_VER=0.15.0 \
    QNIB_CONSUL=0.1.1
RUN apt-get update && \
    apt-get install -y bsdtar curl jq bc
RUN curl -fsL https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip | bsdtar xf - -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/consul
RUN mkdir -p /opt/consul-web-ui/ && \
    curl -fsL http://dl.bintray.com/mitchellh/consul/${CONSUL_VER}_web_ui.zip | bsdtar xf - -C /opt/consul-web-ui/ && \
    unset CONSUL_VER
RUN curl -Lsf https://releases.hashicorp.com/consul-template/${CT_VER}/consul-template_${CT_VER}_linux_amd64.zip | bsdtar xf - -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/consul-template && \
    unset CT_VER
RUN curl -fsL https://github.com/qnib/consul-content/releases/download/${QNIB_CONSUL}/consul.tar |tar xf - -C /opt/qnib/

ADD etc/consul.d/agent.json /etc/consul.d/
ADD etc/supervisord.d/consul.ini /etc/supervisord.d/
RUN mkdir -p /opt/qnib/bin && \
    ln -s /opt/qnib/consul/bin/start.sh /opt/qnib/bin/start_consul.sh
