class AddPromotionIdToTicketCategoriesOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :ticket_categories_orders, :promotion, foreign_key: true
  end
end
