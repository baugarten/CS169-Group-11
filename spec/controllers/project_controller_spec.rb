require 'spec_helper'

describe ProjectsController do
	describe 'charge' do
    
		it 'should call Stripe with the correct details' do
      controller.stub!(:current_user).and_return(false)
    
			expected_hash = {
        :amount      => 500,
        :card        => "this is a token",
        :description => "Donation for TestFarmer",
        :currency    => 'usd'
      }
      stripe_charge = mock(Stripe::Charge,
        :id     => "aStripeChargeId"
      )
			Stripe::Charge.should_receive(:create).with(expected_hash).and_return(stripe_charge)
      
      fake_project = mock_model(Project,
        :completed=>false,
        :farmer=>"TestFarmer",
        :current_remaining=>500,
        :update_current_donated=>nil
      )
      Project.should_receive(:find).and_return(fake_project)
      
			post :charge, :id=>"1", :donation=>{:readable_amount=>"$5.00", :email=>"test@email.com"}, :stripeToken=> "this is a token"
		end
    
		it 'should redirect on donating to completed project' do
      controller.stub!(:current_user).and_return(false)
      
      fake_project = mock_model(Project,
        :completed=>true
      )
      Project.should_receive(:find).and_return(fake_project)
      
      Stripe::Charge.should_not_receive(:create)
      
			post :charge, :id=>"1", :donation=>{:readable_amount=>"$5.00", :email=>"test@email.com"}, :stripeToken=> "this is a token"
      
      response.should be_redirect
		end
    
		it 'should redirect on attempting to donate too much' do
      controller.stub!(:current_user).and_return(false)
      
      fake_project = mock_model(Project,
        :completed=>false,
        :current_remaining=>10,
        :readable_current_remaining=>"$10.00"
      )
      Project.should_receive(:find).and_return(fake_project)
      
      Stripe::Charge.should_not_receive(:create)
      
			post :charge, :id=>"1", :donation=>{:readable_amount=>"$20.00", :email=>"test@email.com"}, :stripeToken=> "this is a token"
      
      response.should be_redirect
		end
	end
end
