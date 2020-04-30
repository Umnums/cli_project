require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  def get_page(url)
    Nokogiri::HTML(open(url))
  end

  def scrape_index
    doc = self.get_page(@index_url)
    cities = []
    list = doc.css(".col-wrapper-357f4 li a")
    list.each{|x| cities << x.text}
    print cities
    return cities
  end

  def scrape_city(city_url)
    doc = self.get_page(city_url)
    games = doc.css(".content_box")
    print games
  end

  def initialize
    @index_url = "https://pickupultimate.com/cities"
  end


end

city_url = "https://pickupultimate.com/map/city/annarbor"
scraper = Scraper.new
scraper.scrape_index
