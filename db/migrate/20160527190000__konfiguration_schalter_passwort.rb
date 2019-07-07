class KonfigurationSchalterPasswort < ActiveRecord::Migration[5.2]
  def change
    add_column :konfigurations, :schalter_passwort,           :string
  end
end
