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
  attr_accessor :name, :city, :description
  @@all = []

  def initialize(name, city)
    @name = name
    @city = city.name
    @@all << self
  end

  def self.add_from_Nokoguri(obj, city)
    scraper = Scraper.new
    names = []
    obj = scraper.scrape_city("https://pickupultimate.com/map/city/atlanta")
    obj.each do |game|
      name = game.css("h1").text
      new_game = Game.new(name, city) unless name.include?("Ultimate Frisbee Games in ")
      names << name unless name.include?("Ultimate Frisbee Games in ")
    end
    counter = 0
    contact_string = obj.text
    # print contact_string
    while counter < names.length
        str_process = contact_string.split("Description: ")
        description = str_process[1].split("view game")[0]
        str_process[2..-1].each{|x| x.prepend("Description: ")}
        contact_string = str_process[2..-1].join(" ")
        Game.all.select{|x| x.name == names[counter]}[0].description = description
        counter += 1
    end
  end


  def self.all
    @@all
  end


end
annarbor = City.new("Ann Arbor")
Game.add_from_Nokoguri("",annarbor)
print Game.all
