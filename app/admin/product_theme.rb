ActiveAdmin.register ProductTheme do
  permit_params :name
  config.filters = false
  actions  :index, :new, :create, :destroy, :update, :edit
  menu priority: 2, url: -> { admin_product_themes_path(locale: I18n.locale) }

  index do
    column :name
    actions
  end

  form do |f|
    f.inputs "" do
      f.input :name
    end
    f.actions
   end

  controller do

   def create
      super do |format|
        redirect_to admin_product_themes_path and return if resource.valid?
      end
    end

    def destroy
      product_theme = ProductTheme.find(params[:id].to_i)
      ceramiques = product_theme.ceramiques.size
      if ceramiques > 0
        flash[:alert] = "Ce thème est toujours utilisé dans des produits. Impossible de le supprimer."
        redirect_to admin_product_themes_path and return
      end
      super do |format|
        redirect_to admin_product_themes_path and return
      end
    end

    def update
      super do |format|
        redirect_to admin_product_themes_path and return if resource.valid?
      end
    end

  end

end
