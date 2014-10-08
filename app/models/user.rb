class User < ActiveRecord::Base
  validates :name,  presence: true, length: { maximum: 50 }
  validates :password, length: { minimum: 6 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  before_save do
    self.email = self.email.downcase
  end

  has_secure_password
end
