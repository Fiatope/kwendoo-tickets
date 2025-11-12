class CreateKycsTable < ActiveRecord::Migration
  def change
    create_table :kyc_files do |t|
      t.references  :user, index: true, null: false
      t.string      :uploaded_image
      t.string      :proof_type
      t.datetime    :created_at
      t.datetime    :updated_at
      t.string      :document_key
    end
  end
end
