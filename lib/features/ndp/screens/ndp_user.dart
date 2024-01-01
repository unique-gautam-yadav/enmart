import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

import '../../../common/constant/app_collections.dart';
import '../../../routes/routes_const.dart';
import '../models/ndp_order.dart';

class UserNDPScreen extends StatefulWidget {
  const UserNDPScreen({super.key});

  @override
  State<UserNDPScreen> createState() => _UserNDPScreenState();
}

class _UserNDPScreenState extends State<UserNDPScreen> {
  TextEditingController qfc = TextEditingController();
  TextEditingController input = TextEditingController();
  TextEditingController quality = TextEditingController();
  TextEditingController plant = TextEditingController();
  TextEditingController packing = TextEditingController();
  TextEditingController embossing = TextEditingController();
  TextEditingController decoration = TextEditingController();
  TextEditingController coating = TextEditingController();
  TextEditingController printing = TextEditingController();
  TextEditingController frosting = TextEditingController();
  TextEditingController hfs = TextEditingController();
  TextEditingController other = TextEditingController();
  TextEditingController moq = TextEditingController();
  TextEditingController annualRequirement = TextEditingController();
  TextEditingController remarks = TextEditingController();

  final _fKey = GlobalKey<FormState>();

  File? imageFile;
  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Order NDP"),
        previousPageTitle: "Your NDPs",
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                  ),
                  Form(
                    key: _fKey,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 15,
                      runSpacing: 15,
                      children: [
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: qfc,
                            placeholder: "OFC Required",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: input,
                            placeholder: "Input",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: quality,
                            placeholder: "Quality",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: plant,
                            placeholder: "Plant",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: packing,
                            placeholder: "Packing",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: embossing,
                            placeholder: "Embossing",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: decoration,
                            placeholder: "Decoration",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: coating,
                            placeholder: "Coating",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: printing,
                            placeholder: "Printing",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: frosting,
                            placeholder: "Frosting",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: hfs,
                            placeholder: "HFS",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: other,
                            placeholder: "Other",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: moq,
                            placeholder: "MOQ",
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: customTextField(
                            controller: annualRequirement,
                            placeholder: "Annual Requirement",
                          ),
                        ),
                        Max400Width(
                          child: CupertinoButton(
                            onPressed: () {
                              pickAndCrop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: CupertinoColors.systemGrey3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: imageFile == null
                                    ? const Text(
                                        "Your image here",
                                        style: TextStyle(
                                          color: CupertinoColors.systemGrey3,
                                        ),
                                      )
                                    : AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: kIsWeb
                                            ? Image.network(imageFile!.path)
                                            : Image.file(imageFile!),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Max400Width(
                          height: 40,
                          child: CupertinoTextField(
                            controller: remarks,
                            placeholder: "Remarks",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  CupertinoButton.filled(
                    child: const Text("SUBMIT"),
                    onPressed: () {
                      if (_fKey.currentState!.validate()) {
                        proceedUpload(context);
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  proceedUpload(BuildContext context) async {
    if (imageFile == null ||
        qfc.text.isEmpty ||
        input.text.isEmpty ||
        quality.text.isEmpty ||
        packing.text.isEmpty ||
        embossing.text.isEmpty ||
        decoration.text.isEmpty ||
        coating.text.isEmpty ||
        printing.text.isEmpty ||
        frosting.text.isEmpty ||
        hfs.text.isEmpty ||
        other.text.isEmpty ||
        moq.text.isEmpty ||
        annualRequirement.text.isEmpty ||
        remarks.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "All fields are required",
      );
      return;
    }
    QuickAlert.show(context: context, type: QuickAlertType.loading);

    try {
      DateTime dt = DateTime.now();

      String url = await uploadImage();

      NDPModel m = NDPModel(
        ofc: qfc.text,
        input: input.text,
        quality: quality.text,
        packing: packing.text,
        embossing: embossing.text,
        decoration: decoration.text,
        coating: coating.text,
        printing: printing.text,
        frosting: frosting.text,
        hfs: hfs.text,
        other: other.text,
        moq: moq.text,
        annualRequirement: annualRequirement.text,
        imgUrl: url,
        remarks: remarks.text,
        uid: FirebaseAuth.instance.currentUser!.uid,
        dateTime: dt,
      );

      await ndpCollection
          .doc(dt.millisecondsSinceEpoch.toString())
          .set(m.toMap());

      if (context.mounted) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            onConfirmBtnTap: () {
              context.go(UserRoutes.homeRoute.path);
            });
      }
    } catch (e) {
      log(e.toString());
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: e.toString(),
        );
      }
    }
  }

  Future<void> pickAndCrop(BuildContext context) async {
    QuickAlert.show(context: context, type: QuickAlertType.loading);
    try {
      ImageSource? src;
      await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Theme.of(context).bottomSheetTheme.backgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            width: double.infinity,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Choose image source"),
                const Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                  child: Divider(),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
        XFile? uFile = await ImagePicker().pickImage(source: src!);
        if (uFile != null) {
          CroppedFile? cFile = await ImageCropper().cropImage(
            sourcePath: uFile.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              IOSUiSettings(
                title: 'Cropper',
              ),
              context.mounted
                  ? WebUiSettings(
                      context: context,
                      presentStyle: CropperPresentStyle.page,
                      boundary: const CroppieBoundary(
                        width: 520,
                        height: 520,
                      ),
                      viewPort: const CroppieViewPort(width: 480, height: 480),
                      enableExif: true,
                      enableZoom: true,
                      showZoomer: true,
                    )
                  : IOSUiSettings(
                      title: 'Cropper',
                    ),
            ],
          );
          if (cFile != null) {
            imageFile = File(cFile.path);
            image =
                await cFile.readAsBytes().whenComplete(() => setState(() {}));
          }
        }
      }
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      log(e.toString());
      if (context.mounted) {
        QuickAlert.show(
            context: context, type: QuickAlertType.error, title: e.toString());
      }
    }
  }

  Future<String> uploadImage() async {
    late String u;
    String pId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref("productsImages").child(pId);
    if (kIsWeb) {
      await ref.putData(image!).whenComplete(() async {
        String url = await ref.getDownloadURL();
        log(url);
        u = url;
      });
    } else {
      await ref.putFile(imageFile!).whenComplete(() async {
        String url = await ref.getDownloadURL();
        log(url);
        u = url;
      });
    }
    Fluttertoast.showToast(msg: "Image uploaded");

    return u;
  }

  customTextField(
      {required TextEditingController controller,
      required String placeholder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(placeholder),
        ),
        const SizedBox(height: 4),
        CupertinoTextFormFieldRow(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: CupertinoColors.systemGrey3),
            borderRadius: BorderRadius.circular(5),
          ),
          controller: controller,
          placeholder: placeholder,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class Max400Width extends StatelessWidget {
  const Max400Width({super.key, required this.child, this.height});

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    width -= 30;
    int count = (width ~/ 400);
    width -= (20 * (count - 1));
    width = 400 + ((width % 400) / count);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width,
        // maxWidth: 400,
        minWidth: 150,
        // maxHeight: height,
        // minHeight: height
      ),
      child: child,
    );
  }
}
