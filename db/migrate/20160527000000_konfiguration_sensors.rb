class KonfigurationSensors < ActiveRecord::Migration[5.2]
  def change
    add_column :konfigurations, :schalter_typ,                :string, :default => 'Rutenbeck_TPIP1'
    add_column :konfigurations, :schalter_ip,                 :string, :default => '192.168.178.48'

    add_column :konfigurations, :filename_vorlauf_sensor,     :string, :default => '/sys/bus/w1/devices/28-04146f57a7ff/w1_slave'
    add_column :konfigurations, :filename_ruecklauf_sensor,   :string, :default => '/sys/bus/w1/devices/28-04146f57bdff/w1_slave'
    add_column :konfigurations, :filename_sonne_sensor,       :string, :default => '/sys/bus/w1/devices/28-021503c262ff/w1_slave'
    add_column :konfigurations, :filename_schatten_sensor,    :string, :default => '/sys/bus/w1/devices/28-021503c981ff/w1_slave'
  end
end
