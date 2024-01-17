import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class ImageUtils {
  static Future<Uint8List> getImageBytes(String url) async {
    var response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  static Future<void> saveImageToLocal(
      Uint8List imageBytes, String imageName) async {
    Directory? imageDirectory = await getExternalStorageDirectory();
    log(imageDirectory != null
        ? imageDirectory.path.toString()
        : "no directory access");
    if (imageDirectory == null) {
      log("Fail to save image");
      return;
    }
    String imagePath = path.join(imageDirectory.path, path.basename(imageName));
    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageBytes);
    log("Save image completed, path: $imagePath");
  }

  static Future<Uint8List> getImageFromLocal(String imageName) async {
    Directory? imageDirectory = await getExternalStorageDirectory();
    if (imageDirectory == null) {
      throw Exception("get path error");
    }
    String imagePath = path.join(imageDirectory.path, path.basename(imageName));
    File imageFile = File(imagePath);
    log("Get image successfully, path: $imagePath");

    return imageFile.readAsBytes();
  }
}
