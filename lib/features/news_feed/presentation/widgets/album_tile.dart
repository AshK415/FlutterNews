import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumTile extends StatefulWidget {
  const AlbumTile({required this.album, required this.onSelect, super.key});

  final AssetPathEntity album;
  final VoidCallback onSelect;

  @override
  _AlbumTileState createState() => _AlbumTileState();
}

class _AlbumTileState extends State<AlbumTile> {
  Uint8List? albumThumb;
  bool hasError = false;

  @override
  void initState() {
    _getAlbumThumb(widget.album);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amberAccent,
      height: 80,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onSelect,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 80,
                height: 80,
                child: !hasError
                    ? albumThumb != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              albumThumb!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )
                    : Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.grey.shade400,
                          size: 40,
                        ),
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.album.name,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              const SizedBox(
                width: 5,
              ),
              // Text(
              //   '${widget.album.assetCountAsync}',
              //   style: TextStyle(
              //       color: Colors.grey.shade600,
              //       fontSize: 12,
              //       fontWeight: FontWeight.w400),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getAlbumThumb(AssetPathEntity album) async {
    final media = await album.getAssetListPaged(page: 0, size: 1);
    final thumbByte =
        await media[0].thumbnailDataWithSize(const ThumbnailSize(80, 80));
    if (thumbByte != null) {
      print(thumbByte);
      setState(() {
        albumThumb = thumbByte;
      });
    } else {
      setState(() {
        hasError = true;
      });
    }
  }
}
