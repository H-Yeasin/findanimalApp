enum AppLanguage {
  french('fr', 'FRENCH', 'FRANCAIS'),
  english('en', 'ENGLISH', 'ANGLAIS'),
  german('de', 'GERMAN', 'ALLEMAND'),
  spanish('es', 'SPANISH', 'ESPAGNOL'),
  italian('it', 'ITALIAN', 'ITALIEN');

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
}
