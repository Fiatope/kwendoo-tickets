class CreateOrangeMoneySnQrCodeTransactions < ActiveRecord::Migration[6.1]
  def up
    return if table_exists?(:orange_money_sn_qr_code_transactions)

    create_table :orange_money_sn_qr_code_transactions do |t|
      t.integer :contribution_id, null: false, index: true
      t.string  :id_from_client
      t.string  :id_from_gu
      # Filled by the webhook when the QR code payment is confirmed (status=SUCCESSFUL).
      # Its presence is used by reconcile_provider_payment to auto-confirm the contribution.
      t.string  :num_transaction
      t.string  :status
      t.text    :qr_code_base64   # base64 PNG returned by gutouch API
      t.string  :deep_link        # Orange Money deep link / MAXIT URL
      t.string  :validity         # seconds before QR code expires (usually "600")
      t.string  :service_code, default: 'PAIEMENTMARCHANDOMQRCODE'
      t.timestamps
    end

    add_foreign_key :orange_money_sn_qr_code_transactions, :contributions,
                    name: 'fk_om_sn_qr_code_transactions_contribution_id'
  end

  def down
    remove_foreign_key :orange_money_sn_qr_code_transactions,
                       name: 'fk_om_sn_qr_code_transactions_contribution_id' rescue nil
    drop_table :orange_money_sn_qr_code_transactions, if_exists: true
  end
end
