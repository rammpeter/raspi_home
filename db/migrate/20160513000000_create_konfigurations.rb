class CreateKonfigurations < ActiveRecord::Migration
  def change
    create_table :konfigurations do |t|
      t.string  :UserName                              # User fuer http-Access
      t.string  :Passwort                              # Passwort fuer http-Access
      t.integer :Max_Stunde_Aktiv                      # Bis wann soll die Pumpe max. aktiv sein, um die Mindestumwälzzeit zu erreichen
      t.integer :Min_Aktiv_Stunden_je_Tag              # Wieviel Stunden je Tag soll Pumpe mindestens zirkulieren
      t.integer :Tage_Rueckwaerts_Mindestens_Aktiv     # Anzahl der Tage, für die in Summe Aktivzeit der Pumpe > x sein soll
      t.integer :Min_Aktiv_Minuten_Vor_Vergleich       # Mindest-Aktivzeit der Pumpe in Minute, bevor Vorlauf und Ruecklauf verglichen werden
      t.integer :Max_Inaktiv_Minuten_Tagsueber         # Max. Inaktivität tagsüber für Reinigung der Oberfläche
      t.integer :Inaktiv_Betrachtung_Start             # Ab welcher Stunde des Tages soll die kurzzeitige Aktivierung bei Überschreiten der maximalen Inaktivität überwacht werden
      t.integer :Inaktiv_Betrachtung_Ende              # Bis zu welcher Stunde des Tages soll die kurzzeitige Aktivierung bei Überschreiten der maximalen Inaktivität überwacht werden
      t.integer :Min_Aktiv_Fuer_Reinigung              # Für wieviel Minuten soll Reinigung aktiv sein bei Überschreiten der maximalen Inaktivität

      t.timestamps null: false
    end

    add_index :konfigurations, :created_at

  end
end
