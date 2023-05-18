import 'dart:ui';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_news/features/news_feed/presentation/widgets/media_list.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaContainer extends HookWidget {
  const MediaContainer({
    required this.asset,
    required this.onSelected,
    this.isSelected = false,
    super.key,
  });
  final AssetEntity asset;
  final bool isSelected;
  final void Function(bool, Media) onSelected;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 100);
    final animationController = useAnimationController(
      duration: duration,
    );
    final animation =
        Tween<double>(begin: 1, end: 1.3).animate(animationController);

    final selected = useState(isSelected);
    if (selected.value) animationController.forward();

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: Colors.grey.shade50,
      ),
      child: FutureBuilder<Media>(
        future: convertMedia(asset),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(0.5),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: InkWell(
                      onTap: () {
                        selected.value = !selected.value;
                        if (selected.value) {
                          animationController.forward();
                        } else {
                          animationController.reverse();
                        }
                        onSelected(selected.value, snapshot.data!);
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              child: AnimatedBuilder(
                                animation: animation,
                                builder: (ctx, child) {
                                  final amount = (animation.value - 1) * 3.33;
                                  return ImageFiltered(
                                    imageFilter: ImageFilter.blur(
                                      sigmaX: 0.5 * amount,
                                      sigmaY: 0.5 * amount,
                                    ),
                                    child: Transform.scale(
                                      scale: animation.value,
                                      child: CachedMemoryImage(
                                        uniqueKey:
                                            'app://image:${snapshot.data!.id}',
                                        bytes: snapshot.data!.thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: AnimatedOpacity(
                              opacity: selected.value ? 1 : 0,
                              curve: Curves.easeOut,
                              duration: duration,
                              child: ClipRect(
                                child: Container(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: AnimatedOpacity(
                        opacity: selected.value ? 1 : 0,
                        duration: duration,
                        curve: Curves.easeOut,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.done,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.grey.shade400,
                size: 40,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<Media> convertMedia(AssetEntity media) async {
    return Media()
      ..file = await media.file
      ..title = media.title
      ..size = media.size
      ..id = media.id
      ..mediaByte = await media.originBytes
      ..creationTime = media.createDateTime
      ..thumbnail = await media.thumbnailDataWithSize(
        const ThumbnailSize(200, 200),
      );
  }
}
