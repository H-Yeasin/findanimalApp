enum AppLanguage {
  french('fr', 'FRANCAIS'),
  english('en', 'ANGLAIS');

  const AppLanguage(this.code, this.label);

  final String code;
  final String label;

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.french,
    );
  }

  // String get flag => this == AppLanguage.french ? '🇫🇷' : '🇬🇧';
}
