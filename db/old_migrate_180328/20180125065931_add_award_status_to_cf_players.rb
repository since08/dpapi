class AddAwardStatusToCfPlayers < ActiveRecord::Migration[5.0]
  def change
    # 添加众筹牌手是否下发扑客币 状态
    add_column :crowdfunding_players,
               :award_status,
               :string,
               default: 'init',
               comment: 'init未开始，waiting等待下发, completed完成下发'
    add_column :crowdfunding_ranks,
               :unit_amount,
               :decimal, precision: 8, scale: 2, default: 0, comment: '单份金额'
  end
end
