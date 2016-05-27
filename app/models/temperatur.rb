require 'net/http'

class Temperatur < ActiveRecord::Base

  # gibt die im File hinterlegte Temperatur zurück
  def self.read_temperature_from_file(sensor_file_name)

    lines = IO.readlines(sensor_file_name)
    raise "2 Zeilen werden erwartet in File #{sensor_file_name} statt #{lines.count}" if lines.count != 2
    line = lines[1]
    line.slice(line.index('t=')+2, 10).to_f/1000   # Temoeratur in Grad
  end

  # Ermitteln des Schalt-Status der schaltbaren Steckdose, return 0 für aus oder 1 für ein
  def self.old_get_schalter_status
    return 0 if ENV['SCHALTER_TYP'] == 'NONE'                                   # Für Betrieb ohne Schaltsteckdose

    raise "Environment-Variable SCHALTER_TYP ist nicht gesetzt, Abbruch" if ENV['SCHALTER_TYP'].nil?

    if ENV['SCHALTER_TYP'] ==  'Rutenbeck_TPIP1'
      raise "Environment-Variable SCHALTER_IP ist nicht gesetzt, Abbruch" if ENV['SCHALTER_IP'].nil?
      result = Net::HTTP.get_response(URI("http://#{ENV['SCHALTER_IP']}/status.xml"))
      xml_result = Nokogiri::XML(result.body)
      return xml_result.xpath('//led1').children[0].to_s.to_i
    else
      raise "SCHALTER_TYP=#{ENV['SCHALTER_TYP']} ist nicht bekannt, Abbruch"
    end
  end

  # Ein/Ausschalten der schaltbaren Steckdose 0/1
  def self.old_set_schalter_status(status)
    return if ENV['SCHALTER_TYP'] == 'NONE'                                   # Für Betrieb ohne Schaltsteckdose

    raise "Environment-Variable SCHALTER_TYP ist nicht gesetzt, Abbruch" if ENV['SCHALTER_TYP'].nil?

    if ENV['SCHALTER_TYP'] ==  'Rutenbeck_TPIP1'
      raise "Environment-Variable SCHALTER_IP ist nicht gesetzt, Abbruch" if ENV['SCHALTER_IP'].nil?

      current = get_schalter_status
      if current != status                                      # Kommando fungiert nur als Umschalter des aktuellen Status
        Net::HTTP.get(URI("http://#{ENV['SCHALTER_IP']}/leds.cgi?led=1"))
      end

    else
      raise "SCHALTER_TYP=#{ENV['SCHALTER_TYP']} ist nicht bekannt, Abbruch"
    end

  end

  # Ermitteln Soll-Schaltstatus der Pumpe
  # Wie soll Pumpe arbeiten in Abhängigkeit der Werte und Vorgeschichte?
  def self.schreibe_temperatur
    # Einfluss-Faktoren:
    #   Temperatur in Sonne
    #   Temperatur Vorlauf (von Solaranlage zum Pool)
    #   Temperatur Rücklauf (von Pumpe zu Solaranlage)
    #   Dauer Pumpenaktivität am aktuellen Tag
    #   Zeitpunkt der letzte Pumpenaktivität

    konf          = Konfiguration.get_aktuelle_konfiguration
    schalter_typ  = SchalterTyp.new(konf.schalter_typ)

    t = Temperatur.new(
        :Vorlauf      => read_temperature_from_file(konf.filename_vorlauf_sensor),
        :Ruecklauf    => read_temperature_from_file(konf.filename_ruecklauf_sensor),
        :Schatten     => read_temperature_from_file(konf.filename_schatten_sensor),
        :Sonne        => read_temperature_from_file(konf.filename_sonne_sensor)
    )


    # Ausgangswerte für Entscheidung:
    start_betrachtung = Time.now.change(:hour=>0) - konf.Tage_Rueckwaerts_Mindestens_Aktiv*24*60*60
    pumpe_aktiv_letzte_tage = Temperatur.where(['Pumpenstatus=1 AND created_at > ?', start_betrachtung]).sum(:Pumpenstatus).to_f/60
    fehlende_stunden_heute = (konf.Min_Aktiv_Stunden_je_Tag * konf.Tage_Rueckwaerts_Mindestens_Aktiv) - pumpe_aktiv_letzte_tage
    fehlende_stunden_heute = 0 if fehlende_stunden_heute < 0
    last_aktiv = Temperatur.where(['Pumpenstatus=1 AND created_at > ?', start_betrachtung]).maximum(:created_at)
    aktiv_in_inaktiv_ueberwachung = Temperatur.where(['Pumpenstatus=1 AND created_at > ?', Time.now - (60*konf.Max_Inaktiv_Minuten_Tagsueber)]).sum(:Pumpenstatus)      # aktive Minuten innerhalb des Zeitraumes der Überwachung auf Inaktivität

    last_record = Temperatur.last

    # Anzahl der letzten minütlichen Messungen mit Pumpe aktiv, max. Wert ist konf.Min_Aktiv_Minuten_Vor_Vergleich, daher immer mit >= vergleichen
    min_pumpe_aktiv_zyklus = Temperatur.where(['ID > ?-?', last_record.id, konf.Min_Aktiv_Minuten_Vor_Vergleich]).sum(:Pumpenstatus)

    # Anzahl der Minuten bereits aktiv wegen zyklischer Reinigung
    minuten_pumpe_aktiv_wegen_reinigung = 0
    Temperatur.last(konf.Min_Aktiv_Fuer_Reinigung+1).sort{|x,y| y.id <=> x.id}.each do |r|
      break if r.wegen_zyklischer_reinigung_aktiv != 1                          # Nur zusammenhängende wegen_zyklischer_reinigung_aktiv zählen
      minuten_pumpe_aktiv_wegen_reinigung += 1                                  # Zählen der Minuten
    end


    # Verschiedene Bedingungen für Aktiv-Schaltung der Pumpe
    wegen_temperatur_aktiv = t.Ruecklauf < t.Sonne &&                                                 # muss immer erfüllt sein
        (min_pumpe_aktiv_zyklus < konf.Min_Aktiv_Minuten_Vor_Vergleich || t.Vorlauf > t.Ruecklauf )   # Wenn Pumpe bereits x Minuten lief, dann muss Vorlauf wärmer sein als Rücklauf

    # Test auf Überschreitung der Maximaltemperatur
    wegen_temperatur_aktiv = false if min_pumpe_aktiv_zyklus >= konf.Min_Aktiv_Minuten_Vor_Vergleich && t.Ruecklauf > konf.max_pool_temperatur

    wegen_zirkulationszeit_aktiv = fehlende_stunden_heute > 0 &&                                           # Es fehlt noch Zirkulationszeit
        Time.now.change(:hour=>konf.Max_Stunde_Aktiv) - Time.now < (fehlende_stunden_heute * 3600)  # Zirkulationsszeit nicht mehr zu schaffen bis max. Stunde?

    wegen_zyklischer_reinigung_aktiv = ( last_aktiv.nil? ||
                                         last_aktiv < Time.now - (60*konf.Max_Inaktiv_Minuten_Tagsueber) ||
                                         (minuten_pumpe_aktiv_wegen_reinigung > 0 && minuten_pumpe_aktiv_wegen_reinigung < konf.Min_Aktiv_Fuer_Reinigung )
                                       ) &&
        Time.now > Time.now.change(:hour=>konf.Inaktiv_Betrachtung_Start)  &&
        Time.now < Time.now.change(:hour=>konf.Inaktiv_Betrachtung_Ende)

    #puts "#{Time.now} Pumpe an wegen: Temperatur=#{wegen_temperatur_aktiv}, Zirkulationszeit=#{wegen_zirkulationszeit_aktiv}, Reinigung=#{wegen_zyklischer_reinigung_aktiv}"

    # Bedingungen für Anschalten der Pumpe
    if (wegen_temperatur_aktiv || wegen_zirkulationszeit_aktiv || wegen_zyklischer_reinigung_aktiv || konf.modus == 1 ) && konf.modus != 2
      schalter_typ.set_schalter_status(1, konf.schalter_ip)    # Anschalten der Pumpe
    else
      schalter_typ.set_schalter_status(0, konf.schalter_ip)    # Ausschalten der Pumpe
    end

    t.wegen_temperatur_aktiv            = wegen_temperatur_aktiv            ? 1 : 0
    t.wegen_zirkulationszeit_aktiv      = wegen_zirkulationszeit_aktiv      ? 1 : 0
    t.wegen_zyklischer_reinigung_aktiv  = wegen_zyklischer_reinigung_aktiv  ? 1 : 0
    t.Pumpenstatus                      = schalter_typ.get_schalter_status(konf.schalter_ip)      # 0/1

    t.save
  end

  # Reduktion der Datenmenge nach Ablauf von Haltefristen
  def self.housekeeping
    # Nur Records auf 10er Minuten behalten wenn älter als x Tage
    # Nur Einzeltransaktionen, damit DB nicht länger als 5 Sekunden gelockt bleibt (Timeout)
    Temperatur.where("created_at < DATETIME('now', '-7 days')").find_each do |t|
      t.destroy if t.created_at.min % 10 != 0
    end
  end

  ###### Formatierungsfunktionen ############
  def pumpe_an_grund
    retval = ''
    retval << 'Außentemperatur, '       if self.wegen_temperatur_aktiv            == 1
    retval << 'Zirkulationszeit, '      if self.wegen_zirkulationszeit_aktiv      == 1
    retval << 'zyklischer Reinigung, '  if self.wegen_zyklischer_reinigung_aktiv  == 1
    retval = retval[0, retval.length-2] if retval.length > 2
    retval = 'Manuell dauerhaft aktiv' if retval.length == 0 && self.Pumpenstatus > 0
    retval
  end

end
