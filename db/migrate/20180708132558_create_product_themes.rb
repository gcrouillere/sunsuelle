class CreateProductThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :product_themes do |t|
      t.string :name
    end

    create_table :product_categories do |t|
      t.references :ceramique, foreign_key: true
      t.references :category, foreign_key: true
      t.timestamps
    end

    create_table :product_theme_associations do |t|
      t.references :ceramique, foreign_key: true
      t.references :product_theme, foreign_key: true
      t.timestamps
    end
  end
end
