source 'http://rubygems.org'

gem 'rails', '3.0.0'

gem 'devise', :git => 'git://github.com/plataformatec/devise.git', :ref => '721843c841f0dc5391da'

gem 'mongoid',  '2.0.0.beta.19'
gem 'bson',     '1.1'
gem 'bson_ext', '1.1'

gem 'validates_timeliness', :git => 'git://github.com/adzap/validates_timeliness.git', :ref => 'd450ab7c0652e049a8e6'

gem 'fbgraph', '0.1.6.4.1'


group :development do
  gem 'mongrel'
end

# added into development so the generate helpers are available
group :test, :development do
  gem 'rspec-rails', '>= 2.0.0.beta.22'
end

group :test do
  gem 'shoulda'
  gem 'database_cleaner'
end