class WelcomeController < ApplicationController
  def index
    @temperatur     = Temperatur.last
    @konfiguration  = Konfiguration.get_aktuelle_konfiguration
  end

  def authenticate

  end

  def do_auth
    konfiguration  = Konfiguration.get_aktuelle_konfiguration
    if params[:username] != konfiguration.UserName || params[:password] != konfiguration.Passwort
      flash[:message] = 'Falscher Benutzer oder falsches Passwort'
      redirect_to(:action => :authenticate)
    else
      session[:username] = params[:username]
      session[:password] = params[:password]
      # Zurück zum ursprünglichen Aufrufer
      redirect_to(:controller => session[:after_auth_controller], :action => session[:after_auth_action])
    end
  end

end
