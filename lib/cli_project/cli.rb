require_relative "./pickup_ultimate_app_classes.rb"
require_relative "./scraper.rb"
class CLI
  attr_accessor :city_url, :scraper
  def initialize
    @scraper = Scraper.new
    @city_url = "https://pickupultimate.com/map/city/"
    @domestic_index = 45
  end

  def call
    puts "Welcome to the Pickup Ultimate Finder App."
    # print City.all
    start
  end

  def welcome
    puts ""
    puts "Would you like to see domestic or international cities?"
    input = gets.strip.downcase
    # print input
    while !(input == "domestic" || input == "international")
      puts "Not a valid choice"
      input = gets.strip.downcase
    end

    puts ""
    return input
  end

  def start

    input = self.welcome
    self.print_cities(input)

    puts ""
    puts "What city would you like more information on? (put number in)"

    index = gets.strip.to_i

    print_game_information(index,input)

#make it so user can see more cities, and exit if done
    puts ""
    puts "Would you like to see another city?"

    flag = nil
    while flag != true
    input = gets.strip.downcase
      if input[0] == "y"
        flag = true
        self.start
      elsif input[0] == "n"
        flag = true
        puts "Hope you found a good game!"
        exit
      else
        puts "Not a valid response."
      end
    end

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

  def print_game_information(index,input)
  #handle it differently for domestic vs international
    if input == "domestic"
      city = City.all[index-1]
      #adds games to the city if it has never been done before
      if city.scraped == false
      #there need to be special cases written to determine url for Washington D.C.
        url_end = city.url.split("city/")[1]
        Game.add_from_Nokoguri(@scraper.scrape_city(@city_url+url_end), city)
        city.scraped = true
        self.print_games(city)
        #prints existing games if it has already been created
      else
        self.print_games(city)
      end
      #add/print games for international cities
    else
      city = City.all[index+@domestic_index-1]
      #check to see if games already exit for chosen city
      if city.scraped == false
        #URL exceptions for oddly named pages for cities
        url_end = city.url.split("city/")[1]
        Game.add_from_Nokoguri(@scraper.scrape_city(@city_url+url_end), city)
        self.print_games(city)
        city.scraped = true
        #prints existing games if it has already been created
      else
        self.print_games(city)
      end
    end
  end

  def print_games(city)
    if city.scraped == true && city.games.size == 0
      puts "No games found in this city!"
    else
      games = city.games
      games.each do |game|
        puts ""
        puts "Name: #{game.name}"
        puts "Description: #{game.description}"
      end
    end
  end

end
