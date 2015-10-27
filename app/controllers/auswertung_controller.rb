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

    @vorlauf = ""
    @ruecklauf = ""
    @sonne = ""
    @schatten = ""
    @pumpenstatus = ""

    @temps.each do |t|
      milliseconds_since_1970 = t.created_at.to_i*1000 + t.created_at.utc_offset*1000
      @vorlauf      << "[#{milliseconds_since_1970}, #{t.Vorlauf}],\n"
      @ruecklauf    << "[#{milliseconds_since_1970}, #{t.Ruecklauf}],\n"
      @sonne        << "[#{milliseconds_since_1970}, #{t.Sonne}],\n"
      @schatten     << "[#{milliseconds_since_1970}, #{t.Schatten}],\n"
      @pumpenstatus << "[#{milliseconds_since_1970}, #{t.Pumpenstatus == 1 ? 10 : 0}],\n"
    end

  end

end
