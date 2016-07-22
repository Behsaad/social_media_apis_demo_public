class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  has_one :authentication

  attr_accessor :login

  def login=(login)
    @login = login
  end

  def login
    @login || self.username
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end


end
