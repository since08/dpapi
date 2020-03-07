class AddRecordStatusToCfPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :crowdfunding_players,
               :record_status,
               :string,
               default: 'unpublished',
               comment: 'unpublished未公布，success晋级成功, failed失败'
  end
end
