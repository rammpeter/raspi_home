class PumpenStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :temperaturs, :Pumpenstatus, :decimal, :precision => 1
  end
end

