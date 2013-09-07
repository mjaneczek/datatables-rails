require 'rails'
require 'common_views/helpers'
require 'common_views/settings'

module CommonViews
  class Railtie < ::Rails::Engine

    #config.app_generators do |g|
      #config.app_generators.scaffold_controller = :scaffold_controller
      #g.templates.unshift File::expand_path('../templates', __FILE__)
      #g.stylesheets = false
      #end

    #initializer "extend Controller with sorcery" do |app|
      #ActionController::Base.send(:include, CommonViews::Controller)
      #ActionView::Base.send(:include, CommonViews::Helpers)
      #end
  end
end
