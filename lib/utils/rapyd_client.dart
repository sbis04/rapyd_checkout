import 'dart:convert';
import 'dart:math';

import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:slibro/application/models/payment_status.dart';

import '../application/models/card_payment.dart';
import '../application/models/checkout.dart';
import '../application/models/customer.dart';
import '../secrets.dart';

class RapydClient {
  final _baseURL = 'https://sandboxapi.rapyd.net';
  final _accessKey = Secrets.rapydAccessKey;
  final _secretKey = Secrets.rapydSecretKey;

  String _generateSalt() {
    final random = Random.secure();
    // Generate 16 characters for salt by generating 16 random bytes
    // and encoding it.
    final randomBytes = List<int>.generate(16, (index) => random.nextInt(256));
    return base64UrlEncode(randomBytes);
  }

  Map<String, String> _generateHeader({
    required String method,
    required String endpoint,
    String body = '',
  }) {
    int unixTimestamp = DateTime.now().millisecondsSinceEpoch;
    String timestamp = (unixTimestamp / 1000).round().toString();

    var salt = _generateSalt();

    var toSign =
        method + endpoint + salt + timestamp + _accessKey + _secretKey + body;

    var keyEncoded = ascii.encode(_secretKey);
    var toSignEncoded = ascii.encode(toSign);

    var hmacSha256 = Hmac(sha256, keyEncoded); // HMAC-SHA256
    var digest = hmacSha256.convert(toSignEncoded);
    var ss = hex.encode(digest.bytes);
    var tt = ss.codeUnits;
    var signature = base64.encode(tt);

    var headers = {
      'Content-Type': 'application/json',
      'access_key': _accessKey,
      'salt': salt,
      'timestamp': timestamp,
      'signature': signature,
    };

    return headers;
  }

  Future<Checkout?> createCheckout({
    required String amount,
    required String currency,
    required String countryCode,
    required String customerId,
    required String orderNumber,
    String? completePaymentURL,
    String? errorPaymentURL,
    String? merchantReferenceId,
    List<String>? paymentMethods,
    bool useCardholdersPreferredCurrency = true,
    String languageCode = 'en',
  }) async {
    Checkout? checkoutDetails;

    var method = "post";
    var checkoutEndpoint = '/v1/checkout';

    final checkoutURL = Uri.parse(_baseURL + checkoutEndpoint);

    var data = jsonEncode({
      "amount": amount,
      "complete_payment_url": completePaymentURL,
      "country": countryCode,
      "currency": currency,
      "error_payment_url": errorPaymentURL,
      "merchant_reference_id": merchantReferenceId,
      "cardholder_preferred_currency": useCardholdersPreferredCurrency,
      "language": languageCode,
      "metadata": {
        "merchant_defined": true,
        "sales_order": orderNumber,
      },
      "payment_method_types_include": paymentMethods,
      "customer": customerId,
    });

    final headers = _generateHeader(
      method: method,
      endpoint: checkoutEndpoint,
      body: data,
    );

    try {
      var response = await http.post(
        checkoutURL,
        headers: headers,
        body: data,
      );

      // FOR TESTING >>
      // print(response.body);

      if (response.statusCode == 200) {
        print('SUCCESSFULLY CHECKOUT');
        checkoutDetails = Checkout.fromJson(jsonDecode(response.body));
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Failed to generate the checkout');
    }

    return checkoutDetails;
  }

  Future<PaymentStatus?> retrieveCheckout({required String checkoutId}) async {
    PaymentStatus? paymentStatus;

    var method = "get";
    var checkoutEndpoint = '/v1/checkout/$checkoutId';

    final checkoutURL = Uri.parse(_baseURL + checkoutEndpoint);

    final headers = _generateHeader(
      method: method,
      endpoint: checkoutEndpoint,
    );

    try {
      var response = await http.get(checkoutURL, headers: headers);

      print(response.body);

      if (response.statusCode == 200) {
        print('Checkout retrieved successfully!');
        paymentStatus = PaymentStatus.fromJson(jsonDecode(response.body));
      } else {
        print(response.statusCode);
      }
    } catch (_) {
      print('Failed to retrieve checkout');
    }

    return paymentStatus;
  }

  Future<Customer?> createNewCustomer({
    required String email,
    required String name,
  }) async {
    Customer? customerDetails;

    var method = "post";
    var checkoutEndpoint = '/v1/customers';

    final checkoutURL = Uri.parse(_baseURL + checkoutEndpoint);

    var data = jsonEncode({
      "email": email,
      "name": name,
      "metadata": {
        "merchant_defined": true,
      },
    });

    final headers = _generateHeader(
      method: method,
      endpoint: checkoutEndpoint,
      body: data,
    );

    try {
      var response = await http.post(
        checkoutURL,
        headers: headers,
        body: data,
      );

      // FOR TESTING >>
      // print(response.body);

      if (response.statusCode == 200) {
        print('CUSTOMER SUCCESSFULLY CREATED');
        customerDetails = Customer.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Failed to create a customer');
    }

    return customerDetails;
  }

  Future<CardPayment?> addPaymentMethodToCustomer({
    required String customerId,
    required String type,
    required String number,
    required String expirationMonth,
    required String expirationYear,
    required String cvv,
    required String cardHoldersName,
  }) async {
    CardPayment? cardDetails;

    var method = "post";
    var checkoutEndpoint = '/v1/customers/$customerId/payment_methods';

    final checkoutURL = Uri.parse(_baseURL + checkoutEndpoint);

    var data = jsonEncode({
      "type": type,
      "fields": {
        "number": number,
        "expiration_month": expirationMonth,
        "expiration_year": expirationYear,
        "cvv": cvv,
        "name": cardHoldersName,
      },
      "metadata": {
        "merchant_defined": true,
      },
    });

    final headers = _generateHeader(
      method: method,
      endpoint: checkoutEndpoint,
      body: data,
    );

    try {
      var response = await http.post(
        checkoutURL,
        headers: headers,
        body: data,
      );

      // FOR TESTING >>
      // print(response.body);

      if (response.statusCode == 200) {
        print('PAYMENT METHOD SUCCESSFULLY ADDED');
        cardDetails = CardPayment.fromJson(jsonDecode(response.body));
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Failed to create the payment method');
    }

    return cardDetails;
  }

  // Future<Wallet?> getWalletDetails({required String walletID}) async {
  //   Wallet? retrievedWallet;

  //   var method = "get";
  //   var walletEndpoint = '/v1/user/$walletID';

  //   final walletURL = Uri.parse(_baseURL + walletEndpoint);

  //   final headers = _generateHeader(
  //     method: method,
  //     endpoint: walletEndpoint,
  //   );

  //   try {
  //     var response = await http.get(walletURL, headers: headers);

  //     print(response.body);

  //     if (response.statusCode == 200) {
  //       print('Wallet retrieved successfully!');
  //       retrievedWallet = Wallet.fromJson(jsonDecode(response.body));
  //     }
  //   } catch (_) {
  //     print('Failed to retrieve wallet');
  //   }

  //   return retrievedWallet;
  // }

  // Future<Transfer?> transferMoney({
  //   required String sourceWallet,
  //   required String destinationWallet,
  //   required int amount,
  // }) async {
  //   Transfer? transferDetails;

  //   var method = "post";
  //   var transferEndpoint = '/v1/account/transfer';

  //   final transferURL = Uri.parse(_baseURL + transferEndpoint);

  //   var data = jsonEncode({
  //     "source_ewallet": sourceWallet,
  //     "amount": amount,
  //     "currency": "USD",
  //     "destination_ewallet": destinationWallet,
  //   });

  //   final headers = _generateHeader(
  //     method: method,
  //     endpoint: transferEndpoint,
  //     body: data,
  //   );

  //   try {
  //     var response = await http.post(
  //       transferURL,
  //       headers: headers,
  //       body: data,
  //     );

  //     print(response.body);

  //     if (response.statusCode == 200) {
  //       print('SUCCESSFULLY TRANSFERED');
  //       transferDetails = Transfer.fromJson(jsonDecode(response.body));
  //     }
  //   } catch (e) {
  //     print('Failed to transfer amount');
  //   }

  //   return transferDetails;
  // }

  // Future<Transfer?> transferResponse({
  //   required String id,
  //   required String response,
  // }) async {
  //   Transfer? transferDetails;

  //   var method = "post";
  //   var responseEndpoint = '/v1/account/transfer/response';

  //   final responseURL = Uri.parse(_baseURL + responseEndpoint);

  //   var data = jsonEncode({
  //     "id": id,
  //     "status": response,
  //   });

  //   final headers = _generateHeader(
  //     method: method,
  //     endpoint: responseEndpoint,
  //     body: data,
  //   );

  //   try {
  //     var response = await http.post(
  //       responseURL,
  //       headers: headers,
  //       body: data,
  //     );

  //     print(response.body);

  //     if (response.statusCode == 200) {
  //       print('TRANSFER STATUS UPDATED: $response');
  //       transferDetails = Transfer.fromJson(jsonDecode(response.body));
  //     }
  //   } catch (e) {
  //     print('Failed to update transfer status');
  //   }

  //   return transferDetails;
  // }
}
