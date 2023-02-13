require 'open-uri'
require 'nokogiri'
require 'pry-byebug'
require_relative 'recipe'


class Farser
  @recipes = []

  class << self
    attr_reader :recipes
  end
  # def initialize
  #   @imported = []
  # end

  def self.search_recipes(ingredient)
    html_file = URI.open("https://www.allrecipes.com/search?q=#{ingredient}").read
    html_doc = Nokogiri::HTML.parse(html_file)
    # binding-pry
    recipes = []

    html_doc.search('a.card').each do |ele|
      break if recipes.size == 5
      link = ele.attribute("href")
      recipe_file = URI.open(link).read
      recipe_doc = Nokogiri::HTML.parse(recipe_file)
      next if recipe_doc.search(".mntl-recipe-details__value").empty?
      name = recipe_doc.search("#article-heading_2-0").text.strip
      rating = recipe_doc.search("#mntl-recipe-review-bar__rating_2-0").text.strip.to_f
      description = recipe_doc.search("#article-subheading_2-0").text.strip
      prep_time = recipe_doc.search(".mntl-recipe-details__value").first.text.strip

      @recipes << Recipe.new(name, description, prep_time, rating)
    end
    return @recipes
  end
end
