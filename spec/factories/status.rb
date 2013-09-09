FactoryGirl.define do
  factory :status do
    message "All is well!"
    code Status::Codes::UP
  end

  factory :up_status, :parent => :status do
    message "All is well!"
    code Status::Codes::UP
  end

  factory :down_status, :parent => :status do
    message "Something is wrong..."
    code Status::Codes::DOWN
  end
end
