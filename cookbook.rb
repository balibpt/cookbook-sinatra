require 'pry-byebug'
require "csv"
require_relative 'recipe'

class Cookbook
  attr_accessor :recipes

  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path
    load_recipes
  end

  def all
    @recipes
  end

  def create(recipe)
    @recipes << recipe
    save_to_csv
  end

  def destroy(recipe_index)
    @recipes.delete_at(recipe_index)
    save_to_csv
  end

  def save_to_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.rating.to_i, recipe.done]
      end
    end
  end

  def load_recipes
    CSV.foreach(@csv_file_path) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3], row[4] == 'true')
    end
  end
end
