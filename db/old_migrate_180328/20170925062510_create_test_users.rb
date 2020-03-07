class CreateTestUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :test_users do |t|
      t.references :user, default: 0
    end
  end
end
