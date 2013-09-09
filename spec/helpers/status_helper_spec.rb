require 'spec_helper'

describe StatusHelper do
  describe "#status_code" do
    it "renders a status code and message in green if the provided status is up" do
      assert_dom_equal "<span style='color:green'>UP - fake_message</span>",
        helper.status_code(create(:up_status, :message => "fake_message"))
    end

    it "renders a status code and message in red if the provided status is down" do
      assert_dom_equal "<span style='color:red'>DOWN - fake_message</span>",
        helper.status_code(create(:down_status, :message => "fake_message"))
    end

    it "cleanly renders a status without a message if none is provided" do
      assert_dom_equal "<span style='color:green'>UP</span>",
        helper.status_code(create(:up_status, :message => nil))

      assert_dom_equal "<span style='color:red'>DOWN</span>",
        helper.status_code(create(:down_status, :message => nil))
    end

    it "renders unknown in orange if provided no status" do
      assert_dom_equal "<span style='color:orange'>UNKNOWN</span>",
        helper.status_code(nil)
    end
  end
end
