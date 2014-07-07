class State

  attr_reader :states

  def self.all
    State.new
  end

  def initialize
    @states = Hashie::Mash.new(YAML.load_file("#{Rails.root}/config/states.yml")).states.values
  end

  def sorted
    @states.sort_by(&:abbrev)
  end

  def abbrevs
    @states.map(&:abbrev)
  end

  def names
    @states.map(&:name)
  end

  def find_by_abbrev(abbrev)
    @states.detect{|state| state.abbrev == abbrev}
  end

end
