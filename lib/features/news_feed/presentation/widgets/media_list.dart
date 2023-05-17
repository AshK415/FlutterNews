import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_news/features/news_feed/presentation/widgets/media_tile.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaList extends HookWidget {
  const MediaList({required this.album, required this.previousList, super.key});
  final AssetPathEntity album;
  final List<Media> previousList;

  @override
  Widget build(BuildContext context) {
    final selectedMedia = useState<List<Media>>([]);
    final lastPage = useState(0);
    final currentPage = useState(0);
    final mediaList = useState<List<Widget>>([]);

    // useEffect(() {
    //   _fetchMedia(lastPage, currentPage, mediaList, selectedMedia);
    //   return;
    // });

    return FutureBuilder<bool>(
      future: _fetchMedia(
          lastPage.value, currentPage.value, mediaList, selectedMedia),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          print('OP length');
          print(mediaList.value.length);
          return GridView.builder(
            itemCount: mediaList.value.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              crossAxisCount: 4,
            ),
            itemBuilder: (c, i) => mediaList.value[i],
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Got some error'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // NotificationListener<ScrollNotification>(
  //       onNotification: (ScrollNotification scroll) {
  //         if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
  //           if (currentPage.value != lastPage.value) {
  //             _fetchMedia(lastPage, currentPage, mediaList, selectedMedia);
  //           }
  //         }
  //         return true;
  //       },
  //       child: GridView.builder(
  //         itemCount: mediaList.value.length,
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 4,
  //         ),
  //         itemBuilder: (c, i) => mediaList.value[i],
  //       ),
  //     )

  Future<bool> _fetchMedia(
    int lastPage,
    int currentPage,
    ValueNotifier<List<Widget>> mediaList,
    ValueNotifier<List<Media>> selectedMedia,
  ) async {
    //lastPage. = currentPage.value;
    final result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized ||
        result == PermissionState.limited) {
      final media = await album.getAssetListPaged(page: currentPage, size: 60);
      final temp = <Widget>[];
      //print('Printing media');
      //print(media);
      for (final asset in media) {
        //print('Processing for: ${asset.id}');
        temp.add(
          Container(
            height: 80,
            width: 80,
            color: Colors.black54,
            child: FutureBuilder<Uint8List?>(
              future: asset.thumbnailData,
              builder: (_, snap) {
                if (snap.hasData) {
                  if (snap.data != null) {
                    return Image.memory(
                      snap.data!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  }
                } else if (snap.hasError) {
                  return const Center(
                    child: Text('Got some error'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          // MediaTile(
          //   media: asset,
          //   onSelected: (isSelected, media) {
          //     if (isSelected) {
          //       selectedMedia.value.add(media);
          //     } else {
          //       selectedMedia.value
          //           .removeWhere((element) => element.id == media.id);
          //     }
          //   },
          //   isSelected: isPreviouslySelected(asset, selectedMedia.value),
          // ),
        );
      }
      mediaList.value.addAll(temp);

      return true;
    } else {
      await PhotoManager.openSetting();
    }
    return false;
  }

  bool isPreviouslySelected(AssetEntity media, List<Media> selectedMedias) {
    var isSelected = false;
    for (final asset in selectedMedias) {
      if (asset.id == media.id) isSelected = true;
    }
    return isSelected;
  }
}

class Media {
  Media({
    this.id,
    this.file,
    this.thumbnail,
    this.mediaByte,
    this.size,
    this.creationTime,
    this.title,
  });

  ///File saved on local storage
  File? file;

  ///Unique id to identify
  String? id;

  ///A low resolution image to show as preview
  Uint8List? thumbnail;

  ///The image file in bytes format
  Uint8List? mediaByte;

  ///Image Dimensions
  Size? size;

  ///Creation time of the media file on local storage
  DateTime? creationTime;

  ///media name or title
  String? title;
}
