import 'package:flutter/material.dart';
import 'package:flutter_advanced_ui/shared/widget/no_data_placeholder_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_advanced_ui/i18n/app_localizations.dart';
import 'package:flutter_advanced_ui/shared/bloc/music_data_states.dart';
import 'package:flutter_advanced_ui/shared/bloc/music_tracks_lookup_bloc.dart';
import 'package:flutter_advanced_ui/shared/model/album.dart';
import 'package:transparent_image/transparent_image.dart';

import 'track_list_tile.dart';

class AlbumDetailPage extends StatefulWidget {
  final Album album;

  const AlbumDetailPage({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  _AlbumDetailPageState createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // ignore: close_sinks
    final bloc = BlocProvider.of<MusicTracksLookupBloc>(context);
    // Tracks need to be obtained only once
    bloc.add(LookupTracks(albumId: widget.album.id));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  get l10n => AppLocalizations.of(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 360,
            backgroundColor: Colors.black,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final showTitle = constraints.biggest.height == 80.0;
                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  title: AnimatedOpacity(
                    opacity: showTitle ? 1.0 : 0,
                    duration: const Duration(milliseconds: 100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.album.title,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Container(
                            transform: Matrix4.translationValues(0.0, 8.0, 0),
                            child: FadeInImage.memoryNetwork(
                              height: 40,
                              placeholder: kTransparentImage,
                              image: widget.album.artworkUrl,
                              fadeInDuration: const Duration(
                                milliseconds: 300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  background: Hero(
                    tag: widget.album.id,
                    child: FadeInImage.memoryNetwork(
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                      placeholder: kTransparentImage,
                      image: widget.album.artworkUrl,
                      fadeInDuration: const Duration(
                        milliseconds: 300,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(
              height: 1.0,
            ),
          ),
          BlocBuilder<MusicTracksLookupBloc, MusicDataState>(
            builder: (context, state) {
              return state is TracksLoaded
                  ? SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate.fixed(
                          List.generate(state.tracks.length, (index) {
                            return Column(
                              children: <Widget>[
                                TrackListTile(state.tracks[index]),
                                const Divider(),
                              ],
                            );
                          }),
                        ),
                      ),
                    )
                  : SliverFillRemaining(
                      child: NoDataPlaceholder(
                        isLoading: state is DataLoading,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
