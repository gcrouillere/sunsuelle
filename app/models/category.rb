class Category < ApplicationRecord
  has_many :product_categories
  has_many :ceramiques, through: :product_categories

  extend Mobility
  translates :name, type: :string, fallbacks: { fr: :en, en: :fr }, locale_accessors: [:en, :fr]

  validates :name, presence: true, uniqueness: true
  accepts_nested_attributes_for :ceramiques
end
