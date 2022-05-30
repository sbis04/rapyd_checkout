import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rapyd/models/models.dart';
import 'package:rive/rive.dart';
import 'package:slibro/application/models/checkout.dart';
import 'package:slibro/application/models/payment_status.dart';
import 'package:slibro/application/res/palette.dart';
import 'package:slibro/main.dart';
import 'package:slibro/utils/database.dart';
import 'package:slibro/utils/invoice_generator.dart';
import 'package:slibro/utils/rapyd_client.dart';
import 'package:slibro/utils/sendgrid_client.dart';

class PaymentCompletePage extends StatefulWidget {
  const PaymentCompletePage({
    Key? key,
    required this.paymentStatus,
    required this.user,
    required this.stories,
    required this.checkoutId,
  }) : super(key: key);

  final String paymentStatus;
  final User user;
  final List<Document> stories;
  final String checkoutId;

  @override
  State<PaymentCompletePage> createState() => _PaymentCompletePageState();
}

class _PaymentCompletePageState extends State<PaymentCompletePage> {
  final DatabaseClient _databaseClient = DatabaseClient();
  // final RapydClient _rapydClient = RapydClient();
  final SendGridClient _sendGridClient = SendGridClient();

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  /// Message that displays when state has changed
  String transactionMessage = '';

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _checkTrigger;
  SMIInput<bool>? _errorTrigger;
  PaymentData? paymentInfo;

  Timer? _timer;
  int _start = 10;
  Uint8List? pdfBytes;

  String? _paymentStatus;
  List<Product> _products = [];

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          Navigator.of(context).pop();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

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
      double price = widget.stories[i].data['price'];

      _products.add(Product(title, price, 1));

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

  retrieveCheckout() async {
    PaymentStatus? paymentStatus;

    try {
      paymentStatus = await rapydClient.retrieveCheckout(
        checkoutId: widget.checkoutId,
      );
    } catch (e) {
      log(e.toString());
    }

    if (paymentStatus != null) {
      log('CHECKOUT ID: ${paymentStatus.data.id}');
      setState(() {
        paymentInfo = paymentStatus!.data.payment;
      });

      await addToPurchased();

      pdfBytes = await generateInvoice(
        invoiceNumber: paymentInfo!.metadata.salesOrder,
        taxFraction: 0.12,
        products: _products,
        paymentData: paymentInfo!,
      );

      startTimer();

      if (pdfBytes != null) {
        String pdfString = base64Encode(pdfBytes!);

        _sendGridClient.sendEmail2(
          fileContent: pdfString,
          fileName: paymentInfo!.metadata.salesOrder,
          toEmail: widget.user.email,
        );
      }
    } else {
      setState(() {
        _paymentStatus = 'failed';
      });
    }
  }

  @override
  void initState() {
    _paymentStatus = widget.paymentStatus;

    log('PAYMENT STATUS: $_paymentStatus');

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

        await retrieveCheckout();

        if (_paymentStatus == 'success') {
          _checkTrigger?.value = true;
          setState(() {});
          log('inside success');
        } else {
          await Future.delayed(const Duration(seconds: 1));
          _errorTrigger?.value = true;
          setState(() {});
          await Future.delayed(const Duration(seconds: 3));
          Navigator.of(context).pop();
          log('inside failed');
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: paymentInfo != null
                        ? InkWell(
                            onTap: () async {
                              _timer?.cancel();

                              await FileSaver.instance.saveAs(
                                paymentInfo!.metadata.salesOrder,
                                pdfBytes!,
                                'pdf',
                                MimeType.PDF,
                              );

                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                border: Border.all(
                                  color: Palette.blackLight,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Invoice ${paymentInfo!.metadata.salesOrder}',
                                    ),
                                    const SizedBox(width: 16),
                                    Container(
                                      height: 30,
                                      width: 2,
                                      color: Palette.black,
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.download),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(height: 50),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: paymentInfo != null
                        ? Text(
                            'Redirecting in $_start seconds',
                            style: const TextStyle(
                              color: Palette.greyDark,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
    );
  }
}
