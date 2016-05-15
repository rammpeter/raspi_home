class AuswertungController < ApplicationController

  def show_temperatur_verlauf
    if session[:start]
      @start = session[:start]
    else
      @start = Temperatur.first.created_at.strftime "%d.%m.%Y"
    end

    if session[:ende]
      @ende = session[:ende]
    else
      @ende = Temperatur.last.created_at.strftime "%d.%m.%Y"
    end

  end

  def list_temperatur_verlauf
    @start = params[:start]
    @ende  = params[:ende]
    session[:start] = params[:start]
    session[:ende]  = params[:ende]

    startDate = Time.new(
        params[:start][6,4],
        params[:start][3,2],
        params[:start][0,2],
    )

    endeDate = Time.new(
        params[:ende][6,4],
        params[:ende][3,2],
        params[:ende][0,2],
    )+(60*60*24)    # Bis Ende des letzten Tages scannen

    @temps = Temperatur.where(:created_at => startDate..endeDate)

    @vorlauf                            = ""
    @ruecklauf                          = ""
    @sonne                              = ""
    @schatten                           = ""
    @pumpenstatus                       = ""
    @wegen_temperatur_aktiv             = ''
    @wegen_zirkulationszeit_aktiv       = ''
    @wegen_zyklischer_reinigung_aktiv   = ''

    @temps.each do |t|
      milliseconds_since_1970 = t.created_at.to_i*1000 + t.created_at.utc_offset*1000
      @vorlauf                          << "[#{milliseconds_since_1970}, #{t.Vorlauf}],\n"
      @ruecklauf                        << "[#{milliseconds_since_1970}, #{t.Ruecklauf}],\n"
      @sonne                            << "[#{milliseconds_since_1970}, #{t.Sonne}],\n"
      @schatten                         << "[#{milliseconds_since_1970}, #{t.Schatten}],\n"
      @pumpenstatus                     << "[#{milliseconds_since_1970}, #{t.Pumpenstatus                     == 1 ? 5 : 0}],\n"
      @wegen_temperatur_aktiv           << "[#{milliseconds_since_1970}, #{t.wegen_temperatur_aktiv           == 1 ? 5 : 0}],\n"
      @wegen_zirkulationszeit_aktiv     << "[#{milliseconds_since_1970}, #{t.wegen_zirkulationszeit_aktiv     == 1 ? 5 : 0}],\n"
      @wegen_zyklischer_reinigung_aktiv << "[#{milliseconds_since_1970}, #{t.wegen_zyklischer_reinigung_aktiv == 1 ? 5 : 0}],\n"
    end

  end

  def show_temperatur_verlauf_aktuell
    params[:start] = (Time.now-(60*60*24)).strftime "%d.%m.%Y"
    params[:ende]  = Time.now.strftime "%d.%m.%Y"
    list_temperatur_verlauf
    render :template => 'auswertung/list_temperatur_verlauf'
  end


end
