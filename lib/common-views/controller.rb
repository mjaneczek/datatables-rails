require 'common-views/responder'

module CommonViews
  module Controller
    def self.included(klass)
      klass.class_eval do
        self.responder = CommonViews::Responder
      
        protect_from_forgery with: :exception
        respond_to :html, :json

        include InstanceMethods
      end
    end

    module InstanceMethods

    end

  end
end