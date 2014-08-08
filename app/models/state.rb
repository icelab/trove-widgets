class State

  def items
    @items ||= Hashie::Mash.new(YAML.load_file("#{Rails.root}/config/states.yml")).states.values
  end

  def sorted
    items.sort_by(&:abbrev)
  end

  def abbrevs
    items.map(&:abbrev)
  end

  def names
    items.map(&:name)
  end

  def find_by_abbrev(abbrev)
    items.detect{|state| state.abbrev == abbrev}.merge(titles: Title.new.find_by_state(abbrev))
  end

end
