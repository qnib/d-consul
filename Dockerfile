### QNIBTerminal debian image
FROM qnib/d-supervisor

ENV TERM=xterm \
    BOOTSTRAP_CONSUL=false \
    RUN_SERVER=false \
    CONSUL_VER=0.6.3 \
    CT_VER=0.11.1
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

ADD etc/consul.json /etc/consul.json
ADD etc/supervisord.d/consul.ini /etc/supervisord.d/
ADD opt/qnib/consul/bin/start.sh /opt/qnib/consul/bin/
RUN mkdir -p /opt/qnib/bin && \
    ln -s /opt/qnib/consul/bin/start.sh /opt/qnib/bin/start_consul.sh
ADD opt/qnib/consul/etc/bash_functions.sh /opt/qnib/consul/etc/
