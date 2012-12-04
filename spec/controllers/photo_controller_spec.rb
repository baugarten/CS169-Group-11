require 'spec_helper'

describe PhotoController do
	describe 'display' do
		it 'should send find the correct photo' do
			fake_result = mock('Photo', :id=>"42", :url=>"https://dl.dropbox.com/s/seh66m5mbjwrt69/rails.png", :filename=>"omg", :content_type => "blargh", :binary_data => "abcd");
			Photo.should_receive(:find).with("42").and_return(fake_result)
			post :display, :id=>"42"
		end
	end
end
