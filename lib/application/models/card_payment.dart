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
// //     final cardPayment = cardPaymentFromJson(jsonString);

// import 'dart:convert';

// class CardPayment {
//   CardPayment({
//     required this.status,
//     required this.data,
//   });

//   final Status status;
//   final Data data;

//   factory CardPayment.fromRawJson(String str) =>
//       CardPayment.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory CardPayment.fromJson(Map<String, dynamic> json) => CardPayment(
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
//     required this.type,
//     required this.category,
//     required this.nextAction,
//     required this.name,
//     required this.last4,
//     required this.acsCheck,
//     required this.cvvCheck,
//     required this.expirationYear,
//     required this.expirationMonth,
//     required this.fingerprintToken,
//     required this.redirectUrl,
//   });

//   final String id;
//   final String type;
//   final String category;
//   final String? nextAction;
//   final String name;
//   final String last4;
//   final String? acsCheck;
//   final String? cvvCheck;
//   final String expirationYear;
//   final String expirationMonth;
//   final String? fingerprintToken;
//   final String? redirectUrl;

//   factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         type: json["type"],
//         category: json["category"],
//         nextAction: json["next_action"],
//         name: json["name"],
//         last4: json["last4"],
//         acsCheck: json["acs_check"],
//         cvvCheck: json["cvv_check"],
//         expirationYear: json["expiration_year"],
//         expirationMonth: json["expiration_month"],
//         fingerprintToken: json["fingerprint_token"],
//         redirectUrl: json["redirect_url"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "type": type,
//         "category": category,
//         "next_action": nextAction,
//         "name": name,
//         "last4": last4,
//         "acs_check": acsCheck,
//         "cvv_check": cvvCheck,
//         "expiration_year": expirationYear,
//         "expiration_month": expirationMonth,
//         "fingerprint_token": fingerprintToken,
//         "redirect_url": redirectUrl,
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
