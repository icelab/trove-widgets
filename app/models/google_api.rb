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
    result = request({
      'dimensions' => 'ga:pagePath, ga:pageTitle',
      'metrics'    => 'ga:pageviews',
      'sort'       => '-ga:pageviews',
      'max-results' => 150
    })
    p result.inspect
  end

end
