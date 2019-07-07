class TemperaturWeitereSpalten < ActiveRecord::Migration[5.2]
  def change
    add_column :temperaturs, :wegen_temperatur_aktiv,           :integer, :precision => 1
    add_column :temperaturs, :wegen_zirkulationszeit_aktiv,     :integer, :precision => 1
    add_column :temperaturs, :wegen_zyklischer_reinigung_aktiv, :integer, :precision => 1
  end
end
