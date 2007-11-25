require File.dirname(__FILE__) + '/stories_helper'

require 'spec'
require 'spec/rails'

#require File.join(File.dirname(__FILE__), *%w[helper])

require File.dirname(__FILE__) + '/helpers/registration_helper.rb'
require File.dirname(__FILE__) + '/steps/registration.rb'

with_steps_for :registration do
  run File.dirname(__FILE__) + '/stories/registration.story', :type => RailsStory
end
