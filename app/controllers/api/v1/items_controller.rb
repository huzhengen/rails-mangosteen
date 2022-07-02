class Api::V1::ItemsController < ApplicationController
  def create
    # item = Item.new(item_params)
    item = Item.new amount: params[:amount]
    if item.save
      render json: { resource: item }, status: 201
    else
      render json: { errors: item.errors }, status: :unprocessable_entity
    end
  end

  def index
    current_user_id = request.env['current_user_id']
    return head :unauthorized if current_user_id.nil?
    created_after =  params[:created_after] || '1970-01-01'
    created_before =  params[:created_before] || '9999-12-31'
    items = Item.where({user_id: current_user_id}).where({created_at: created_after..created_before})
      .page(params[:page])
    render json: { resources: items, pager: {
      page: params[:page] || 1,
      per_page: Item.default_per_page,
      count: Item.count
    }}
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
