module DatatablesRails
  class CustomizeService
    class << self
      @@registered_items = {}

      def register(symbol, &block)
        @@registered_items[symbol] = block
      end

      def try_call(symbol, parameters)
        @@registered_items[symbol].call(*parameters) if @@registered_items[symbol]
      end
    end
  end
end