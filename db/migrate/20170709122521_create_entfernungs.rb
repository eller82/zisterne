class CreateEntfernungs < ActiveRecord::Migration[5.1]
  def change
    create_table :entfernungs do |t|
      t.float :entfernung
      t.datetime :messdatum

      t.timestamps null: false
    end
  end
end
