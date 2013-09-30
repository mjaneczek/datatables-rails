require 'rails/generators'

module DatatablesRails
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../initializing_files", __FILE__) 

    def add_datatables_rails_initializer
      copy_file "datatables_settings.rb", "config/initializers/datatables_settings.rb"
      copy_file "config_file.yml", "config/datatables_config.yml"
    end
  end
end