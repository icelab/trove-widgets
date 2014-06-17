class Widgets::SummaryController < ApplicationController

  require 'net/http'
  layout 'widgets'

  def single
    @titles = titles_hash(params[:ids])
  end

  def multiple
    @titles = titles_hash(params[:ids])
  end

private

  def parse(params)
    response = Net::HTTP.get_response(URI.parse("#{ENV['TROVE_API_URL']}/#{params}&key=#{ENV['TROVE_API_KEY']}&encoding=json"))
    JSON.parse(response.body)
  end

  def titles_hash(ids)
    titles = []
    ids.split(',').each do |title|
      json = parse("newspaper/title/#{title}?include=years")
      newspaper = json['newspaper']
      titles << {
        id: newspaper['id'],
        name: newspaper['title'].split('(').first,
        url: newspaper['troveUrl'],
        start_date: newspaper['startDate'].to_date.strftime('%Y'),
        end_date: newspaper['endDate'].to_date.strftime('%Y'),
        issuecount: newspaper['year'].inject(0){|memo, el| memo + el['issuecount'].to_i}
      }
    end
    titles
  end

end
