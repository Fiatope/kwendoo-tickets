class AddTicketTemplateImageToRewards < ActiveRecord::Migration[6.1]
  def up
    unless column_exists?(:rewards, :ticket_template_image)
      add_column :rewards, :ticket_template_image, :string
    end
  end

  def down
    if column_exists?(:rewards, :ticket_template_image)
      remove_column :rewards, :ticket_template_image
    end
  end
end