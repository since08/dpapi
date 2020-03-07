class AddEndDateToRanking < ActiveRecord::Migration[5.0]
  def change
    add_reference :crowdfunding_ranks, :crowdfunding
    add_reference :crowdfunding_ranks, :crowdfunding_player
    add_column :crowdfunding_ranks, :end_date, :date, comment: '赛事结束的日期'
    add_column :crowdfunding_ranks, :sale_amount, :decimal, precision: 8, scale: 2, default: 0, comment: '出让总金额'
    add_column :crowdfunding_ranks, :total_amount, :decimal, precision: 8, scale: 2, default: 0, comment: '总金额'
    remove_column :crowdfunding_ranks, :platform_tax
    add_column :crowdfunding_ranks, :platform_tax, :decimal, precision: 5, scale: 2, default: 0, comment: '平台扣除百分比'
  end
end
