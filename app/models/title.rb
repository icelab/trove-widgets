require 'pstore'

class Title

  def initialize(file="#{Rails.root}/db/titles.pstore")
    @file = file
  end

  def store
    @store ||= PStore.new(@file)
  end

  def items(readonly=true)
    @items ||= Hashie::Mash.new(store.transaction{store[:title]}.inject({}){|memo, item| memo[item[:id]] = item; memo}).values
  end

  def sorted
    items.sort_by(&:name)
  end

  def add(title)
    store.transaction do
      store[:title] ||= []
      store[:title] << title
    end
  end

  def clear
    store.transaction do
      store[:title] = []
    end
  end

  def self.sync
    titles = self.new
    titles.clear
    State.new.items.each do |state|
      trove_api_titles = Trove::Client.new(key: ENV['TROVE_API_KEY']).titles_by_state(state.abbrev)
      trove_api_titles.newspaper.each do |newspaper|
        titles.add({id: newspaper.id, name: newspaper.title, abbrev: state.abbrev})
      end
    end
  end

end
