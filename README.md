# Trove widgets toolset

 Trove widgets is based on the [Trove API](http://help.nla.gov.au/trove/building-with-trove/api-technical-guide) and the [Trove gem](https://github.com/icelab/trove). Trove widgets is a Ruby on Rails application. See it in action here: [http://widgets.trovespace.webfactional.com](http://widgets.trovespace.webfactional.com).

## Development

### Cloning

    git clone git@github.com:icelab/trove-widgets.git
    cd trove-widgets

### Setup

Before starting, you will need Ruby (see [rbenv](https://github.com/sstephenson/rbenv) for easy installation) and [bundler](http://bundler.io/) installed.

From your trove-widgets folder:

    cp .env.example .env
    bundle --without production

### Configuration

Add the following settings to your .env file:

* `TROVE_API_KEY` - Your Trove API development key

If you would like to work with usage summary widgets, you will also need:

* `GA_APP_NAME` - Application name (any string, important for Google API wrapper)
* `GA_APP_VERSION` - Application version (any integer, important for Google API wrapper)
* `GA_API_EMAIL` - Looks like 12345@developer.gserviceaccount.com
* `GA_API_KEYPATH` - The path to the downloaded .p12 key file
* `GA_API_PROFILE` - GA profile id

To request access to Trove's analytics, please [contact Trove](http://librariesaustraliaref.nla.gov.au/reft100.aspx?pmi=tozT0aHGcV).

### Populating title information

You may want to fetch the latest Trove title information.

    rake trove:import_titles

### Running

    bundle exec foreman start -f Procfile.dev
    open http://localhost:3000

## Deploying your app to Heroku

## Setup

    heroku create your-app-name
    heroku addons:add memcachier:dev
    heroku config:add TROVE_API_KEY="your-development-key"

    heroku config:add GA_APP_NAME="your app name"
    heroku config:add GA_APP_VERSION=1
    heroku config:add GA_API_EMAIL="Google Analytics API Service Account Email here"
    heroku config:add GA_API_KEYPATH="local path to .p12 key file here"
    heroku config:add GA_API_PROFILE="GA profile id"

### Deploy

    git push heroku master

## Capistrano deployment

Capistrano is used to deploy this app to http://widgets.trovespace.webfactional.com

### Setup

* On Webfactional, add your public key to /home/trovespace/.ssh/authorized_keys first.
* `bundle exec cap deploy:setup` – prepares your server for deployment.
* Copy .env file to /home/trovespace/webapps/widgets/shared end set contained variables.
* `bundle exec cap deploy:cold` – deploys project for the first time.

### Deploy

* `bundle exec cap deploy` – deploys project. This calls both `update' and `restart'.

### Restarting the application

* `bundle exec cap deploy:restart` – stops and starts Unicorn server

## Contributing

We encourage you to collaborate with us on this project.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
