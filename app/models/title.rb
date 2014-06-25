class Title < ActiveRecord::Base

  self.primary_key = :trove_id
  belongs_to :state, class_name: State

  def self.import_stats
    all.each do |title|
      @client = Trove::Client.new(key: ENV['TROVE_API_KEY'])
      issues = @client.title_include_years(title.trove_id).year.inject(0){|memo, el| memo + el.issuecount.to_i}
      articles = @client.title_articles_count(title.trove_id)
      comments = @client.title_comments_count(title.trove_id)
      tags = @client.title_tags_count(title.trove_id)
      title.update(issue_count: issues, article_count: articles, comment_count: comments, tag_count: tags)
      sleep 5.seconds
    end
  end

end
