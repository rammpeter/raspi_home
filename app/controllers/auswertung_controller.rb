class AuswertungController < ApplicationController

  def show_temperatur_verlauf
  end

  def list_temperatur_verlauf
    startDate = Time.new(
        params[:time]['start(1i)'],
        params[:time]['start(2i)'],
        params[:time]['start(3i)'],
    )

    endeDate = Time.new(
        params[:time]['ende(1i)'],
        params[:time]['ende(2i)'],
        params[:time]['ende(3i)'],
    )

    @temps = Temperatur.where(:created_at => startDate..endeDate)

    @vorlauf = ""
    @ruecklauf = ""
    @sonne = ""
    @schatten = ""

    @temps.each do |t|
      milliseconds_since_1970 = t.created_at.to_i*1000 + t.created_at.utc_offset*1000
      @vorlauf    << "[#{milliseconds_since_1970}, #{t.Vorlauf}],\n"
      @ruecklauf  << "[#{milliseconds_since_1970}, #{t.Ruecklauf}],\n"
      @sonne      << "[#{milliseconds_since_1970}, #{t.Sonne}],\n"
      @schatten   << "[#{milliseconds_since_1970}, #{t.Schatten}],\n"
    end

  end

end
