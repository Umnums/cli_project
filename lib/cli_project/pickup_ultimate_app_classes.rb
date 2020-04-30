require_relative "./scraper.rb"

class City
  attr_accessor :games, :name
  @@all = []

  def initialize(name)
    @name = name
    @@all << self
    @games = []
  end

  def self.all
    @@all
  end

  def self.add_from_Nokoguri(obj)
    # scraper = Scraper.new
    # obj = scraper.scrape_index
    obj.each{|x| City.new(x)}
  end

end

def Game
  attr_accessor :name, :contact, :city, :description
  @@all = []

  def initialize(name, city)
    @name = name
    @contact = contact
    @city = city.name
    @@all < self
  end

  def self.add_from_Nokoguri(obj, city)
    obj.each do |game|
      name = game.css("h1").text
      new_game = Game.new(name, city) unless name.include?("Ultimate Frisbee Games in ")
      new_game.contact = game.css(name)


end

City.add_from_Nokoguri("")
print City.all
