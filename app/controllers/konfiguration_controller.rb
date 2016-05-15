class KonfigurationController < ApplicationController

  def show_konfiguration
    @konfiguration = Konfiguration.get_aktuelle_konfiguration
  end

  def save_konfiguration
    Konfiguration.create(params[:konfiguration].to_hash)
    redirect_to :controller => :Welcome, :action => :index
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

end
