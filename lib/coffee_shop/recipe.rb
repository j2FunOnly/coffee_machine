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
end
