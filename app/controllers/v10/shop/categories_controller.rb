module V10
  module Shop
    class CategoriesController < ApplicationController
      def index
        @categories = Category.roots
      end

      def children
        @category = Category.find(params[:id])
      end

      def products
        category = Category.find(params[:id])
        @products = Product.published.in_category(category).page(params[:page]).per(params[:page_size])
        render 'v10/shop/products/index'
      end
    end
  end
end