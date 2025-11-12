module Neighborly
  module Api
    class Engine < ::Rails::Engine
      isolate_namespace Neighborly::Api

      config.to_prepare do
        ::User.send(:include, Neighborly::Api::UserConcern)
      end
    end
  end
end
