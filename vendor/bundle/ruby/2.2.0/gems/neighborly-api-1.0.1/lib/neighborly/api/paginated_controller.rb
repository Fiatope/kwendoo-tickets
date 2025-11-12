module Neighborly
  module Api
    module PaginatedController
      extend ActiveSupport::Concern

      included do
        has_scope :page, default: 1
      end

      def respond_with_pagination(collection)
        render json: collection, meta: {
          page:        collection.current_page,
          total:       collection.total_count,
          total_pages: collection.total_pages
        }
      end
    end
  end
end
