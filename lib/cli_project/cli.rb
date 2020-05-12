require_relative "./pickup_ultimate_app_classes.rb"
require_relative "./scraper.rb"
class CLI
  attr_accessor :city_url, :scraper
  def initialize
    @scraper = Scraper.new
    City.add_from_Nokoguri(scraper.scrape_index)
    @city_url = "https://pickupultimate.com/map/city/"
    @domestic_index = 45
  end

  def call
    puts "Welcome to the Pickup Ultimate Finder App."
    # print City.all
    start
  end

  def start
    puts ""
    puts "Would you like to see domestic or international cities?"
    input = gets.downcase.strip
    # print input
    if !(input == "domestic" || input == "international")
      puts "Not a valid choice"
      self.start
    end

    puts ""

    self.print_cities(input)

    puts ""
    puts "What city would you like more information on? (put number in)"

    index = gets.strip.to_i
    city = City.all[index-1]
#handle it differently for domestic vs international
    if input == "domestic"
      #adds games to the city if it has never been done before
      if city.games.size == 0
      #there need to be special cases written to determine url for Washington D.C.
        if index == 45
          url_end = "washingtondc"
        else
          url_end = city.name.split(", ")[0].downcase.gsub(/\s/, "")
        end
        # puts "#{@city_url + url_end}"
        Game.add_from_Nokoguri(@scraper.scrape_city(@city_url+url_end), city)
        # puts "#{city.games}"
        # puts "#{Game.all}"
        # print self.class
        self.print_games(city)
        #prints existing games if it has already been created
      else
        self.print_games(city)
      end
    else
    end

    #  print Game.all

  end


  def print_cities(input)
    if input == "domestic"
      #I tried to do this with each_with_index but the index didn't increment for some reason
      counter = 0
      City.all.each do |x|
        while counter < @domestic_index
          puts "#{counter + 1}. #{City.all[counter].name}"
          counter += 1
        end
      end

    else
      counter = 45
      City.all.each do |x|
        while counter < City.all.size
          puts "#{counter - 44}. #{City.all[counter].name}"
          counter += 1
        end
      end
    end
  end


  def print_games(city)
    games = city.games
    games.each do |game|
      puts ""
      puts "Name: #{game.name}"
      puts "Description: #{game.description}"
    end
  end

end

CLI.new.call
# print City.all[45].name.split(", ")[0].downcase.strip
# print City.all[44].name

# elsif input == "international"
#   if city == 8
#     url_end = "hongkong"
#   elsif city == 22
#     url_end = "singapore"
#   elsif city == 24
#     url_end = "hague"
#   end
