class SchalterTyp
  attr_accessor :name

  def initialize(name)
    raise "Schalter-Typ '#{name}' ist nicht bekannt, Abbruch!" unless SchalterTyp.get_namen.include?(name)
    @name = name
  end

  # Erlaubte Namen für schalter-Typen
  def self.get_namen
    [ 'Rutenbeck_TPIP1', 'Edimax SP-1101W', 'Dummy ohne Funktion' ]
  end

  # Array der bekannten Typen
  def self.get_typen
    get_namen.map{|x| SchalterTyp.new(x) }
  end

  # Ermitteln des Schalt-Status der schaltbaren Steckdose, return 0 für aus oder 1 für ein
  def get_schalter_status(ip_address)
    case name
      when 'Rutenbeck_TPIP1' then
        result = Net::HTTP.get_response(URI("http://#{ip_address}/status.xml"))
        xml_result = Nokogiri::XML(result.body)
        return xml_result.xpath('//led1').children[0].to_s.to_i
      when 'Edimax SP-1101W' then
        raise "Not implemented"
    end
  end

  # Ein/Ausschalten der schaltbaren Steckdose 0/1
  def set_schalter_status(status, ip_address)
    case name
      when 'Rutenbeck_TPIP1' then
        current = get_schalter_status(ip_address)
        if current != status                                      # Kommando fungiert nur als Umschalter des aktuellen Status
          Net::HTTP.get(URI("http://#{ip_address}/leds.cgi?led=1"))
        end
      when 'Edimax SP-1101W' then
        raise "Not implemented"
    end
  end



end