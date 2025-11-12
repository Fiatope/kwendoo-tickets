class AllowUserColumnNullForContribution < ActiveRecord::Migration[6.1]
    def change
      change_column_null :contributions, :user_id, true
    end
  end