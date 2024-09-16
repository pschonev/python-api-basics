# Dockerfile
FROM ruby:3.1-slim-bullseye as jekyll

# Install dependencies and Jekyll
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && gem update --system \
    && gem install jekyll

EXPOSE 4000 35729

WORKDIR /site

# Build from the image we just built with different metadata
FROM jekyll as jekyll-serve

# Copy Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock /site/

# Install the necessary gems
RUN bundle install --jobs=4 --retry=3

# Copy the rest of the application code
COPY . /site

CMD [ "bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000", "--livereload" ]
