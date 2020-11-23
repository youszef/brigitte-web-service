FROM ruby:2.7.2-slim

# TODO push git dependant gems to rubygems and avoid installing git to keep footrpint small
# install git
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git &&\
		# lib needed for building nokogiri
    apt-get install -y build-essential &&\
		# lib & headers for postgres dev
    apt-get install -y libpq-dev

# Set the working directory.
WORKDIR /usr/src/app

# Copy the file from your host to your current location.
COPY Gemfile* ./

RUN bundle config set without 'test development'
RUN bundle install -j 4

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 80

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . ./

# Start the application
CMD [ 'rails', 'server' ]