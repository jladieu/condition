class Status < ActiveRecord::Base

  module Codes
    UP = 'UP'
    DOWN = 'DOWN'
  end

  attr_accessible :message, :code
  validates_inclusion_of :code, :in => [Status::Codes::UP, Status::Codes::DOWN]

  class << self

    def current
      reverse_chronological_order.first
    end

    def history
      reverse_chronological_order.limit(10)
    end

    def publish(options)
      options[:code] ||= Status.current.try(:code) # default to existing Status if none provided

      Status.create(options).tap do |new_status|
        unless new_status.valid?
          raise ArgumentError.new("Invalid options provided: #{options.inspect}")
        end
      end
    end

    private

    def reverse_chronological_order
      self.order("created_at DESC")
    end

  end

  def up?
    Codes::UP == self.code
  end
end
