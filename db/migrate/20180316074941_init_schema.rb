class InitSchema < ActiveRecord::Migration[5.0]
  def up
    create_table "account_change_stats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.datetime "change_time"
      t.string   "account_type", default: "mobile",              comment: "修改账户的类别 mobile or email"
      t.string   "mender",       default: "",                    comment: "修改者"
      t.datetime "created_at",                      null: false
      t.datetime "updated_at",                      null: false
      t.index ["user_id"], name: "index_account_change_stats_on_user_id", using: :btree
    end
    create_table "activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "title",                                                           comment: "活动标题"
      t.string   "link",                                                            comment: "h5链接"
      t.text     "description",   limit: 65535,                                     comment: "活动描述"
      t.string   "banner",                                                          comment: "横图"
      t.boolean  "pushed",                      default: false,                     comment: "推送到首页的图片"
      t.string   "pushed_img",                                                      comment: "推送到首页的图片"
      t.datetime "activity_time",                                                   comment: "活动时间"
      t.string   "tag",                                                             comment: "活动标签"
      t.datetime "created_at",                                         null: false
      t.datetime "updated_at",                                         null: false
      t.datetime "start_push",                                                      comment: "推送开始时间"
      t.datetime "end_push",                                                        comment: "推送结束时间"
      t.string   "push_type",                   default: "once_a_day",              comment: "推送类型 每日一次 once_a_day， 仅一次 once"
    end
    create_table "activity_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "title",                                                           comment: "活动标题"
      t.string   "link",                                                            comment: "h5链接"
      t.string   "tag",                                                             comment: "活动标签"
      t.text     "description",   limit: 65535,                                     comment: "活动描述"
      t.string   "banner",                                                          comment: "横图"
      t.boolean  "pushed",                      default: false,                     comment: "推送到首页的图片"
      t.string   "pushed_img",                                                      comment: "推送到首页的图片"
      t.string   "push_type",                   default: "once_a_day",              comment: "推送类型 每日一次 once_a_day， 仅一次 once"
      t.datetime "activity_time",                                                   comment: "活动时间"
      t.datetime "start_push",                                                      comment: "推送开始时间"
      t.datetime "end_push",                                                        comment: "推送结束时间"
      t.datetime "created_at",                                         null: false
      t.datetime "updated_at",                                         null: false
    end
    create_table "affiliate_apps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "affiliate_id"
      t.string   "app_id",       limit: 50
      t.string   "app_name",     limit: 100
      t.string   "app_key",      limit: 36
      t.string   "app_secret",   limit: 36
      t.integer  "status",                   default: 0
      t.datetime "created_at",                           null: false
      t.datetime "updated_at",                           null: false
      t.index ["affiliate_id"], name: "index_affiliate_apps_on_affiliate_id", using: :btree
      t.index ["app_key"], name: "index_affiliate_apps_on_app_key", unique: true, using: :btree
    end
    create_table "affiliates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "aff_uuid",   limit: 36
      t.string   "aff_name",   limit: 100
      t.string   "aff_type",   limit: 50,  default: "company"
      t.integer  "status",                 default: 0
      t.string   "mobile",     limit: 20
      t.datetime "created_at",                                 null: false
      t.datetime "updated_at",                                 null: false
      t.index ["aff_name"], name: "index_affiliates_on_aff_name", unique: true, using: :btree
      t.index ["aff_uuid"], name: "index_affiliates_on_aff_uuid", unique: true, using: :btree
      t.index ["mobile"], name: "index_affiliates_on_mobile", unique: true, using: :btree
    end
    create_table "album_photos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "album_id"
      t.string  "image"
      t.index ["album_id"], name: "index_album_photos_on_album_id", using: :btree
    end
    create_table "albums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string  "name",        comment: "相册名称"
      t.integer "photo_count", comment: "图片统计"
    end
    create_table "app_versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "platform",      default: "ios",              comment: "ios 平台或 android平台"
      t.string   "version",                                    comment: "版本号"
      t.boolean  "force_upgrade", default: false,              comment: "是否强制升级"
      t.datetime "created_at",                    null: false
      t.datetime "updated_at",                    null: false
      t.string   "title",                                      comment: "更新标题"
      t.string   "content",                                    comment: "更新内容"
    end
    create_table "areas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string "name"
      t.string "area_id"
      t.string "city_id"
    end
    create_table "banners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string  "image"
      t.string  "source_type"
      t.integer "source_id"
      t.string  "link",                             comment: "链接地址"
      t.bigint  "position",                         comment: "用于拖拽排序"
      t.boolean "published",   default: false,      comment: "是否发布"
      t.string  "banner_type", default: "homepage", comment: "homepage 首页banner, crowdfunding 众筹banner"
      t.index ["source_type", "source_id"], name: "index_banners_on_source_type_and_source_id", using: :btree
    end
    create_table "bills", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "merchant_id",                                                                  comment: "商户号"
      t.string   "order_number", limit: 30,                                                      comment: "订单号"
      t.decimal  "amount",                  precision: 8, scale: 2, default: "0.0"
      t.string   "pay_time",                                                                     comment: "支付时间"
      t.string   "trade_number",                                                                 comment: "交易商户编号"
      t.string   "trade_status",                                                                 comment: "返回的status"
      t.string   "trade_code",                                                                   comment: "返回的code"
      t.string   "trade_msg",                                                                    comment: "返回的交易状态信息"
      t.datetime "created_at",                                                      null: false
      t.datetime "updated_at",                                                      null: false
    end
    create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string  "name"
      t.string  "image"
      t.integer "parent_id"
      t.integer "lft",                        null: false
      t.integer "rgt",                        null: false
      t.integer "depth",          default: 0, null: false
      t.integer "children_count", default: 0, null: false, comment: "该分类下所有子分类的统计"
      t.integer "products_count", default: 0, null: false, comment: "该分类下所有产品的统计"
      t.index ["lft"], name: "index_categories_on_lft", using: :btree
      t.index ["parent_id"], name: "index_categories_on_parent_id", using: :btree
      t.index ["rgt"], name: "index_categories_on_rgt", using: :btree
    end
    create_table "cities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string "city_id"
      t.string "name"
      t.string "province_id"
    end
    create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.string   "topic_type",                                                comment: "评论的节点资讯或视频"
      t.integer  "topic_id",                                                  comment: "评论的节点资讯或视频"
      t.text     "body",           limit: 65535,                              comment: "评论内容"
      t.datetime "deleted_at"
      t.string   "deleted_reason"
      t.datetime "created_at",                                   null: false
      t.datetime "updated_at",                                   null: false
      t.boolean  "recommended",                  default: false,              comment: "是否精选"
      t.boolean  "deleted",                      default: false,              comment: "是否删除"
      t.integer  "reply_count",                  default: 0,                  comment: "统计下面有多少个回复"
      t.index ["topic_type", "topic_id"], name: "index_comments_on_topic_type_and_topic_id", using: :btree
      t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
    end
    create_table "crowdfunding_banners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "image"
      t.string   "source_type"
      t.integer  "source_id"
      t.string   "link",                                     comment: "链接地址"
      t.bigint   "position",    default: 0,                  comment: "用于拖拽排序"
      t.boolean  "published",   default: false,              comment: "是否发布"
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
      t.index ["source_type", "source_id"], name: "index_crowdfunding_banners_on_source_type_and_source_id", using: :btree
    end
    create_table "crowdfunding_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "crowdfunding_id"
      t.string   "name",                          default: "",              comment: "栏目名字"
      t.text     "description",     limit: 65535,                           comment: "栏目对应的描述"
      t.integer  "position",                      default: 0,               comment: "排序"
      t.datetime "created_at",                                 null: false
      t.datetime "updated_at",                                 null: false
      t.index ["crowdfunding_id"], name: "index_crowdfunding_categories_on_crowdfunding_id", using: :btree
    end
    create_table "crowdfunding_counters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "crowdfunding_id"
      t.integer  "page_views",      default: 0,              comment: "浏览量"
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
      t.index ["crowdfunding_id"], name: "index_crowdfunding_counters_on_crowdfunding_id", using: :btree
    end
    create_table "crowdfunding_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "crowdfunding_player_id"
      t.integer  "user_id"
      t.integer  "crowdfunding_id"
      t.string   "order_number",                                                                        comment: "订单号"
      t.integer  "order_stock_number",                             default: 0,                          comment: "认购该牌手的份数"
      t.integer  "order_stock_money",                              default: 0,                          comment: "认购该牌手的单份价格"
      t.boolean  "paid",                                           default: false,                      comment: "是否付款"
      t.datetime "pay_time",                                                                            comment: "付款的时间"
      t.integer  "total_money",                                    default: 0,                          comment: "支付的总价格"
      t.boolean  "deleted",                                        default: false,                      comment: "是否删除"
      t.datetime "created_at",                                                             null: false
      t.datetime "updated_at",                                                             null: false
      t.string   "record_status",                                  default: "unpublished",              comment: "unpublished未公布，success晋级成功, failed失败"
      t.integer  "poker_coins",                                    default: 0,                          comment: "扑客币更换为整形"
      t.integer  "user_extra_id"
      t.boolean  "deduction",                                      default: false,                      comment: "是否使用扑客币抵扣"
      t.integer  "deduction_numbers",                              default: 0,                          comment: "抵扣的扑客币数量"
      t.string   "deduction_result",                               default: "init",                     comment: "扑客币的抵扣状态，init，success，failed"
      t.decimal  "final_price",            precision: 8, scale: 2, default: "0.0",                      comment: "最终付款的价格"
      t.decimal  "deduction_price",        precision: 8, scale: 2, default: "0.0",                      comment: "扑客币折扣的价格"
      t.index ["crowdfunding_id"], name: "index_crowdfunding_orders_on_crowdfunding_id", using: :btree
      t.index ["crowdfunding_player_id"], name: "index_crowdfunding_orders_on_crowdfunding_player_id", using: :btree
      t.index ["user_extra_id"], name: "index_crowdfunding_orders_on_user_extra_id", using: :btree
      t.index ["user_id"], name: "index_crowdfunding_orders_on_user_id", using: :btree
    end
    create_table "crowdfunding_player_counters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "crowdfunding_player_id"
      t.integer  "crowdfunding_id"
      t.integer  "fans",                   default: 0,              comment: "认购人数，只有付完款才统计"
      t.integer  "order_stock_number",     default: 0,              comment: "认购的份数"
      t.integer  "order_stock_money",      default: 0,              comment: "认购的金额"
      t.datetime "created_at",                         null: false
      t.datetime "updated_at",                         null: false
      t.integer  "total_money",            default: 0,              comment: "支付的总价格"
      t.index ["crowdfunding_id"], name: "index_crowdfunding_player_counters_on_crowdfunding_id", using: :btree
      t.index ["crowdfunding_player_id"], name: "index_crowdfunding_player_counters_on_crowdfunding_player_id", using: :btree
    end
    create_table "crowdfunding_players", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "crowdfunding_id"
      t.integer  "player_id"
      t.string   "join_slogan",                                           comment: "参赛口号"
      t.integer  "sell_stock",       default: 0,                          comment: "出让股份百分比"
      t.integer  "stock_number",     default: 0,                          comment: "股份划分的份数"
      t.integer  "stock_unit_price", default: 0,                          comment: "每股单价"
      t.integer  "cf_money",         default: 0,                          comment: "众筹总额"
      t.integer  "limit_buy",        default: 0,                          comment: "限购的份数, 0表示不限购"
      t.boolean  "published",        default: false,                      comment: "是否发布"
      t.datetime "created_at",                               null: false
      t.datetime "updated_at",                               null: false
      t.string   "award_status",     default: "init",                     comment: "init未开始，waiting等待下发, completed完成下发"
      t.string   "record_status",    default: "unpublished",              comment: "unpublished未公布，success晋级成功, failed失败"
      t.index ["crowdfunding_id"], name: "index_crowdfunding_players_on_crowdfunding_id", using: :btree
      t.index ["player_id"], name: "index_crowdfunding_players_on_player_id", using: :btree
    end
    create_table "crowdfunding_ranks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "race_id"
      t.integer  "player_id"
      t.integer  "ranking",                                                                     comment: "排名"
      t.integer  "earning",                                                                     comment: "收入奖金"
      t.integer  "score",                                                                       comment: "得分"
      t.boolean  "awarded",                                        default: false,              comment: "是否进入钱圈"
      t.boolean  "finaled",                                        default: false,              comment: "是否进入决赛"
      t.decimal  "deduct_tax",             precision: 8, scale: 2, default: "0.0",              comment: "扣除的费用,数字"
      t.datetime "created_at",                                                     null: false
      t.datetime "updated_at",                                                     null: false
      t.integer  "crowdfunding_id"
      t.integer  "crowdfunding_player_id"
      t.date     "end_date",                                                                    comment: "赛事结束的日期"
      t.decimal  "sale_amount",            precision: 8, scale: 2, default: "0.0",              comment: "出让总金额"
      t.decimal  "total_amount",           precision: 8, scale: 2, default: "0.0",              comment: "总金额"
      t.decimal  "platform_tax",           precision: 5, scale: 2, default: "0.0",              comment: "平台扣除百分比"
      t.decimal  "unit_amount",            precision: 8, scale: 2, default: "0.0",              comment: "单份金额"
      t.index ["crowdfunding_id"], name: "index_crowdfunding_ranks_on_crowdfunding_id", using: :btree
      t.index ["crowdfunding_player_id"], name: "index_crowdfunding_ranks_on_crowdfunding_player_id", using: :btree
      t.index ["player_id"], name: "index_crowdfunding_ranks_on_player_id", using: :btree
      t.index ["race_id"], name: "index_crowdfunding_ranks_on_race_id", using: :btree
    end
    create_table "crowdfunding_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "crowdfunding_id"
      t.integer  "crowdfunding_player_id"
      t.datetime "record_time",                                                     comment: "赛事的记录时间"
      t.string   "title",                                default: "",               comment: "赛事标题"
      t.integer  "level",                                default: 0,                comment: "赛事级别"
      t.string   "small_blind",                          default: "0",              comment: "最小盲注"
      t.string   "big_blind",                            default: "0",              comment: "最大盲注"
      t.string   "ante",                                 default: "0",              comment: "前注"
      t.text     "description",            limit: 65535,                            comment: "图文内容"
      t.datetime "created_at",                                         null: false
      t.datetime "updated_at",                                         null: false
      t.string   "name",                                 default: "",               comment: "赛事的主标题名字"
      t.index ["crowdfunding_id"], name: "index_crowdfunding_reports_on_crowdfunding_id", using: :btree
      t.index ["crowdfunding_player_id"], name: "index_crowdfunding_reports_on_crowdfunding_player_id", using: :btree
    end
    create_table "crowdfundings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "race_id"
      t.string   "master_image",                              comment: "众筹主图"
      t.integer  "cf_cond",      default: 0,                  comment: "参加众筹条件"
      t.date     "expire_date",                               comment: "截止日期"
      t.date     "publish_date",                              comment: "公布日期"
      t.date     "award_date",                                comment: "发奖时间"
      t.boolean  "published",    default: false,              comment: "是否发布"
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
      t.index ["race_id"], name: "index_crowdfundings_on_race_id", using: :btree
    end
    create_table "dynamics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.string   "typological_type",                                 comment: "动态的类型,评论，点赞或回复"
      t.integer  "typological_id",                                   comment: "动态的类型,评论，点赞或回复"
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
      t.string   "option_type",      default: "normal",              comment: "normal,普通评论或回复，delete后台删除"
      t.index ["option_type"], name: "index_dynamics_on_option_type", using: :btree
      t.index ["typological_type", "typological_id"], name: "index_dynamics_on_typological_type_and_typological_id", using: :btree
      t.index ["user_id"], name: "index_dynamics_on_user_id", using: :btree
    end
    create_table "express_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string  "name",                         comment: "快递公司名称"
      t.string  "express_code",                 comment: "快递编码"
      t.string  "region",                       comment: "快递区域: 国外foreign, 国内china，transfer转运"
      t.boolean "published",    default: false, comment: "是否发布"
      t.string  "phone",        default: "",    comment: "官方电话"
      t.string  "site",         default: "",    comment: "官网地址"
    end
    create_table "feedbacks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "user_id", default: 0
      t.string  "content",                 comment: "反馈内容"
      t.string  "contact",                 comment: "联系方式"
      t.boolean "dealt",   default: false, comment: "是否已处理"
      t.index ["user_id"], name: "index_feedbacks_on_user_id", using: :btree
    end
    create_table "fre_special_provinces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "fre_special_id"
      t.integer  "province_id"
      t.string   "province_name"
      t.datetime "created_at",     null: false
      t.datetime "updated_at",     null: false
      t.index ["fre_special_id"], name: "index_fre_special_provinces_on_fre_special_id", using: :btree
      t.index ["province_id"], name: "index_fre_special_provinces_on_province_id", using: :btree
    end
    create_table "fre_specials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "freight_id"
      t.integer  "first_cond"
      t.decimal  "first_price", precision: 5, scale: 2
      t.integer  "add_cond"
      t.decimal  "add_price",   precision: 5, scale: 2
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
      t.index ["freight_id"], name: "index_fre_specials_on_freight_id", using: :btree
    end
    create_table "freights", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "name"
      t.integer  "first_cond"
      t.decimal  "first_price",  precision: 5, scale: 2
      t.integer  "add_cond"
      t.decimal  "add_price",    precision: 5, scale: 2
      t.boolean  "default",                              default: false,              comment: "是否默认"
      t.string   "freight_type",                         default: "",                 comment: "类型"
      t.datetime "created_at",                                           null: false
      t.datetime "updated_at",                                           null: false
    end
    create_table "headlines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string  "source_type"
      t.integer "source_id"
      t.string  "title",                       comment: "头条标题"
      t.bigint  "position",                    comment: "用于拖拽排序"
      t.boolean "published",   default: false, comment: "是否发布"
      t.index ["source_type", "source_id"], name: "index_headlines_on_source_type_and_source_id", using: :btree
    end
    create_table "hot_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string  "source_type"
      t.integer "source_id"
      t.bigint  "position",    comment: "用于拖拽排序"
      t.index ["source_type", "source_id"], name: "index_hot_infos_on_source_type_and_source_id", using: :btree
    end
    create_table "info_counters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "page_views",     default: 0, comment: "浏览量"
      t.integer "view_increment", default: 0, comment: "浏览量增量"
      t.integer "likes",          default: 0, comment: "点赞数"
      t.integer "info_id"
      t.index ["info_id"], name: "index_info_counters_on_info_id", using: :btree
    end
    create_table "info_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "info_type_id",                                                  comment: "外键对应info_type_en_id"
      t.string   "title",                                                         comment: "资讯标题"
      t.date     "date",                                                          comment: "资讯时间"
      t.string   "source_type",                   default: "source",              comment: "source 来源, author 作者"
      t.string   "source",                                                        comment: "内容"
      t.string   "image",                                                         comment: "图片"
      t.boolean  "top",                           default: false,                 comment: "是否置顶"
      t.boolean  "published",                     default: false,                 comment: "是否发布"
      t.text     "description",  limit: 16777215,                                 comment: "图文内容"
      t.datetime "created_at",                                       null: false
      t.datetime "updated_at",                                       null: false
      t.boolean  "is_show",                       default: true,                  comment: "是否显示出来"
      t.integer  "race_tag_id"
      t.index ["race_tag_id"], name: "index_info_ens_on_race_tag_id", using: :btree
    end
    create_table "info_type_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "name",                                    comment: "类别的名称"
      t.boolean  "published",  default: false,              comment: "是否发布"
      t.integer  "level",      default: 0,                  comment: "类别排序级别"
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
    end
    create_table "info_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "name",                                    comment: "类别的名称"
      t.boolean  "published",  default: false,              comment: "是否发布"
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
      t.integer  "level",      default: 0,                  comment: "类别排序级别"
    end
    create_table "infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "info_type_id"
      t.string   "title",                                                         comment: "资讯标题"
      t.date     "date"
      t.string   "source_type",                   default: "source",              comment: "source 来源, author 作者"
      t.string   "source",                                                        comment: "内容"
      t.string   "image",                                                         comment: "图片"
      t.boolean  "top",                           default: false,                 comment: "是否置顶"
      t.boolean  "published",                     default: false,                 comment: "是否发布"
      t.text     "description",  limit: 16777215,                                 comment: "图文内容"
      t.datetime "created_at",                                       null: false
      t.datetime "updated_at",                                       null: false
      t.boolean  "is_show",                       default: true,                  comment: "是否显示出来"
      t.integer  "race_tag_id"
      t.index ["info_type_id"], name: "index_infos_on_info_type_id", using: :btree
      t.index ["race_tag_id"], name: "index_infos_on_race_tag_id", using: :btree
    end
    create_table "invite_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "name"
      t.string   "mobile"
      t.string   "email"
      t.string   "code"
      t.datetime "created_at",                            null: false
      t.datetime "updated_at",                            null: false
      t.string   "coupon_type",   default: "no_discount",              comment: "邀请码优惠类型， rebate是打折，reduce是减价格, 默认是none，没有优惠"
      t.integer  "coupon_number", default: 0,                          comment: "邀请码折扣数量， 打折的话是数字大小0..100, 减价0..商品价格"
    end
    create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "user_id",                                   null: false
      t.string   "notify_type",                               null: false, comment: "消息类型:order 订单, certification 实名认证"
      t.string   "title",                                     null: false, comment: "标题"
      t.text     "content",     limit: 65535,                 null: false, comment: "内容"
      t.string   "source_type",                                            comment: "产生消息的出处"
      t.integer  "source_id",                                              comment: "产生消息的出处"
      t.datetime "created_at",                                null: false
      t.datetime "updated_at",                                null: false
      t.text     "extra_data",  limit: 65535,                              comment: "使用json存额外信息"
      t.string   "color_type",                                             comment: "颜色类型：success 成功，failure 失败"
      t.boolean  "read",                      default: false,              comment: "是否已读"
      t.index ["source_type", "source_id"], name: "index_notifications_on_source_type_and_source_id", using: :btree
      t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
    end
    create_table "offline_race_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "invite_code_id"
      t.string   "mobile"
      t.string   "email"
      t.string   "name"
      t.string   "ticket"
      t.integer  "price"
      t.datetime "created_at",     null: false
      t.datetime "updated_at",     null: false
      t.index ["invite_code_id"], name: "index_offline_race_orders_on_invite_code_id", using: :btree
    end
    create_table "option_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "product_id"
      t.string   "name"
      t.integer  "position",   default: 0, null: false
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
      t.index ["product_id"], name: "index_option_types_on_product_id", using: :btree
    end
    create_table "option_values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "option_type_id"
      t.string   "name"
      t.integer  "position",       default: 0
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
      t.index ["option_type_id"], name: "index_option_values_on_option_type_id", using: :btree
    end
    create_table "order_snapshots", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "purchase_order_id"
      t.integer "race_id"
      t.string  "name",              limit: 256,                          comment: "赛事的名称"
      t.string  "logo",              limit: 256,                          comment: "赛事的logo"
      t.integer "prize",                         default: 0, null: false, comment: "赛事的奖池"
      t.string  "location",          limit: 256,                          comment: "赛事比赛地点"
      t.integer "ticket_price",                  default: 0,              comment: "票的价格"
      t.date    "begin_date",                                             comment: "赛事开始日期"
      t.date    "end_date",                                               comment: "赛事结束的日期"
      t.index ["purchase_order_id"], name: "index_order_snapshots_on_purchase_order_id", using: :btree
      t.index ["race_id"], name: "index_order_snapshots_on_race_id", using: :btree
    end
    create_table "photos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "user_type"
      t.integer  "user_id"
      t.string   "image"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_type", "user_id"], name: "index_photos_on_user_type_and_user_id", using: :btree
    end
    create_table "player_follows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.integer  "player_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["player_id"], name: "index_player_follows_on_player_id", using: :btree
      t.index ["user_id"], name: "index_player_follows_on_user_id", using: :btree
    end
    create_table "player_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "player_id"
      t.string  "image"
      t.bigint  "position",  default: 0
      t.index ["player_id"], name: "index_player_images_on_player_id", using: :btree
    end
    create_table "player_scores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "race_id"
      t.string  "player_id", limit: 32, comment: "牌手的uuid"
      t.integer "earning"
      t.integer "score"
      t.index ["race_id"], name: "index_player_scores_on_race_id", using: :btree
    end
    create_table "players", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "player_id",         limit: 32,                                  comment: "牌手的uuid"
      t.string   "name",                               default: "",               comment: "牌手的姓名"
      t.string   "avatar",            limit: 100,                                 comment: "牌手头像"
      t.string   "gender",                             default: "0",              comment: "牌手的性别, 0表示男， 1表示女"
      t.string   "country",                            default: "",               comment: "牌手的国籍"
      t.integer  "dpi_total_earning"
      t.integer  "gpi_total_earning"
      t.integer  "dpi_total_score"
      t.integer  "gpi_total_score"
      t.string   "memo",                               default: "",               comment: "备忘"
      t.datetime "created_at",                                       null: false
      t.datetime "updated_at",                                       null: false
      t.string   "avatar_md5",        limit: 32,       default: "",  null: false, comment: "用户图像md5"
      t.integer  "follows_count",                      default: 0,                comment: "该牌手的被关注数"
      t.string   "nick_name",                          default: "",               comment: "牌手昵称"
      t.string   "logo",                                                          comment: "牌手用于展示的头像"
      t.text     "description",       limit: 16777215,                            comment: "牌手描述"
      t.integer  "lairage_rate",                       default: 0,                comment: "进圈率"
      t.integer  "final_rate",                         default: 0,                comment: "决赛率"
    end
    create_table "poker_coin_discounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.decimal  "discount",   precision: 3, scale: 2, default: "0.0",              comment: "扑客币换成浮点数"
      t.datetime "created_at",                                         null: false
      t.datetime "updated_at",                                         null: false
    end
    create_table "poker_coins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.string   "typeable_type",                            comment: "扑客币来源的类型"
      t.integer  "typeable_id",                              comment: "扑客币来源的类型"
      t.string   "memo",           default: "",              comment: "备忘"
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
      t.integer  "number",         default: 0,               comment: "扑客币更换为整形"
      t.string   "orderable_type",                           comment: "记录扑客币的去向"
      t.integer  "orderable_id",                             comment: "记录扑客币的去向"
      t.index ["orderable_type", "orderable_id"], name: "index_poker_coins_on_orderable_type_and_orderable_id", using: :btree
      t.index ["typeable_type", "typeable_id"], name: "index_poker_coins_on_typeable_type_and_typeable_id", using: :btree
      t.index ["user_id"], name: "index_poker_coins_on_user_id", using: :btree
    end
    create_table "product_counters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "product_id"
      t.integer "all_page_view", default: 0, comment: "总浏览量"
      t.integer "sales_volume",  default: 0, comment: "销售量"
      t.index ["product_id"], name: "index_product_counters_on_product_id", using: :btree
    end
    create_table "product_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string  "viewable_type"
      t.integer "viewable_id"
      t.string  "filename"
      t.integer "position",      default: 0
      t.index ["viewable_type", "viewable_id"], name: "index_product_images_on_viewable_type_and_viewable_id", using: :btree
    end
    create_table "product_order_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "product_order_id"
      t.integer  "variant_id"
      t.decimal  "original_price",    precision: 8, scale: 2,                  null: false, comment: "原始价格"
      t.decimal  "price",             precision: 8, scale: 2,                  null: false, comment: "实际价格"
      t.integer  "number",                                                     null: false, comment: "购买数量"
      t.string   "sku_value",                                 default: "",                  comment: "商品属性组合"
      t.datetime "created_at",                                                 null: false
      t.datetime "updated_at",                                                 null: false
      t.boolean  "seven_days_return",                         default: false,               comment: "是否支持7天退货"
      t.string   "refund_status",                             default: "none",              comment: "none, open, close, completed"
      t.integer  "product_id"
      t.index ["product_id"], name: "index_product_order_items_on_product_id", using: :btree
      t.index ["product_order_id"], name: "index_product_order_items_on_product_order_id", using: :btree
      t.index ["variant_id"], name: "index_product_order_items_on_variant_id", using: :btree
    end
    create_table "product_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.string   "order_number",        limit: 32,                                            null: false, comment: "商品订单编号"
      t.string   "status",                                                 default: "unpaid",              comment: "订单状态"
      t.string   "pay_status",                                             default: "unpaid",              comment: "支付状态"
      t.decimal  "shipping_price",                 precision: 5, scale: 2, default: "0.0",                 comment: "总运费"
      t.decimal  "total_product_price",            precision: 8, scale: 2, default: "0.0",                 comment: "总商品费用"
      t.decimal  "total_price",                    precision: 8, scale: 2, default: "0.0",                 comment: "支付费用，包含订单商品和运费"
      t.datetime "cancelled_at",                                                                           comment: "取消时间"
      t.string   "cancel_reason",                                          default: "",                    comment: "取消原因"
      t.datetime "created_at",                                                                null: false
      t.datetime "updated_at",                                                                null: false
      t.boolean  "delivered",                                              default: false
      t.boolean  "freight_free",                                           default: false,                 comment: "是否免运费"
      t.string   "memo",                                                                                   comment: "用户备注"
      t.datetime "delivered_time",                                                                         comment: "发货时间"
      t.datetime "completed_time",                                                                         comment: "确认收货时间"
      t.boolean  "deleted",                                                default: false,                 comment: "是否删除"
      t.boolean  "deduction",                                              default: false,                 comment: "是否使用扑客币抵扣"
      t.integer  "deduction_numbers",                                      default: 0,                     comment: "抵扣的扑客币数量"
      t.string   "deduction_result",                                       default: "init",                comment: "扑客币的抵扣状态，init，success，failed"
      t.decimal  "final_price",                    precision: 8, scale: 2, default: "0.0",                 comment: "最终付款的价格"
      t.decimal  "deduction_price",                precision: 8, scale: 2, default: "0.0",                 comment: "扑客币折扣的价格"
      t.decimal  "refund_price",                   precision: 8, scale: 2, default: "0.0",                 comment: "已退款的金额"
      t.integer  "refund_poker_coins",                                     default: 0,                     comment: "已退的扑客币数量"
      t.index ["order_number"], name: "index_product_orders_on_order_number", using: :btree
      t.index ["user_id"], name: "index_product_orders_on_user_id", using: :btree
    end
    create_table "product_refund_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "product_order_item_id"
      t.integer  "product_refund_id"
      t.datetime "created_at",            null: false
      t.datetime "updated_at",            null: false
      t.index ["product_order_item_id"], name: "index_product_refund_details_on_product_order_item_id", using: :btree
      t.index ["product_refund_id"], name: "index_product_refund_details_on_product_refund_id", using: :btree
    end
    create_table "product_refund_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "product_refund_id"
      t.string   "image",                          comment: "用户退款的图片"
      t.string   "memo",                           comment: "图片说明"
      t.datetime "created_at",        null: false
      t.datetime "updated_at",        null: false
      t.index ["product_refund_id"], name: "index_product_refund_images_on_product_refund_id", using: :btree
    end
    create_table "product_refund_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    create_table "product_refunds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "product_refund_type_id"
      t.string   "refund_number",          limit: 32,                                          null: false, comment: "商品退款编号"
      t.decimal  "refund_price",                      precision: 8, scale: 2,                  null: false, comment: "退款金额"
      t.string   "memo",                                                                                    comment: "申请退换原因"
      t.string   "admin_memo",                                                                              comment: "审核结果原因"
      t.string   "status",                                                    default: "open",              comment: "退换货状态open审核中, close关闭或审核不通过, completed审核通过完成"
      t.datetime "created_at",                                                                 null: false
      t.datetime "updated_at",                                                                 null: false
      t.integer  "product_order_id"
      t.integer  "refund_poker_coins",                                        default: 0,                   comment: "需要退的扑客币数量"
      t.index ["product_order_id"], name: "index_product_refunds_on_product_order_id", using: :btree
      t.index ["product_refund_type_id"], name: "index_product_refunds_on_product_refund_type_id", using: :btree
    end
    create_table "product_shipment_with_order_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "product_shipment_id"
      t.integer  "product_order_item_id"
      t.datetime "created_at",            null: false
      t.datetime "updated_at",            null: false
      t.index ["product_order_item_id"], name: "index_product_shipment_with_order_items_on_product_order_item_id", using: :btree
      t.index ["product_shipment_id"], name: "index_product_shipment_with_order_items_on_product_shipment_id", using: :btree
    end
    create_table "product_shipments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "product_order_id"
      t.integer  "express_code_id"
      t.string   "shipping_company",              comment: "快递公司"
      t.string   "shipping_number",               comment: "快递单号"
      t.datetime "created_at",       null: false
      t.datetime "updated_at",       null: false
      t.index ["express_code_id"], name: "index_product_shipments_on_express_code_id", using: :btree
      t.index ["product_order_id"], name: "index_product_shipments_on_product_order_id", using: :btree
    end
    create_table "product_shipping_addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "product_order_id"
      t.string   "name",                          comment: "收货人姓名"
      t.string   "province"
      t.string   "city"
      t.string   "area"
      t.string   "address"
      t.string   "mobile"
      t.string   "zip"
      t.string   "change_reason",                 comment: "后台修改地址的原因"
      t.string   "memo",                          comment: "修改备注"
      t.datetime "created_at",       null: false
      t.datetime "updated_at",       null: false
      t.index ["product_order_id"], name: "index_product_shipping_addresses_on_product_order_id", using: :btree
    end
    create_table "product_wx_bills", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "product_order_id"
      t.string   "bank_type",                     comment: "付款银行"
      t.integer  "cash_fee",                      comment: "现金支付金额"
      t.string   "fee_type",                      comment: "货币类型"
      t.string   "is_subscribe",                  comment: "是否关注"
      t.string   "mch_id",                        comment: "商户ID"
      t.string   "open_id",                       comment: "支付用户的openid"
      t.string   "time_end",                      comment: "订单支付时间"
      t.integer  "total_fee",                     comment: "订单总金额"
      t.string   "trade_type",                    comment: "交易类型"
      t.string   "transaction_id",                comment: "微信支付的流水号"
      t.string   "result_code"
      t.string   "return_code"
      t.datetime "created_at",       null: false
      t.datetime "updated_at",       null: false
      t.index ["product_order_id"], name: "index_product_wx_bills_on_product_order_id", using: :btree
    end
    create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "category_id"
      t.string   "title"
      t.string   "icon"
      t.text     "description",       limit: 65535
      t.datetime "created_at",                                         null: false
      t.datetime "updated_at",                                         null: false
      t.boolean  "published",                       default: false,                 comment: "是否上架"
      t.boolean  "recommended",                     default: false,                 comment: "是否推荐"
      t.string   "product_type",                    default: "entity",              comment: "entity 实物， virtual 虚拟物品"
      t.integer  "freight_id"
      t.boolean  "freight_free",                    default: false,                 comment: "是否免运费"
      t.boolean  "seven_days_return",               default: false,                 comment: "是否支持7天退货"
      t.index ["category_id"], name: "index_products_on_category_id", using: :btree
      t.index ["freight_id"], name: "index_products_on_freight_id", using: :btree
    end
    create_table "provinces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string "name"
      t.string "province_id"
    end
    create_table "purchase_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "user_id"
      t.integer  "ticket_id"
      t.integer  "race_id"
      t.string   "ticket_type",       limit: 30,                         default: "e_ticket",              comment: "票的类型 e_ticket-电子票, entity_ticket-实体票"
      t.string   "email",                                                                                  comment: "电子票发送邮箱"
      t.string   "address",                                                                                comment: "实体票邮寄地址"
      t.string   "consignee",         limit: 50,                                                           comment: "收货人"
      t.string   "mobile",            limit: 50,                                                           comment: "联系方式"
      t.string   "order_number",      limit: 30,                                                           comment: "订单号"
      t.integer  "price",                                                                     null: false, comment: "价格"
      t.integer  "original_price",                                                            null: false, comment: "原始价格"
      t.string   "status",            limit: 30,                         default: "unpaid",                comment: "订单状态 unpaid-未付款, paid-已付款, delivered-已发货， completed-已完成, canceled-已取消"
      t.datetime "created_at",                                                                null: false
      t.datetime "updated_at",                                                                null: false
      t.string   "courier",                                                                                comment: "快递公司名称"
      t.string   "tracking_no",                                                                            comment: "快递单号"
      t.datetime "delivery_time",                                                                          comment: "发货时间"
      t.string   "invite_code",                                                                            comment: "用户填写的邀请码"
      t.integer  "user_extra_id"
      t.boolean  "deduction",                                            default: false,                   comment: "是否使用扑客币抵扣"
      t.integer  "deduction_numbers",                                    default: 0,                       comment: "抵扣的扑客币数量"
      t.string   "deduction_result",                                     default: "init",                  comment: "扑客币的抵扣状态，init，success，failed"
      t.decimal  "final_price",                  precision: 8, scale: 2, default: "0.0",                   comment: "最终付款的价格"
      t.decimal  "deduction_price",              precision: 8, scale: 2, default: "0.0",                   comment: "扑客币折扣的价格"
      t.index ["order_number"], name: "index_purchase_orders_on_order_number", unique: true, using: :btree
      t.index ["race_id"], name: "index_purchase_orders_on_race_id", using: :btree
      t.index ["status"], name: "index_purchase_orders_on_status", using: :btree
      t.index ["ticket_id"], name: "index_purchase_orders_on_ticket_id", using: :btree
      t.index ["user_extra_id"], name: "index_purchase_orders_on_user_extra_id", using: :btree
      t.index ["user_id"], name: "index_purchase_orders_on_user_id", using: :btree
    end
    create_table "race_blind_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "race_id"
      t.integer  "level",       default: 0,                  comment: "级别"
      t.string   "small_blind", default: "0",                comment: "最小盲注"
      t.string   "big_blind",   default: "0",                comment: "最大盲注"
      t.string   "ante",        default: "0",                comment: "前注"
      t.string   "race_time",   default: "0",                comment: "赛事时间"
      t.string   "content",     default: "",                 comment: "文字输入类型对应的内容"
      t.integer  "blind_type",  default: 0,                  comment: "0表示有盲注，前注这些结构， 1表示有文字输入"
      t.bigint   "position",    default: 10000,              comment: "用于拖拽排序"
      t.datetime "created_at",                  null: false
      t.datetime "updated_at",                  null: false
      t.index ["race_id"], name: "index_race_blind_ens_on_race_id", using: :btree
    end
    create_table "race_blinds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "race_id"
      t.integer  "level",       default: 0,                comment: "级别"
      t.string   "small_blind", default: "0",              comment: "最小盲注"
      t.string   "big_blind",   default: "0",              comment: "最大盲注"
      t.string   "ante",        default: "0",              comment: "前注"
      t.string   "race_time",   default: "0",              comment: "赛事时间"
      t.string   "content",     default: "",               comment: "文字输入类型对应的内容"
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
      t.integer  "blind_type",  default: 0,                comment: "0表示有盲注，前注这些结构， 1表示有文字输入"
      t.bigint   "position",    default: 0,                comment: "用于拖拽排序"
      t.index ["race_id"], name: "index_race_blinds_on_race_id", using: :btree
    end
    create_table "race_desc_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "race_id"
      t.text     "description", limit: 65535
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
      t.text     "schedules",   limit: 65535,              comment: "赛程信息"
      t.index ["race_id"], name: "index_race_descs_on_race_id", using: :btree
    end
    create_table "race_descs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "race_id"
      t.text     "description", limit: 65535
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
      t.text     "schedules",   limit: 65535,              comment: "赛程信息"
      t.index ["race_id"], name: "index_race_descs_on_race_id", using: :btree
    end
    create_table "race_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "name",                limit: 256,                              comment: "赛事的名称"
      t.bigint   "seq_id",                          default: 0,     null: false, comment: "为每一个赛事增加的id"
      t.string   "logo",                limit: 256,                              comment: "赛事的logo"
      t.string   "prize",                           default: "",    null: false, comment: "赛事的奖池"
      t.string   "location",            limit: 256,                              comment: "赛事比赛地点"
      t.date     "begin_date",                                                   comment: "赛事开始日期"
      t.date     "end_date",                                                     comment: "赛事结束的日期"
      t.integer  "status",                          default: 0,     null: false, comment: "赛事的状态 0-未开始  1-进行中  2-已结束  3-已关闭"
      t.datetime "created_at",                                      null: false
      t.datetime "updated_at",                                      null: false
      t.string   "ticket_price",                    default: "",                 comment: "票的价格"
      t.boolean  "published",                       default: false,              comment: "该赛事是否已发布"
      t.boolean  "ticket_sellable",                 default: true,               comment: "是否可以售票"
      t.boolean  "describable",                     default: true,               comment: "是否有详情内容"
      t.integer  "parent_id",                       default: 0,                  comment: "主赛的parent_id默认为0， 边赛的parent_id为主赛的id"
      t.boolean  "roy",                             default: false,              comment: "是否有roy"
      t.string   "blind",                           default: "",                 comment: "赛事的盲注"
      t.integer  "participants",                                                 comment: "赛事的参与人数"
      t.integer  "race_host_id"
      t.string   "schedule_begin_time",                                          comment: "赛程开始时间"
      t.string   "required_id_type",                default: "any",              comment: "报名该场赛事所需要身份证明：any 任意一种， chinese_id 中国身份证， passport_id 护照"
      t.index ["begin_date"], name: "index_races_on_begin_date", using: :btree
      t.index ["parent_id"], name: "index_races_on_parent_id", using: :btree
      t.index ["race_host_id"], name: "index_races_on_race_host_id", using: :btree
      t.index ["seq_id"], name: "index_races_on_seq_id", unique: true, using: :btree
    end
    create_table "race_extra_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "race_id"
      t.text    "blind_memo",    limit: 65535, comment: "盲注结构的备注"
      t.text    "schedule_memo", limit: 65535, comment: "赛程的备注"
      t.index ["race_id"], name: "index_race_extra_ens_on_race_id", using: :btree
    end
    create_table "race_extras", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "race_id"
      t.text    "blind_memo",    limit: 65535, comment: "盲注结构的备注"
      t.text    "schedule_memo", limit: 65535, comment: "赛程的备注"
      t.index ["race_id"], name: "index_race_extras_on_race_id", using: :btree
    end
    create_table "race_follows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "user_id"
      t.integer  "race_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["race_id"], name: "index_race_follows_on_race_id", using: :btree
      t.index ["user_id"], name: "index_race_follows_on_user_id", using: :btree
    end
    create_table "race_hosts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "name",                    comment: "主办方名称"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    create_table "race_ranks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "race_id"
      t.integer "player_id"
      t.integer "ranking",               comment: "排名"
      t.integer "earning",   default: 0, comment: "收入奖金"
      t.integer "score",     default: 0, comment: "得分"
      t.date    "end_date",              comment: "赛事结束的日期"
      t.index ["player_id"], name: "index_race_ranks_on_player_id", using: :btree
      t.index ["race_id"], name: "index_race_ranks_on_race_id", using: :btree
    end
    create_table "race_schedule_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "race_id"
      t.string   "schedule",   limit: 100,              comment: "日程表"
      t.datetime "begin_time"
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
      t.index ["race_id"], name: "index_race_schedule_ens_on_race_id", using: :btree
    end
    create_table "race_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "race_id"
      t.string   "schedule",   limit: 25,              comment: "日程表"
      t.datetime "begin_time"
      t.datetime "created_at",            null: false
      t.datetime "updated_at",            null: false
      t.index ["race_id"], name: "index_race_schedules_on_race_id", using: :btree
    end
    create_table "race_tag_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    create_table "race_tag_maps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "race_tag_id"
      t.string   "data_type"
      t.integer  "data_id"
      t.datetime "created_at",  null: false
      t.datetime "updated_at",  null: false
      t.index ["data_type", "data_id"], name: "index_race_tag_maps_on_data_type_and_data_id", using: :btree
      t.index ["race_tag_id"], name: "index_race_tag_maps_on_race_tag_id", using: :btree
    end
    create_table "race_tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    create_table "races", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "name",                limit: 256,                              comment: "赛事的名称"
      t.bigint   "seq_id",                          default: 0,     null: false, comment: "为每一个赛事增加的id"
      t.string   "logo",                limit: 256,                              comment: "赛事的logo"
      t.string   "prize",                           default: "",    null: false, comment: "赛事的奖池"
      t.string   "location",            limit: 256,                              comment: "赛事比赛地点"
      t.date     "begin_date",                                                   comment: "赛事开始日期"
      t.date     "end_date",                                                     comment: "赛事结束的日期"
      t.integer  "status",                          default: 0,     null: false, comment: "赛事的状态 0-未开始  1-进行中  2-已结束  3-已关闭"
      t.datetime "created_at",                                      null: false
      t.datetime "updated_at",                                      null: false
      t.string   "ticket_price",                    default: "",                 comment: "票的价格"
      t.boolean  "published",                       default: false,              comment: "该赛事是否已发布"
      t.boolean  "ticket_sellable",                 default: true,               comment: "是否可以售票"
      t.boolean  "describable",                     default: true,               comment: "是否有详情内容"
      t.integer  "parent_id",                       default: 0,                  comment: "主赛的parent_id默认为0， 边赛的parent_id为主赛的id"
      t.boolean  "roy",                             default: false,              comment: "是否有roy"
      t.string   "blind",                           default: "",                 comment: "赛事的盲注"
      t.integer  "participants",                                                 comment: "赛事的参与人数"
      t.integer  "race_host_id"
      t.string   "schedule_begin_time",                                          comment: "赛程开始时间"
      t.string   "required_id_type",                default: "any",              comment: "报名该场赛事所需要身份证明：any 任意一种， chinese_id 中国身份证， passport_id 护照"
      t.index ["begin_date"], name: "index_races_on_begin_date", using: :btree
      t.index ["parent_id"], name: "index_races_on_parent_id", using: :btree
      t.index ["race_host_id"], name: "index_races_on_race_host_id", using: :btree
      t.index ["seq_id"], name: "index_races_on_seq_id", unique: true, using: :btree
    end
    create_table "ranking_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "name",       limit: 100,              comment: "排名的类型"
      t.datetime "created_at",             null: false
      t.datetime "updated_at",             null: false
    end
    create_table "releases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "keywords",                                comment: "发布模块关键字"
      t.boolean  "published",  default: false,              comment: "是否发布"
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
    end
    create_table "replies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.text     "body",           limit: 65535
      t.datetime "deleted_at"
      t.string   "deleted_reason"
      t.datetime "created_at",                                   null: false
      t.datetime "updated_at",                                   null: false
      t.boolean  "deleted",                      default: false,              comment: "是否删除"
      t.string   "topic_type",                                                comment: "评论的节点资讯或视频"
      t.integer  "topic_id",                                                  comment: "评论的节点资讯或视频"
      t.integer  "comment_id",                                                comment: "追溯回复的哪条评论"
      t.integer  "reply_id",                                                  comment: "追溯回复的是哪条回复"
      t.integer  "reply_user_id",                                             comment: "回复对应的那个人id"
      t.boolean  "is_read",                      default: false,              comment: "标记回复是否已读"
      t.index ["comment_id"], name: "index_replies_on_comment_id", using: :btree
      t.index ["is_read"], name: "index_replies_on_is_read", using: :btree
      t.index ["reply_id"], name: "index_replies_on_reply_id", using: :btree
      t.index ["reply_user_id"], name: "index_replies_on_reply_user_id", using: :btree
      t.index ["topic_type", "topic_id"], name: "index_replies_on_topic_type_and_topic_id", using: :btree
      t.index ["user_id"], name: "index_replies_on_user_id", using: :btree
    end
    create_table "reply_templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "content"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer  "type_id"
    end
    create_table "shipping_addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "user_id"
      t.string   "consignee",      limit: 50,                              comment: "收货人"
      t.string   "mobile",         limit: 50,                              comment: "联系方式"
      t.string   "address",                                                comment: "所在地"
      t.string   "address_detail",                                         comment: "详细地址"
      t.string   "post_code",      limit: 50,                              comment: "邮政编码"
      t.boolean  "default",                   default: false,              comment: "是否为默认地址"
      t.datetime "created_at",                                null: false
      t.datetime "updated_at",                                null: false
      t.string   "province",                  default: "",                 comment: "省份"
      t.string   "city",                      default: "",                 comment: "城市"
      t.string   "area",                      default: "",                 comment: "区域"
      t.index ["user_id"], name: "index_shipping_addresses_on_user_id", using: :btree
    end
    create_table "sms_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "sid",                                           comment: "短信服务商返回回来的短信id"
      t.string   "mobile"
      t.string   "content"
      t.string   "error_msg",                                     comment: "返回回来的错误信息"
      t.integer  "fee",          default: 0,                      comment: "短信计费条数"
      t.datetime "send_time",                                     comment: "发送时间"
      t.datetime "arrival_time",                                  comment: "到达时间"
      t.datetime "created_at",                       null: false
      t.datetime "updated_at",                       null: false
      t.string   "status",       default: "sending",              comment: "发送中-sending, 成功-success, 失败-failed"
    end
    create_table "template_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    create_table "test_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "user_id", default: 0
      t.index ["user_id"], name: "index_test_users_on_user_id", using: :btree
    end
    create_table "ticket_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "race_id"
      t.string   "title",          limit: 256,                                     comment: "票名称"
      t.string   "logo",           limit: 256,                                     comment: "票缩略图"
      t.integer  "price",                                                          comment: "折后价格"
      t.integer  "original_price",                                                 comment: "原始价格"
      t.datetime "created_at",                                        null: false
      t.datetime "updated_at",                                        null: false
      t.string   "ticket_class",                 default: "race",                  comment: "类型:single_ticket -> 仅赛票, package_ticket -> 套票"
      t.text     "description",    limit: 65535,                                   comment: "赛票描述"
      t.string   "status",         limit: 30,    default: "unsold",                comment: "售票的状态 unsold-未售票, selling-售票中, end-售票结束, sold_out-票已售完"
      t.string   "banner",                                                         comment: "横图 750x440"
      t.integer  "level",                        default: 0,                       comment: "用于自定义排序"
      t.string   "role_group",                   default: "everyone",              comment: "everyone 所有人 tester测试人员"
      t.index ["race_id"], name: "index_tickets_on_race_id", using: :btree
    end
    create_table "ticket_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "total_number",              default: 0,              comment: "总票数"
      t.integer  "e_ticket_number",           default: 0,              comment: "总电子票数"
      t.integer  "entity_ticket_number",      default: 0,              comment: "总实体票数"
      t.integer  "e_ticket_sold_number",      default: 0,              comment: "已售电子票数"
      t.integer  "entity_ticket_sold_number", default: 0,              comment: "已售实体票数"
      t.datetime "created_at",                            null: false
      t.datetime "updated_at",                            null: false
      t.integer  "lock_version",              default: 0
      t.integer  "ticket_id"
      t.index ["ticket_id"], name: "index_ticket_infos_on_ticket_id", using: :btree
    end
    create_table "tickets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "race_id"
      t.string   "title",          limit: 256,                                     comment: "票名称"
      t.string   "logo",           limit: 256,                                     comment: "票缩略图"
      t.integer  "price",                                                          comment: "折后价格"
      t.integer  "original_price",                                                 comment: "原始价格"
      t.datetime "created_at",                                        null: false
      t.datetime "updated_at",                                        null: false
      t.string   "ticket_class",                 default: "race",                  comment: "类型:single_ticket -> 仅赛票, package_ticket -> 套票"
      t.text     "description",    limit: 65535,                                   comment: "赛票描述"
      t.string   "status",         limit: 30,    default: "unsold",                comment: "售票的状态 unsold-未售票, selling-售票中, end-售票结束, sold_out-票已售完"
      t.string   "banner",                                                         comment: "横图 750x440"
      t.integer  "level",                        default: 0,                       comment: "用于自定义排序"
      t.string   "role_group",                   default: "everyone",              comment: "everyone 所有人 tester测试人员"
      t.index ["race_id"], name: "index_tickets_on_race_id", using: :btree
    end
    create_table "tmp_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "image",                   comment: "用户上传的临时图片"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    create_table "topic_likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.string   "topic_type",                              comment: "点赞的节点资讯或视频"
      t.integer  "topic_id",                                comment: "点赞的节点资讯或视频"
      t.boolean  "canceled",   default: false,              comment: "是否取消点赞"
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
      t.index ["topic_type", "topic_id"], name: "index_topic_likes_on_topic_type_and_topic_id", using: :btree
      t.index ["user_id"], name: "index_topic_likes_on_user_id", using: :btree
    end
    create_table "topic_view_rules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "day",          default: 0,                  comment: "第几天"
      t.integer  "interval",     default: 0,                  comment: "时间间隔，单位分钟"
      t.integer  "min_increase", default: 0,                  comment: "最小增长量"
      t.integer  "max_increase", default: 0,                  comment: "最大增长量"
      t.boolean  "hot",          default: false,              comment: "是否是热增长"
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
    end
    create_table "topic_view_toggles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "topic_type",                                 comment: "节点资讯或视频"
      t.integer  "topic_id",                                   comment: "节点资讯或视频"
      t.boolean  "toggle_status", default: false,              comment: "是否打开, 默认关闭"
      t.boolean  "hot",           default: false,              comment: "是否是热增长"
      t.datetime "begin_time"
      t.datetime "last_time"
      t.datetime "created_at",                    null: false
      t.datetime "updated_at",                    null: false
      t.index ["topic_type", "topic_id"], name: "index_topic_view_toggles_on_topic_type_and_topic_id", using: :btree
    end
    create_table "user_counters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.integer  "total_poker_coins", default: 0,              comment: "扑客币更换为整形"
      t.datetime "created_at",                    null: false
      t.datetime "updated_at",                    null: false
      t.index ["user_id"], name: "index_user_counters_on_user_id", using: :btree
    end
    create_table "user_extras", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer  "user_id"
      t.string   "real_name",  limit: 50,                                     comment: "真实姓名"
      t.string   "cert_type",  limit: 50, default: "chinese_id",              comment: "证件类型  chinese_id-中国身份证"
      t.string   "cert_no",                                                   comment: "证件号码"
      t.string   "memo",                                                      comment: "备忘"
      t.string   "image",                 default: "",                        comment: "身份证图片"
      t.string   "image_md5",  limit: 32, default: "",           null: false, comment: "图片md5"
      t.string   "status",     limit: 20, default: "init",                    comment: "初始化-init, 审核中-pending, 审核通过-passed, 审核失败-failed"
      t.datetime "created_at",                                   null: false
      t.datetime "updated_at",                                   null: false
      t.integer  "is_delete",             default: 0,                         comment: "0未删除 1删除"
      t.boolean  "default",               default: false,                     comment: "是否默认"
      t.index ["is_delete"], name: "index_user_extras_on_is_delete", using: :btree
      t.index ["user_id"], name: "index_user_extras_on_user_id", using: :btree
    end
    create_table "user_tag_maps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.integer  "user_tag_id"
      t.datetime "created_at",  null: false
      t.datetime "updated_at",  null: false
      t.index ["user_id"], name: "index_user_tag_maps_on_user_id", using: :btree
      t.index ["user_tag_id"], name: "index_user_tag_maps_on_user_tag_id", using: :btree
    end
    create_table "user_tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "user_uuid",      limit: 32,                   null: false, comment: "用户的uuid"
      t.string   "user_name",      limit: 32,                                comment: "用户姓名, 唯一"
      t.string   "nick_name",      limit: 32,                                comment: "用户的昵称"
      t.string   "password",       limit: 32,                                comment: "用户的密码"
      t.string   "password_salt",             default: "",      null: false, comment: "密码盐值"
      t.integer  "gender",                    default: 0,                    comment: "用户的性别, 0表示男， 1表示女, 2未知"
      t.string   "email",          limit: 64,                                comment: "用户的邮箱 唯一"
      t.string   "mobile",         limit: 16,                                comment: "用户手机号 唯一"
      t.string   "avatar",                                                   comment: "用户头像"
      t.date     "birthday",                                                 comment: "用户的生日"
      t.datetime "reg_date",                                                 comment: "注册日期"
      t.datetime "last_visit",                                               comment: "上次登录时间"
      t.datetime "created_at",                                  null: false
      t.datetime "updated_at",                                  null: false
      t.string   "signature",      limit: 64, default: "",      null: false, comment: "个性签名"
      t.string   "avatar_md5",     limit: 32, default: "",      null: false, comment: "用户图像md5"
      t.string   "role",                      default: "basic",              comment: "用户角色"
      t.integer  "login_count",               default: 0,                    comment: "用户登录次数"
      t.string   "mark",                      default: "",                   comment: "用户备注，运营人员用"
      t.string   "wx_avatar"
      t.boolean  "silenced",                  default: false,                comment: "是否被禁言"
      t.datetime "silence_at",                                               comment: "被禁言的时间"
      t.datetime "silence_till",                                             comment: "解禁的时间"
      t.string   "silence_reason",            default: "",                   comment: "被禁言的原因"
      t.boolean  "blocked",                   default: false,                comment: "是否被拉入黑名单"
      t.datetime "blocked_at",                                               comment: "被拉入黑名单时间"
      t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
      t.index ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree
      t.index ["user_name"], name: "index_users_on_user_name", unique: true, using: :btree
      t.index ["user_uuid"], name: "index_users_on_user_uuid", unique: true, using: :btree
    end
    create_table "variant_option_values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "variant_id"
      t.integer "option_value_id"
      t.integer "option_type_id"
      t.index ["option_type_id"], name: "index_variant_option_values_on_option_type_id", using: :btree
      t.index ["option_value_id"], name: "index_variant_option_values_on_option_value_id", using: :btree
      t.index ["variant_id"], name: "index_variant_option_values_on_variant_id", using: :btree
    end
    create_table "variants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "product_id"
      t.string   "sku",                                       default: "",    null: false, comment: "sku"
      t.string   "sku_option_values",                         default: "",    null: false, comment: "该sku(单品)所有选项值的json数据"
      t.decimal  "price",             precision: 8, scale: 2, default: "0.0",              comment: "实付金额"
      t.decimal  "original_price",    precision: 8, scale: 2, default: "0.0"
      t.decimal  "weight",            precision: 8, scale: 3,                              comment: "商品重量，计量单位为kg"
      t.decimal  "volume",            precision: 8, scale: 2,                              comment: "商品体积，计量单位为m3"
      t.integer  "stock",                                     default: 0,                  comment: "库存"
      t.string   "origin_point",                                                           comment: "发货地点"
      t.boolean  "is_master",                                 default: false,              comment: "true 为商品的默认variant的属性"
      t.datetime "deleted_at"
      t.datetime "created_at",                                                null: false
      t.datetime "updated_at",                                                null: false
      t.index ["product_id"], name: "index_variants_on_product_id", using: :btree
    end
    create_table "video_counters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer "page_views",     default: 0, comment: "浏览量"
      t.integer "view_increment", default: 0, comment: "浏览量增量"
      t.integer "likes",          default: 0, comment: "点赞数"
      t.integer "video_id"
      t.index ["video_id"], name: "index_video_counters_on_video_id", using: :btree
    end
    create_table "video_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "video_type_id",                                                comment: "外键对应video_type_en_id"
      t.string   "name",                                                         comment: "视频名称"
      t.string   "video_link",                                                   comment: "视频链接"
      t.string   "cover_link",                                                   comment: "封面链接"
      t.boolean  "top",                             default: false,              comment: "是否置顶"
      t.boolean  "published",                       default: false,              comment: "是否发布"
      t.text     "description",    limit: 16777215,                              comment: "视频描述"
      t.datetime "created_at",                                      null: false
      t.datetime "updated_at",                                      null: false
      t.string   "video_duration",                                               comment: "视频时长"
      t.string   "title_desc",                                                   comment: "视频标题简短描述"
      t.integer  "video_group_id"
      t.boolean  "is_main",                         default: false,              comment: "是否是主视频"
      t.integer  "level",                           default: 0,                  comment: "用于自定义排序"
      t.bigint   "position",                        default: 0,                  comment: "用于拖拽排序"
      t.boolean  "is_show",                         default: true,               comment: "是否显示出来"
      t.integer  "race_tag_id"
      t.index ["race_tag_id"], name: "index_video_ens_on_race_tag_id", using: :btree
      t.index ["video_group_id"], name: "index_video_ens_on_video_group_id", using: :btree
    end
    create_table "video_group_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    create_table "video_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    create_table "video_type_ens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "name"
      t.integer  "level",      default: 0,                  comment: "排序"
      t.boolean  "published",  default: false,              comment: "是否发布"
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
    end
    create_table "video_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "name"
      t.integer  "level",      default: 0,                  comment: "排序"
      t.boolean  "published",  default: false,              comment: "是否发布"
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
    end
    create_table "videos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "video_type_id"
      t.string   "name",                                                         comment: "视频名称"
      t.string   "video_link",                                                   comment: "视频链接"
      t.string   "cover_link",                                                   comment: "封面链接"
      t.boolean  "top",                             default: false,              comment: "是否置顶"
      t.boolean  "published",                       default: false,              comment: "是否发布"
      t.text     "description",    limit: 16777215,                              comment: "视频描述"
      t.datetime "created_at",                                      null: false
      t.datetime "updated_at",                                      null: false
      t.string   "video_duration",                                               comment: "视频时长"
      t.string   "title_desc",                                                   comment: "视频标题简短描述"
      t.integer  "video_group_id"
      t.boolean  "is_main",                         default: false,              comment: "是否是主视频"
      t.integer  "level",                           default: 0,                  comment: "用于自定义排序"
      t.bigint   "position",                        default: 0,                  comment: "用于拖拽排序"
      t.boolean  "is_show",                         default: true,               comment: "是否显示出来"
      t.integer  "race_tag_id"
      t.index ["race_tag_id"], name: "index_videos_on_race_tag_id", using: :btree
      t.index ["video_group_id"], name: "index_videos_on_video_group_id", using: :btree
      t.index ["video_type_id"], name: "index_videos_on_video_type_id", using: :btree
    end
    create_table "weixin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.integer  "user_id"
      t.string   "open_id",                    comment: "用户的open_id"
      t.string   "nick_name",                  comment: "用户昵称"
      t.integer  "sex",                        comment: "用户性别"
      t.string   "province",                   comment: "用户所在的省份"
      t.string   "city",                       comment: "用户所在的城市"
      t.string   "country",                    comment: "用户所在的省份"
      t.string   "head_img",                   comment: "用户头像"
      t.string   "privilege",                  comment: "用户权限列表"
      t.string   "union_id",                   comment: "union id"
      t.datetime "created_at",    null: false
      t.datetime "updated_at",    null: false
      t.string   "access_token"
      t.string   "expires_in"
      t.string   "refresh_token"
      t.index ["user_id"], name: "index_weixin_users_on_user_id", using: :btree
    end
    create_table "wx_bills", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
      t.string   "appid",                                          comment: "授权公众号appid"
      t.string   "bank_type",                                      comment: "付款银行"
      t.integer  "cash_fee",                                       comment: "现金支付金额"
      t.string   "fee_type",                                       comment: "货币类型"
      t.string   "is_subscribe",                                   comment: "是否关注"
      t.string   "mch_id",                                         comment: "商户ID"
      t.string   "open_id",                                        comment: "支付用户的openid"
      t.string   "out_trade_no",                                   comment: "商户订单"
      t.string   "result_code"
      t.string   "return_code"
      t.string   "time_end",                                       comment: "订单支付时间"
      t.integer  "total_fee",                                      comment: "订单总金额"
      t.string   "trade_type",                                     comment: "交易类型"
      t.string   "transaction_id",                                 comment: "微信支付的流水号"
      t.datetime "created_at",                        null: false
      t.datetime "updated_at",                        null: false
      t.string   "bill_type",      default: "ticket",              comment: "ticket 票务的账单, crowdfunding 众筹的账单"
    end
    add_foreign_key "affiliate_apps", "affiliates"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
