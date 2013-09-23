module DatatablesRails
  class CustomizeService
    def initialize
      @registered_items = {}
    end

    def register(symbol, &block)
      @registered_items[symbol] = block
    end

    def try_call(symbol, parameters)
      @registered_items[symbol].call(*parameters) if @registered_items[symbol]
    end
  end
end