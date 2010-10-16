class MoPoser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :oauth_providerprovider # twitter/facebook
  field :oauth_uid # The UID on facebook/twitter
  field :oauth_token
  field :oauth_secret
  field :full_name
  field :original_profile_pic_url
  field :permissions, :type => Hash

  # some general validations for the user profile
  validates_presence_of  :full_name, :original_profile_pic_url

  # Setup accessible (or protected) attributes for your model
  attr_accessible :full_name, :original_profile_pic_url
  attr_accessible :oauth_provider, :oauth_uid, :oauth_token, :oauth_secret

  def self.setup_poser(auth_hash)
    poser = MoPoser.find(:first, :conditions => {:oauth_provider => auth_hash[:provider], :oauth_uid => auth_hash[:uid]})
    poser = MoPoser.create(:oauth_provider => auth_hash[:provider], :oauth_uid => auth_hash[:uid]) unless poser
    poser.update_details(auth_hash)
    poser.save!
    poser
  end

  # Would love to use the after_initialize but it appears that mongoid doesn't support that....
  # def after_initialize(*args)
  #   self.extend DailyMo::NetworkConnectors.register_connector(oauth_provider)
  # end

  def connector
    @connector ||= self.extend DailyMo::NetworkConnectors.register_connector(oauth_provider)
  end

  def update_details(auth_hash)
    update_attributes(
      :oauth_uid                => auth_hash[:uid],
      :oauth_provider           => auth_hash[:provider],
      :oauth_token              => auth_hash[:credentials]['token'],
      :oauth_secret             => auth_hash[:credentials]['secret'],
      :full_name                => auth_hash[:user_info]['name'],
      :original_profile_pic_url => auth_hash[:user_info]['image'] || connector.profile_picture_url
    )
    self
  end

  def default_message
    [
      "Mijn profiel foto zit snor! Laat ook je snor staan, steun Oranje en @kika8118! http://snoranje.nl/s/#{snipped} #wk2010 #snoranje",
      "Mijn profiel foto is gesnort voor @kika8118! http://snoranje.nl/s/#{snipped} #snoranje #wk2010",
      "Laat ook je snor staan, ik snor voor Oranje en @kika8118! http://snoranje.nl/s/#{snipped} #snoranje #wk2010",
      "Ik heb net mijn profiel foto gesnort! http://snoranje.nl/s/#{snipped} #snoranje #wk2010 Go @kika8118"
    ][rand(4)]
  end

end
