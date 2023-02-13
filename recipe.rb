class Recipe
  attr_accessor :name, :description, :prep_time, :rating, :done

  def initialize(name, description, prep_time, rating, done)
    @name = name
    @description = description
    @prep_time = prep_time
    @rating = rating
    @done = done || false
  end

  def done!
    @done = true
  end
end
