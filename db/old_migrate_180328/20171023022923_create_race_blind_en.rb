class CreateRaceBlindEn < ActiveRecord::Migration[5.0]
  def change
    create_table :race_blind_ens do |t|
      t.references :race
      t.integer  'level',       default: 0,     comment: '级别'
      t.string   'small_blind', default: '0',   comment: '最小盲注'
      t.string   'big_blind',   default: '0',   comment: '最大盲注'
      t.string   'ante',        default: '0',   comment: '前注'
      t.string   'race_time',   default: '0',   comment: '赛事时间'
      t.string   'content',     default: '',    comment: '文字输入类型对应的内容'
      t.integer  'blind_type',  default: 0,    comment: '0表示有盲注，前注这些结构， 1表示有文字输入'
      t.bigint   'position',    default: 10000, comment: '用于拖拽排序'
      t.timestamps
    end

    RaceBlind.find_each do |blind|
      RaceBlindEn.create(blind.attributes)
    end
  end
end
