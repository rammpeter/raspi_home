class Konfiguration < ActiveRecord::Base

  def self.defaults
    {
        :Min_Aktiv_Minuten_Vor_Vergleich => {
            :short          => 'Akt. vor Vergl.',
            :initial_value  => 5,
            :title          => 'Mindest-Aktivzeit der Pumpe in Minuten, bevor Vorlauf und Rücklauf verglichen werden bzw. Pumpe abgeschalten wird wenn Vorlauf < Rücklauf'
        },
        :min_sonne_ruecklauf_distanz => {
            :short          => 'Dist. Sonne Rückl.',
            :initial_value  => 0.5,
            :title          => 'Minimale Temperaturdifferenz um die Sonne höher sein muss als Rücklauf (Becken) für Aktivierung der Pumpe.<br>Verhindert Pendeln am Abend wenn Sonne-Sensor evtl. noch gespeicherte Wärme misst, aber kein Temperaturgewinn mehr stattfindet'
        },
        :min_vorlauf_ruecklauf_distanz => {
            :short          => 'Dist. Vorl. Rückl.',
            :initial_value  => 0.2,
            :title          => 'Minimaler Temperaturgewinn der Solaranlage (Vorlauf-Rücklauf) für Aktivierung der Pumpe.<br>Sicherstellen, dass Gewinn an Temperatur nicht durch Leitungsverluste z.B. bei Erdverlegung wieder kompensiert wird bevor das Becken erreicht wird'
        },
        :max_pool_temperatur => {
            :short          => 'Max. Pool Temp.',
            :initial_value  => 30,
            :title          => 'Maximale Beckentemperatur bis zu der Temperatur-Steuerung über aktiv bleibt. Bei Überschreitung wird Pumpe nicht mehr aktiviert, wenn Temperatur des Vorlauf > Rücklauf'
        },
        :Tage_Rueckwaerts_Mindestens_Aktiv => {
            :short          => 'Tage rückw.',
            :initial_value  => 4,
            :title          => 'Anzahl der Tage, für die in Summe über diese Tage die Mindestaktivitätszeit der Pumpe erricht sein soll'
        },
        :Min_Aktiv_Stunden_je_Tag => {
            :short          => 'Std. akt. je Tag',
            :initial_value  => 4,
            :title          => 'Wieviel Stunden je Tag soll Pumpe mindestens aktiv sein (Wasser zirkulieren)?'
        },
        :Max_Stunde_Aktiv => {
            :short          => 'Max. Std. akt.',
            :initial_value  => 17,
            :title          => 'Bis zu welcher Stunde des Tages soll die Pumpe maximal aktiv sein, um die Mindestumwälzzeit zu erreichen?'
        },
        :Max_Inaktiv_Minuten_Tagsueber => {
            :short          => 'Max. inakt.',
            :initial_value  => 60,
            :title          => 'Maximale Inaktivität tagsüber in Minuten, bevor für Reinigung der Oberfläche Pumpe kurz aktiviert wird'
        },
        :Inaktiv_Betrachtung_Start => {
            :short          => 'Inakt. Start',
            :initial_value  => 6,
            :title          => 'Ab welcher Stunde des Tages soll die kurzzeitige Aktivierung bei Überschreiten der maximalen Inaktivität überwacht werden?'
        },
        :Inaktiv_Betrachtung_Ende => {
            :short          => 'Inakt. Ende',
            :initial_value  => 17,
            :title          => 'Bis zu welcher Stunde des Tages soll die kurzzeitige Aktivierung bei Überschreiten der maximalen Inaktivität überwacht werden'
        },
        :Min_Aktiv_Fuer_Reinigung => {
            :short          => 'Min. akt. Rein.',
            :initial_value  => 2,
            :title          => 'Für wieviel Minuten soll Reinigung aktiv sein bei Überschreiten der maximalen Inaktivität'
        },
        :UserName => {
            :short          => 'Benutzer',
            :initial_value  => 'admin',
            :title          => 'Benutzername für Absicherung des Zugriffs auf Konfiguration'
        },
        :Passwort => {
            :short          => 'Passwort',
            :initial_value  => 'hauptstrasse18',
            :title          => 'Passwort für Absicherung des Zugriffs auf Konfiguration'
        },
        :modus => {
            :short          => 'Mod.',
            :initial_value  => 0,
            :title          => 'Betriebsmodus der Pumpensteuerung (0=automatisch, 1=ständig an, 2=ständig aus)'
        },
        :schalter_typ => {
            :short          => 'Schalter Typ',
            :initial_value  => 'Rutenbeck_TPIP1',
            :title          => 'Typ der verwendeten Schalter-Steckdose'
        },
        :schalter_ip => {
            :short          => 'Schalter IP',
            :initial_value  => '0.0.0.0',
            :title          => 'IP-Adresse der verwendeten Schalter-Steckdose im Netzwerk'
        },
        :schalter_passwort => {
            :short          => 'Schalter Paswort',
            :initial_value  => '****',
            :title          => 'Passwort für Zugriff auf Schalter-Steckdose (wenn erforderlich)'
        },
        :filename_vorlauf_sensor => {
            :short          => 'Sensor Vorlauf',
            :initial_value  => '/sys/bus/w1/devices/xxxxxx/w1_slave',
            :title          => 'Name der Sensor-Datei des DS18B20-Sensors für Vorlauf-Temperatur (von Solar-Anlage zum Pool) im Kernel-Filesystem des Raspi'
        },
        :filename_ruecklauf_sensor => {
            :short          => 'Sensor Rücklauf',
            :initial_value  => '/sys/bus/w1/devices/xxxxxx/w1_slave',
            :title          => 'Name der Sensor-Datei des DS18B20-Sensors für Rücklauf-Temperatur (von Pool zu Solar-Anlage) im Kernel-Filesystem des Raspi'
        },
        :filename_sonne_sensor => {
            :short          => 'Sensor Sonne',
            :initial_value  => '/sys/bus/w1/devices/xxxxxx/w1_slave',
            :title          => 'Name der Sensor-Datei des DS18B20-Sensors für Temperatur in der Sonne (bzw. auf der Solar-Anlage) im Kernel-Filesystem des Raspi'
        },
        :filename_schatten_sensor => {
            :short          => 'Sensor Schatten',
            :initial_value  => '/sys/bus/w1/devices/xxxxxx/w1_slave',
            :title          => 'Name der Sensor-Datei des DS18B20-Sensors für Temperatur im Schatten im Kernel-Filesystem des Raspi'
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
