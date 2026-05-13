enum AppLanguage {
  french('fr', 'FRANÇAIS'),
  english('en', 'ENGLISH');

  const AppLanguage(this.code, this.label);

  final String code;
  final String label;

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (language) => language.code == code,
      orElse: () => AppLanguage.french,
    );
  }
}
