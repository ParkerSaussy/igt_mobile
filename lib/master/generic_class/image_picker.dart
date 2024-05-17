import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesgo/master/networking/request_manager.dart';

class CustomImagePicker {
  // Image Picker
  static pickImage(
      {bool isSelectMultipleImage = false,
      ImageSource? source,
      CropAspectRatio? aspectRatio}) async {
    if (!isSelectMultipleImage) {
      //FGBGEvents.ignoreWhile(() async {
      var selectedCroppedImage = '';
      XFile? image =
          await ImagePicker().pickImage(source: source ?? ImageSource.gallery);
      if (image != null) {
        selectedCroppedImage = await cropImage(image, aspectRatio: aspectRatio);
      }
      return selectedCroppedImage;
      //});
    } else {
      //FGBGEvents.ignoreWhile(() async {
      final List<File> croppedImageList = [];
      List<XFile>? images = await ImagePicker().pickMultiImage();
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          String croppedImage = "";
          croppedImage = await cropImage(images[i]);
          croppedImageList.add(File(croppedImage));
        }
      }
      return croppedImageList;
      //});
    }
  }

  static Future<List<XFile>> pickMultiImage() async {
    List<XFile>? images = await ImagePicker().pickMultiImage();
    return images;
  }

  static Future<List<File>> compressAndConvertImages(List<XFile> images) async {
    final List<File> croppedImageList = [];

    for (int i = 0; i < images.length; i++) {
      String croppedImage = "";
      // croppedImage = await cropImage(images[i]);

      String imagePath = images[i].path;
      int bytes = File(imagePath).readAsBytesSync().lengthInBytes;

      // int bytes = File(images[i].path).readAsBytesSync().lengthInBytes;

      while (bytes > (2 * 1024 * 1024)) {
        // Image is greater than 2 MB, compress it
        Uint8List? compressedBytes =
            await FlutterImageCompress.compressWithFile(
          imagePath,
          quality: 80, // Adjust quality as needed
        );

        if (compressedBytes != null) {
          // Save the compressed image to a new file
          File compressedImage =
              File(imagePath.replaceAll(".jpg", "_compressed.jpg"));
          await compressedImage.writeAsBytes(compressedBytes);

          // Update the image path and size for the next iteration
          imagePath = compressedImage.path;
          bytes = compressedImage.lengthSync();
        } else {
          // Compression failed, break the loop
          break;
        }
      }
      croppedImageList.add(File(imagePath));
    }
    return croppedImageList;
  }

  static Future<String> cropImage(XFile file,
      {CropAspectRatio? aspectRatio}) async {
    final cropImageFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        maxWidth: 512,
        maxHeight: 512,
        aspectRatio: aspectRatio,
        compressFormat: ImageCompressFormat.jpg);
    return cropImageFile!.path;
  }
}
