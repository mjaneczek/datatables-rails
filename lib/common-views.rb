require 'rails'
require 'common-views/helpers'
require 'common-views/controller'

module CommonViews
  class Railtie < ::Rails::Railtie

    config.app_generators do |g|
      config.app_generators.scaffold_controller = :scaffold_controller
      g.templates.unshift File::expand_path('../templates', __FILE__)
      g.stylesheets = false
    end

    initializer "extend Controller with sorcery" do |app|
      ActionController::Base.send(:include, CommonViews::Controller)
      ActionView::Base.send(:include, CommonViews::Helpers)
    end

    rake_tasks do
      load "tasks/db_all.rake"
    end
  end
end
