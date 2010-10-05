class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :trackable, :validatable,
         :oauthable

  field :first_name
  field :last_name
  field :gender
  field :date_of_birth
  field :mobile_number

  field :facebook_id
  field :facebook_token

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
end
