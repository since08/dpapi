module V10
  module Shop
    class RecommendedProductsController < ApplicationController
      def index
        @products = Product.published.recommended.page(params[:page]).per(params[:page_size])
        render 'v10/shop/products/index'
      end
    end
  end
end