class InitDb < ActiveRecord::Migration[5.0]
  def change
    create_table 'account_change_stats', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'user_id'
      t.datetime 'change_time'
      t.string   'account_type', default: 'mobile',              comment: '修改账户的类别 mobile or email'
      t.string   'mender',       default: '',                    comment: '修改者'
      t.datetime 'created_at',                      null: false
      t.datetime 'updated_at',                      null: false
      t.index ['user_id'], name: 'index_account_change_stats_on_user_id', using: :btree
    end

    create_table 'affiliate_apps', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'affiliate_id'
      t.string   'app_id',       limit: 50
      t.string   'app_name',     limit: 100
      t.string   'app_key',      limit: 36
      t.string   'app_secret',   limit: 36
      t.integer  'status',                   default: 0
      t.datetime 'created_at',                           null: false
      t.datetime 'updated_at',                           null: false
      t.index ['affiliate_id'], name: 'index_affiliate_apps_on_affiliate_id', using: :btree
      t.index ['app_key'], name: 'index_affiliate_apps_on_app_key', unique: true, using: :btree
    end

    create_table 'affiliates', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'aff_uuid',   limit: 36
      t.string   'aff_name',   limit: 100
      t.string   'aff_type',   limit: 50,  default: 'company'
      t.integer  'status',                 default: 0
      t.string   'mobile',     limit: 20
      t.datetime 'created_at',                                 null: false
      t.datetime 'updated_at',                                 null: false
      t.index ['aff_name'], name: 'index_affiliates_on_aff_name', unique: true, using: :btree
      t.index ['aff_uuid'], name: 'index_affiliates_on_aff_uuid', unique: true, using: :btree
      t.index ['mobile'], name: 'index_affiliates_on_mobile', unique: true, using: :btree
    end

    create_table 'info_types', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'name',                                    comment: '类别的名称'
      t.boolean  'published',  default: false,              comment: '是否发布'
      t.datetime 'created_at',                 null: false
      t.datetime 'updated_at',                 null: false
      t.integer  'level',      default: 0,                  comment: '类别排序级别'
    end

    create_table 'infos', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'info_type_id'
      t.string   'title',                                                      comment: '资讯标题'
      t.date     'date'
      t.string   'source_type',                default: 'source',              comment: 'source 来源, author 作者'
      t.string   'source',                                                     comment: '内容'
      t.string   'image',                                                      comment: '图片'
      t.boolean  'top',                        default: false,                 comment: '是否置顶'
      t.boolean  'published',                  default: false,                 comment: '是否发布'
      t.text     'description',  limit: 65535,                                 comment: '图文内容'
      t.datetime 'created_at',                                    null: false
      t.datetime 'updated_at',                                    null: false
      t.index ['info_type_id'], name: 'index_infos_on_info_type_id', using: :btree
    end

    create_table 'notifications', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'user_id',                   null: false
      t.string   'notify_type',               null: false, comment: '消息类型:order 订单, certification 实名认证'
      t.string   'title',                     null: false, comment: '标题'
      t.text     'content',     limit: 65535, null: false, comment: '内容'
      t.string   'source_type',                            comment: '产生消息的出处'
      t.integer  'source_id',                              comment: '产生消息的出处'
      t.datetime 'created_at',                null: false
      t.datetime 'updated_at',                null: false
      t.text     'extra_data',  limit: 65535,              comment: '使用json存额外信息'
      t.string   'color_type',                             comment: '颜色类型：success 成功，failure 失败'
      t.index ['source_type', 'source_id'], name: 'index_notifications_on_source_type_and_source_id', using: :btree
      t.index ['user_id'], name: 'index_notifications_on_user_id', using: :btree
    end

    create_table 'order_snapshots', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer 'purchase_order_id'
      t.integer 'race_id'
      t.string  'name',              limit: 256,                          comment: '赛事的名称'
      t.string  'logo',              limit: 256,                          comment: '赛事的logo'
      t.integer 'prize',                         default: 0, null: false, comment: '赛事的奖池'
      t.string  'location',          limit: 256,                          comment: '赛事比赛地点'
      t.integer 'ticket_price',                  default: 0,              comment: '票的价格'
      t.date    'begin_date',                                             comment: '赛事开始日期'
      t.date    'end_date',                                               comment: '赛事结束的日期'
      t.index ['purchase_order_id'], name: 'index_order_snapshots_on_purchase_order_id', using: :btree
      t.index ['race_id'], name: 'index_order_snapshots_on_race_id', using: :btree
    end

    create_table 'photos', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'user_type'
      t.integer  'user_id'
      t.string   'image'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['user_type', 'user_id'], name: 'index_photos_on_user_type_and_user_id', using: :btree
    end

    create_table 'player_scores', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer 'race_id'
      t.string  'player_id', limit: 32, comment: '牌手的uuid'
      t.integer 'earning'
      t.integer 'score'
      t.index ['race_id'], name: 'index_player_scores_on_race_id', using: :btree
    end

    create_table 'players', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'player_id',         limit: 32,                             comment: '牌手的uuid'
      t.string   'name',                          default: '',               comment: '牌手的姓名'
      t.string   'avatar',            limit: 100,                            comment: '牌手头像'
      t.string   'gender',                        default: '0',              comment: '牌手的性别, 0表示男， 1表示女'
      t.string   'country',                       default: '',               comment: '牌手的国籍'
      t.integer  'dpi_total_earning'
      t.integer  'gpi_total_earning'
      t.integer  'dpi_total_score'
      t.integer  'gpi_total_score'
      t.string   'memo',                          default: '',               comment: '备忘'
      t.datetime 'created_at',                                  null: false
      t.datetime 'updated_at',                                  null: false
      t.string   'avatar_md5',        limit: 32,  default: '',  null: false, comment: '用户图像md5'
    end

    create_table 'purchase_orders', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'user_id'
      t.integer  'ticket_id'
      t.integer  'race_id'
      t.string   'ticket_type',    limit: 30, default: 'e_ticket',              comment: '票的类型 e_ticket-电子票, entity_ticket-实体票'
      t.string   'email',                                                       comment: '电子票发送邮箱'
      t.string   'address',                                                     comment: '实体票邮寄地址'
      t.string   'consignee',      limit: 50,                                   comment: '收货人'
      t.string   'mobile',         limit: 50,                                   comment: '联系方式'
      t.string   'order_number',   limit: 30,                                   comment: '订单号'
      t.integer  'price',                                          null: false, comment: '价格'
      t.integer  'original_price',                                 null: false, comment: '原始价格'
      t.string   'status',         limit: 30, default: 'unpaid',                comment: '订单状态 unpaid-未付款, paid-已付款, delivered-已发货， completed-已完成, canceled-已取消'
      t.datetime 'created_at',                                     null: false
      t.datetime 'updated_at',                                     null: false
      t.index ['order_number'], name: 'index_purchase_orders_on_order_number', unique: true, using: :btree
      t.index ['race_id'], name: 'index_purchase_orders_on_race_id', using: :btree
      t.index ['status'], name: 'index_purchase_orders_on_status', using: :btree
      t.index ['ticket_id'], name: 'index_purchase_orders_on_ticket_id', using: :btree
      t.index ['user_id'], name: 'index_purchase_orders_on_user_id', using: :btree
    end

    create_table 'race_blinds', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'race_id'
      t.integer  'level',       default: 0,                comment: '级别'
      t.string   'small_blind', default: '0',              comment: '最小盲注'
      t.string   'big_blind',   default: '0',              comment: '最大盲注'
      t.string   'ante',        default: '0',              comment: '前注'
      t.string   'race_time',   default: '0',              comment: '赛事时间'
      t.string   'content',     default: '',               comment: '文字输入类型对应的内容'
      t.datetime 'created_at',                null: false
      t.datetime 'updated_at',                null: false
      t.integer  'blind_type',  default: 0,                comment: '0表示有盲注，前注这些结构， 1表示有文字输入'
      t.index ['race_id'], name: 'index_race_blinds_on_race_id', using: :btree
    end

    create_table 'race_descs', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'race_id'
      t.text     'description', limit: 65535
      t.datetime 'created_at',                null: false
      t.datetime 'updated_at',                null: false
      t.index ['race_id'], name: 'index_race_descs_on_race_id', using: :btree
    end

    create_table 'race_follows', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'user_id'
      t.integer  'race_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['race_id'], name: 'index_race_follows_on_race_id', using: :btree
      t.index ['user_id'], name: 'index_race_follows_on_user_id', using: :btree
    end

    create_table 'race_hosts', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'name',                    comment: '主办方名称'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end

    create_table 'race_ranks', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer 'race_id'
      t.integer 'player_id'
      t.integer 'ranking',               comment: '排名'
      t.integer 'earning',   default: 0, comment: '收入奖金'
      t.integer 'score',     default: 0, comment: '得分'
      t.index ['player_id'], name: 'index_race_ranks_on_player_id', using: :btree
      t.index ['race_id'], name: 'index_race_ranks_on_race_id', using: :btree
    end

    create_table 'race_schedules', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'race_id'
      t.string   'schedule',   limit: 25,              comment: '日程表'
      t.datetime 'begin_time'
      t.datetime 'created_at',            null: false
      t.datetime 'updated_at',            null: false
      t.index ['race_id'], name: 'index_race_schedules_on_race_id', using: :btree
    end

    create_table 'races', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'name',            limit: 256,                              comment: '赛事的名称'
      t.bigint   'seq_id',                      default: 0,     null: false, comment: '为每一个赛事增加的id'
      t.string   'logo',            limit: 256,                              comment: '赛事的logo'
      t.string   'prize',                       default: '',    null: false, comment: '赛事的奖池'
      t.string   'location',        limit: 256,                              comment: '赛事比赛地点'
      t.date     'begin_date',                                               comment: '赛事开始日期'
      t.date     'end_date',                                                 comment: '赛事结束的日期'
      t.integer  'status',                      default: 0,     null: false, comment: '赛事的状态 0-未开始  1-进行中  2-已结束  3-已关闭'
      t.datetime 'created_at',                                  null: false
      t.datetime 'updated_at',                                  null: false
      t.string   'ticket_price',                default: '',                 comment: '票的价格'
      t.boolean  'published',                   default: false,              comment: '该赛事是否已发布'
      t.boolean  'ticket_sellable',             default: true,               comment: '是否可以售票'
      t.boolean  'describable',                 default: true,               comment: '是否有详情内容'
      t.integer  'parent_id',                   default: 0,                  comment: '主赛的parent_id默认为0， 边赛的parent_id为主赛的id'
      t.boolean  'roy',                         default: false,              comment: '是否有roy'
      t.string   'blind',                       default: '',                 comment: '赛事的盲注'
      t.integer  'participants',                                             comment: '赛事的参与人数'
      t.integer  'race_host_id'
      t.index ['begin_date'], name: 'index_races_on_begin_date', using: :btree
      t.index ['parent_id'], name: 'index_races_on_parent_id', using: :btree
      t.index ['race_host_id'], name: 'index_races_on_race_host_id', using: :btree
      t.index ['seq_id'], name: 'index_races_on_seq_id', unique: true, using: :btree
    end

    create_table 'ranking_types', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'name',       limit: 100,              comment: '排名的类型'
      t.datetime 'created_at',             null: false
      t.datetime 'updated_at',             null: false
    end

    create_table 'shipping_addresses', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'user_id'
      t.string   'consignee',      limit: 50,                              comment: '收货人'
      t.string   'mobile',         limit: 50,                              comment: '联系方式'
      t.string   'address',                                                comment: '所在地'
      t.string   'address_detail',                                         comment: '详细地址'
      t.string   'post_code',      limit: 50,                              comment: '邮政编码'
      t.boolean  'default',                   default: false,              comment: '是否为默认地址'
      t.datetime 'created_at',                                null: false
      t.datetime 'updated_at',                                null: false
      t.index ['user_id'], name: 'index_shipping_addresses_on_user_id', using: :btree
    end

    create_table 'sms_logs', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'sid',                                           comment: '短信服务商返回回来的短信id'
      t.string   'mobile'
      t.string   'content'
      t.string   'error_msg',                                     comment: '返回回来的错误信息'
      t.integer  'fee',          default: 0,                      comment: '短信计费条数'
      t.datetime 'send_time',                                     comment: '发送时间'
      t.datetime 'arrival_time',                                  comment: '到达时间'
      t.datetime 'created_at',                       null: false
      t.datetime 'updated_at',                       null: false
      t.string   'status',       default: 'sending',              comment: '发送中-sending, 成功-success, 失败-failed'
    end

    create_table 'ticket_infos', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'total_number',              default: 0,              comment: '总票数'
      t.integer  'e_ticket_number',           default: 0,              comment: '总电子票数'
      t.integer  'entity_ticket_number',      default: 0,              comment: '总实体票数'
      t.integer  'e_ticket_sold_number',      default: 0,              comment: '已售电子票数'
      t.integer  'entity_ticket_sold_number', default: 0,              comment: '已售实体票数'
      t.datetime 'created_at',                            null: false
      t.datetime 'updated_at',                            null: false
      t.integer  'lock_version',              default: 0
      t.integer  'ticket_id'
      t.index ['ticket_id'], name: 'index_ticket_infos_on_ticket_id', using: :btree
    end

    create_table 'tickets', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'race_id'
      t.string   'title',          limit: 256,                                   comment: '票名称'
      t.string   'logo',           limit: 256,                                   comment: '票缩略图'
      t.integer  'price',                                                        comment: '折后价格'
      t.integer  'original_price',                                               comment: '原始价格'
      t.datetime 'created_at',                                      null: false
      t.datetime 'updated_at',                                      null: false
      t.string   'ticket_class',                 default: 'race',                comment: '类型:single_ticket -> 仅赛票, package_ticket -> 套票'
      t.text     'description',    limit: 65535,                                 comment: '赛票描述'
      t.string   'status',         limit: 30,    default: 'unsold',              comment: '售票的状态 unsold-未售票, selling-售票中, end-售票结束, sold_out-票已售完'
      t.index ['race_id'], name: 'index_tickets_on_race_id', using: :btree
    end

    create_table 'user_extras', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'user_id'
      t.string   'real_name',  limit: 50,                                     comment: '真实姓名'
      t.string   'cert_type',  limit: 50, default: 'chinese_id',              comment: '证件类型  chinese_id-中国身份证'
      t.string   'cert_no',                                                   comment: '证件号码'
      t.string   'memo',                                                      comment: '备忘'
      t.string   'image',                 default: '',                        comment: '身份证图片'
      t.string   'image_md5',  limit: 32, default: '',           null: false, comment: '图片md5'
      t.string   'status',     limit: 20, default: 'init',                    comment: '初始化-init, 审核中-pending, 审核通过-passed, 审核失败-failed'
      t.datetime 'created_at',                                   null: false
      t.datetime 'updated_at',                                   null: false
      t.index ['user_id'], name: 'index_user_extras_on_user_id', using: :btree
    end

    create_table 'users', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'user_uuid',     limit: 32,              null: false, comment: '用户的uuid'
      t.string   'user_name',     limit: 32,                           comment: '用户姓名, 唯一'
      t.string   'nick_name',     limit: 32,                           comment: '用户的昵称'
      t.string   'password',      limit: 32,                           comment: '用户的密码'
      t.string   'password_salt',            default: '', null: false, comment: '密码盐值'
      t.integer  'gender',                   default: 0,               comment: '用户的性别, 0表示男， 1表示女, 2未知'
      t.string   'email',         limit: 64,                           comment: '用户的邮箱 唯一'
      t.string   'mobile',        limit: 16,                           comment: '用户手机号 唯一'
      t.string   'avatar',                                             comment: '用户头像'
      t.date     'birthday',                                           comment: '用户的生日'
      t.datetime 'reg_date',                                           comment: '注册日期'
      t.datetime 'last_visit',                                         comment: '上次登录时间'
      t.datetime 'created_at',                            null: false
      t.datetime 'updated_at',                            null: false
      t.string   'signature',     limit: 64, default: '', null: false, comment: '个性签名'
      t.string   'avatar_md5',    limit: 32, default: '', null: false, comment: '用户图像md5'
      t.index ['email'], name: 'index_users_on_email', unique: true, using: :btree
      t.index ['mobile'], name: 'index_users_on_mobile', unique: true, using: :btree
      t.index ['user_name'], name: 'index_users_on_user_name', unique: true, using: :btree
      t.index ['user_uuid'], name: 'index_users_on_user_uuid', unique: true, using: :btree
    end

    create_table 'video_types', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string   'name'
      t.integer  'level',      default: 0,                  comment: '排序'
      t.boolean  'published',  default: false,              comment: '是否发布'
      t.datetime 'created_at',                 null: false
      t.datetime 'updated_at',                 null: false
    end

    create_table 'videos', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer  'video_type_id'
      t.string   'name',                                                      comment: '视频名称'
      t.string   'video_link',                                                comment: '视频链接'
      t.string   'cover_link',                                                comment: '封面链接'
      t.boolean  'top',                          default: false,              comment: '是否置顶'
      t.boolean  'published',                    default: false,              comment: '是否发布'
      t.text     'description',    limit: 65535,                              comment: '视频描述'
      t.datetime 'created_at',                                   null: false
      t.datetime 'updated_at',                                   null: false
      t.string   'video_duration',                                            comment: '视频时长'
      t.index ['video_type_id'], name: 'index_videos_on_video_type_id', using: :btree
    end

    add_foreign_key 'affiliate_apps', 'affiliates'
  end
end
