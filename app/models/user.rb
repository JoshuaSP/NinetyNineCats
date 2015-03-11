# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_reader :password

  validates_presence_of :username, :password_digest
  validates :username, :session_token, uniqueness: true

  has_many :cats

  def self.find_by_credentials(session_params)
    user = User.find_by(username: session_params[:username])
    user if user.is_password?(session_params[:password])
  end

  def reset_session_token!
    session_token = SecureRandom::urlsafe_base64
    until User.find_by_session_token(session_token).nil?
      session_token = SecureRandom::urlsafe_base64
    end
    self.session_token = session_token
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
end
