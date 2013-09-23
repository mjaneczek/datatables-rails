module DatatablesRails
  require 'rails'
  require 'active_support/core_ext'
  require 'require_helper'
  require 'datatables_rails/customize_service'
  require_dir("datatables_rails", "datatables_rails/data_source_types")

  class Railtie < Rails::Engine
    
  end
end
