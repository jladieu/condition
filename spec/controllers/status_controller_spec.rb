require 'spec_helper'

describe StatusController do

  describe "GET /status" do
    it "routes to status#show" do
      { :get => "/status" }.should route_to(
        :controller => "status",
        :action => 'show'
      )
    end

    it "renders the :show template" do
      get :show

      controller.should respond_with(:success)
      controller.should have_rendered(:show)
    end

    it "displays the current status" do
      expected_status = build(:status, :code => "fake_code", :message => "Good news!")
      Status.stubs(:current).returns(expected_status)

      get :show
      controller.should assign_to(:current_status).with(expected_status)
    end

    it "displays the status history" do
      expected_status_history = (1..3).map { create(:status) }
      Status.stubs(:history).returns(expected_status_history)

      get :show
      controller.should assign_to(:status_history).with(expected_status_history)
    end
  end

  describe "PUT /status" do
    it "routes to status#update" do
      { :put => "/status" }.should route_to(
        :controller => "status",
        :action => "update"
      )
    end

    it "creates a new Status based on the provided parameters" do
      fake_status = create(:status, :code => "UP", :message => "Alive and well")
      Status.expects(:publish).
        with(has_entries("code" => "UP", "message" => "Alive and well")).
          returns(fake_status)

      put :update, "status" => { "code" => "UP", "message" => "Alive and well" }

      controller.should respond_with(:success)
      response.body.should == "UP: Alive and well"
    end

    it "renders an appropriate response when no message is provided" do
      put :update, "status" => { "code" => "DOWN" }

      controller.should respond_with(:success)
      response.body.should == "DOWN: (No message provided)"
    end

    it "renders an error response when given a bad code" do
      put :update, "status" => { "code" => "Foo" }

      controller.should respond_with(:bad_request)
      response.body.should match(/Foo/)
    end
  end
end
