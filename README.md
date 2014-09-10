# [Trove library](http://trove.nla.gov.au/) widgets toolset

Based on [Trove (trove.nla.gov.au) API](http://help.nla.gov.au/trove/building-with-trove/api-technical-guide) and [Trove gem](https://github.com/icelab/trove)

## Development

### Cloning

    git clone git@bitbucket.org:icelab/trove-widgets.git
    cd trove-widgets

### Setup

    cp .env.example .env
    bundle --without production
    git remote add heroku git@heroku.com:trove-widgets.git
    rake trove:import_titles

### Configuration

There are few things you will need to add to .env for it to work:

* `TROVE_API_KEY` - Your Trove API development key
* `GA_APP_NAME` - Application name (any string, important for Google API wrapper)
* `GA_APP_VERSION` - Application version (any integer, important for Google API wrapper)
* `GA_API_EMAIL` - Looks like 12345@developer.gserviceaccount.com
* `GA_API_KEYPATH` - The path to the downloaded .p12 key file
* `GA_API_PROFILE` - GA profile id

### Running

    bundle exec foreman start -f Procfile.dev

## Heroku

## Setup

    heroku create trove-widgets
    heroku addons:add memcachier:dev
    heroku config:add TROVE_API_KEY={your developmen key}
    heroku config:add GA_APP_NAME=trove-widgets
    heroku config:add GA_APP_VERSION=1
    heroku config:add GA_API_EMAIL={Google Analytics API Service Account Email}
    heroku config:add GA_API_KEYPATH={local path to .p12 key file}
    heroku config:add GA_API_PROFILE={GA profile id}

### Deploy

    git push heroku master

## Capistrano (for dedicated servers)

## Setup

* Add your public key to /home/trovespace/.ssh/authorized_keys first.
* `bundle exec cap deploy:setup` – prepares your server for deployment.
* Copy .env file to /home/trovespace/webapps/widgets/shared end set contained variables.
* `bundle exec cap deploy:cold` – deploys project.

## Deploy

* `bundle exec cap deploy` – deploys project. This calls both `update' and `restart'.
* `bundle exec cap deploy:restart` – stops and starts Unicorn server

