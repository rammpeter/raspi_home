class Temperatur < ActiveRecord::Base

  def self.schreibe_temperatur(vorlauf, ruecklauf)
    t = Temperatur.new(
        :Vorlauf    => vorlauf,
        :Ruecklauf  => ruecklauf
    ).save
  end
end
