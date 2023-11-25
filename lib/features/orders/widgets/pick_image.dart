import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

File? imageFile;

Future<void> firstStep(BuildContext context) async {
  ImageSource? src;
  await showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        width: double.infinity,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Choose image source"),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
              child: Divider(),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  src = ImageSource.camera;
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 110,
                  width: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                          color: Colors.grey.shade300,
                          child: const SizedBox(
                              height: 70,
                              width: 70,
                              child: Center(
                                  child: Icon(
                                Icons.camera_alt_rounded,
                                size: 30,
                              )))),
                      const Text("Camera"),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  src = ImageSource.gallery;
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 110,
                  width: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        color: Colors.grey.shade300,
                        child: const SizedBox(
                          height: 70,
                          width: 70,
                          child: Center(
                            child: Icon(
                              Icons.photo,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const Text("Gallery"),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      );
    },
  );
  if (src != null) {
    await secondStep(src!);
  }
}

Future<void> secondStep(ImageSource src) async {
  XFile? uFile = await ImagePicker().pickImage(source: src);
  if (uFile != null) {
    CroppedFile? cFile = await ImageCropper().cropImage(
        sourcePath: uFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1));
    if (cFile != null) {
      imageFile = File(cFile.path);
    }
    String pId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref("productsImages").child(pId);
    await ref.putFile(imageFile!).whenComplete(() async {
      String url = await ref.getDownloadURL();
      log(url);
    });
    Fluttertoast.showToast(msg: "Profile picture updated");
  }
}
