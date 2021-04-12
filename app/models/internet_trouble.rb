class InternetTrouble < ApplicationRecord
  # model relations
  belongs_to :user

  validates :trouble,
            presence: true

  validates :trouble,
            length: { minimum: 6, maximum: 255 }

  validates :category,
            presence: true, on: :edit

  validates :status,
            presence: true, on: :edit
  
  validates :is_predicted,
            inclusion: { in: [true, false] }

 scope  :read_by_admin, -> { where("is_read_by_admin is not null") }
 scope  :unread_by_admin, -> { where("is_read_by_admin is null") }
 scope  :get_all, -> { where("is_read_by_admin is null or is_read_by_admin is not null") }
end
