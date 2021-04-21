require "./spec_helper"

describe MapTogether::Server do

  it "renders /" do
      get "/"
      response.body.should eq "hi"
  end
  
end
