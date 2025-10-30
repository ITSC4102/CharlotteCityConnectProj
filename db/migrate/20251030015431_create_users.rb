class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :bigint do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :tag, null: false
      t.boolean :admin, null: false, default: false
      t.bigint :reg_events, array: true, default: []
      t.string :password_digest, null: false

      t.timestamps default: -> { "CURRENT_TIMESTAMP" }
    end

    add_index :users, :email, unique: true
  end
end
