class CreateProductImages < ActiveRecord::Migration[5.0]
  def change
    create_table :product_images do |t|
      t.references :viewable,  polymorphic: true
      t.string     :filename
      t.integer    :position, default: 0
    end
  end
end
