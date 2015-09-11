class Temperatur < ActiveRecord::Base

  def self.schreibe_temperatur
    t = Temperatur.new()
    t.Zeit = Time.now
    t.Vorlauf=20
    t.Ruecklauf=22
    t.save

  end
end
