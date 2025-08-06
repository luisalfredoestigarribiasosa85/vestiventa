class ClothingItemsController < ApplicationController
  before_action :set_clothing_item, only: %i[ show edit update destroy ]

  # GET /clothing_items or /clothing_items.json
  def index
    @clothing_items = ClothingItem.all
  end

  # GET /clothing_items/1 or /clothing_items/1.json
  def show
  end

  # GET /clothing_items/new
  def new
    @clothing_item = ClothingItem.new
  end

  # GET /clothing_items/1/edit
  def edit
  end

  # POST /clothing_items or /clothing_items.json
  def create
    @clothing_item = ClothingItem.new(clothing_item_params)

    respond_to do |format|
      if @clothing_item.save
        format.html { redirect_to clothing_items_path, notice: "Clothing item was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clothing_items/1 or /clothing_items/1.json
  def update
    respond_to do |format|
      if @clothing_item.update(clothing_item_params)
        format.html { redirect_to @clothing_item, notice: "Clothing item was successfully updated." }
        format.json { render :show, status: :ok, location: @clothing_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @clothing_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clothing_items/1 or /clothing_items/1.json
  def destroy
    @clothing_item.destroy!

    respond_to do |format|
      format.html { redirect_to clothing_items_path, status: :see_other, notice: "Clothing item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clothing_item
      @clothing_item = ClothingItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def clothing_item_params
      params.expect(clothing_item: [ :name, :size, :color, :price, :owner_name, :sold ])
    end
end
