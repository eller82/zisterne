class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.integer     :user_id, :limit => 8
      t.string      :last_alert, null: true, default: ""
      
      t.timestamps  null: false
    end

  end
end
