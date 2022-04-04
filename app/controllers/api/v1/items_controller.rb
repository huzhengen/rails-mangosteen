class Api::V1::ItemsController < ApplicationController
  def create
    item = Item.new(item_params)
    if item.save
      render json: { resource: item }
    else
      render json: { errors: item.errors }, status: :unprocessable_entity
    end
  end

  def index
    render json: { resources: Item.page(params[:page] || 1).per(params[:per_page] || 5),
                   pager: { total: Item.count,
                           page: params[:page] || 1,
                           per_page: params[:per_page] || 5 } }
    # Item.where("id > ?", params[:start_id]).limit(100)
  end

  def show
    render json: Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    render json: item
  end

  def destroy
    Item.find(params[:id]).destroy
  end

  private

  def item_params
    params.require(:item).permit(:amount)
  end
end
