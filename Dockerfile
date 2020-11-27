FROM ruby:2.7.2

RUN curl -s https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get -qq update && \
    apt-get -qq upgrade -y && \
		# install node & yarn
		apt-get install -y nodejs
RUN apt-get -qq clean

RUN npm install -g yarn

## export RAILS_ENV for proper precompile
ARG RAILS_ENV
ARG SECRET_KEY_BASE
ENV NODE_ENV production

# Set the working directory.
WORKDIR /usr/src/app

# Copy the file from your host to your current location.
COPY Gemfile* ./

RUN bundle config set without 'test development'
RUN bundle install -j 4

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 3000

COPY package.json yarn.lock /usr/src/app/
RUN yarn install --ignore-engines

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . ./

# Compile assets
RUN bundle exec rake assets:precompile RAILS_ENV=$RAILS_ENV SECRET_KEY_BASE=$SECRET_KEY_BASE

# Start the application
CMD bin/rails-startup.sh