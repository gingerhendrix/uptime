require File.dirname(__FILE__) + '/../spec_helper'

describe IndexController do

  it "should render index template on GET to index" do
    get 'index'
    response.should render_template(:index)
  end

end
