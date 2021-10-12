import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_advanced_ui/shared/bloc/music_data_states.dart';
import 'package:flutter_advanced_ui/shared/bloc/music_artists_search_bloc.dart';
import 'package:flutter_advanced_ui/shared/model/artist.dart';
import 'package:flutter_advanced_ui/shared/widget/no_data_placeholder_widget.dart';

class MusicSearchDelegate extends SearchDelegate<Artist?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<MusicArtistsSearchBloc>(context);

    if (query.isNotEmpty) {
      bloc.add(SearchArtists(term: query));

      return BlocBuilder<MusicArtistsSearchBloc, MusicDataState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is ArtistsLoaded) {
            final artists = state.artists;
            return ListView.builder(
              itemCount: artists.length,
              itemBuilder: (context, index) {
                final artist = artists[index];
                return ListTile(
                  title: Text(artist.name),
                  onTap: () {
                    close(context, artist);
                  },
                );
              },
            );
          } else {
            return NoDataPlaceholder(
              isLoading: state is DataLoading,
            );
          }
        },
      );
    } else {
      return const NoDataPlaceholder();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const NoDataPlaceholder();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: theme.primaryTextTheme.headline6?.color,
        ),
      ),
      primaryColor: Colors.black,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      textTheme: theme.textTheme.copyWith(
        headline6: theme.textTheme.headline6?.copyWith(
          color: theme.primaryTextTheme.headline6?.color,
        ),
      ),
    );
  }
}
