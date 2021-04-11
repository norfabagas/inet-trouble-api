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
end
