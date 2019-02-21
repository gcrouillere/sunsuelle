class Ceramique < ApplicationRecord
  include AlgoliaSearch
  # extend FriendlyId

  extend Mobility
  translates :name, type: :string, fallbacks: { fr: :en, en: :fr }, locale_accessors: [:en, :fr]
  translates :description, type: :text, fallbacks: { fr: :en, en: :fr }, locale_accessors: [:en, :fr]

  algoliasearch do
    add_attribute :translated_name_fr
    add_attribute :translated_name_en
    add_attribute :translated_description_fr
    add_attribute :translated_description_en
    add_attribute :translated_category_en
    add_attribute :translated_category_fr
    attribute :categories
  end

  has_many :product_categories
  has_many :categories, through: :product_categories, dependent: :destroy
  has_many :product_theme_associations
  has_many :product_themes, through: :product_theme_associations, dependent: :destroy
  belongs_to :offer, required: false
  has_attachments :photos, maximum: 4, dependent: :destroy
  has_many :basketlines

  monetize :price_cents

  validates :photos, presence: true
  validates :categories, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :weight, presence: true, numericality: { greater_than: 0, less_than: 30001 , only_integer: true, message: 'Le poids doit être compris entre 1 et 30 000 grammes. Pas d\'expédition Colissimo possible en dehors de cette plage.' }
  validates :stock, presence: true, numericality: { only_integer: true , message: 'Doit être un entier'}
  validates :price_cents, presence: true, numericality: { greater_than: 0 , message: 'Doit être un entier supérieur à 0' }


  def to_param
    name_param = self.send(I18n.locale == :fr ? (name_fr.present? ? "name_fr" : (name_en.present? ? "name_en" : "name")) : (name_en.present? ? "name_en" : "name")) || ""
    category_param = categories.map{|cat| cat.send(I18n.locale == :fr ? (cat.name_fr.present? ? "name_fr" : (cat.name_en.present? ? "name_en" : "name")) : (cat.name_en.present? ? "name_en" : "name")) || ""}.join("-")
    [id, name_param.parameterize, category_param.parameterize].join("-")
  end

  def translated_name_fr
    self.name_fr
  end

  def translated_name_en
    self.name_en
  end

  def translated_description_fr
    self.description_fr
  end

  def translated_description_en
    self.description_en
  end

  def translated_category_fr
    self.categories.map{|c| c.name_fr}.join(" - ")
  end

  def translated_category_en
    self.categories.map{|c| c.name_en}.join(" - ")
  end
end
