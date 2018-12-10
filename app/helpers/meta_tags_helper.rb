module MetaTagsHelper
  def meta_title
    content_for?(:title_tag) ? content_for(:title_tag) : "Sunsuelle : sacs tendances faits main, en France"
  end

  def meta_product_name
    content_for?(:meta_product_name) ? content_for(:meta_product_name) : "Sunsuelle : sacs tendances faits main, en France"
  end

  def meta_description
    description = "Tous les sacs à main de Sunsuelle sont uniques et cousus à la main en France. Découvrez toutes les créations en vente dans la boutique."
    content_for?(:description) ? content_for(:description) : description
  end

  def meta_image
    admin_photo = @admin ? (@admin.productphoto.present? ? cl_image_path(@admin.productphoto.path) : image_path(ENV['HOMEPIC'])) : image_path(ENV['HOMEPIC'])
    meta_image = (content_for?(:meta_image) ? content_for(:meta_image).strip : admin_photo)
    # little twist to make it work equally with an asset or a url
    meta_image.starts_with?("http") ? meta_image : image_url(meta_image)
  end

  def meta_no_index
    content_for(:noindex) if content_for?(:noindex)
  end
end

