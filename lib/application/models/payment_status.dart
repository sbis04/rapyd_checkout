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
// //     final paymentStatus = paymentStatusFromJson(jsonString);

// import 'package:meta/meta.dart';
// import 'dart:convert';

// class PaymentStatus {
//   PaymentStatus({
//     required this.status,
//     required this.data,
//   });

//   final Status status;
//   final Data data;

//   factory PaymentStatus.fromRawJson(String str) =>
//       PaymentStatus.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory PaymentStatus.fromJson(Map<String, dynamic> json) => PaymentStatus(
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
//     required this.payment,
//     required this.customer,
//     required this.timestamp,
//   });

//   final String id;
//   final String status;
//   final String language;
//   final PaymentData payment;
//   final String customer;
//   final int timestamp;

//   factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         status: json["status"],
//         language: json["language"],
//         payment: PaymentData.fromJson(json["payment"]),
//         customer: json["customer"],
//         timestamp: json["timestamp"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "status": status,
//         "language": language,
//         "payment": payment.toJson(),
//         "customer": customer,
//         "timestamp": timestamp,
//       };
// }

// class PaymentData {
//   PaymentData({
//     required this.id,
//     required this.amount,
//     required this.isPartial,
//     required this.currencyCode,
//     required this.countryCode,
//     required this.status,
//     required this.paymentMethodData,
//     required this.metadata,
//     required this.paid,
//     required this.paidAt,
//   });

//   final String id;
//   final double amount;
//   final bool isPartial;
//   final String currencyCode;
//   final String countryCode;
//   final String status;
//   final PaymentMethodData paymentMethodData;
//   final Metadata metadata;
//   final bool paid;
//   final int paidAt;

//   factory PaymentData.fromRawJson(String str) =>
//       PaymentData.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
//         id: json["id"],
//         amount: json["amount"].toDouble(),
//         isPartial: json["is_partial"],
//         currencyCode: json["currency_code"],
//         countryCode: json["country_code"],
//         status: json["status"],
//         paymentMethodData:
//             PaymentMethodData.fromJson(json["payment_method_data"]),
//         metadata: Metadata.fromJson(json["metadata"]),
//         paid: json["paid"],
//         paidAt: json["paid_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "amount": amount,
//         "is_partial": isPartial,
//         "currency_code": currencyCode,
//         "country_code": countryCode,
//         "status": status,
//         "payment_method_data": paymentMethodData.toJson(),
//         "metadata": metadata.toJson(),
//         "paid": paid,
//         "paid_at": paidAt,
//       };
// }

// class Metadata {
//   Metadata({
//     required this.salesOrder,
//     required this.merchantDefined,
//   });

//   final String salesOrder;
//   final bool merchantDefined;

//   factory Metadata.fromRawJson(String str) =>
//       Metadata.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
//         salesOrder: json["sales_order"],
//         merchantDefined: json["merchant_defined"],
//       );

//   Map<String, dynamic> toJson() => {
//         "sales_order": salesOrder,
//         "merchant_defined": merchantDefined,
//       };
// }

// class PaymentMethodData {
//   PaymentMethodData({
//     required this.id,
//     required this.type,
//     required this.address,
//     required this.name,
//     required this.last4,
//     required this.expirationYear,
//     required this.expirationMonth,
//     required this.fingerprintToken,
//   });

//   final String id;
//   final String type;
//   final Address address;
//   final String name;
//   final String last4;
//   final String expirationYear;
//   final String expirationMonth;
//   final String fingerprintToken;

//   factory PaymentMethodData.fromRawJson(String str) =>
//       PaymentMethodData.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory PaymentMethodData.fromJson(Map<String, dynamic> json) =>
//       PaymentMethodData(
//         id: json["id"],
//         type: json["type"],
//         address: Address.fromJson(json["address"]),
//         name: json["name"],
//         last4: json["last4"],
//         expirationYear: json["expiration_year"],
//         expirationMonth: json["expiration_month"],
//         fingerprintToken: json["fingerprint_token"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "type": type,
//         "address": address.toJson(),
//         "name": name,
//         "last4": last4,
//         "expiration_year": expirationYear,
//         "expiration_month": expirationMonth,
//         "fingerprint_token": fingerprintToken,
//       };
// }

// class Address {
//   Address({
//     required this.id,
//     required this.name,
//     required this.line1,
//     required this.line2,
//     required this.city,
//     required this.state,
//     required this.country,
//     required this.zip,
//     required this.phoneNumber,
//     required this.createdAt,
//   });

//   final String id;
//   final String name;
//   final String line1;
//   final String? line2;
//   final String city;
//   final String state;
//   final String country;
//   final String zip;
//   final dynamic phoneNumber;
//   final int createdAt;

//   factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Address.fromJson(Map<String, dynamic> json) => Address(
//         id: json["id"],
//         name: json["name"],
//         line1: json["line_1"],
//         line2: json["line_2"],
//         city: json["city"],
//         state: json["state"],
//         country: json["country"],
//         zip: json["zip"],
//         phoneNumber: json["phone_number"],
//         createdAt: json["created_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "line_1": line1,
//         "line_2": line2,
//         "city": city,
//         "state": state,
//         "country": country,
//         "zip": zip,
//         "phone_number": phoneNumber,
//         "created_at": createdAt,
//       };
// }

// class Status {
//   Status({
//     required this.errorCode,
//     required this.status,
//     required this.message,
//     required this.responseCode,
//     required this.operationId,
//   });

//   final String? errorCode;
//   final String status;
//   final String? message;
//   final String? responseCode;
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
