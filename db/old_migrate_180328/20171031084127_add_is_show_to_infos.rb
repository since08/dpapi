class AddIsShowToInfos < ActiveRecord::Migration[5.0]
  def change
    add_column :infos, :is_show, :boolean, default: true, comment: '是否显示出来'
    add_column :info_ens, :is_show, :boolean, default: true, comment: '是否显示出来'
  end
end
