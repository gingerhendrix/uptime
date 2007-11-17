require File.dirname(__FILE__) + '/stories_helper'

require 'spec'
require 'spec/rails'

require File.dirname(__FILE__) + '/steps/login.rb'

#require File.join(File.dirname(__FILE__), *%w[helper])


with_steps_for :login do
  run File.dirname(__FILE__) + '/stories/login.story', :type => RailsStory
end
