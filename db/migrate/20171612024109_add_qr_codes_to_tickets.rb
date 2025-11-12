class AddQrCodesToTickets < ActiveRecord::Migration
  def change
    change_table :tickets do |t|
      t.string :qr_code
    end
  end
end
