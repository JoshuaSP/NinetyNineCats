class CatRentalRequestsController < ApplicationController
  before_action :set_request, except: [:index, :new, :create]

  def index
    @cat_rental_requests = CatRentalRequest.all
    render json: @cat_rental_requests
  end

  def show
    render :show
  end

  def new
    @cat_rental_request = CatRentalRequest.new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @cat_rental_request.save
      redirect_to cats_url(current_cat)
    else
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @cat_rental_request.update(cat_rental_params)
      redirect_to @cat_rental_request
    else
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :edit
    end
  end

  def approve
    @cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def deny
    @cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  private

  def set_request
    @cat_rental_request ||= CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    @cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :end_date, :start_date, :status)
  end
end
