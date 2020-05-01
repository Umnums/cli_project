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

class Game
  attr_accessor :name, :contact, :city, :description
  @@all = []

  def initialize(name, city)
    @name = name
    @contact = contact
    @city = city.name
    @@all << self
  end

  def self.add_from_Nokoguri(obj, city)
    scraper = Scraper.new
    names = []
    obj = scraper.scrape_city("https://pickupultimate.com/map/city/annarbor")
    obj.each do |game|
      name = game.css("h1").text
      new_game = Game.new(name, city) unless name.include?("Ultimate Frisbee Games in ")
      names << name
    end
    counter = 0
    while counter < names.length
      contact = obj.text.split("Contact: ")[1].split(/\s/)
      # puts "#{Game.all[counter].name}"
      # puts "#{names[counter]}"
      puts "#{names}"
      # puts "#{Game.all.select{|x| x.name == names[counter]}}"
      counter += 1
    end
  end

  def self.all
    @@all
  end


end
annarbor = City.new("Ann Arbor")
Game.add_from_Nokoguri("",annarbor)
# print Game.all
