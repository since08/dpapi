class CreateAppVersion < ActiveRecord::Migration[5.0]
  def change
    create_table :app_versions do |t|
      t.string :platform, default: 'ios', comment: 'ios 平台或 android平台'
      t.string :version, comment: '版本号'
      t.boolean :force_upgrade, default: false, comment: '是否强制升级'
      t.timestamps
    end
  end
end
