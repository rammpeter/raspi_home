class AuswertungController < ApplicationController

  def show_temperatur_verlauf
  end

  def list_temperatur_verlauf
    startDate = Time.new(
        params[:start][6,4],
        params[:start][3,2],
        params[:start][0,2],
    )

    endeDate = Time.new(
        params[:ende][6,4],
        params[:ende][3,2],
        params[:ende][0,2],
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
