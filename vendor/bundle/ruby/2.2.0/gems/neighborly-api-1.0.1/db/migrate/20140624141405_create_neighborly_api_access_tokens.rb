class CreateNeighborlyApiAccessTokens < ActiveRecord::Migration
  def change
    create_table :api_access_tokens do |t|
      t.string :code, null: false
      t.boolean :expired, default: false, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
