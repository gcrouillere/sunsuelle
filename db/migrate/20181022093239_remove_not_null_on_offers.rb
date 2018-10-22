class RemoveNotNullOnOffers < ActiveRecord::Migration[5.2]
  def change
    change_column_null :offers, :description, true
    change_column_null :offers, :showcased, true
    change_column_null :offers, :title, true
  end
end
