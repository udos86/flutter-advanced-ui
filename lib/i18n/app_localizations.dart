import 'package:flutter/material.dart';

import 'translations.dart';

@immutable
class AppLocalizations {
  AppLocalizations(this.locale)
      : _translations = appTranslations[locale.languageCode];

  final Locale locale;

  final Map<Translation, String>? _translations;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('de'),
    Locale('en'),
  ];

  String? translate(Translation key) => _translations?[key];

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.contains(locale);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      Future.value(AppLocalizations(locale));

  @override
  bool shouldReload(LocalizationsDelegate old) => false;
}
