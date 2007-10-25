require File.dirname(__FILE__) + '/../spec_helper'

context "A new User" do
  specify "should be created" do
    lambda{ 
        user = create_user 
        user.should_not be_new_record 
    }.should change(User,:count).by(1)
  end
  
  specify "should require login" do
    lambda{ 
      u = create_user(:login => nil)
      u.should have_at_least(1).errors_on(:login) 
    }.should_not change(User,:count)
  end
  
  specify "should require password" do
    lambda{ 
      u = create_user(:password => nil)
      u.should have_at_least(1).errors_on(:password)
    }.should_not change(User,:count)
  end

  specify "should require password confirmation" do
    lambda{ 
      u = create_user(:password_confirmation => nil)
      u.should have_at_least(1).errors_on(:password_confirmation)
    }.should_not change(User,:count)
  end

  specify "should require email" do
    lambda{ 
      u = create_user(:email => nil)
      u.should have_at_least(1).errors_on(:email)
    }.should_not change(User,:count)
  end
  
  protected
  
  def create_user(options = {})
    User.create({ :login      => 'quire', 
                  :email      => 'quire@example.com', 
                  :password   => 'quire', 
                  :password_confirmation => 'quire' }.merge(options))
  end
end

context "User with fixtures loaded" do
  fixtures :users

  specify "should reset password" do
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    users(:quentin).should == User.authenticate('quentin','new password')
  end

  specify "should not rehash password" do
    users(:quentin).update_attributes(:login => 'quentin2')
    users(:quentin).should == User.authenticate('quentin2','test')
  end

  specify "should authenticate user" do
    users(:quentin).should == User.authenticate('quentin','test')
  end

  specify "should set remember token" do
    users(:quentin).remember_me
    users(:quentin).remember_token.should_not be_nil
    users(:quentin).remember_token_expires_at.should_not be_nil
  end
  
  specify "should unset remember token" do
    users(:quentin).remember_me
    users(:quentin).remember_token.should_not be_nil
    users(:quentin).forget_me
    users(:quentin).remember_token.should be_nil
  end
  
  specify "should remember me for one week" do
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    users(:quentin).remember_token.should_not be_nil
    users(:quentin).remember_token_expires_at.should_not be_nil
    users(:quentin).remember_token_expires_at.should be_between(before, after)
  end
  
  specify "should remember me until one week" do
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    users(:quentin).remember_token.should_not be_nil
    users(:quentin).remember_token_expires_at.should_not be_nil
    users(:quentin).remember_token_expires_at.should == time
  end
  

  specify "should remember me for two week by default" do
    before = 2.week.from_now.utc
    users(:quentin).remember_me
    after = 2.week.from_now.utc
    users(:quentin).remember_token.should_not be_nil
    users(:quentin).remember_token_expires_at.should_not be_nil
    users(:quentin).remember_token_expires_at.should be_between(before, after)
  end
end