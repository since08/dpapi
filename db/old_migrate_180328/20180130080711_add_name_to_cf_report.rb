class AddNameToCfReport < ActiveRecord::Migration[5.0]
  def change
    add_column :crowdfunding_reports,
               :name,
               :string,
               default: '',
               comment: '赛事的主标题名字'
  end
end
