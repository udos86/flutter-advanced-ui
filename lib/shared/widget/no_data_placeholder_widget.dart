import 'package:flutter/material.dart';

import 'package:flutter_advanced_ui/i18n/app-localizations.dart';
import 'package:flutter_advanced_ui/i18n/translations.dart';
import 'package:flutter_advanced_ui/shared/bloc/music_data_states.dart';

class NoDataPlaceholder extends StatelessWidget {
  NoDataPlaceholder({
    this.state,
    Key key,
  }) : super(key: key);

  final MusicDataState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: state is DataEmpty
          ? Text(l10n.translate(Translation.textEmptyView))
          : CircularProgressIndicator(),
    );
  }
}
