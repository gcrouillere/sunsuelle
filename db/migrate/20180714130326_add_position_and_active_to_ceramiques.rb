class AddPositionAndActiveToCeramiques < ActiveRecord::Migration[5.2]
  def change
    add_column :ceramiques, :active, :boolean
    add_column :ceramiques, :position, :integer
  end
end
