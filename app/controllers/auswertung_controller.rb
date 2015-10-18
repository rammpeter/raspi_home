class AuswertungController < ApplicationController

  def show_temperatur_verlauf
  end

  def list_temperatur_verlauf
    # Zeiten als GMT erzeugen, da in DB auch Ablage in GMT erwartet wird
    startDate = Time.gm(
        params[:time]['start(1i)'],
        params[:time]['start(2i)'],
        params[:time]['start(3i)'],
    )

    endeDate = Time.gm(
        params[:time]['ende(1i)'],
        params[:time]['ende(2i)'],
        params[:time]['ende(3i)'],
    )

    puts startDate.to_s
    puts startDate.localtime.to_s


    @temps = Temperatur.where(:created_at => startDate..endeDate)

    @vorlauf = ""
    @ruecklauf = ""
    @sonne = ""
    @schatten = ""

    @temps.each do |t|
      @vorlauf    << "[#{t.created_at.to_i*1000}, #{t.Vorlauf}],\n"
      @ruecklauf  << "[#{t.created_at.to_i*1000}, #{t.Ruecklauf}],\n"
      @sonne      << "[#{t.created_at.to_i*1000}, #{t.Sonne}],\n"
      @schatten   << "[#{t.created_at.to_i*1000}, #{t.Schatten}],\n"
    end

  end

end
