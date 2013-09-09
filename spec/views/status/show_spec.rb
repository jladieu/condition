require "spec_helper"

describe "status/show.html.erb" do

  before do
    view.extend StatusHelper
  end

  it "displays the current status" do
    assign(:current_status, build(:status, :code => "fake_code"))
    assign(:status_history, [])
    render

    assert_select "#current_status", :text => /fake_code/
  end

  it "displays the status history" do
    expected_status = []
    fixed_time = 5.minutes.ago
    (1..3).each do
      Timecop.freeze(fixed_time) do
        expected_status << create(:status, :code => "DOWN", :message => "something happened")
      end
    end

    assign(:status_history, expected_status)

    render

    expected_status.each do |status|
      assert_select "#status_#{status.id}" do
        assert_select ".time", :text => fixed_time
        assert_select ".description", :text => /DOWN/
        assert_select ".description", :text => /something happened/
      end
    end
  end
end