enum AppLanguage {
  french('fr', 'FRENCH', 'FRANCAIS'),
  english('en', 'ENGLISH', 'ANGLAIS');

  const AppLanguage(this.code, this.labelEn, this.labelFr);

  final String code;
  final String labelEn;
  final String labelFr;

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.french,
    );
  }

  String get flag => this == AppLanguage.french ? '🇫🇷' : '🇬🇧';
}
