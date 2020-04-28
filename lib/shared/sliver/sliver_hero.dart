import 'package:flutter/material.dart';

class SliverHero extends SliverPersistentHeader {
  final Hero child;
  final bool floating;
  final maxHeight;
  final minHeight;
  final bool pinned;

  SliverHero({
    @required this.child,
    this.floating = false,
    this.maxHeight = 400.0,
    this.minHeight = 0.0,
    this.pinned = false,
  }) : super(
          delegate: _SliverHeroDelegate(child, maxHeight, minHeight),
          floating: true,
          pinned: true,
        );
}

class _SliverHeroDelegate extends SliverPersistentHeaderDelegate {
  final Hero _hero;
  final _maxHeight;
  final _minHeight;

  @override
  double get maxExtent => _maxHeight;

  @override
  double get minExtent => _minHeight;

  _SliverHeroDelegate(this._hero, this._maxHeight, this._minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _hero;
  }

  @override
  bool shouldRebuild(_SliverHeroDelegate oldDelegate) {
    return false;
  }
}
