import 'dart:developer';
import 'dart:io';

import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slibro/application/res/palette.dart';
import 'package:slibro/presentation/screens/story_reading/reading_view.dart';
import 'package:slibro/presentation/screens/story_writing/chapter_description.dart';
import 'package:slibro/presentation/screens/story_writing/writing_view.dart';
import 'package:slibro/utils/database.dart';
import 'package:slibro/utils/storage.dart';
import 'package:slibro/utils/validators.dart';

class PublishingPage extends StatefulWidget {
  const PublishingPage({
    Key? key,
    required this.story,
    required this.user,
  }) : super(key: key);

  final models.Document story;
  final models.User user;

  @override
  State<PublishingPage> createState() => _PublishingPageState();
}

class _PublishingPageState extends State<PublishingPage> {
  final _publishingFormKey = GlobalKey<FormState>();
  late final Map<String, dynamic> _storyData;
  final DatabaseClient _databaseClient = DatabaseClient();
  final StorageClient _storageClient = StorageClient();
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _descriptionTextController;
  late final TextEditingController _priceTextController;

  late final FocusNode _descriptionFocusNode;
  late final FocusNode _priceFocusNode;

  int _selectedPriceIndex = -1;
  CroppedFile? _coverImageFile;

  @override
  void initState() {
    _storyData = widget.story.data;
    _descriptionTextController = TextEditingController();
    _priceTextController = TextEditingController();

    _descriptionFocusNode = FocusNode();
    _priceFocusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // log(widget.story.data.toString());
    return GestureDetector(
      onTap: () {
        _descriptionFocusNode.unfocus();
        _priceFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Palette.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Palette.white,
          iconTheme: const IconThemeData(
            color: Palette.black,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _publishingFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _storyData['title'],
                      // 'Story title is this here',
                      style: const TextStyle(
                        color: Palette.black,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionTextController,
                      focusNode: _descriptionFocusNode,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Palette.black,
                      ),
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.name,
                      cursorColor: Palette.greyMedium,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Palette.black,
                            width: 3,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Palette.black.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        hintText: 'Enter story description',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Palette.black.withOpacity(0.5),
                        ),
                      ),
                      validator: (value) => Validators.validateDescription(
                        name: value,
                      ),
                      // onChanged: (value) => widget.onChange(value),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () async {
                              final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery,
                              );

                              if (image != null) {
                                CroppedFile? croppedFile =
                                    await ImageCropper().cropImage(
                                  sourcePath: image.path,
                                  aspectRatio: const CropAspectRatio(
                                    ratioX: 1,
                                    ratioY: 1.5,
                                  ),
                                  uiSettings: [
                                    AndroidUiSettings(
                                      toolbarTitle: 'Cover Image',
                                      toolbarColor: Palette.black,
                                      toolbarWidgetColor: Colors.white,
                                      initAspectRatio:
                                          CropAspectRatioPreset.original,
                                      lockAspectRatio: true,
                                      activeControlsWidgetColor: Palette.black,
                                      hideBottomControls: true,
                                    ),
                                    IOSUiSettings(
                                      title: 'Cropper',
                                    ),
                                  ],
                                );

                                if (croppedFile != null) {
                                  setState(() {
                                    _coverImageFile = croppedFile;
                                  });
                                }
                              }
                            },
                            child: _coverImageFile != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Palette.greyLight,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Palette.greyDark,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_coverImageFile!.path),
                                      ),
                                    ),
                                  )
                                : AspectRatio(
                                    aspectRatio: 1 / 1.5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Palette.greyLight,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Palette.greyDark,
                                          width: 2,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Add cover image',
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 8),
                                            Icon(Icons.add_circle_outline),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Aspect Ratio',
                                style: TextStyle(
                                  color: Palette.greyMedium,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '1.5 : 1',
                                style: TextStyle(
                                  color: Palette.greyDark,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Resolution (recommended)',
                                style: TextStyle(
                                  color: Palette.greyMedium,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '1200 x 800 pixels',
                                style: TextStyle(
                                  color: Palette.greyDark,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Price',
                      style: TextStyle(
                        color: Palette.greyDark,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _selectedPriceIndex,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedPriceIndex = value!;
                            });
                          },
                          activeColor: Palette.black,
                        ),
                        const Text(
                          'Free',
                          style: TextStyle(
                            color: Palette.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _selectedPriceIndex,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedPriceIndex = value!;
                            });
                          },
                          activeColor: Palette.black,
                        ),
                        const Text(
                          'Paid',
                          style: TextStyle(
                            color: Palette.black,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    _selectedPriceIndex == 2
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextFormField(
                              controller: _priceTextController,
                              focusNode: _priceFocusNode,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Palette.black,
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              cursorColor: Palette.greyMedium,
                              decoration: InputDecoration(
                                prefix: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    '\$',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Palette.greyMedium,
                                    ),
                                  ),
                                ),
                                border: const UnderlineInputBorder(),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Palette.black,
                                    width: 3,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Palette.black.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                hintText: 'Enter selling price of the book',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Palette.black.withOpacity(0.5),
                                ),
                              ),
                              validator: _selectedPriceIndex == 2
                                  ? (value) => Validators.validatePrice(
                                        name: value,
                                      )
                                  : null,
                              // onChanged: (value) => widget.onChange(value),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Palette.black,
                        ),
                        onPressed: () async {
                          if (_publishingFormKey.currentState!.validate()) {
                            if (_coverImageFile != null) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Dialog(
                                  backgroundColor: Palette.black,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 30,
                                    ),
                                    child: SizedBox(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            'Publishing...',
                                            style: TextStyle(
                                              color: Palette.white,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Palette.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );

                              final coverImage =
                                  await _storageClient.storeCoverImage(
                                filePath: _coverImageFile!.path,
                                fileName:
                                    '${_storyData['title']}_${DateTime.now().millisecondsSinceEpoch}.${_coverImageFile!.path.split('.').last}',
                              );

                              final publishedStory =
                                  await _databaseClient.uploadPublishingDetails(
                                documentID: widget.story.$id,
                                coverImageID: coverImage.$id,
                                storyDescription:
                                    _descriptionTextController.text,
                                isPaid: _selectedPriceIndex == 1 ? false : true,
                                price: _priceTextController.text.isNotEmpty
                                    ? double.parse(_priceTextController.text)
                                    : null,
                              );
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: const Text(
                          'Publish',
                          style: TextStyle(
                            color: Palette.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
