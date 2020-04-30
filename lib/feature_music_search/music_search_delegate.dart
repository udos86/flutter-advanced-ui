import 'package:flutter/material.dart';
import 'package:flutter_advanced_ui/shared/model/artist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_advanced_ui/shared/bloc/music_data_events.dart';
import 'package:flutter_advanced_ui/shared/bloc/music_data_states.dart';
import 'package:flutter_advanced_ui/shared/bloc/music_search_bloc.dart';

class MusicSearchDelegate extends SearchDelegate<Artist> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<MusicSearchBloc>(context);
    bloc.add(SearchArtists(term: query));

    return BlocBuilder<MusicSearchBloc, MusicDataState>(
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
          // TODO: Implement NoDataWidget
          return Column();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Column();
  }
}
