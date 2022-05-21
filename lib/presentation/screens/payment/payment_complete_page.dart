import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:slibro/application/res/palette.dart';
import 'package:slibro/main.dart';
import 'package:slibro/utils/database.dart';

class PaymentCompletePage extends StatefulWidget {
  const PaymentCompletePage({
    Key? key,
    required this.paymentStatus,
    required this.user,
    required this.stories,
  }) : super(key: key);

  final String paymentStatus;
  final User user;
  final List<Document> stories;

  @override
  State<PaymentCompletePage> createState() => _PaymentCompletePageState();
}

class _PaymentCompletePageState extends State<PaymentCompletePage> {
  final DatabaseClient _databaseClient = DatabaseClient();

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  /// Message that displays when state has changed
  String transactionMessage = '';

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _checkTrigger;
  SMIInput<bool>? _errorTrigger;

  late final String _paymentStatus;

  Future<void> addToPurchased() async {
    Account account = Account(client);
    final prefs = await account.getPrefs();

    List<String> cartItems = List<String>.from(prefs.data['in_cart']);
    List<String>? purchasedItems = prefs.data['purchased'] != null
        ? List<String>.from(prefs.data['purchased'])
        : null;

    if (purchasedItems != null) {
      purchasedItems.addAll(cartItems);
    } else {
      purchasedItems = cartItems;
    }

    Map<String, dynamic> retrievedPrefs = prefs.data;

    retrievedPrefs.remove('in_cart');
    retrievedPrefs.putIfAbsent(
      'purchased',
      () => purchasedItems,
    );

    await account.updatePrefs(
      prefs: retrievedPrefs,
    );

    for (int i = 0; i < widget.stories.length; i++) {
      String title = widget.stories[i].data['title'];
      String description = widget.stories[i].data['description'];
      String author = widget.stories[i].data['author'];
      bool isShort = widget.stories[i].data['is_short'];
      List<String> chapters =
          List<String>.from(widget.stories[i].data['chapters']);
      String imageId = widget.stories[i].data['cover'];

      await _databaseClient.addStoryToPublished(
        user: widget.user,
        storyName: title,
        storyAuthor: author,
        storyDescription: description,
        isShort: isShort,
        chapters: chapters,
        coverImageId: imageId,
      );
    }
  }

  @override
  void initState() {
    _paymentStatus = widget.paymentStatus;
    // if (paymentStatus == 'success') {
    //   _controller = SimpleAnimation('Check');
    // } else {
    //   _controller = SimpleAnimation('Err');
    // }

    rootBundle.load('assets/rive/check_error.riv').then(
      (data) async {
        final file = RiveFile.import(data);

        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(
          artboard,
          'State Machine 1',
          onStateChange: _onStateChange,
        );
        if (controller != null) {
          artboard.addController(controller);
          _checkTrigger = controller.findInput('Check');
          _errorTrigger = controller.findInput('Error');
        }
        setState(() => _riveArtboard = artboard);
        // await Future.delayed(const Duration(seconds: 1));
        await addToPurchased();

        if (_paymentStatus == 'success') {
          _checkTrigger?.value = true;
        } else {
          _errorTrigger?.value = true;
        }

        await Future.delayed(
          const Duration(seconds: 3),
        );

        Navigator.of(context).pop();
      },
    );

    super.initState();
  }

  /// Do something when the state machine changes state
  void _onStateChange(String stateMachineName, String stateName) {
    log(stateName);
    setState(() {
      if (stateName == 'Check') {
        transactionMessage = 'Transaction successful';
      } else if (stateName == 'Err') {
        transactionMessage = 'Transaction failed';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: _riveArtboard == null
          ? const SizedBox()
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200,
                    child: Rive(
                      artboard: _riveArtboard!,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transactionMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Palette.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
