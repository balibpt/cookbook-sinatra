require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
set :bind, "0.0.0.0"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

require_relative 'cookbook'
require_relative 'recipe'
require_relative 'parser'

get '/' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :form
end

get '/delete/:id' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  @recipes = cookbook.all
  cookbook.destroy(params[:id].to_i)
  redirect to '/'
end

get '/import/:id' do
  # recipes[params(:id)]
  recipe_added = Farser.recipes[params[:id].to_i]
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  recipe = Recipe.new(recipe_added.name, recipe_added.description, recipe_added.prep_time, recipe_added.rating, recipe_added.done)
  cookbook.create(recipe)
  redirect to '/'
end

get '/mark_done/:id' do
  @cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  recipe = @cookbook.recipes[params[:id].to_i]
  recipe.done!
  @cookbook.save_to_csv
  redirect to '/'
end

post '/create' do
  # creating a new recipe
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  recipe = Recipe.new(params[:name], params[:description], params[:preptime], params[:rating], false)
  cookbook.create(recipe)
  # redirect to root page
  redirect to '/'
end

get '/import' do
  erb :import
end

post '/scrape' do
  @recipes = Farser.search_recipes(params[:ingredient])
  @keyword = params[:ingredient]

  erb :scrapper
end


# def recipes
#   @recipes ||= parser.search_recipes(params[:keyword])
# end

# def parser
#   @parser ||= Farser.new
# end
