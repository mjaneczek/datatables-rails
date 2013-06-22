require 'action_controller/base'

module CommonRails
  class Railtie < ::Rails::Railtie
    if config.respond_to?(:app_generators)
      #config.app_generators.scaffold_controller = :nmc_controller
      #config.app_generators.template_engine :nmc
      config.app_generators.stylesheets = false
    else
      #config.generators.scaffold_controller = :nmc_controller
      config.generators.stylesheets = false
    end
  end
end
