class User < ApplicationRecord
  # use bcrypt to validate password
  has_secure_password

  # model relations
  has_many :internet_troubles

  validates :email,
            :password, 
            :name,
            presence: true

  validates :email,
            length: { minimum: 4, maximum: 255 },
            uniqueness: true, on: :create,
            email: true

  validates :password,
            length: { minimum: 6 }

  validates :name,
            length: { maximum: 255 }

  validates_format_of :name, :with => /\A[A-Za-z ]*\z/
end
