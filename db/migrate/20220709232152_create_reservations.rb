class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.date :day, null: false
      t.string :time, null: false
      t.integer :user_id, null: false
      t.datetime :start_time, null: false
      t.timestamps
    end
  end
end
