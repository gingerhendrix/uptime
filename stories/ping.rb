require File.dirname(__FILE__) + '/stories_helper'

require 'spec'
require 'spec/rails'

#require File.join(File.dirname(__FILE__), *%w[helper])

require File.dirname(__FILE__) + '/steps/ping.rb'

with_steps_for :ping do
  run File.dirname(__FILE__) + '/stories/ping.story', :type => RailsStory
end
