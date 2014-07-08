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

### Running

    bundle exec foreman start -f Procfile.dev

## Heroku Deploy

    git push heroku master

## Heroku Setup

    heroku create trove-widgets
    heroku addons:add memcachier:dev
    heroku config:add TROVE_API_KEY={your developmen key}
