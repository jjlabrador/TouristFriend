# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  email             :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  password_digest   :string(255)
#  ciudad_residencia :string(255)
#  remember_token    :string(255)
#  admin             :boolean         default(FALSE)
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :ciudad_residencia
  has_secure_password

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    end
  end

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
#  validates :password, presence: true, length: { minimum: 6 }
  validates :password, length: { minimum: 6 } # Para evitar el duplicado del flash
  validates :password_confirmation, presence: true
  validates :ciudad_residencia, presence: true

  private
  
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
