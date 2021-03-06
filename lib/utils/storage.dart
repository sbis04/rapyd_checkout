import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:slibro/application/res/appwrite_const.dart';
import 'package:slibro/main.dart';

class StorageClient {
  Storage storage = Storage(client);

  Future<File> storeJSONFile({
    required String filePath,
    required String fileName,
  }) async {
    File file = await storage
        .createFile(
      bucketId: filesBucketId,
      fileId: 'unique()',
      file: InputFile(
        path: filePath,
        filename: fileName,
      ),
    )
        .catchError((e) {
      log(
        'Error storing file: ${e.toString()}',
      );
    });

    log('File successfully stored, ID: ${file.$id}');

    return file;
  }

  Future<String> getJSONFile({required String fileID}) async {
    Uint8List rawFile = await storage
        .getFileDownload(
      bucketId: filesBucketId,
      fileId: fileID,
    )
        .catchError((e) {
      log('Error retrieving file: ${e.toString()}');
    });

    final jsonString = utf8.decode(rawFile);

    return jsonString;
  }

  Future<File> storeCoverImage({
    required String filePath,
    required String fileName,
  }) async {
    File image = await storage
        .createFile(
      bucketId: coversBucketId,
      fileId: 'unique()',
      file: InputFile(
        path: filePath,
        filename: fileName,
      ),
    )
        .catchError((e) {
      log(
        'Error storing cover image: ${e.toString()}',
      );
    });

    log('Cover image successfully stored, ID: ${image.$id}');

    return image;
  }

  Future<Uint8List> getCoverImage({required String imageID}) async {
    Uint8List rawImageFile = await storage
        .getFileDownload(
      bucketId: coversBucketId,
      fileId: imageID,
    )
        .catchError((e) {
      log('Error retrieving cover image: ${e.toString()}');
    });

    return rawImageFile;
  }
}
