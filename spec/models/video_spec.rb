require 'spec_helper'

describe Video do
  it 'should convert a youtube url to a video id' do
    v = Video.create({:video_id => 'http://youtube.com/watch?k=kjhasdjfha&v=garbage&poop=jalkjsdf' })
    v.video_id.should_not be_blank
    v.video_id.should eq('garbage')
  end

  it 'should leave a random string of characters alone' do
    v = Video.create({:video_id => 'garbage' })
    v.video_id.should_not be_blank
    v.video_id.should eq('garbage')
  end
end
