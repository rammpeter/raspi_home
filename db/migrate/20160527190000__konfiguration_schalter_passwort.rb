class KonfigurationSchalterPasswort < ActiveRecord::Migration
  def change
    add_column :konfigurations, :schalter_passwort,           :string
  end
end
