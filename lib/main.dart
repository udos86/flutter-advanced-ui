import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;

import 'feature_albums_lookup/albums_view.dart';
import 'feature_music_search/music_search_delegate.dart';
import 'i18n/app-localizations.dart';
import 'shared/bloc/music_albums_lookup_bloc.dart';
import 'shared/bloc/music_artists_search_bloc.dart';
import 'shared/bloc/music_tracks_lookup_bloc.dart';
import 'shared/data/music_data_provider.dart';
import 'shared/data/music_data_repository.dart';
import 'shared/model/artist.dart';

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
        BlocProvider<MusicArtistsSearchBloc>(
          create: (context) => MusicArtistsSearchBloc(repository: repository),
        ),
        BlocProvider<MusicAlbumsLookupBloc>(
          create: (context) => MusicAlbumsLookupBloc(repository: repository),
        ),
        BlocProvider<MusicTracksLookupBloc>(
          create: (context) => MusicTracksLookupBloc(repository: repository),
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
      appBar: _buildAppBar(context),
      body: AlbumsView(
        layout: AlbumsViewLayout.SliverGridView,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: MusicSearchDelegate(),
            ).then(onSearchValue);
          },
        ),
      ],
    );
  }

  void onSearchValue(Artist artist) {
    if (artist != null) {
      // ignore: close_sinks
      final bloc = BlocProvider.of<MusicAlbumsLookupBloc>(context);
      bloc.add(LookupAlbums(artistId: artist.id));
    }
  }
}
