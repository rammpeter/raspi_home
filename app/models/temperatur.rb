require 'net/http'

class Temperatur < ActiveRecord::Base

  # gibt die im File hinterlegte Temperatur zurück
  def self.read_temperature_from_file(env_name)
    raise "#{env_name} muss mit Pfad und Name der w1_slave-Datei belegt sein für den Sensor"     unless ENV[env_name]

    lines = IO.readlines(ENV[env_name])
    raise "2 Zeilen werden erwartet in File #{ENV[env_name]} statt #{lines.count}" if lines.count != 2
    line = lines[1]
    line.slice(line.index('t=')+2, 10).to_f/1000   # Temoeratur in Grad
  end

  # Ermitteln des Schalt-Status der schaltbaren Steckdose, return 0 für aus oder 1 für ein
  def self.get_schalter_status
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
  def self.set_schalter_status(status)
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
  MAX_STUNDE_AKTIV=17                                                           # Bis wann soll die Pumpe max. aktiv sein, um die Mindestumwälzzeit zu erreichen
  MIN_AKTIV_STUNDEN_JE_TAG = 4                                                  # Wieviel Stunden je Tag soll Pumpe mindestens zirkulieren
  TAGE_RUCKWAERTS_MINDESTENS_AKTIV = 4                                          # Anzahl der Tage, für die in Summe Aktivzeit der Pumpe > x sein soll
  MIN_AKTIV_MINUTEN_VOR_VERGLEICH=5                                             # Mindest-Aktivzeit der Pumpe in Minute, bevor Vorlauf und Ruecklauf verglichen werden
  MAX_INAKTIV_MINUTEN_TAGSUEBER=60                                              # Max. Inaktivität tagsüber für Reinigung der Oberfläche

  def self.berechne_pumpen_status(vorlauf, ruecklauf, schatten, sonne)
    # Einfluss-Faktoren:
    #   Temperatur in Sonne
    #   Temperatur Vorlauf (von Solaranlage zum Pool)
    #   Temperatur Rücklauf (von Pumpe zu Solaranlage)
    #   Dauer Pumpenaktivität am aktuellen Tag
    #   Zeitpunkt der letzte Pumpenaktivität

    start_betrachtung = Time.now.change(:hour=>0) - TAGE_RUCKWAERTS_MINDESTENS_AKTIV*24*60*60
    pumpe_aktiv_letzte_tage = Temperatur.where(['Pumpenstatus=1 AND created_at > ?', start_betrachtung]).sum(:Pumpenstatus).to_f/60
    fehlende_stunden_heute = (MIN_AKTIV_STUNDEN_JE_TAG * TAGE_RUCKWAERTS_MINDESTENS_AKTIV) - pumpe_aktiv_letzte_tage
    fehlende_stunden_heute = 0 if fehlende_stunden_heute < 0
    last_aktiv = Temperatur.where(['Pumpenstatus=1 AND created_at > ?', start_betrachtung]).maximum(:created_at)

    last_record = Temperatur.last

    min_pumpe_aktiv_zyklus = Temperatur.where(['ID > ?-?', last_record.id, MIN_AKTIV_MINUTEN_VOR_VERGLEICH]).sum(:Pumpenstatus)    # Anzahl der letzten minütlichen Messungen mit Pumpe aktiv

    # Verschiedene Bedingungen für Aktiv-Schaltung der Pumpe
    wegen_temperatur_aktiv = ruecklauf < sonne &&                                                   # muss immer erfüllt sein
        (min_pumpe_aktiv_zyklus >= MIN_AKTIV_MINUTEN_VOR_VERGLEICH || vorlauf > ruecklauf )   # Wenn Pumpe bereits x Minuten lief, dann muss Vorlauf wärmer sein als Rücklauf

    wegen_zirkulationszeit_aktiv = fehlende_stunden_heute > 0 &&                                           # Es fehlt noch Zirkulationszeit
        Time.now.change(:hour=>MAX_STUNDE_AKTIV) - Time.now < (fehlende_stunden_heute * 3600)  # Zirkulationsszeit nicht mehr zu schaffen bis max. Stunde?

    wegen_zyklischer_reinigung_aktiv = last_aktiv.nil? || last_aktiv < Time.now - (60*MAX_INAKTIV_MINUTEN_TAGSUEBER)

    #puts "Pumpe an wegen: Temperatur=#{wegen_temperatur_aktiv}, Zirkulationszeit=#{wegen_zirkulationszeit_aktiv}, Reinigung=#{wegen_zyklischer_reinigung_aktiv}"

    # Bedingungen für Anschalten der Pumpe
    if wegen_temperatur_aktiv || wegen_zirkulationszeit_aktiv || wegen_zyklischer_reinigung_aktiv
      set_schalter_status(1)    # Anschalten der Pumpe
    else
      set_schalter_status(0)    # Ausschalten der Pumpe
    end

  end

  def self.schreibe_temperatur
    vorlauf      = read_temperature_from_file('FILENAME_VORLAUF')
    ruecklauf    = read_temperature_from_file('FILENAME_RUECKLAUF')
    schatten     = read_temperature_from_file('FILENAME_SCHATTEN')
    sonne        = read_temperature_from_file('FILENAME_SONNE')

    berechne_pumpen_status(vorlauf, ruecklauf, schatten, sonne)   # Muss statt finden bevor der aktuelle Record geschrieben wird

    t = Temperatur.new(
        :Vorlauf      => vorlauf,
        :Ruecklauf    => ruecklauf,
        :Schatten     => schatten,
        :Sonne        => sonne,
        :Pumpenstatus => get_schalter_status      # 0/1
    )
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

end
