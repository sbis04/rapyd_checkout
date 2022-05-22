import 'dart:developer';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slibro/application/res/palette.dart';
import 'package:slibro/main.dart';
import 'package:slibro/presentation/screens/story_writing/chapter_view.dart';
import 'package:slibro/utils/database.dart';
import 'package:slibro/utils/storage.dart';

class MyStoryView extends StatefulWidget {
  const MyStoryView({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<MyStoryView> createState() => _MyStoryViewState();
}

class _MyStoryViewState extends State<MyStoryView> {
  final DatabaseClient _databaseClient = DatabaseClient();
  final StorageClient _storageClient = StorageClient();
  List<Document>? _myStories;
  List<Document>? _purchasedStories;

  _getPurchasedStories() async {
    List<Document> purchasedStories = [];
    final stories = await _databaseClient.getPurchasedStories();

    for (int i = 0; i < stories.documents.length; i++) {
      final storyData = stories.documents[i].data;

      if (storyData['uid'] == widget.user.$id) {
        purchasedStories.add(stories.documents[i]);
      }
    }
    if (mounted) {
      setState(() {
        _purchasedStories = purchasedStories.reversed.toList();
      });
    }
  }

  _getMyStories() async {
    List<Document> myStories = [];
    final stories = await _databaseClient.getStories();

    for (int i = 0; i < stories.documents.length; i++) {
      final storyData = stories.documents[i].data;

      if (storyData['uid'] == widget.user.$id) {
        myStories.add(stories.documents[i]);
      }
    }
    if (mounted) {
      setState(() {
        _myStories = myStories.reversed.toList();
      });
    }
  }

  @override
  void initState() {
    _getPurchasedStories();
    _getMyStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Stories',
            style: TextStyle(
              color: Palette.black,
              fontSize: 36.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _purchasedStories != null
              ? _purchasedStories!.isEmpty
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'PURCHASED',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Palette.greyDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 370,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: _purchasedStories!.length,
                            itemBuilder: (context, index) {
                              final List<Document> retrievedStories =
                                  _purchasedStories!;
                              log(retrievedStories.length.toString());

                              final storyData = retrievedStories[index].data;
                              final String title = storyData['title'];
                              final String author = storyData['author'];
                              final String coverId = storyData['cover'];
                              final String description =
                                  storyData['description'];
                              // final bool isPaid = storyData['paid'];
                              // final double? price = storyData['price'];

                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChapterViewScreen(
                                          story: retrievedStories[index],
                                          user: widget.user,
                                          isPurchased: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 210,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 210 * 1.5,
                                          width: 210,
                                          decoration: BoxDecoration(
                                            color: Palette.greyLight,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Palette.greyDark,
                                              width: 2,
                                            ),
                                          ),
                                          child: FutureBuilder<Uint8List>(
                                            future:
                                                _storageClient.getCoverImage(
                                              imageID: coverId,
                                            ),
                                            builder: (context, snapshot) {
                                              return snapshot.hasData &&
                                                      snapshot.data != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      child: Image.memory(
                                                        snapshot.data!,
                                                      ),
                                                    )
                                                  : const SizedBox();
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          title,
                                          // 'Checking if a long story title is present',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            letterSpacing: 0,
                                            color: Palette.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Written by $author',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Palette.greyDark,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(width: 16),
                                  // Expanded(
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: [
                                  //       Text(
                                  //         title,
                                  //         // 'Checking if a long story title is present',
                                  //         maxLines: 2,
                                  //         overflow: TextOverflow.ellipsis,
                                  //         style: const TextStyle(
                                  //           fontSize: 18,
                                  //           color: Palette.black,
                                  //         ),
                                  //       ),
                                  //       const SizedBox(height: 4.0),
                                  //       Text(
                                  //         'Written by $author',
                                  //         maxLines: 1,
                                  //         overflow: TextOverflow.ellipsis,
                                  //         style: const TextStyle(
                                  //           color: Palette.greyMedium,
                                  //           fontSize: 12,
                                  //         ),
                                  //       ),
                                  //       const SizedBox(height: 4.0),
                                  //       Text(
                                  //         description,
                                  //         maxLines: 2,
                                  //         overflow: TextOverflow.ellipsis,
                                  //         style: const TextStyle(
                                  //           color: Palette.greyDark,
                                  //           fontSize: 12,
                                  //           letterSpacing: 0,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // )
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
              : const SizedBox(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'WRITTEN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Palette.greyDark,
                ),
              ),
              _myStories == null
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Palette.greyDark,
                        ),
                        strokeWidth: 2,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 8),
          _myStories != null
              ? _myStories!.isEmpty
                  ? const Text(
                      'You haven\'t yet written any stories. Please tap on the add button to start writing stories.',
                      style: TextStyle(
                        color: Palette.greyMedium,
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        color: Palette.black,
                        onRefresh: () => _getMyStories(),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemCount: _myStories!.length,
                          itemBuilder: (context, index) {
                            final List<Document> retrievedStories = _myStories!;
                            log(retrievedStories.length.toString());

                            final storyData = retrievedStories[index].data;
                            final String title = storyData['title'];
                            final String author = storyData['author'];

                            return InkWell(
                              onTap: () async {
                                final List<String>? isDeleted =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChapterViewScreen(
                                      story: retrievedStories[index],
                                      user: widget.user,
                                    ),
                                  ),
                                );

                                if (isDeleted != null &&
                                    isDeleted.first == 'delete') {
                                  _getMyStories();
                                } else {
                                  log('just came back');
                                }
                              },
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                subtitle: Text('Written by $author'),
                              ),
                            );
                          },
                        ),
                      ),
                    )
              : const SizedBox(),
        ],
      ),
    );
  }
}
