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
  field :date_of_birth, :type => Date
  field :mobile_number

  field :facebook_id
  field :facebook_token


  # some general validations for the user profile
  validates_presence_of  :first_name, :last_name
  validates_inclusion_of :gender,        :in => %w( male female )
  validates_date         :date_of_birth, :before => lambda { 14.years.ago }
  validates_format_of    :mobile_number, :with => /^[\w\d]+$/, :allow_blank => true # we need a mobile number regex

  # if we have one peice of fb info, we need the other
  validates_presence_of :facebook_id,    :if => Proc.new { |user| user.facebook_token.present? }
  validates_presence_of :facebook_token, :if => Proc.new { |user| user.facebook_id.present? }


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :gender, :date_of_birth, :mobile_number

end
