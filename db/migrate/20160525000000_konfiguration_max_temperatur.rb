class KonfigurationMaxTemperatur < ActiveRecord::Migration
  def change
    add_column :konfigurations, :max_pool_temperatur, :integer, :precision => 2, :default=>30
  end
end
