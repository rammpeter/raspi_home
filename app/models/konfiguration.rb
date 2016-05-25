class Konfiguration < ActiveRecord::Base

  def self.defaults
    {
        :Min_Aktiv_Minuten_Vor_Vergleich => {
            :initial_value  => 5,
            :title          => 'Mindest-Aktivzeit der Pumpe in Minuten, bevor Vorlauf und Rücklauf verglichen werden bzw. Pumpe abgeschalten wird wenn Vorlauf < Rücklauf'
        },
        :Tage_Rueckwaerts_Mindestens_Aktiv => {
            :initial_value  => 4,
            :title          => 'Anzahl der Tage, für die in Summe über diese Tage die Mindestaktivitätszeit der Pumpe erricht sein soll'
        },
        :Min_Aktiv_Stunden_je_Tag => {
            :initial_value  => 4,
            :title          => 'Wieviel Stunden je Tag soll Pumpe mindestens aktiv sein (Wasser zirkulieren)?'
        },
        :Max_Stunde_Aktiv => {
            :initial_value  => 17,
            :title          => 'Bis zu welcher Stunde des Tages soll die Pumpe maximal aktiv sein, um die Mindestumwälzzeit zu erreichen?'
        },
        :Max_Inaktiv_Minuten_Tagsueber => {
            :initial_value  => 60,
            :title          => 'Maximale Inaktivität tagsüber in Minuten, bevor für Reinigung der Oberfläche Pumpe kurz aktiviert wird'
        },
        :Inaktiv_Betrachtung_Start => {
            :initial_value  => 6,
            :title          => 'Ab welcher Stunde des Tages soll die kurzzeitige Aktivierung bei Überschreiten der maximalen Inaktivität überwacht werden?'
        },
        :Inaktiv_Betrachtung_Ende => {
            :initial_value  => 17,
            :title          => 'Bis zu welcher Stunde des Tages soll die kurzzeitige Aktivierung bei Überschreiten der maximalen Inaktivität überwacht werden'
        },
        :Min_Aktiv_Fuer_Reinigung => {
            :initial_value  => 2,
            :title          => 'Für wieviel Minuten soll Reinigung aktiv sein bei Überschreiten der maximalen Inaktivität'
        },
        :UserName => {
            :initial_value  => 'admin',
            :title          => 'Benutzername für Absicherung des Zugriffs auf Konfiguration'
        },
        :Passwort => {
            :initial_value  => 'hauptstrasse18',
            :title          => 'Passwort für Absicherung des Zugriffs auf Konfiguration'
        },
        :modus => {
            :initial_value  => 0,
            :title          => 'Betriebsmodus der Pumpensteuerung (0=automatisch, 1=ständig an, 2=ständig aus)'
        },
        :max_pool_temperatur => {
            :initial_value  => 30,
            :title          => 'Maximale Beckentemperatur bis zu der Temperatur-Steuerung über aktiv bleibt. Bei Überschreitung wird Pumpe nicht mehr aktiviert, wenn Temperatur des Vorlauf > Rücklauf'
        },
    }
  end

  def self.get_initial_values_hash
    result = {}
    defaults.each do |key, value|
      result[key] = value[:initial_value]
    end
    result
  end

  def self.get_title(column)
    raise "Kein Default vorhanden für '#{column}' (Class=#{column.class.name})" unless defaults[column]
    defaults[column][:title]
  end

  # sichert,dass die Initial-Einstellung existiert mit mindestens einenm Record
  def self.ensure_first_record
    if Konfiguration.count == 0
      Konfiguration.create(get_initial_values_hash)
    end
  end

  # Letzten Record der Konfiguration lesen
  def self.get_aktuelle_konfiguration
    ensure_first_record
    Konfiguration.last
  end

  ########### Formatierung der Werte
  def modus_text
    case self.modus
      when 0 then 'Automatisch'
      when 1 then 'ständig an'
      when 2 then 'ständig aus'
    end
  end

end
