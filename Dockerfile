FROM ruby:2.4.2
RUN apt-get update -qq && \
apt-get install -y build-essential libpq-dev curl python-software-properties && \
curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
apt-get -y install nodejs && \
npm install yarn -g && \
mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
CMD /myapp/start.sh