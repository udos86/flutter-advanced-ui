import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;

import 'feature_music_search/music_search_view.dart';
import 'i18n/app-localizations.dart';
import 'shared/bloc/music_lookup_bloc.dart';
import 'shared/bloc/music_search_bloc.dart';
import 'shared/data/music_data_provider.dart';
import 'shared/data/music_data_repository.dart';

void main() {
  final repository = MusicDataRepository(
    provider: MusicDataProvider(
      httpClient: http.Client(),
    ),
  );

  runApp(App(repository: repository));
}

class App extends StatelessWidget {
  final MusicDataRepository repository;

  App({
    Key key,
    @required this.repository,
  })  : assert(repository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MusicSearchBloc>(
          create: (context) => MusicSearchBloc(repository: repository),
        ),
        BlocProvider<MusicLookupBloc>(
          create: (context) => MusicLookupBloc(repository: repository),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Flutter Advanced UI',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: HomePage(title: 'Flutter Advanced UI'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: MusicSearchView(
        layout: SearchViewLayout.SliverGridView,
      ),
    );
  }
}