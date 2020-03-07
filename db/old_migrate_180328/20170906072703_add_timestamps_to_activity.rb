class AddTimestampsToActivity < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :activities
  end
end
