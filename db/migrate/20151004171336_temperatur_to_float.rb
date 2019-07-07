class TemperaturToFloat < ActiveRecord::Migration[5.2]
  def change
    add_column :temperaturs, :Schatten, :decimal, :precision => 6, :scale => 3
    add_column :temperaturs, :Sonne, :decimal, :precision => 6, :scale => 3

    reversible do |dir|
      change_table :temperaturs do |t|
        dir.up   {
          t.change :Vorlauf,    :decimal, :precision => 6, :scale => 3
          t.change :Ruecklauf,  :decimal, :precision => 6, :scale => 3
        }
        dir.down {
          t.change :Vorlauf, :integer
          t.change :Rueckauf, :integer
        }
      end
    end
  end
end
