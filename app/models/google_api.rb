require 'google/api_client'

class GoogleApi

  def initialize

    check_env_keys

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
      'ids'         => "ga:#{ENV['GA_API_PROFILE']}",
      'start-date'  => (Date.today - 7.years).to_s,
      'end-date'    => Date.today.to_s,
      'max-results' => 50
    }

  end

  def request(options={})
    @client.execute(api_method: @api_method, parameters: @parameters.merge(options))
  end

  def top_titles(limit)
    @response = request({
      dimensions: 'ga:customVarName1, ga:customVarValue1',
      metrics:    'ga:pageviews, ga:uniquePageviews, ga:sessions',
      sort:       '-ga:pageviews',
      filters:    'ga:customVarName1==titleId',
      'max-results' => limit
    })
    hashify
  end

  def title_stats(ids)
    regex    = ids.map{|id| "^#{id}$"}.join("|")
    @response = request({
      dimensions: "ga:customVarName1, ga:customVarValue1",
      metrics:    "ga:pageviews, ga:uniquePageviews, ga:sessions",
      sort:       "-ga:pageviews",
      filters:    "ga:customVarName1==titleId;ga:customVarValue1=~#{regex}"
    })
    hashify
  end

private

  def hashify
    injector = @response.data.rows.inject({}) do |memo, metric|
      memo[metric[1]] = {
        id: metric[1],
        pageviews: metric[2],
        visitors: metric[3],
        sessions: metric[4]
      }
      memo
    end
    Hashie::Mash.new(injector).values
  end

  def env_keys
    %w(GA_APP_NAME GA_APP_VERSION GA_API_EMAIL GA_API_KEYPATH GA_API_PROFILE)
  end

  def check_env_keys
    env_keys.each do |item|
      raise ArgumentError, "Value of ENV['#{item}'] must be specified. Please, check the README first." if ENV[item].nil? || ENV[item].empty?
    end
  end

end
