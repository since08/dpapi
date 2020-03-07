class AddRequiredIdTypeTorace < ActiveRecord::Migration[5.0]
  def change
    add_column :races, :required_id_type, :string,
               default: 'any',
               comment: '报名该场赛事所需要身份证明：any 任意一种， chinese_id 中国身份证， passport_id 护照'

    add_column :race_ens, :required_id_type, :string,
               default: 'any',
               comment: '报名该场赛事所需要身份证明：any 任意一种， chinese_id 中国身份证， passport_id 护照'
  end
end
