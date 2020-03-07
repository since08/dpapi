class CreateAlbumPhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :album_photos do |t|
      t.references :album
      t.string :image
    end
  end
end
