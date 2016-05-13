class Konfiguration < ActiveRecord::Base

  # sichert,dass die Initial-Einstellung existiert mit mindestens einenm Record
  def self.ensure_first_record
    if Konfiguration.count == 0
      first = Konfiguration.new

      first.UserName                          = 'admin'           # User fuer http-Access
      first.Passwort                          = 'hauptstrasse18'  # Passwort fuer http-Access
      first.Max_Stunde_Aktiv                  = 17                # Bis wann soll die Pumpe max. aktiv sein, um die Mindestumwälzzeit zu erreichen
      first.Min_Aktiv_Stunden_je_Tag          = 4                 # Wieviel Stunden je Tag soll Pumpe mindestens zirkulieren
      first.Tage_Rueckwaerts_Mindestens_Aktiv = 4                 # Anzahl der Tage, für die in Summe Aktivzeit der Pumpe > x sein soll
      first.Min_Aktiv_Minuten_Vor_Vergleich   = 5                 # Mindest-Aktivzeit der Pumpe in Minute, bevor Vorlauf und Ruecklauf verglichen werden
      first.Max_Inaktiv_Minuten_Tagsueber     = 60                # Max. Inaktivität tagsüber für Reinigung der Oberfläche
      first.Inaktiv_Betrachtung_Start         = 6                 # Ab welcher Stunde des Tages soll die kurzzeitige Aktivierung bei Überschreiten der maximalen Inaktivität überwacht werden
      first.Inaktiv_Betrachtung_Ende          = 17                # Bis zu welcher Stunde des Tages soll die kurzzeitige Aktivierung bei Überschreiten der maximalen Inaktivität überwacht werden
      first.Min_Aktiv_Fuer_Reinigung          = 2                 # Für wieviel Minuten soll Reinigung aktiv sein bei Überschreiten der maximalen Inaktivität

      first.save
    end
  end

  # Letzten Record der Konfiguration lesen
  def self.get_aktuelle_konfiguration
    ensure_first_record
    Konfiguration.last
  end



end
