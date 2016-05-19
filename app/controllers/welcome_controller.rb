class WelcomeController < ApplicationController
  def index
    @temperatur     = Temperatur.last
    @konfiguration  = Konfiguration.get_aktuelle_konfiguration
  end

end
