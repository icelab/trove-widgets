require 'google/api_client'

class GoogleApi

  def initialize

    @client  = Google::APIClient.new(application_name: ENV['GA_APP_NAME'], application_version: ENV['GA_APP_VERSION'])

    @client.authorization = Signet::OAuth2::Client.new(
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      audience:             'https://accounts.google.com/o/oauth2/token',
      scope:                'https://www.googleapis.com/auth/analytics.readonly',
      issuer:               ENV['GA_API_EMAIL'],
      signing_key:          Google::APIClient::PKCS12.load_key(ENV['GA_API_KEYPATH'], 'notasecret')
    ).tap { |auth| auth.fetch_access_token! }

    @api_method = @client.discovered_api('analytics','v3').data.ga.get

    @parameters = {
      'ids'         => ENV['GA_API_PROFILE'],
      'start-date'  => (Date.today - 7.years).to_s,
      'end-date'    => Date.today.to_s,
      'max-results' => 50
    }

  end

  def request(options={})
    @client.execute(api_method: @api_method, parameters: @parameters.merge(options))
  end

  def pageviews
    request({
      dimensions: 'ga:hostname, ga:pagePath, ga:pageTitle',
      metrics:    'ga:pageviews, ga:uniquePageviews',
      sort:       '-ga:pageviews',
    }).data.rows
  end

  def countries
    request({
      dimensions: 'ga:country',
      metrics:    'ga:sessions',
      sort:       '-ga:sessions',
      filters:    'ga:country!=(not set)'
    }).data.rows
  end

  def cities
    request({
      dimensions: 'ga:city',
      metrics:    'ga:sessions',
      sort:       '-ga:sessions',
      filters:    'ga:city!=(not set)'
    }).data.rows
  end

end
