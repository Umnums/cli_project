require 'open-uri'
require 'pry'
require 'nokogiri'
require_relative "./pickup_ultimate_app_classes.rb"

class Scraper

  def initialize
    @index_url = "https://pickupultimate.com/cities"
  end

  def get_page(url)
    Nokogiri::HTML(open(url))
  end

  def scrape_index
    doc = self.get_page(@index_url)
    list = doc.css(".col-wrapper-357f4 li a")
    list.each do |x|
      city = City.new(x.text)
      city.url = x.attr("href")
    end
  end

  def scrape_city(city_url)
    doc = self.get_page(city_url)
    games = doc.css(".content_box")
    games
  end

end


# city_url = "https://pickupultimate.com/map/city/annarbor"
scraper = Scraper.new
scraper.scrape_index
