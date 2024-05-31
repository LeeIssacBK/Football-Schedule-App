enum Continent {
  asia, europe, southAmerica, northAmerica, africa, oceania;

  static Continent strToEnum(String str) {
    switch (str) {
      case 'ASIA':
        return Continent.asia;
      case 'EUROPE':
        return Continent.europe;
      case 'SOUTH_AMERICA':
        return Continent.southAmerica;
      case 'NORTH_AMERICA':
        return Continent.northAmerica;
      case 'AFRICA':
        return Continent.africa;
      case 'OCEANIA':
        return Continent.oceania;
    }
    throw Exception('not found continent');
  }

  static String enumToStr(Continent continent) {
    switch (continent) {
      case Continent.asia:
        return 'ASIA';
      case Continent.europe:
        return 'EUROPE';
      case Continent.southAmerica:
        return 'SOUTH_AMERICA';
      case Continent.northAmerica:
        return 'NORTH_AMERICA';
      case Continent.africa:
        return 'AFRICA';
      case Continent.oceania:
        return 'OCEANIA';
    }
  }
}