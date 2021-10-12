import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:flutter_advanced_ui/shared/bloc/music_albums_lookup_bloc.dart';
import 'package:flutter_advanced_ui/i18n/app_localizations.dart';
import 'package:flutter_advanced_ui/i18n/translations.dart';
import 'package:flutter_advanced_ui/shared/bloc/music_data_states.dart';
import 'package:flutter_advanced_ui/shared/model/album.dart';
import 'package:flutter_advanced_ui/shared/widget/no_data_placeholder_widget.dart';

import 'album_detail_page.dart';

enum AlbumsViewLayout {
  gridView,
  listView,
  sliverGridView,
  sliverListView,
}

class AlbumsView extends StatefulWidget {
  const AlbumsView({
    Key? key,
    this.layout = AlbumsViewLayout.listView,
  }) : super(key: key);

  final AlbumsViewLayout layout;

  @override
  _AlbumsViewState createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  get l10n => AppLocalizations.of(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        /*
        if (widget.layout == SearchViewLayout.GridView ||
            widget.layout == SearchViewLayout.ListView) ...[
          _buildSearchInput(context),
          Divider(
            height: 1.0,
          ),
        ],
         */
        BlocBuilder<MusicAlbumsLookupBloc, MusicDataState>(
          builder: (context, state) {
            if (state is AlbumsLoaded) {
              switch (widget.layout) {
                case AlbumsViewLayout.gridView:
                  return _buildGridView(context, state.albums);
                case AlbumsViewLayout.listView:
                  return _buildListView(context, state.albums);
                case AlbumsViewLayout.sliverListView:
                  return _buildSliverScrollView(context, state.albums);
                case AlbumsViewLayout.sliverGridView:
                  return _buildSliverScrollView(context, state.albums);
                default:
                  return _buildListView(context, state.albums);
              }
            } else {
              return Expanded(
                child: NoDataPlaceholder(
                  isLoading: state is DataLoading,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context, List<Album> albums) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          return _buildListItem(context, albums[index]);
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Album album) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: Hero(
              tag: album.id,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                width: 56.0, // fixed width to avoid text moving on load
                image: album.artworkUrl,
                fadeInDuration: const Duration(milliseconds: 300),
              ),
            ),
            title: Text(album.title),
            subtitle: Text(album.release.year.toString()),
            onTap: () => _onItemTaped(album),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context, List<Album> albums) {
    return Expanded(
      child: GridView.count(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: <Widget>[
          for (final album in albums) _buildGridItem(context, album),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, Album album) {
    return GridTile(
      child: GestureDetector(
        onTap: () => _onItemTaped(album),
        child: Hero(
          tag: album.id,
          child: FadeInImage.memoryNetwork(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            placeholder: kTransparentImage,
            image: album.artworkUrl,
            fadeInDuration: const Duration(milliseconds: 300),
          ),
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: Text(
          album.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSliverScrollView(BuildContext context, List<Album> albums) {
    return Expanded(
      child: CustomScrollView(
        slivers: <Widget>[
          /*
          SliverAppBar(
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: _buildSearchInput(context),
            ),
            backgroundColor: Theme.of(context).canvasColor,
            //title: _buildSearchInput(),
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Divider(
              height: 1.0,
            ),
          ),
           */
          if (widget.layout == AlbumsViewLayout.sliverGridView)
            SliverGrid.count(
              crossAxisCount: 2,
              children: <Widget>[
                for (final album in albums) _buildGridItem(context, album),
              ],
            ),
          if (widget.layout == AlbumsViewLayout.sliverListView)
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _buildListItem(context, albums[index]);
                  },
                  childCount: albums.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onItemTaped(Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlbumDetailPage(album: album),
      ),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<MusicAlbumsLookupBloc>(context);
    return TextFormField(
      controller: _searchController,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: l10n.translate(Translation.labelSearch),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 16.0),
        prefixIcon: const Icon(Icons.search),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffixIcon: GestureDetector(
          onTap: () {
            // Workaround see #17647
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              _searchController.clear();
            });
          },
          child: const Icon(Icons.clear),
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          bloc.add(LookupAlbums(artistId: value));
        }
      },
    );
  }
}
