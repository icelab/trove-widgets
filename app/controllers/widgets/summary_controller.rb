class Widgets::SummaryController < ApplicationController

  require 'net/http'
  layout 'widgets'

  def single
    @newspapers = get_items(params[:ids])
  end

  def multiple
    @newspapers = get_items(params[:ids])
  end

  def state
    json = request_json("newspaper/titles?state=#{params[:state]}")
    @state = params[:state].upcase
    @issuecount = json['response']['records']['total']
    @newspapers = json['response']['records']['newspaper'].inject([]){|memo, newspaper| memo << convert_items(newspaper); memo}
    dates = @newspapers.map{|item| item[:start_date]}
    @start_date = dates.min
    @end_date = dates.max
  end

private

  def request_json(params)
    response = Net::HTTP.get_response(URI.parse("#{ENV['TROVE_API_URL']}/#{params}&key=#{ENV['TROVE_API_KEY']}&encoding=json"))
    JSON.parse(response.body)
  end

  def get_items(ids)
    items = []
    ids.split(',').each do |title|
      json = request_json("newspaper/title/#{title}?include=years")
      items << convert_items(json['newspaper'])
    end
    items
  end

  def convert_items(json)
    response = {}
    response[:id] = json['id']
    response[:title] = json['title'].split('(').first.strip
    response[:url] = json['troveUrl']
    response[:start_date] = json['startDate'].to_date.strftime('%Y')
    response[:end_date] = json['endDate'].to_date.strftime('%Y')
    response[:issuecount] = json['year'].inject(0){|memo, el| memo + el['issuecount'].to_i} if json['year']
    response
  end

end
