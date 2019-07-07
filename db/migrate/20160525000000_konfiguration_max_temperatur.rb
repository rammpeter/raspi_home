class KonfigurationMaxTemperatur < ActiveRecord::Migration[5.2]
  def change
    add_column :konfigurations, :max_pool_temperatur, :integer, :precision => 2, :default=>30
  end
end
