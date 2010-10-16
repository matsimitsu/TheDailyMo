class MoPoser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :full_name
  field :profile_picture
  field :permissions, :type => Hash

  # some general validations for the user profile
  validates_presence_of  :full_name, :profile_picture

  # Setup accessible (or protected) attributes for your model
  attr_accessible :full_name, :profile_picture

end
