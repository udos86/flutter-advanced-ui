import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:flutter_advanced_ui/shared/bloc/music_albums_lookup_bloc.dart';
import 'package:flutter_advanced_ui/i18n/app-localizations.dart';
import 'package:flutter_advanced_ui/i18n/translations.dart';
import 'package:flutter_advanced_ui/shared/bloc/music_data_states.dart';
import 'package:flutter_advanced_ui/shared/model/album.dart';
import 'package:flutter_advanced_ui/shared/widget/no_data_placeholder_widget.dart';

import 'album_detail_page.dart';

enum AlbumsViewLayout {
  GridView,
  ListView,
  SliverGridView,
  SliverListView,
}

class AlbumsView extends StatefulWidget {
  AlbumsView({
    Key key,
    this.layout = AlbumsViewLayout.ListView,
  }) : super(key: key);

  final AlbumsViewLayout layout;

  @override
  _AlbumsViewState createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView> {
  TextEditingController _searchController;

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
                case AlbumsViewLayout.GridView:
                  return _buildGridView(context, state.albums);
                case AlbumsViewLayout.ListView:
                  return _buildListView(context, state.albums);
                case AlbumsViewLayout.SliverListView:
                  return _buildSliverScrollView(context, state.albums);
                case AlbumsViewLayout.SliverGridView:
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
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
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
                fadeInDuration: Duration(milliseconds: 300),
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
            fadeInDuration: Duration(milliseconds: 300),
          ),
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: Text(
          album.title,
          textAlign: TextAlign.center,
          style: TextStyle(
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
          if (widget.layout == AlbumsViewLayout.SliverGridView)
            SliverGrid.count(
              crossAxisCount: 2,
              children: <Widget>[
                for (final album in albums) _buildGridItem(context, album),
              ],
            ),
          if (widget.layout == AlbumsViewLayout.SliverListView)
            SliverPadding(
              padding: EdgeInsets.all(8.0),
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
        contentPadding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 16.0),
        prefixIcon: Icon(Icons.search),
        hasFloatingPlaceholder: false,
        suffixIcon: GestureDetector(
          onTap: () {
            // Workaround see #17647
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _searchController.clear();
            });
          },
          child: Icon(Icons.clear),
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
