class CreateDynamics < ActiveRecord::Migration[5.0]
  def change
    create_table :dynamics do |t|
      t.references :user
      t.references :typological, polymorphic: true, comment: '动态的类型,评论，点赞或回复'
      t.timestamps
    end
  end
end
