class KonfigurationMinDistance < ActiveRecord::Migration
  def change
    # Pendeln verhindern am Abend wenn Sonne-Sensor noch gespeicherte Wärme misst, aber kein Temperaturgewinn mehr stattfindet
    add_column :konfigurations, :min_sonne_ruecklauf_distanz,   :decimal, :precision => 3, :scale => 1, :default=>0.5
    # Sicherstellen, dass Gewinn an Temperatur nicht durch Leitungs-Verluste z.B. bei Erdverlegung wieder kompensiert wird bevor Becken erreicht wird
    add_column :konfigurations, :min_vorlauf_ruecklauf_distanz, :decimal, :precision => 3, :scale => 1, :default=>0.2
  end
end
