class CreateStatus < ActiveRecord::Migration
  def change
    create_table :status do |status|
      status.string :message, :default => nil
      status.string :code, :default => 'UP'
      status.datetime :created_at
    end
  end
end
