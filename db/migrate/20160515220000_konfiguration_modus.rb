class KonfigurationModus < ActiveRecord::Migration[5.2]
  def change
    add_column :konfigurations, :modus, :integer, :precision => 1     # 0 = automatisch, 1 = immer ein, 2 = immer aus
  end
end
