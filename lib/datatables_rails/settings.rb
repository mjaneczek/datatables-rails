module DatatablesRails
  class Settings
    @@settings = { }

    def self.load!(file_path)
      raw_config = File.read(file_path)
      @@settings = ActiveSupport::HashWithIndifferentAccess.new(YAML.load(raw_config))
    end

    def self.method_missing(name)
      @@settings[name.to_s] ||
      fail(NoMethodError, "unknown configuration root #{name}", caller)
    end
  end
end