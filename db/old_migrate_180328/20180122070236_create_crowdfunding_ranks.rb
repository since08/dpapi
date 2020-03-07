class CreateCrowdfundingRanks < ActiveRecord::Migration[5.0]
  def change
    remove_column :race_ranks, :awarded
    remove_column :race_ranks, :finaled
    remove_column :race_ranks, :deduct_tax
    remove_column :race_ranks, :platform_tax

    create_table :crowdfunding_ranks do |t|
      t.references :race
      t.references :player
      t.integer :ranking, comment: '排名'
      t.integer :earning, comment: '收入奖金'
      t.integer :score, comment: '得分'
      t.boolean :awarded, default: false, comment: '是否进入钱圈'
      t.boolean :finaled, default: false, comment: '是否进入决赛'
      t.decimal :deduct_tax, precision: 8, scale: 2, default: 0, comment: '扣除的费用,数字'
      t.decimal :platform_tax, precision: 3, scale: 2, default: 0, comment: '平台扣除百分比'
      t.timestamps
    end
  end
end
