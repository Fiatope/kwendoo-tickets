module Neighborly
  module Balanced
    class Engine < ::Rails::Engine
      isolate_namespace Neighborly::Balanced

      config.autoload_paths += Dir["#{config.root}/app/observers/**/"]

      config.to_prepare do
        ::User.send(:include, Neighborly::Balanced::User)
      end
    end
  end
end
