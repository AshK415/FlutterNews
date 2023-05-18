import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_news/features/news_feed/presentation/providers/gallery_fetch.dart';
import 'package:flutter_news/features/news_feed/presentation/widgets/media_container.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaList extends HookConsumerWidget {
  const MediaList({required this.album, required this.previousList, super.key});
  final AssetPathEntity album;
  final List<Media> previousList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final currentPage = useState(0);
    final currentIdx = useState(0);
    final galleryProvider = ref.watch(galleryFetchProvider(album, 0));
    return galleryProvider.when(
      data: (data) {
        if (data.fetchedImages!.isNotEmpty) {
          return Column(
            children: [
              if (data.selected.isNotEmpty)
                Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade50,
                  ),
                  child: Image.memory(
                    data.selected[currentIdx.value].thumbnail!,
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(),
              Expanded(
                child: GridView.builder(
                  itemCount: data.fetchedImages!.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (c, i) => MediaContainer(
                    asset: data.fetchedImages![i],
                    isSelected: isPreviouslySelected(
                      data.fetchedImages![i],
                      data.selected,
                    ),
                    onSelected: (isSelected, media) {
                      if (isSelected) {
                        ref
                            .read(galleryFetchProvider(album, 0).notifier)
                            .addMedia(media);
                        // lastIdx.value = currentIdx.value;
                        // currentIdx.value = i;
                      } else {
                        ref
                            .read(galleryFetchProvider(album, 0).notifier)
                            .removeMedia(media);
                        //currentIdx.value = lastIdx.value;
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('Unable to fetch images'),
          );
        }
      },
      error: (e, st) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // return Column(
    //   children: [
    //     ValueListenableBuilder<List<Media>>(
    //       valueListenable: selectedMedia,
    //       builder: (cc, md, _) => Text('${md.length}'),
    //     ),
    //     FutureBuilder<List<AssetEntity>?>(
    //       future: _fetchAllMedia(currentPage.value),
    //       builder: (ctx, snapshot) {
    //         if (snapshot.hasData) {
    //           final medias = snapshot.data;
    //           if (medias == null) {
    //             return const Center(
    //               child: Text('Unable to fetch pictures'),
    //             );
    //           }
    //           return Expanded(
    //             child: GridView.builder(
    //               itemCount: medias.length,
    //               shrinkWrap: true,
    //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //                 mainAxisSpacing: 4,
    //                 crossAxisSpacing: 4,
    //                 crossAxisCount: 4,
    //               ),
    //               itemBuilder: (c, i) => MediaContainer(
    //                 asset: medias[i],
    //                 isSelected:
    //                     isPreviouslySelected(medias[i], selectedMedia.value),
    //                 onSelected: (isSelected, media) {
    //                   if (isSelected) {
    //                     final tmp = selectedMedia.value..add(media);
    //                     selectedMedia.value = tmp;
    //                   } else {
    //                     final tmp = selectedMedia.value
    //                       ..removeWhere((element) => element.id == media.id);
    //                     selectedMedia.value = tmp;
    //                   }
    //                   print(selectedMedia.value);
    //                 },
    //               ),
    //             ),
    //           );
    //         } else if (snapshot.hasError) {
    //           return const Center(
    //             child: Text('Got some error'),
    //           );
    //         }
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       },
    //     ),
    //   ],
    // );
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
