class SchalterTyp
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  # Array der bekannten Typen
  def self.get_typen
    [
        SchalterTyp.new('Rutenbeck_TPIP1'),
        SchalterTyp.new('Edimax SP-1101W')
    ]
  end


end