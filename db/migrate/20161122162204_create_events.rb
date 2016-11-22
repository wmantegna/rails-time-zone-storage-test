class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start
      t.string :time_zone

      t.timestamps null: false
    end
  end
end
