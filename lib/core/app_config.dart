class Config {
  static const bool useFinalFSDB = false; // false = Dev, true = Prod
  static const double version = 0.1;

  static String get environment =>
      useFinalFSDB ? "Production" : "Development";
}

enum Screen {
  homeScreen,
  listScreen,
  newlist,
  info,
  favorites
}

