require File.dirname(__FILE__) + '/../../spec_helper'

describe "/index/index" do
    it "should have title 'Uptime'" do
      render "/index/index"
      response.should have_tag('title', 'Uptime')
    end
end
