require 'rails/generators'

module DatatablesRails
  module Generators
    class HelpersGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/helpers", __FILE__)

      desc "Generate common helpers"

      def copy_standard_files
        #directory 'files', '.', force: options.force?

        inject_into_class "app/controllers/application_controller.rb", "ApplicationController", <<-RUBY
  helper DatatablesRails::Helpers
        RUBY
      end

    end
  end
end