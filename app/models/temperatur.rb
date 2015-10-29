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

  def self.schreibe_temperatur

    t = Temperatur.new(
        :Vorlauf      => read_temperature_from_file('FILENAME_VORLAUF'),
        :Ruecklauf    => read_temperature_from_file('FILENAME_RUECKLAUF'),
        :Schatten     => read_temperature_from_file('FILENAME_SCHATTEN'),
        :Sonne        => read_temperature_from_file('FILENAME_SONNE'),
        :Pumpenstatus => get_schalter_status      # 0/1
    )
    t.save
  end

  # Reduktion der Datenmenge nach Ablauf von Haltefristen
  def housekeeping
    # Nur Records auf 10er Minuten behalten wenn älter als x Tage
    Temperatur.where("created_at > DATETIME('now', '-7 days')").find_each do |t|
      t.destroy if t.created_at.min % 10 != 0
    end


  end

end
