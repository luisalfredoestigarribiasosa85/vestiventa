class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_sale, only: %i[ show edit update destroy ]
  before_action :authorize_owner!, only: %i[edit update destroy]
  before_action :set_available_items, only: %i[new edit]

  # GET /sales or /sales.json
  def index
    base = current_user.sales.includes(:clothing_item).recent
    @filter = params[:estado].presence_in(%w[pendientes en_transito entregadas]) || "todas"
    @counts = {
      todas: base.count,
      pendientes: base.delivery_status_pending.count,
      en_transito: base.delivery_status_in_transit.count,
      entregadas: base.delivery_status_delivered.count
    }
    @sales =
      case @filter
      when "pendientes" then base.delivery_status_pending
      when "en_transito" then base.delivery_status_in_transit
      when "entregadas" then base.delivery_status_delivered
      else base
      end
    @total_earnings = current_user.total_earnings
  end

  # GET /sales/1 or /sales/1.json
  def show
  end

  # GET /sales/new
  def new
    @sale = current_user.sales.new
    return if params[:clothing_item_id].blank?

    item = current_user.clothing_items.available_for_sale.find_by(id: params[:clothing_item_id])
    if item
      @sale.clothing_item = item
      @sale.price = item.price
    end
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales or /sales.json
  def create
    @sale = current_user.sales.new(sale_params)
    @sale.clothing_item = current_user.clothing_items.find_by(id: sale_params[:clothing_item_id])

    # Si no se proporciona un precio, usar el de la prenda
    if @sale.price.blank? && @sale.clothing_item
      @sale.price = @sale.clothing_item.price
    end

    # Asegurarse de que el delivery_status se establezca correctamente
    @sale.delivery_status = sale_params[:delivery_status] if sale_params[:delivery_status].present?

    respond_to do |format|
      if @sale.save
        format.html { redirect_to sales_path, notice: t(".notices.created") }
        format.json { render :show, status: :created, location: @sale }
      else
        set_available_items
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1 or /sales/1.json
  def update
    respond_to do |format|
      # Actualizar los atributos, incluyendo el precio
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: t(".notices.updated") }
        format.json { render :show, status: :ok, location: @sale }
      else
        set_available_items
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1 or /sales/1.json
  def destroy
    @sale.destroy!

    respond_to do |format|
      format.html { redirect_to sales_path, status: :see_other, notice: t(".notices.destroyed") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = current_user.sales.find_by(id: params[:id])
      redirect_to sales_path, alert: t(".sale_not_found") unless @sale
    end

    # Set available clothing items for the select dropdown.
    # When editing, keep the item already attached to the sale in the list.
    def set_available_items
      @available_items = current_user.clothing_items.available_for_sale.order(:name).to_a
      if @sale&.persisted? && @sale.clothing_item && !@available_items.include?(@sale.clothing_item)
        @available_items << @sale.clothing_item
      end
    end

    # Only allow a list of trusted parameters through.
    def sale_params
      params.require(:sale).permit(:clothing_item_id, :buyer_name, :address, :delivery_status, :price)
    end

    def authorize_owner!
      unless @sale.user == current_user
        redirect_to root_path, alert: t("unauthorized")
      end
    end
end
