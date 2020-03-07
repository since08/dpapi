class CreateAlbum < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
      t.string :name, comment: '相册名称'
      t.integer :photo_count, comment: '图片统计'
    end
  end
end
