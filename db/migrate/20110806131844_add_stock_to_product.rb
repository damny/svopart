class AddStockToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :stock, :integer, :default => 1
  end

  def self.down
    remove_column :products, :stock
  end
end
