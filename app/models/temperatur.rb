class Temperatur < ActiveRecord::Base

  # gibt die im File hinterlegte Temperatur zurück
  def self.read_temperature_from_file(env_name)
    raise "#{env_name} muss mit Pfad und Name der w1_slave-Datei belegt sein für den Sensor"     unless ENV[env_name]

    lines = IO.readlines(ENV[env_name])
    raise "2 Zeilen werden erwartet in File #{ENV[env_name]} statt #{lines.count}" if lines.count != 2
    line = lines[1]
    line.slice(line.index('t=')+2, 10).to_f/1000   # Temoeratur in Grad
  end

  def self.schreibe_temperatur
    t = Temperatur.new(
        :Vorlauf    => read_temperature_from_file('FILENAME_VORLAUF'),
        :Ruecklauf  => read_temperature_from_file('FILENAME_RUECKLAUF'),
        :Schatten   => read_temperature_from_file('FILENAME_SCHATTEN'),
        :Sonne      => read_temperature_from_file('FILENAME_SONNE')
    ).save
  end
end
