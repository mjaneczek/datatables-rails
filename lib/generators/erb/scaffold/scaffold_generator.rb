require 'rails/generators/erb/scaffold/scaffold_generator'

module Erb
  module Generators
    class ScaffoldGenerator < Erb::Generators::ScaffoldGenerator
      source_root File.expand_path("../templates", __FILE__)

      protected

        def available_views
          %w(index edit new _form)
        end

    end
  end
end