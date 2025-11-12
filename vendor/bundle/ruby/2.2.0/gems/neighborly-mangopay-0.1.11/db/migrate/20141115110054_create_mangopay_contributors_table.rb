class CreateMangopayContributorsTable < ActiveRecord::Migration
  def change
    create_table :mangopay_contributors do |t|
      t.references :user, index: true
      t.integer :organization_id
      t.string :key, null: false
      t.string :href
      t.string :wallet_key
      t.string :verification_level, default: 'light'

      t.timestamps
    end
    remove_foreign_key :mangopay_contributors, name: :fk_mangopay_contributors_organization_id
  end
end
