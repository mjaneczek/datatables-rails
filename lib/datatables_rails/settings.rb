module DatatablesRails
  class Settings
    @@settings = { }

    def self.load!(filename, options = {})
      raw_config = File.read(filename)
      @@settings = HashWithIndifferentAccess.new(YAML.load(raw_config))
    end

    def self.method_missing(name, *args, &block)
      @@settings[name.to_s] ||
      fail(NoMethodError, "unknown configuration root #{name}", caller)
    end
  end
end