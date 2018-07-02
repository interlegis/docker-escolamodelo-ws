FROM ruby:2.5.1

ENV ESCOLA_MODELO_WS_GITHUB=https://github.com/interlegis/escolamodelo-ws.git \
    ESCOLA_MODELO_WS_VERSION=1.0.0-0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev && apt-get -y install apache2-utils
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
&& apt-get install -y yarn
RUN apt-get install -y imagemagick libc6 libffi6 libgcc1 libgmp-dev libssl1.1 libncurses5 libreadline7 libstdc++6 libtinfo5 libxml2 libxslt1-dev zlib1g zlib1g-dev netcat-traditional

# Configuring main directory
RUN mkdir -p /project_system/system
VOLUME ['/project_system']

RUN git clone ${ESCOLA_MODELO_WS_GITHUB} --depth=1 --branch ${ESCOLA_MODELO_WS_VERSION} /projeto/
RUN ln -sf /project_system/system /projeto/public/system
WORKDIR /projeto

# Setting env up
ENV RAILS_ENV='production'
ENV RAKE_ENV='production'

RUN bundle install --jobs 20 --retry 5 --without development test

RUN yarn install
RUN rails assets:precompile

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

