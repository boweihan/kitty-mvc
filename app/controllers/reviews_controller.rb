class ReviewsController < ApplicationController

  before_action :ensure_logged_in, only: [:create, :destroy]
  # here you are LOADING the post because you are rendering the review on the product page
  before_action :load_product

  def show
    @review = Review.find(params[:id])
  end

  def create
    @review = @product.reviews.build(review_params)
    #OR @review = @product.build_review(review_params)
    @review.user = current_user

    #alternatively
    #@review = Review.new(review_params)
    #@review.product = @product
    #@review.user = current_user

    # Check out this article on [.build](http://stackoverflow.com/questions/783584/ruby-on-rails-how-do-i-use-the-active-record-build-method-in-a-belongs-to-rel)
    # You could use a longer alternate syntax if it makes more sense to you
    #
    # @review = Review.new(
    #   comment: params[:review][:comment],
    #   product_id: @product.id,
    #   user_id: current_user.id
    # )

    if @review.save
      #or @products instead of products_url
      redirect_to products_url, notice: 'Review created successfully'
    else
      render 'products/show'
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
  end

  private
  def review_params
    params.require(:review).permit(:comment, :product_id)
  end

  def load_product
    @product = Product.find(params[:product_id])
  end
end
