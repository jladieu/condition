require 'spec_helper'

describe Status do
  it { should allow_mass_assignment_of(:code) }
  it { should allow_mass_assignment_of(:message) }

  it { should allow_value(Status::Codes::UP).for(:code) }
  it { should allow_value(Status::Codes::DOWN).for(:code) }
  it { should_not allow_value("other").for(:code) }

  it "has a default status code of UP" do
    Status.new.code.should == Status::Codes::UP
  end

  describe "#up?" do
    it "is true when the status code is UP" do
      assert build(:status, :code => Status::Codes::UP).up?
    end

    it "is not true when the status code is anything but UP" do
      assert !build(:status, :code => Status::Codes::DOWN).up?
    end
  end

  describe "#publish" do

    it "creates and returns a new Status based on the provided code and message" do
      expected_create_time = Time.now

      returned_status = nil
      Timecop.freeze(expected_create_time) do
        lambda {
          returned_status = Status.publish(:code => Status::Codes::UP, :message => "Online!")
        }.should change(Status, :count).by(1)
      end

      updated_status = Status.current
      updated_status.should == returned_status
      updated_status.should_not be_nil
      updated_status.code.should == Status::Codes::UP
      updated_status.message.should == "Online!"
      updated_status.created_at.should be_the_same_time_as(expected_create_time)

      # can also mark it as down
      returned_status = Status.publish(:code => Status::Codes::DOWN, :message => "Offline :(")

      updated_status = Status.current
      updated_status.should == returned_status
      updated_status.code.should == Status::Codes::DOWN
      updated_status.message.should == "Offline :("
    end

    it "skips the message if none is provided" do
      Status.publish(:code => Status::Codes::DOWN)

      updated_status = Status.current
      updated_status.message.should be_nil
    end

    it "raises if given an invalid code" do
      expect { Status.publish(:code => "foobar") }.to(
        raise_error(ArgumentError) { |error| error.message.should match(/foobar/)}
      )

      Status.current.should be_nil, "Should not persist anything either"
    end

    context "without any existing status messages" do
      before(:each) { Status.current.should be_nil, "Precondition: no status" }

      it "raises if no code is provided on the first invocation" do
        expect { Status.publish(:message => "Online!") }.to(
          raise_error(ArgumentError) { |error| error.message.should match(/nil/)}
        )

        Status.current.should be_nil, "Should not persist anything either"
      end
    end

    context "with an existing status messages" do
      before(:each) { @existing_status = create(:up_status, :message => "Existing status") }

      it "uses the existing Status code to determine the new Status if no code is provided" do
        result = Status.publish(:message => "New status")

        new_status = Status.current
        new_status.should_not == @existing_status
        new_status.code.should == Status::Codes::UP
        new_status.message.should == "New status"

        # now change the current Status to down...
        new_status.update_attribute(:code, Status::Codes::DOWN)

        result = Status.publish(:message => "Even newer status!")

        newest_status = Status.current
        newest_status.should_not == new_status
        newest_status.code.should == Status::Codes::DOWN
        newest_status.message.should == "Even newer status!"
      end
    end
  end

  describe "#current" do
    it "returns nil if there are no existing Status updates" do
      Status.current.should be_nil
    end

    it "returns the most recently created Status" do
      prior_statuses = [5, 10, 15].each do |number_of_minutes|
        Timecop.freeze(number_of_minutes.minutes.ago) do
          create(:status, :message => "(not expected) #{number_of_minutes} minutes ago")
        end
      end

      Timecop.freeze(5.seconds.ago) do
        create(:status, :message => "(expected) Latest status!")
      end
      current_status = Status.current
      current_status.should_not be_nil
      current_status.message.should == '(expected) Latest status!'
    end
  end

  describe "#history" do
    it "returns an empty list if there are no existing Status updates" do
      Status.history.should == []
    end

    it "returns all the available Status updates if there are 10 or fewer" do
      cumulative_status_updates = []
      1.upto(10) do |i|
        Timecop.freeze(i.minutes.ago) do
          cumulative_status_updates << create(:status)
        end

        Status.history.should == cumulative_status_updates
      end
    end

    it "returns the most recent 10 available Status updates if there are more than 10" do
      expected = []
      older = []

      1.upto(10) do |i|
        Timecop.freeze(i.minutes.ago) do
          expected << create(:status)
        end
      end

      11.upto(15) do |i|
        Timecop.freeze(i.minutes.ago) do
          older << create(:status)
        end
      end

      Status.history.should == expected
    end
  end
end
