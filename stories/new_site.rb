require File.dirname(__FILE__) + '/stories_helper'

require 'spec'
require 'spec/rails'

#require File.join(File.dirname(__FILE__), *%w[helper])

require File.dirname(__FILE__) + '/steps/login.rb'
require File.dirname(__FILE__) + '/steps/sites.rb'

with_steps_for :login, :sites do
  run File.dirname(__FILE__) + '/stories/new_site.story', :type => RailsStory
end
