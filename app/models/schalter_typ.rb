require 'net/http'

class SchalterTyp
  attr_accessor :name
  attr_accessor :ip_adresse
  attr_accessor :passwort

  def initialize(name, ip_adresse, passwort = nil)
    raise "Schalter-Typ '#{name}' ist nicht bekannt, Abbruch!" unless SchalterTyp.get_namen.include?(name)
    @name       = name
    @ip_adresse = ip_adresse
    @passwort   = passwort
  end

  # Erlaubte Namen für schalter-Typen
  def self.get_namen
    [ 'Rutenbeck_TPIP1', 'Edimax SP-1101W', 'Dummy ohne Funktion' ]
  end

  # Array der bekannten Typen
#  def self.get_typen
#    get_namen.map{|x| SchalterTyp.new(x) }
#  end

  # Ermitteln des Schalt-Status der schaltbaren Steckdose, return 0 für aus oder 1 für ein
  def get_schalter_status
    case name

      when 'Rutenbeck_TPIP1' then
        result = Net::HTTP.get_response(URI("http://#{@ip_adresse}/status.xml"))
        xml_result = Nokogiri::XML(result.body)
        return xml_result.xpath('//led1').children[0].to_s.to_i

      when 'Edimax SP-1101W' then
        uri = URI.parse("http://#{@ip_adresse}:10000/smartplug.cgi")
        header = {'Content-Type' => 'text/xml'}

        # Create the HTTP objects
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.basic_auth 'admin', @passwort
        request.body = '<?xml version="1.0" encoding="utf-8"?>
                        <SMARTPLUG id="edimax">
                          <CMD id="get">
                            <Device.System.Power.State></Device.System.Power.State>
                          </CMD>
                        </SMARTPLUG>'

        # Send the request
        response = http.request(request)

        raise "Authorisierung mit Passwort #{@passwort} fehlgeschlagen für Typ=#{@name}" if response.class == Net::HTTPUnauthorized

        # Ausschneiden der ersten Zeile "<?xml version="1.0" encoding="UTF8"?>" die Nokogiri nicht interpretieren kann
        res = ''
        response.body.to_s.split("\n").each{|l| res << l if l['<?xml version="1.0" encoding="UTF8"?>'].nil? }

        on_off =  Nokogiri::XML(res).xpath('//CMD//Device.System.Power.State').children[0].to_s
        return 0 if on_off == 'OFF'
        return 1 if on_off == 'ON'
        raise "Unbekanntes Resultat '#{response.body}' bei Abfrage Schalter-Status"
    end
  end

  # Ein/Ausschalten der schaltbaren Steckdose 0/1
  def set_schalter_status(status)
    case name
      when 'Rutenbeck_TPIP1' then
        current = get_schalter_status(@ip_adresse)
        if current != status                                      # Kommando fungiert nur als Umschalter des aktuellen Status
          Net::HTTP.get(URI("http://#{@ip_adresse}/leds.cgi?led=1"))
        end

      when 'Edimax SP-1101W' then
        uri = URI.parse("http://#{@ip_adresse}:10000/smartplug.cgi")
        header = {'Content-Type' => 'text/xml'}

        # Create the HTTP objects
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.basic_auth 'admin', @passwort
        request.body = "<?xml version='1.0' encoding='utf-8'?>
                        <SMARTPLUG id='edimax'>
                          <CMD id='setup'>
                            <Device.System.Power.State>#{status == 1 ? 'ON' : 'OFF'}</Device.System.Power.State>
                          </CMD>
                        </SMARTPLUG>"

        # Send the request
        response = http.request(request)

        raise "Authorisierung mit Passwort #{@passwort} fehlgeschlagen für Typ=#{@name}" if response.class == Net::HTTPUnauthorized
        raise "Unbekanntes Resultat '#{response.body}', class=#{response.class} bei Setzen Schalter-Status" unless response.class == Net::HTTPOK
    end
  end
end