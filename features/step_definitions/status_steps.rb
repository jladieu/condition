Given /^I have (\d+) existing status updates$/ do |num_updates|
  num_updates.to_i.times { create(:status) }
end

When /^I show current status$/ do
  visit "/status"
end

Then /^I should see the current status update$/ do
  page.should have_selector "#current_status"
end

Then /^I should see the (\d+) most recent status updates$/ do |num_updates|
  page.should have_selector ".history_item", :count => num_updates.to_i
end

