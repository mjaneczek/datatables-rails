require 'action_controller/base'

module CommonRails
  class Railtie < ::Rails::Railtie
    config.app_generators do |g|
    #config.app_generators.scaffold_controller = :nmc_controller
    #config.app_generators.template_engine :nmc
      g.templates.unshift File::expand_path('../templates', __FILE__)
      g.stylesheets = false
    end
    
    rake_tasks do
      load "tasks/db_all.rake"
    end
  end
end
