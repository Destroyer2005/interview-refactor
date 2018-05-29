class User < ActiveRecord::Base

  has_many :tv_shows

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :generate_api_key


  def generate_api_key
    api_key = SecureRandom.hex(16)
    unless User.where(api_key: api_key).any?
      self.api_key = api_key
    else
      generate_api_key
    end
  end
end
