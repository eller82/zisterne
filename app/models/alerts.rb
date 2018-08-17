class Alerts < ApplicationRecord
  
  belongs_to :user
  
  scope :last_alert, ->(user_id) { where("user_id = ?", user_id) if user_id.present? }
  
end
