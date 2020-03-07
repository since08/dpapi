class CreateCrowdfundings < ActiveRecord::Migration[5.0]
  def change
    create_table :crowdfundings do |t|
      t.references :race
      t.string :master_image, comment: '众筹主图'
      t.integer :cf_cond, default: 0, comment: '参加众筹条件'
      t.date :expire_date, comment: '截止日期'
      t.date :publish_date, comment: '公布日期'
      t.date :award_date, comment: '发奖时间'
      t.boolean :published, default: false, comment: '是否发布'
      t.timestamps
    end

    create_table :crowdfunding_categories do |t|
      t.references :crowdfunding
      t.string :name, default: '', comment: '栏目名字'
      t.text :description, comment: '栏目对应的描述'
      t.integer :position, default: 0, comment: '排序'
      t.timestamps
    end

    create_table :crowdfunding_counters do |t|
      t.references :crowdfunding
      t.integer :page_views, default: 0, comment: '浏览量'
      t.timestamps
    end

    create_table :crowdfunding_banners do |t|
      t.string :image
      t.references :source, polymorphic: true
      t.string :link, comment: '链接地址'
      t.bigint :position, default: 0, limit: 20, comment: '用于拖拽排序'
      t.boolean :published, default: false, comment: '是否发布'
      t.timestamps
    end

    create_table :crowdfunding_players do |t|
      t.references :crowdfunding
      t.references :player
      t.string :join_slogan, comment: '参赛口号'
      t.integer :sell_stock, default: 0, comment: '出让股份百分比'
      t.integer :stock_number, default: 0, comment: '股份划分的份数'
      t.integer :stock_unit_price, default: 0, comment: '每股单价'
      t.integer :cf_money, default: 0, comment: '众筹总额'
      t.integer :limit_buy, default: 0, comment: '限购的份数, 0表示不限购'
      t.boolean :published, default: false, comment: '是否发布'
      t.timestamps
    end

    create_table :player_images do |t|
      t.references :player
      t.string :image
      t.bigint :position, default: 0
    end

    create_table :crowdfunding_orders do |t|
      t.references :crowdfunding_player
      t.references :user
      t.references :crowdfunding
      t.string :order_number, comment: '订单号'
      t.integer :order_stock_number, default: 0, comment: '认购该牌手的份数'
      t.integer :order_stock_money, default: 0, comment: '认购该牌手的单份价格'
      t.boolean :paid, default: false, comment: '是否付款'
      t.datetime :pay_time, comment: '付款的时间'
      t.integer :total_money, default: 0, comment: '支付的总价格'
      t.boolean :deleted, default: false, comment: '是否删除'
      t.timestamps
    end

    create_table :crowdfunding_player_counters do |t|
      t.references :crowdfunding_player
      t.references :crowdfunding
      t.integer :fans, default: 0, comment: '认购人数，只有付完款才统计'
      t.integer :order_stock_number, default: 0, comment: '认购的份数'
      t.integer :order_stock_money, default: 0, comment: '认购的金额'
      t.timestamps
    end

    create_table :poker_coins do |t|
      t.references :user
      t.references :typeable, polymorphic: true, comment: '扑客币来源的类型'
      t.integer :number, default: 0, comment: '扑客币数量，如果是负数，表示减少，正数表示新增'
      t.string :memo, default: '', comment: '备忘'
      t.timestamps
    end

    # 扩充牌手对应的表
    add_column :players, :nick_name, :string, default: '', comment: '牌手昵称'
    add_column :players, :logo, :string, comment: '牌手用于展示的头像'
    add_column :players, :description, :text, comment: '牌手描述'
    add_column :players, :lairage_rate, :integer, default: 0, comment: '进圈率'
    add_column :players, :final_rate, :integer, default: 0, comment: '决赛率'
    add_column :race_ranks, :awarded, :boolean, default: false, comment: '是否进入钱圈'
    add_column :race_ranks, :finaled, :boolean, default: false, comment: '是否进入决赛'
    add_column :race_ranks, :deduct_tax, :decimal, precision: 8, scale: 2, default: 0, comment: '扣除的费用,数字'
    add_column :race_ranks, :platform_tax, :decimal, precision: 3, scale: 2, default: 0, comment: '平台扣除百分比'
  end
end
