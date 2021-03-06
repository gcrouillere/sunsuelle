class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :confirmation, :info, :contact, :google906057532e2dbb7e, :robots, :legal, :cgv, :about]

  def home
    @ceramiques = Ceramique.where(active: true).order(position: :asc).order(updated_at: :desc).first(4)
    Offer.where(showcased: true).first ? (Offer.where(showcased: true).first.ceramiques.present? ? @front_offer = Offer.all.where(showcased: true).first : nil) : nil
    @dev_redirection = "https://www.guillaumecrouillere.fr"
    render "home_#{@active_theme.name}"
  end

  def confirmation
    render "confirmation_#{@active_theme.name}"
  end

  def info
    @dev_redirection = "https://www.guillaumecrouillere.fr"
    render "info_#{@active_theme.name}"
  end

  def about
    @dev_redirection = "https://www.guillaumecrouillere.fr"
  end

  def contact
    @dev_redirection = "https://www.guillaumecrouillere.fr"
    render "contact_#{@active_theme.name}"
  end

  def legal
    @dev_redirection = "https://www.guillaumecrouillere.fr"
  end

  def cgv
    @dev_redirection = "https://www.guillaumecrouillere.fr"
  end

  def google906057532e2dbb7e
  end

  def robots
    render 'pages/robots.txt.erb'
    expires_in 6.hours, public: true
  end

end
