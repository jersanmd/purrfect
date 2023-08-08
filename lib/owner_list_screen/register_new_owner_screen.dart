import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purrfect/controller/owner_controller.dart';
import 'package:image_cropper/image_cropper.dart';

import '../model/owner.dart';

class RegisterNewOwnerScreen extends StatefulWidget {
  const RegisterNewOwnerScreen({super.key});

  @override
  State<RegisterNewOwnerScreen> createState() => _RegisterNewOwnerScreenState();
}

class _RegisterNewOwnerScreenState extends State<RegisterNewOwnerScreen> {
  final TextEditingController _phoneCodeEditingController =
      TextEditingController();

  RxInt phoneNumberLength = 1.obs;
  final OwnerController _ownerController = Get.find<OwnerController>();

  String ownerId = '';
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _phoneNumberEditingController =
      TextEditingController();
  final TextEditingController _addressTextEditingController =
      TextEditingController();
  final TextEditingController _cityTextEditingController =
      TextEditingController();
  final TextEditingController _zipTextEditingController =
      TextEditingController();
  RxBool isActive = true.obs;

  @override
  void initState() {
    super.initState();

    _phoneCodeEditingController.text = "+63";
    _phoneNumberEditingController.text = "9";

    ownerId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void dispose() {
    super.dispose();

    _ownerController.image = null;
    _ownerController.uploadTask = null;
    _ownerController.imageDownloadUrl.value = '';
    _ownerController.uploadStatus.value = 'Tap Image to Upload Photo.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Register New Owner'),
          actions: [
            InkWell(
              onTap: () {
                Owner newOwner = Owner(
                    ownerName: _nameTextEditingController.text,
                    ownerEmail: _emailTextEditingController.text,
                    ownerImage: _ownerController.imageDownloadUrl.toString(),
                    ownerMobileNo: '0${_phoneNumberEditingController.text}',
                    ownerAddress: _addressTextEditingController.text,
                    ownerCity: _cityTextEditingController.text,
                    ownerZip: _zipTextEditingController.text,
                    isActive: '${isActive.value}');

                _showAlertDialog(context, newOwner);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8, left: 8),
                child: Center(child: Text('Confirm')),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(12),
                InkWell(
                  onTap: (() => _showModalBottomSheet(context)),
                  child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          image: _ownerController.image == null
                              ? const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/images/image_placeholder.png'))
                              : DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(_ownerController.image!)),
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100))),
                ),
                Obx(() => Text(_ownerController.uploadStatus.value)),
                const Gap(24),
                textFieldFormat('Email address', 'Please enter email address',
                    _emailTextEditingController, TextInputType.emailAddress),
                textFieldFormat('Full name', 'First Last',
                    _nameTextEditingController, TextInputType.name),
                phoneNumberTextFieldFormat(),
                addressTextField(),
                Row(
                  children: [
                    cityMunicipalityTextField(),
                    postalCodeTextField()
                  ],
                ),
                const Gap(16),
                floatingStatusBottom(),
                const Row()
              ],
            ),
          ),
        ));
  }

  _showAlertDialog(BuildContext context, Owner newOwner) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Confirm"),
      onPressed: () {
        _ownerController
            .addOwner(newOwner)
            .whenComplete(() => Navigator.pop(context))
            .whenComplete(() => Navigator.pop(context));
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Register new owner"),
      content: const Text("Would you like to continue?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _ownerController.image = img;
        Navigator.pop(context);
        _ownerController.uploadFile(ownerId);
      });
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: ((context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.25,
            maxChildSize: 0.26,
            minChildSize: 0.2,
            builder: ((context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: modalContents(),
                )))));
  }

  Widget modalContents() {
    return Column(
      children: [
        const Gap(10),
        Container(
          width: 60,
          height: 7,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
        ),
        const Gap(20),
        browseGallery(
            FluentIcons.content_view_gallery_24_filled, 'Browse Gallery'),
        const Gap(10),
        useCamera(FluentIcons.camera_24_filled, 'Use Camera'),
      ],
    );
  }

  Widget browseGallery(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
          onPressed: () => {_pickImage(ImageSource.gallery)},
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              foregroundColor: Colors.white,
              backgroundColor: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon), const Gap(10), Text(text)],
          )),
    );
  }

  Widget useCamera(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
          onPressed: () => {_pickImage(ImageSource.camera)},
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              foregroundColor: Colors.white,
              backgroundColor: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon), const Gap(10), Text(text)],
          )),
    );
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  Widget addressTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('House/Unit/Flr #, Bldg Name, Blk or Lot #'),
          const Gap(4),
          Container(
            width: Get.width,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300, width: 1)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: _addressTextEditingController,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Please enter exact address'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cityMunicipalityTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 36, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('City/Municipality'),
          const Gap(4),
          Container(
            width: Get.width / 2 - 30,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300, width: 1)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: _cityTextEditingController,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'City/Municipality of the address'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget postalCodeTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Postal Code'),
          const Gap(4),
          Container(
            width: Get.width / 2 - 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300, width: 1)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _zipTextEditingController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Postal Code'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneNumberTextFieldFormat() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Phone Number'),
            const Gap(16),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 21,
                            width: 42,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/ph_flag.jpeg'))),
                          ),
                          const Gap(10),
                          Container(
                              alignment: Alignment.center,
                              width: 35,
                              child: TextField(
                                maxLength: 3,
                                keyboardType: TextInputType.number,
                                controller: _phoneCodeEditingController,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    border: InputBorder.none,
                                    enabled: false),
                              )),
                        ],
                      ),
                      Container(
                        width: 90,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: Get.width - 190,
                          child: TextField(
                            onChanged: (value) {
                              phoneNumberLength.value = value.length;
                            },
                            maxLength: 10,
                            controller: _phoneNumberEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              border: InputBorder.none,
                            ),
                          )),
                      Container(
                        width: 200,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }

  Widget textFieldFormat(
      String title,
      String placeholder,
      TextEditingController textEditingController,
      TextInputType textInputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const Gap(4),
          Container(
            width: Get.width,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300, width: 1)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  keyboardType: textInputType,
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(hintText: placeholder),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget floatingStatusBottom() {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(8),
      color: Colors.black,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: Get.width - 28,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Active',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Obx(() => CupertinoSwitch(
                value: isActive.value,
                onChanged: (bool newValue) {
                  isActive.value = newValue;
                }))
          ],
        ),
      ),
    );
  }
}
