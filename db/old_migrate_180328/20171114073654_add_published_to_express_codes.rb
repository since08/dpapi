class AddPublishedToExpressCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :express_codes, :published, :boolean, default: false, comment: '是否发布'
  end
end
