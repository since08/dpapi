class CreateInviteCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :invite_codes do |t|
      t.string :name
      t.string :mobile
      t.string :email
      t.string :code
      t.timestamps
    end
  end
end
