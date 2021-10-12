import 'package:flutter/material.dart';

import 'package:flutter_advanced_ui/i18n/app_localizations.dart';
import 'package:flutter_advanced_ui/i18n/translations.dart';

class NoDataPlaceholder extends StatelessWidget {
  const NoDataPlaceholder({
    Key? key,
    this.isLoading = false,
    this.message,
  }) : super(key: key);

  final bool isLoading;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : Text(message ??
              l10n?.translate(Translation.textEmptyView) ??
              'Loading'),
    );
  }
}
