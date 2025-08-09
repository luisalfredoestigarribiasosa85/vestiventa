class ClothingItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_clothing_item, only: %i[ show edit update destroy ]
  before_action :authorize_owner!, only: %i[edit update destroy]

  # GET /clothing_items or /clothing_items.json
  def index
    @clothing_items = current_user.clothing_items.order(created_at: :desc)
  end

  # GET /clothing_items/1 or /clothing_items/1.json
  def show
  end

  # GET /clothing_items/new
  def new
    @clothing_item = current_user.clothing_items.new
  end

  # GET /clothing_items/1/edit
  def edit
  end

  # POST /clothing_items or /clothing_items.json
  def create
    @clothing_item = current_user.clothing_items.new(clothing_item_params)

    respond_to do |format|
      if @clothing_item.save
        format.html { redirect_to clothing_items_path, notice: t('.notices.created') }
        format.json { render :show, status: :created, location: @clothing_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @clothing_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clothing_items/1 or /clothing_items/1.json
  def update
    respond_to do |format|
      if @clothing_item.update(clothing_item_params)
        format.html { redirect_to @clothing_item, notice: t('.notices.updated') }
        format.json { render :show, status: :ok, location: @clothing_item }
      else
        format.html { 
          flash.now[:alert] = t('.errors.update_failed')
          render :edit, status: :unprocessable_entity 
        }
        format.json { render json: @clothing_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clothing_items/1 or /clothing_items/1.json
  def destroy
    @clothing_item.destroy!

    respond_to do |format|
      format.html { redirect_to clothing_items_path, status: :see_other, notice: t('.notices.destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clothing_item
      @clothing_item = current_user.clothing_items.find_by(id: params[:id])
      redirect_to clothing_items_path, alert: t('.clothing_item_not_found') unless @clothing_item
    end

    # Only allow a list of trusted parameters through.
    def clothing_item_params
      params.require(:clothing_item).permit(:name, :size, :color, :price, :owner_name, :sold)
    end
    
    def authorize_owner!
      unless @clothing_item.user == current_user
        redirect_to root_path, alert: t('unauthorized')
      end
    end
end
