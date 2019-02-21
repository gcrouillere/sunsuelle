class CeramiquesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    Offer.where(showcased: true).first ? (Offer.where(showcased: true).first.ceramiques.present? ? @front_offer = Offer.all.where(showcased: true).first : nil) : nil
    @front_offer ? @ceramiques_to_display_in_offer = Ceramique.all.where(offer: @front_offer) : nil
    clean_orders
    macro_filter
    unless params[:all].present?
      filter_by_category if params[:categories].present?
      filter_by_theme if params[:themes].present?
      filter_by_offer if params[:offer].present?
      filter_globally if params[:search].present?
      filter_by_price if params[:prix_max].present?
    end
    @ceramiques = Ceramique.where(id: @ceramiques.map(&:id), active: true).order(position: :asc).order(updated_at: :desc)
    @dev_redirection = "https://www.creermonecommerce.fr/product_claim_details"
    @twitter_url = request.original_url.to_query('url')
    @facebookid = ""
    render "index_#{@active_theme.name}"
  end

  def show
    session[:zoom_message] ? session[:zoom_message] += 1 : session[:zoom_message] = 0
    @dev_redirection = "https://www.creermonecommerce.fr/produits"
    clean_orders
    @ceramique = Ceramique.find(params[:id])
    @same_category_products = Ceramique.where(active: true).where.not(id: @ceramique.id).joins(:categories).where(categories: @ceramique.categories.map(&:id)).uniq
    @twitter_url = request.original_url.to_query('url')
    render "show_#{@active_theme.name}"
  end

  def update
    @ceramique = Ceramique.find(params[:id])
    @fieldvalue =  @ceramique.send(get_editing_field)
    if @ceramique.update(ceramique_params)
      render json: @ceramique
    else
      render json: {id: @ceramique.id, fieldvalue: @fieldvalue, errors: @ceramique.errors}, status: :unprocessable_entity
    end
  end

  def update_positions_after_swap_in_admin
    params[:finalPositions].gsub("]","").gsub("[", "").split(",").map(&:to_i).each_with_index do |position, index|
      Ceramique.find(position).update(position: index + params[:startingPosition].to_i)
    end
    @ceramiques = Ceramique.all.order(position: :asc).order(updated_at: :desc)
    render json: @ceramiques
  end

  private

  def clean_orders
    Order.all.each do |order|
      if ((Time.now - order.created_at)/60/60 > ENV['BASKETDURATION'].to_f && order.state == "pending" && order.lesson.blank?) || ((Time.now - order.created_at)/60/60 > 24 && order.state == "payment page" && order.lesson.blank?)
        order.basketlines.each do |basketline|
          ceramique = basketline.ceramique
          ceramique.update(stock: ceramique.stock + basketline.quantity)
        end
        if session[:order]
          wip_local_order = Order.find(session[:order])
          session[:order] = nil if order == wip_local_order
        end
        order.update(state: "lost")
      end
    end
  end

  def macro_filter
    if user_signed_in?
      if current_user.admin
        @ceramiques = Ceramique.all
      else
        @ceramiques = Ceramique.where(active: true)
      end
    else
      @ceramiques = Ceramique.where(active: true)
    end
  end

  def filter_by_category
    categories = params[:categories].map {|category| "%#{category}%" }
    @ceramiques = @ceramiques.joins(:categories).merge(Category.i18n {name.matches_any(categories)})
  end

  def filter_by_theme
    themes = params[:themes].map {|theme| "%#{theme}%" }
    @ceramiques = @ceramiques.joins(:product_themes).merge(ProductTheme.i18n {name.matches_any(themes)})
  end

  def filter_by_price
    @ceramiques = @ceramiques.joins(:offer).where("price_cents * (1 - discount) <= ? AND price_cents * (1 - discount) >= ? ", params[:prix_max].to_i * 100, params[:prix_min].to_i * 100) +
                  @ceramiques.where('offer_id IS NULL').where("price_cents <= ? AND price_cents >= ?", params[:prix_max].to_i * 100, params[:prix_min].to_i * 100)
  end

  def filter_by_offer
    @ceramiques = @ceramiques.where(offer: @front_offer)
  end

  def filter_globally
    raw_json = Ceramique.raw_search(params[:search])
    ceramiques_ids = raw_json["hits"].map {|hit| hit["objectID"].to_i}
    @ceramiques = @ceramiques.where(id: ceramiques_ids)
  end

  def ceramique_params
    if params[:ceramique][:category_ids].present?
      params.require(:ceramique).permit(:name, :stock, :weight, :price_cents, :description).merge(category_ids: Category.i18n.where(name: params[:ceramique][:category_ids].split("#%#")).map(&:id))
    else
      params.require(:ceramique).permit(:name, :stock, :weight, :price_cents, :description)
    end
  end

  def get_editing_field
    params.require(:ceramique).permit(:name, :stock, :weight, :price_cents, :description, :category_ids).to_h.map {|k, v| k }.join
  end
end

