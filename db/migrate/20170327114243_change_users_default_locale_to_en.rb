class ChangeUsersDefaultLocaleToEn < ActiveRecord::Migration
  def up
    change_column_default :users, :locale, "en"
  end

  def down
    change_column_default :users, :locale, "pt"
  end
end
