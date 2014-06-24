class TroveApi

  def initialize
    @client = Trove::Client.new(key: ENV['TROVE_API_KEY'])
  end

  def single_include_years(id)
    titles = []
    response = @client.title_include_years(id)
    response = data_comb(response)
    response = combine_issues(response)
    titles << response
  end

  def multiple_include_years(ids)
    titles = []
    ids.split(',').each do |id|
      response = @client.title_include_years(id)
      response = data_comb(response)
      response = combine_issues(response)
      titles << response
    end
    titles
  end

  def state(state)
    response = @client.titles_by_state(state)
    {total: response.total, titles: response.newspaper.inject([]){|memo, newspaper| memo << data_comb(newspaper); memo}}
  end

private

  def data_comb(data)
    data[:title] = data.title.split('(').first.strip
    data[:url] = data.troveUrl
    data[:start_date] = data.startDate.to_date.strftime('%Y')
    data[:end_date] = data.endDate.to_date.strftime('%Y')
    data
  end

  def combine_issues(data)
    data[:issuecount] = data.year.inject(0){|memo, el| memo + el['issuecount'].to_i} if data.year
    data
  end

end
