class CreateReplyTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :reply_templates do |t|
      t.string :type
      t.string :content
      t.timestamps
    end
  end
end
