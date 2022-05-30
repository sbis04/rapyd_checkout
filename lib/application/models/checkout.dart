/**
 * --------------------------------------------------------------
 * 
 * These model classes have been shifted to the Rapyd Flutter SDK
 * Here's the link to the package: https://pub.dev/packages/rapyd
 * 
 * --------------------------------------------------------------
 */

// // To parse this JSON data, do
// //
// //     final checkout = checkoutFromJson(jsonString);

// import 'dart:convert';

// class Checkout {
//   Checkout({
//     required this.status,
//     required this.data,
//   });

//   final Status status;
//   final Data data;

//   factory Checkout.fromRawJson(String str) =>
//       Checkout.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Checkout.fromJson(Map<String, dynamic> json) => Checkout(
//         status: Status.fromJson(json["status"]),
//         data: Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status.toJson(),
//         "data": data.toJson(),
//       };
// }

// class Data {
//   Data({
//     required this.id,
//     required this.status,
//     required this.language,
//     required this.merchantWebsite,
//     required this.pageExpiration,
//     required this.redirectUrl,
//     required this.country,
//     required this.currency,
//     required this.amount,
//     required this.payment,
//     required this.paymentMethodType,
//     required this.paymentMethodTypeCategories,
//     required this.paymentMethodTypesInclude,
//     required this.paymentMethodTypesExclude,
//     required this.customer,
//     required this.timestamp,
//     required this.paymentExpiration,
//     required this.escrow,
//     required this.escrowReleaseDays,
//   });

//   final String? id;
//   final String? status;
//   final String? language;
//   final String? merchantWebsite;
//   final int? pageExpiration;
//   final String? redirectUrl;
//   final String? country;
//   final String? currency;
//   final double? amount;
//   final Payment payment;
//   final dynamic paymentMethodType;
//   final dynamic paymentMethodTypeCategories;
//   final List<String>? paymentMethodTypesInclude;
//   final dynamic paymentMethodTypesExclude;
//   final dynamic customer;
//   final int? timestamp;
//   final dynamic paymentExpiration;
//   final dynamic escrow;
//   final dynamic escrowReleaseDays;

//   factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         status: json["status"],
//         language: json["language"],
//         merchantWebsite: json["merchant_website"],
//         pageExpiration: json["page_expiration"],
//         redirectUrl: json["redirect_url"],
//         country: json["country"],
//         currency: json["currency"],
//         amount: json["amount"].toDouble(),
//         payment: Payment.fromJson(json["payment"]),
//         paymentMethodType: json["payment_method_type"],
//         paymentMethodTypeCategories: json["payment_method_type_categories"],
//         paymentMethodTypesInclude: List<String>.from(
//             json["payment_method_types_include"].map((x) => x)),
//         paymentMethodTypesExclude: json["payment_method_types_exclude"],
//         customer: json["customer"],
//         timestamp: json["timestamp"],
//         paymentExpiration: json["payment_expiration"],
//         escrow: json["escrow"],
//         escrowReleaseDays: json["escrow_release_days"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "status": status,
//         "language": language,
//         "merchant_website": merchantWebsite,
//         "page_expiration": pageExpiration,
//         "redirect_url": redirectUrl,
//         "country": country,
//         "currency": currency,
//         "amount": amount,
//         "payment": payment.toJson(),
//         "payment_method_type": paymentMethodType,
//         "payment_method_type_categories": paymentMethodTypeCategories,
//         "payment_method_types_include": paymentMethodTypesInclude != null
//             ? List<dynamic>.from(paymentMethodTypesInclude!.map((x) => x))
//             : null,
//         "payment_method_types_exclude": paymentMethodTypesExclude,
//         "customer": customer,
//         "timestamp": timestamp,
//         "payment_expiration": paymentExpiration,
//         "escrow": escrow,
//         "escrow_release_days": escrowReleaseDays,
//       };
// }

// class Payment {
//   Payment({
//     required this.id,
//     required this.amount,
//     required this.originalAmount,
//     required this.isPartial,
//     required this.currencyCode,
//     required this.countryCode,
//     required this.status,
//     required this.description,
//     required this.merchantReferenceId,
//     required this.customerToken,
//     required this.paymentMethod,
//     required this.paymentMethodData,
//     required this.expiration,
//     required this.captured,
//     required this.refunded,
//     required this.refundedAmount,
//     required this.receiptEmail,
//     required this.redirectUrl,
//     required this.completePaymentUrl,
//     required this.errorPaymentUrl,
//     required this.receiptNumber,
//     required this.flowType,
//     required this.address,
//     required this.statementDescriptor,
//     required this.transactionId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.metadata,
//     required this.failureCode,
//     required this.failureMessage,
//     required this.paid,
//     required this.paidAt,
//   });

//   final String? id;
//   final double? amount;
//   final int? originalAmount;
//   final bool? isPartial;
//   final String? currencyCode;
//   final String? countryCode;
//   final dynamic status;
//   final String? description;
//   final String? merchantReferenceId;
//   final dynamic customerToken;
//   final dynamic paymentMethod;
//   final PaymentMethodData? paymentMethodData;
//   final int? expiration;
//   final bool? captured;
//   final bool? refunded;
//   final int? refundedAmount;
//   final dynamic receiptEmail;
//   final dynamic redirectUrl;
//   final String? completePaymentUrl;
//   final String? errorPaymentUrl;
//   final dynamic receiptNumber;
//   final dynamic flowType;
//   final dynamic address;
//   final dynamic statementDescriptor;
//   final dynamic transactionId;
//   final int? createdAt;
//   final int? updatedAt;
//   final Metadata? metadata;
//   final dynamic failureCode;
//   final dynamic failureMessage;
//   final bool? paid;
//   final int? paidAt;

//   factory Payment.fromRawJson(String str) => Payment.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Payment.fromJson(Map<String, dynamic> json) => Payment(
//         id: json["id"],
//         amount: json["amount"].toDouble(),
//         originalAmount: json["original_amount"],
//         isPartial: json["is_partial"],
//         currencyCode: json["currency_code"],
//         countryCode: json["country_code"],
//         status: json["status"],
//         description: json["description"],
//         merchantReferenceId: json["merchant_reference_id"],
//         customerToken: json["customer_token"],
//         paymentMethod: json["payment_method"],
//         paymentMethodData:
//             PaymentMethodData.fromJson(json["payment_method_data"]),
//         expiration: json["expiration"],
//         captured: json["captured"],
//         refunded: json["refunded"],
//         refundedAmount: json["refunded_amount"],
//         receiptEmail: json["receipt_email"],
//         redirectUrl: json["redirect_url"],
//         completePaymentUrl: json["complete_payment_url"],
//         errorPaymentUrl: json["error_payment_url"],
//         receiptNumber: json["receipt_number"],
//         flowType: json["flow_type"],
//         address: json["address"],
//         statementDescriptor: json["statement_descriptor"],
//         transactionId: json["transaction_id"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//         metadata: Metadata.fromJson(json["metadata"]),
//         failureCode: json["failure_code"],
//         failureMessage: json["failure_message"],
//         paid: json["paid"],
//         paidAt: json["paid_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "amount": amount,
//         "original_amount": originalAmount,
//         "is_partial": isPartial,
//         "currency_code": currencyCode,
//         "country_code": countryCode,
//         "status": status,
//         "description": description,
//         "merchant_reference_id": merchantReferenceId,
//         "customer_token": customerToken,
//         "payment_method": paymentMethod,
//         "payment_method_data": paymentMethodData?.toJson(),
//         "expiration": expiration,
//         "captured": captured,
//         "refunded": refunded,
//         "refunded_amount": refundedAmount,
//         "receipt_email": receiptEmail,
//         "redirect_url": redirectUrl,
//         "complete_payment_url": completePaymentUrl,
//         "error_payment_url": errorPaymentUrl,
//         "receipt_number": receiptNumber,
//         "flow_type": flowType,
//         "address": address,
//         "statement_descriptor": statementDescriptor,
//         "transaction_id": transactionId,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "metadata": metadata?.toJson(),
//         "failure_code": failureCode,
//         "failure_message": failureMessage,
//         "paid": paid,
//         "paid_at": paidAt,
//       };
// }

// class Metadata {
//   Metadata({
//     required this.merchantDefined,
//   });

//   final bool merchantDefined;

//   factory Metadata.fromRawJson(String str) =>
//       Metadata.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
//         merchantDefined: json["merchant_defined"],
//       );

//   Map<String, dynamic> toJson() => {
//         "merchant_defined": merchantDefined,
//       };
// }

// class PaymentMethodData {
//   PaymentMethodData();

//   factory PaymentMethodData.fromRawJson(String str) =>
//       PaymentMethodData.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory PaymentMethodData.fromJson(Map<String, dynamic> json) =>
//       PaymentMethodData();

//   Map<String, dynamic> toJson() => {};
// }

// class Status {
//   Status({
//     required this.errorCode,
//     required this.status,
//     required this.message,
//     required this.responseCode,
//     required this.operationId,
//   });

//   final String errorCode;
//   final String status;
//   final String message;
//   final String responseCode;
//   final String operationId;

//   factory Status.fromRawJson(String str) => Status.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Status.fromJson(Map<String, dynamic> json) => Status(
//         errorCode: json["error_code"],
//         status: json["status"],
//         message: json["message"],
//         responseCode: json["response_code"],
//         operationId: json["operation_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "error_code": errorCode,
//         "status": status,
//         "message": message,
//         "response_code": responseCode,
//         "operation_id": operationId,
//       };
// }
