import 'package:flutter_news/features/news_feed/presentation/providers/gallery_state.dart';
import 'package:flutter_news/features/news_feed/presentation/widgets/media_list.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_fetch.g.dart';

@riverpod
class GalleryFetch extends _$GalleryFetch {
  GalleryFetch(this.galleryState);
  GalleryState galleryState;

  @override
  FutureOr<GalleryState> build(AssetPathEntity asset, int page) async {
    return await fetchImages(asset, page);
  }

  Future<GalleryState> fetchImages(AssetPathEntity album, int page) async {
    var isAllowed = await _checkPermission();
    if (!isAllowed) {
      await PhotoManager.openSetting().then((value) async {
        isAllowed = await _checkPermission();
      });
    }
    final v =
        isAllowed ? await album.getAssetListPaged(page: page, size: 60) : null;
    return GalleryState(
      selected: List<Media>.empty(growable: true),
      fetchedImages: v,
    );
  }

  Future<bool> _checkPermission() async {
    final result = await PhotoManager.requestPermissionExtend();
    return result == PermissionState.authorized ||
        result == PermissionState.limited;
  }

  void addMedia(Media media) {
    state = state..copyWithPrevious(state..value!.selected.add(media));
  }

  void removeMedia(Media media) {
    state = state
      ..copyWithPrevious(state
        ..value!.selected.removeWhere((element) => element.id == media.id));
  }
}
