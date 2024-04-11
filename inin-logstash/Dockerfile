FROM docker.elastic.co/logstash/logstash:8.5.1
COPY logstash-input-cloudwatch-logs /logstash-input-cloudwatch-logs

USER root
RUN echo "Asia/Taipei" > /etc/timezone && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN exec $SHELL

RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
RUN bash -c ". ~/.bashrc"

RUN exec $SHELL
RUN apt install -y rbenv

RUN rbenv install 3.1.2
RUN rbenv global 3.1.2
RUN bash -l -c "eval \"\$(rbenv init -)\""
RUN bash -l -c "ruby -v"
RUN bash -l -c "rbenv rehash"

# Install Bundler
RUN /bin/bash -l -c "gem install bundler"



RUN bundle install
RUN gem build logstash-input-cloudwatch_logs.gemspec


RUN logstash-plugin install --no-verify --local logstash-input-cloudwatch_logs-0.10.6.gem

COPY logstash.conf /usr/share/logstash/pipeline/
