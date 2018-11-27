module CoffeeShop
  class Ingredient::Base
    def initialize(value)
      @value = if value < 0
        -1
      elsif value > 1
        1
      else
        value
      end
    end
  end
end
