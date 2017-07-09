class CreateVolumen < ActiveRecord::Migration[5.1]
  def change
    create_table :volumen do |t|
      t.float :volumen
      t.datetime :messdatum

      t.timestamps null: false
    end
  end
end
