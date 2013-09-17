require 'datatables_rails/helpers'
require 'datatables_rails/settings'

module DatatablesRails
  class Railtie < ::Rails::Engine

    #config.app_generators do |g|
      #config.app_generators.scaffold_controller = :scaffold_controller
      #g.templates.unshift File::expand_path('../templates', __FILE__)
      #g.stylesheets = false
      #end

    #initializer "extend Controller with sorcery" do |app|
      #ActionController::Base.send(:include, DatatablesRails::Controller)
      #ActionView::Base.send(:include, DatatablesRails::Helpers)
      #end
  end
end
