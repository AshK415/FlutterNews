import 'package:flutter_news/features/news_feed/presentation/widgets/media_list.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryState {
  GalleryState({required this.selected, this.fetchedImages});

  factory GalleryState.initial() => GalleryState(
        selected: List<Media>.empty(growable: true),
      );
  List<Media> selected;
  final List<AssetEntity>? fetchedImages;
}
