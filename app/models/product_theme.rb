class ProductTheme < ApplicationRecord
  has_many :product_theme_associations
  has_many :ceramiques, through: :product_theme_associations

  extend Mobility
  translates :name, type: :string, fallbacks: { fr: :en, en: :fr }, locale_accessors: [:en, :fr]

  validates :name, presence: true, uniqueness: true
  accepts_nested_attributes_for :ceramiques
end
