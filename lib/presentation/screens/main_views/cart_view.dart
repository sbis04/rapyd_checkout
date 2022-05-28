import 'dart:developer';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:slibro/application/res/palette.dart';
import 'package:slibro/main.dart';
import 'package:slibro/presentation/screens/payment/checkout_page.dart';
import 'package:slibro/utils/database.dart';
import 'package:slibro/utils/rapyd_client.dart';
import 'package:slibro/utils/storage.dart';
import 'package:slibro/utils/user_client.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final DatabaseClient _databaseClient = DatabaseClient();
  final StorageClient _storageClient = StorageClient();
  final UserClient _userClient = UserClient();

  List<Document>? _stories;
  String _addedPrice = '';
  double _taxFraction = 0.12;
  String _taxAmount = '';
  String _totalPrice = '';

  _getStoriesInCart() async {
    final itemsInCart = await _userClient.getItemsInCart();

    if (itemsInCart != null) {
      List<Document> inCartStories = [];
      double addedPrice = 0.00;

      final stories = await _databaseClient.getStories();

      for (int i = 0; i < stories.documents.length; i++) {
        final storyId = stories.documents[i].$id;
        final storyData = stories.documents[i].data;

        if (storyData['published'] == true && itemsInCart.contains(storyId)) {
          double price = storyData['price'];
          addedPrice += price;

          inCartStories.add(stories.documents[i]);
        }
      }

      double taxAmount = addedPrice * _taxFraction;
      double totalPrice = addedPrice + taxAmount;

      setState(() {
        _addedPrice = addedPrice.toString();
        _taxAmount = taxAmount.toStringAsFixed(2);
        _totalPrice = totalPrice.toStringAsFixed(2);
        _stories = inCartStories;
      });
    } else {
      setState(() {
        _stories = [];
      });
    }
  }

  @override
  void initState() {
    _getStoriesInCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cart',
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
                                  Text('Cart is empty'),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        )
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => _getStoriesInCart(),
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: _stories!.length,
                              itemBuilder: (context, index) {
                                final List<Document> retrievedStories =
                                    _stories!;
                                log(retrievedStories.length.toString());

                                final storyData = retrievedStories[index].data;
                                final String title = storyData['title'];
                                final String author = storyData['author'];
                                final String coverId = storyData['cover'];
                                final String description =
                                    storyData['description'];
                                final bool isPaid = storyData['paid'];
                                final double? price = storyData['price'];

                                return Row(
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
        ),
        _stories != null && _stories!.isNotEmpty
            ? PayBar(
                user: widget.user,
                stories: _stories!,
                totalPrice: _totalPrice,
                addedPrice: _addedPrice,
                taxPercentage: (_taxFraction * 100).toStringAsFixed(0),
                taxAmount: _taxAmount,
                onReturn: () async {
                  await _getStoriesInCart();
                },
              )
            : const SizedBox(),
      ],
    );
  }
}

class PayBar extends StatefulWidget {
  const PayBar({
    Key? key,
    required this.user,
    required this.stories,
    required String totalPrice,
    required String addedPrice,
    required String taxPercentage,
    required String taxAmount,
    required this.onReturn,
  })  : _totalPrice = totalPrice,
        _addedPrice = addedPrice,
        _taxPercentage = taxPercentage,
        _taxAmount = taxAmount,
        super(key: key);

  final User user;
  final List<Document> stories;
  final String _totalPrice;
  final String _addedPrice;
  final String _taxPercentage;
  final String _taxAmount;
  final Function() onReturn;

  @override
  State<PayBar> createState() => _PayBarState();
}

class _PayBarState extends State<PayBar> {
  final RapydClient _rapydClient = RapydClient();

  bool _isShowMoreTapped = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: () {
              setState(() {
                _isShowMoreTapped = !_isShowMoreTapped;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                bottom: 80.0,
              ),
              child: Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  color: Palette.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: _isShowMoreTapped
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Show less',
                                    style: TextStyle(
                                      color: Palette.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Palette.white,
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Palette.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '\$${widget._addedPrice}',
                                    style: const TextStyle(
                                      color: Palette.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tax (${widget._taxPercentage}%)',
                                    style: const TextStyle(
                                      color: Palette.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '+ \$${widget._taxAmount}',
                                    style: const TextStyle(
                                      color: Palette.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      color: Palette.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '= \$${widget._totalPrice}',
                                    style: const TextStyle(
                                      color: Palette.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Show more',
                                    style: TextStyle(
                                      color: Palette.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_up,
                                    color: Palette.white,
                                  )
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total Price',
                          style: TextStyle(
                            color: Palette.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '\$${widget._totalPrice}',
                          style: const TextStyle(
                            color: Palette.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Container(
                      height: 60,
                      width: 2,
                      color: Palette.white.withOpacity(0.5),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade900,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36.0,
                          vertical: 10.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isProcessing = true;
                        });

                        Account account = Account(client);
                        final prefs = await account.getPrefs();
                        final String customerId = prefs.data['customer_id'];

                        final currentTime =
                            DateTime.now().millisecondsSinceEpoch;
                        final orderNumber = 'SLI$currentTime';

                        final checkout = await _rapydClient.createCheckout(
                          amount: widget._totalPrice,
                          currency: 'USD',
                          countryCode: 'US',
                          customerId: customerId,
                          // completePaymentURL: 'http://example.com/complete',
                          // errorPaymentURL: 'http://example.com/error',
                          orderNumber: orderNumber,
                          merchantReferenceId:
                              '$customerId-${DateTime.now().millisecondsSinceEpoch}',
                          useCardholdersPreferredCurrency: true,
                          languageCode: 'en',
                          paymentMethods: [
                            'us_mastercard_card',
                            'us_visa_card'
                          ],
                        );
                        setState(() {
                          _isProcessing = false;
                        });

                        if (checkout != null) {
                          log('CHECKOUT ID: ${checkout.data.id}');

                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CheckoutPage(
                                checkoutId: checkout.data.id!,
                                stories: widget.stories,
                                user: widget.user,
                                onDone: () {
                                  widget.onReturn();
                                },
                              ),
                            ),
                          );
                        }
                      },
                      child: _isProcessing
                          ? const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Palette.white,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Pay'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
