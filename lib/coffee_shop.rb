module CoffeeShop
  class Recipe
    APPLICABLE = ['lemon', 'sugar']
    MAX_VALUE = {
      'sugar' => 9
    }

    attr_reader :name, :ingredients

    def prepare(name, ingredients, changes = {})
      @name = name
      @ingredients = ingredients.dup
      change(changes)
    end

    def change(new_values)
      new_values.each do |k, v|
        next unless APPLICABLE.include?(k) || ingredients.has_key?(k)

        value = ingredients.fetch(k, 0) + normalize_value(k, v)
        ingredients[k] = value < 0 ? 0 : value
      end
    end

    private

    def normalize_value(ingredient, value)
      if value < 0
        -1
      else
        max = MAX_VALUE[ingredient] || 1
        value > max ? max : value
      end
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

    def initialize(recipe = Recipe.new)
      @stat = Hash.new(0)
      @status = {}
      @recipe = recipe
    end

    def load
      @status = Hash[INGREDIENTS.map { |i| [i, MAX_VOLUME] }]
    end

    def order(recipe_name, changes = {})
      ingredients = RECIPES[recipe_name]
      return nil if ingredients.nil?

      @recipe.prepare(recipe_name, ingredients, changes)
      make
    end

    private

    def make
      return nil unless available?

      use_ingredients
      write_to_stat

      true
    end

    def available?
      @recipe.ingredients.all? do |ingredient, value|
        @status[ingredient] - value >= 0
      end
    end

    def write_to_stat
      @stat[@recipe.name] += 1
    end

    def use_ingredients
      @recipe.ingredients.each do |ingredient, value|
        @status[ingredient] -= value
      end
    end
  end
end
