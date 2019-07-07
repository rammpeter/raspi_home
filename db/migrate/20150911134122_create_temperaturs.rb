class CreateTemperaturs < ActiveRecord::Migration[5.2]
  def change
    create_table :temperaturs do |t|
      t.datetime :Zeit
      t.integer :Vorlauf
      t.integer :Ruecklauf

      t.timestamps null: false
    end
  end
end
