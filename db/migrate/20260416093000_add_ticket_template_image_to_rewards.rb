class AddTicketTemplateImageToRewards < ActiveRecord::Migration[6.1]
  def change
    add_column :rewards, :ticket_template_image, :string
  end
end