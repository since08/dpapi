class AddBannerTypeToBanner < ActiveRecord::Migration[5.0]
  def change
    add_column :banners, :banner_type, :string,
               default: 'homepage',
               comment: 'homepage 首页banner, crowdfunding 众筹banner'
  end
end
