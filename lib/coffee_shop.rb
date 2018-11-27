module CoffeeShop
  class Recipe
    attr_reader :ingredients

    def initialize(name, ingredients)
      @name = name
      @ingredients = ingredients.dup
    end

    def change(new_values)
      new_values.each do |k, v|
        next unless ['lemon', 'sugar'].include?(k) || ingredients.has_key?(k)

        v = normalize_value(k, v)

        value = ingredients.fetch(k, 0) + v
        ingredients[k] = value < 0 ? 0 : value
      end
    end

    def normalize_value(ingredient, value)
      if value < 0
        -1
      elsif ingredient == 'sugar'
        value > 9 ? 9 : value
      else
        1
      end
    end

    def to_s
      @name
    end
  end

  class CoffeeMachine
    INGREDIENTS = %w(coffee tea chocolate cream lemon sugar)
    MAX_VOLUME = 50

    RECIPES = {
      'tea' => {
        'tea' => 1,
        'sugar' => 2
      },
      'coffee' => {
        'coffee' => 1,
        'cream' => 1,
        'sugar' => 1
      }
    }

    attr_reader :status, :stat

    def initialize
      @stat = Hash.new(0)
      @status = {}
    end

    def load
      @status = Hash[INGREDIENTS.map { |i| [i, MAX_VOLUME] }]
    end

    def order(recipe, changes = {})
      ingredients = RECIPES[recipe]
      return ingredients if ingredients.nil?

      recipe = Recipe.new(recipe, ingredients)
      recipe.change(changes)

      make(recipe)
    end

    private

    def make(recipe)
      return nil unless available? recipe

      record_to_stat(recipe.to_s)
      use_ingredients(recipe.ingredients)

      true
    end

    def available?(recipe)
      recipe.ingredients.all? do |ingredient, value|
        @status[ingredient] - value >= 0
      end
    end

    def record_to_stat(recipe)
      @stat[recipe] += 1
    end

    def use_ingredients(ingredients)
      ingredients.each do |ingredient, value|
        @status[ingredient] -= value
      end
    end
  end
end
