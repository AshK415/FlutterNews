import 'package:flutter/material.dart';
import 'package:flutter_news/features/news_feed/presentation/widgets/album_tile.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AlbumSelector extends StatelessWidget {
  const AlbumSelector({
    required this.albums,
    required this.controller,
    required this.onSelect,
    super.key,
  });
  final List<AssetPathEntity> albums;
  final ValueChanged<AssetPathEntity> onSelect;
  final PanelController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return SlidingUpPanel(
          controller: controller,
          minHeight: 0,
          color: Theme.of(context).canvasColor,
          boxShadow: const [],
          maxHeight: constraints.maxHeight,
          panelBuilder: (sc) => ListView(
            controller: sc,
            children: List.generate(
              albums.length,
              (index) => AlbumTile(
                album: albums[index],
                onSelect: () => onSelect(albums[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}
