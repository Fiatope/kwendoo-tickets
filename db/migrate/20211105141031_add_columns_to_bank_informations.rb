class AddColumnsToBankInformations < ActiveRecord::Migration[6.1]
  def change
    add_column :bank_informations, :other_account_number, :string
    add_column :bank_informations, :other_bic, :string
    add_column :bank_informations, :other_country, :string
    add_column :bank_informations, :owner_city, :string
    add_column :bank_informations, :owner_region, :string
    add_column :bank_informations, :owner_postal_code, :string
    add_column :bank_informations, :owner_address, :string
  end
end
