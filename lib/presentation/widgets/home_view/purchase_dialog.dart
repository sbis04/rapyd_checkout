import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:slibro/application/res/palette.dart';
import 'package:slibro/utils/storage.dart';
import 'package:slibro/utils/user_client.dart';

class PurchaseDialog extends StatefulWidget {
  const PurchaseDialog({
    Key? key,
    required this.coverId,
    required this.storyId,
    required this.title,
    required this.price,
  }) : super(key: key);

  final String coverId;
  final String storyId;
  final String title;
  final double price;

  @override
  State<PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<PurchaseDialog> {
  final StorageClient _storageClient = StorageClient();
  final UserClient _userClient = UserClient();
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Palette.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 30,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 100 * 1.5,
              width: 100,
              decoration: BoxDecoration(
                color: Palette.greyLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Palette.greyDark,
                  width: 2,
                ),
              ),
              child: FutureBuilder<Uint8List>(
                future: _storageClient.getCoverImage(
                  imageID: widget.coverId,
                ),
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            snapshot.data!,
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    // 'Checking if a long story title is present',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Palette.black,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '\$ ${widget.price.toString()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isAdding = true;
                        });

                        await _userClient.addItemToCart(
                          storyId: widget.storyId,
                        );

                        setState(() {
                          _isAdding = false;
                        });

                        Navigator.of(context).pop();
                      },
                      child: _isAdding
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Palette.white.withOpacity(0.5),
                                ),
                              ),
                            )
                          : const Text(
                              'Add to cart',
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0,
                              ),
                            ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
