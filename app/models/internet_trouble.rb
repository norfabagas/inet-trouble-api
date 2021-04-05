class InternetTrouble < ApplicationRecord
  # model relations
  belongs_to :user

  validates :trouble,
            presence: true

  validates :trouble,
            length: { minimum: 6, maximum: 255 }
end
