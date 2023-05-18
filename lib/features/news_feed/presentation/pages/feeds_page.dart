import 'package:flutter/material.dart';
import 'package:flutter_news/features/news_feed/presentation/widgets/photos_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedsPage extends HookConsumerWidget {
  const FeedsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final picker = ImagePicker();
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _photosSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> _photosSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      builder: (ctx) => const PhotosSheet(),
    );
  }
}
