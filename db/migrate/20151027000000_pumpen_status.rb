class PumpenStatus < ActiveRecord::Migration
  def change
    add_column :temperaturs, :Pumpenstatus, :decimal, :precision => 1
  end
end

