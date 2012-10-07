require 'spec_helper'

describe TimelineController do

  describe "GET #index" do
    before do
      get :index
    end
    its(:status) { should == 302 }
    it { should redirect_to new_session_path }
  end

  describe "GET #index with logged user" do
    before do
      @user = Service.make!.user
      controller.stub(:current_user).and_return(@user)
      get :index
    end
    its(:status) { should == 200 }
  end

end
