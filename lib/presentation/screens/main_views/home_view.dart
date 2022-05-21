import 'dart:developer';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:slibro/application/res/palette.dart';
import 'package:slibro/main.dart';
import 'package:slibro/presentation/screens/story_writing/chapter_view.dart';
import 'package:slibro/presentation/widgets/home_view/purchase_dialog.dart';
import 'package:slibro/utils/database.dart';
import 'package:slibro/utils/storage.dart';
import 'package:slibro/utils/user_client.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DatabaseClient _databaseClient = DatabaseClient();
  final StorageClient _storageClient = StorageClient();

  List<Document>? _stories;

  _getStories() async {
    List<Document> publishedStories = [];
    final stories = await _databaseClient.getStories();

    for (int i = 0; i < stories.documents.length; i++) {
      final storyData = stories.documents[i].data;

      if (storyData['published'] == true) {
        publishedStories.add(stories.documents[i]);
      }
    }

    setState(() {
      _stories = publishedStories;
    });
  }

  @override
  void initState() {
    _getStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stories',
            style: TextStyle(
              color: Palette.black,
              fontSize: 36.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _stories != null
              ? _stories!.isEmpty
                  ? Expanded(
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('No stories are available'),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => _getStories(),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemCount: _stories!.length,
                          itemBuilder: (context, index) {
                            final List<Document> retrievedStories = _stories!;
                            log(retrievedStories.length.toString());

                            final storyData = retrievedStories[index].data;
                            final String title = storyData['title'];
                            final String author = storyData['author'];
                            final String coverId = storyData['cover'];
                            final String description = storyData['description'];
                            final bool isPaid = storyData['paid'];
                            final double? price = storyData['price'];

                            return InkWell(
                                onTap: () {
                                  if (isPaid) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) => PurchaseDialog(
                                        coverId: coverId,
                                        storyId: retrievedStories[index].$id,
                                        title: title,
                                        price: price!,
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChapterViewScreen(
                                          story: retrievedStories[index],
                                          user: widget.user,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
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
                                          imageID: coverId,
                                        ),
                                        builder: (context, snapshot) {
                                          return snapshot.hasData &&
                                                  snapshot.data != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            // 'Checking if a long story title is present',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Palette.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            'Written by $author',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Palette.greyMedium,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Palette.greyDark,
                                              fontSize: 12,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          isPaid
                                              ? Text(
                                                  '\$ ${price.toString()}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : const Text(
                                                  'Free',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                                // child: ListTile(
                                //   title: Padding(
                                //     padding: const EdgeInsets.only(bottom: 4.0),
                                //     child: Text(
                                //       title,
                                //       style: const TextStyle(
                                //         fontSize: 20,
                                //       ),
                                //     ),
                                //   ),
                                //   subtitle: Text('Written by $author'),
                                //   leading: Container(
                                //     decoration: BoxDecoration(
                                //       color: Palette.greyLight,
                                //       borderRadius: BorderRadius.circular(8),
                                //       border: Border.all(
                                //         color: Palette.greyDark,
                                //         width: 2,
                                //       ),
                                //     ),
                                //     child: FutureBuilder<Uint8List>(
                                //         future: _storageClient.getCoverImage(
                                //           imageID: coverId,
                                //         ),
                                //         builder: (context, snapshot) {
                                //           return snapshot.hasData &&
                                //                   snapshot.data != null
                                //               ? ClipRRect(
                                //                   borderRadius:
                                //                       BorderRadius.circular(8),
                                //                   child: Image.memory(
                                //                     snapshot.data!,
                                //                     height: 100,
                                //                   ),
                                //                 )
                                //               : const SizedBox();
                                //         }),
                                //   ),
                                // ),
                                );
                          },
                        ),
                      ),
                    )
              : Expanded(
                  child: Column(
                    children: [
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Palette.greyDark,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
