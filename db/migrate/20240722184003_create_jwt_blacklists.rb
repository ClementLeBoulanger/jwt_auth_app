class CreateJwtBlacklists < ActiveRecord::Migration[7.0]
  def change
    create_table :jwt_blacklists do |t|
      t.string :jti, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
