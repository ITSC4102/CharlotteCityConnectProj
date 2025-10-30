class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :name
      t.bigint :attendees
      t.string :location
      t.datetime :time
      t.text :required_tags

      t.timestamps
    end
  end
end
