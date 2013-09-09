# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'shoulda'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :mocha
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods
end

# From: http://stackoverflow.com/questions/3559924/rails-time-inconsistencies-with-rspec
#
# Usage:
#
# its(:updated_at) { should be_the_same_time_as updated_at }
#
#
# Will pass or fail with message like:
#
# Failure/Error: its(:updated_at) { should be_the_same_time_as 2.days.ago }
# expected Tue, 07 Jun 2011 16:14:09 +0300 to be the same time as Mon, 06 Jun 2011 13:14:09 UTC +00:00
RSpec::Matchers.define :be_the_same_time_as do |expected|
  match do |actual|
    expected.to_i == actual.to_i
  end
end