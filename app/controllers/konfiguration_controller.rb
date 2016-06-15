class KonfigurationController < ApplicationController
  before_action :authenticate

  # Zugangsschutz für Konfiguration
  def authenticate
    konf = Konfiguration.get_aktuelle_konfiguration

    # http basic auth:
    # authenticate_or_request_with_http_basic('Administration') do |username, password|
    #  konf = Konfiguration.get_aktuelle_konfiguration
    #  username == konf.UserName && password == konf.Passwort
    # end

    # Alternativ lokale authentifizierung
    if session[:username] != konf.UserName || session[:password] != konf.Passwort
      session[:after_auth_controller] = params[:controller]
      session[:after_auth_action]     = params[:action]
      redirect_to :controller => :Welcome, :action => :authenticate
    end
  end

  def show_konfiguration
    @konfiguration = Konfiguration.get_aktuelle_konfiguration
  end

  def save_konfiguration
    if params[:commit] == 'Globale Historie'
      redirect_to :action => :show_globale_historie
      return
    end


    new_konf  = Konfiguration.new(params[:konfiguration].to_hash)
    last_konf = Konfiguration.get_aktuelle_konfiguration

    # Vorbereiten für Vergleich
    last_konf.id = new_konf.id
    last_konf.created_at = new_konf.created_at
    last_konf.updated_at = new_konf.updated_at

    if new_konf.attributes != last_konf.attributes
      new_konf.save
      redirect_to :controller => :Welcome, :action => :index
    else
      @message = "Es hat keine Änderung stattgefunden! Konfiguration wurde nicht gespeichert."
      render :show_message
    end
  end

  def show_historie
    @column = params[:column].to_sym
    @historie = []

    last_val = nil
    Konfiguration.find_each do |k|
      if last_val != k[@column]
        @historie << {:created_at => k.created_at, :value => k[@column]}
        last_val = k[@column]
      end
    end

  end

  def show_globale_historie
    @historie = Konfiguration.order(:created_at => :desc)
  end

end
