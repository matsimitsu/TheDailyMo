require 'spec_helper'

describe User do
  before(:each) do
    @user = User.new
  end

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
 
  it { should_not allow_value('manwomen').for(:gender) }
  it { should     allow_value('male').for(:gender) }
  it { should     allow_value('female').for(:gender) }
 
  it { should_not allow_value(12.years.ago).for(:date_of_birth) }
  it { should     allow_value(18.years.ago).for(:date_of_birth) }
  it { should     allow_value(60.years.ago).for(:date_of_birth) }
end