class RegistrationFactory
  include Singleton
  
  def registration_form(attributes = {}) 
    default_attributes = {
      :login => "login",
      :email => "email@example.com",
      :password => "password",
      :password_confirmation => "password",
    }
    return default_attributes.merge(attributes)
  end
  
end