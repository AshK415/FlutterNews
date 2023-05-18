import 'package:flutter/material.dart';
import 'package:flutter_news/features/news_feed/presentation/widgets/media_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotosSheet extends ConsumerWidget {
  const PhotosSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: FutureBuilder<List<AssetPathEntity>?>(
          future: _fetchAlbums(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              final imgs = snapshot.data;
              if (imgs == null) {
                return Container();
              }
              //print(imgs);
              return Column(
                children: [
                  SizedBox(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${imgs.length}'),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: MediaList(
                            album: imgs[1],
                            previousList: [],
                          ),
                        ),
                      ],
                    ),
                    // child: ListView.builder(
                    //   itemCount: imgs.length,
                    //   shrinkWrap: true,
                    //   itemBuilder: (c, i) => ListTile(
                    //     title: Text(imgs[i].name),
                    //   ),
                    // ),
                    // child: AlbumSelector(
                    //   albums: imgs,
                    //   controller: controller,
                    //   onSelect: (value) {
                    //     print(value.id);
                    //   },
                    // ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Some error occured while fetching images'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Future<List<AssetPathEntity>?> _fetchAlbums() async {
    const type = RequestType.image;
    final result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized ||
        result == PermissionState.limited) {
      return PhotoManager.getAssetPathList(type: type);
    } else {
      await PhotoManager.openSetting();
    }
    return null;
  }
}
