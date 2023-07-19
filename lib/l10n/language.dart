import 'dart:ui';

enum Language {
  english(Locale('en', 'US')),
  indonesia(Locale('id', 'ID')),
  arabic(Locale('ar', 'SA')),
  chinese(Locale('zh', 'CN')),
  french(Locale('fr', 'FR')),
  urdu(Locale('ur', 'PK'));

  /// Add another languages support here
  const Language(this.value);

  final Locale value;
}
