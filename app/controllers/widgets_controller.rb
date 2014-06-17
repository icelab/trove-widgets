class WidgetsController < ApplicationController

  require 'net/http'
  layout 'widgets'

  def summary
    json = parse("newspaper/title/#{params[:titles]}?include=years")
    newspaper = json['newspaper']
    @id = newspaper['id']
    @title = newspaper['title'].split('(').first
    @url = newspaper['troveUrl']
    @start_date = newspaper['startDate'].to_date.strftime('%Y')
    @end_date = newspaper['endDate'].to_date.strftime('%Y')
    @issuecount = newspaper['year'].inject(0){|memo, el| memo + el['issuecount'].to_i}
  end

private

  def parse(params)
    response = Net::HTTP.get_response(URI.parse("#{ENV['TROVE_API_URL']}/#{params}&key=#{ENV['TROVE_API_KEY']}&encoding=json"))
    JSON.parse(response.body)
  end

end
