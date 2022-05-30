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
// //     final customer = customerFromJson(jsonString);

// import 'dart:convert';

// class Customer {
//   Customer({
//     required this.status,
//     required this.data,
//   });

//   final Status status;
//   final Data data;

//   factory Customer.fromRawJson(String str) =>
//       Customer.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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
//     required this.name,
//     required this.defaultPaymentMethod,
//     required this.description,
//     required this.email,
//     required this.invoicePrefix,
//     required this.createdAt,
//     required this.businessVatId,
//     required this.ewallet,
//   });

//   final String id;
//   final String name;
//   final String? defaultPaymentMethod;
//   final String? description;
//   final String email;
//   final String? invoicePrefix;
//   final int createdAt;
//   final String? businessVatId;
//   final String? ewallet;

//   factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         name: json["name"],
//         defaultPaymentMethod: json["default_payment_method"],
//         description: json["description"],
//         email: json["email"],
//         invoicePrefix: json["invoice_prefix"],
//         createdAt: json["created_at"],
//         businessVatId: json["business_vat_id"],
//         ewallet: json["ewallet"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "default_payment_method": defaultPaymentMethod,
//         "description": description,
//         "email": email,
//         "invoice_prefix": invoicePrefix,
//         "created_at": createdAt,
//         "business_vat_id": businessVatId,
//         "ewallet": ewallet,
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
