require 'spec_helper'

descripe Movie do
  describe 'video_id' do
    it 'should parse a youtube url' do
      v = mock('Video', :video_id => "http://www.youtube.com/watch?v=JtGchOIRL58&feature=g-vrec")
      v.id_from_url.should be "JtGchOIRL58"
    end

    it "shouldn't mess up a random string" do
      v = mock('Video', :video_id => "JtGchOIRL58")
      v.id_from_url.should be "JtGchOIRL58"
    end
  end
end
