import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purrfect/controller/pet_controller.dart';

import '../model/pet.dart';

class RegisterNewPetScreen extends StatefulWidget {
  const RegisterNewPetScreen({super.key});

  @override
  State<RegisterNewPetScreen> createState() => _RegisterNewPetScreenState();
}

class _RegisterNewPetScreenState extends State<RegisterNewPetScreen> {
  PetController _petController = Get.find<PetController>();

  final ownerListCoolDropDownButtonController = DropdownController();

  String _petId = '';
  final TextEditingController _nameEditingController = TextEditingController();
  final RxString _bDate = ''.obs;
  final RxString _gender = 'Male'.obs;
  final TextEditingController _breedEditingController = TextEditingController();
  final TextEditingController _typeEditingController = TextEditingController();
  //image can find in _petController
  final RxString _ownerID = ''.obs;
  final TextEditingController _notesEditingController = TextEditingController();
  final RxBool _isActive = true.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _petId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _petController.image = null;
    _petController.uploadTask = null;
    _petController.imageDownloadUrl.value = '';
    _petController.uploadStatus.value = 'Tap Image To Upload Photo.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Register New Pet'),
          actions: [
            InkWell(
              onTap: () {
                Pet newPet = Pet(
                    petName: _nameEditingController.text,
                    petBdate: _bDate.value,
                    petGender: _gender.value,
                    petBreed: _breedEditingController.text,
                    petType: _typeEditingController.text,
                    petImage: _petController.imageDownloadUrl.toString(),
                    petOwnerID: _ownerID.value,
                    petNotes: _notesEditingController.text,
                    isActive: '${_isActive.value}');

                _showAlertDialog(context, newPet);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Center(child: Text('Confirm')),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                InkWell(
                  onTap: (() => _showModalBottomSheet(context)),
                  child: Container(
                      width: Get.width,
                      height: 250,
                      decoration: BoxDecoration(
                        image: _petController.image == null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/image_placeholder.png'))
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(_petController.image!)),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                        color: Colors.white,
                      )),
                ),
                Obx(() => Text(_petController.uploadStatus.value)),
                const Gap(12),
                selectOwnerRow(),
                textFieldFormat('Name', 'Please enter name', TextInputType.name,
                    _nameEditingController),
                textFieldFormat('Pet Type', 'Please enter pet type',
                    TextInputType.name, _typeEditingController),
                textFieldFormat('Pet Breed', 'Please enter pet breed',
                    TextInputType.name, _breedEditingController),
                petGenderRow(),
                textFieldFormat('Notes', 'Please enter notes.',
                    TextInputType.text, _notesEditingController),
                petBirthDateColumn(),
                const Gap(8),
                floatingStatusBottom()
              ],
            ),
          ),
        ));
  }

  _showAlertDialog(BuildContext context, Pet newPet) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Confirm"),
      onPressed: () {
        _petController
            .addPet(newPet)
            .whenComplete(() => Navigator.pop(context))
            .whenComplete(() => Navigator.pop(context));
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Register new pet"),
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

  Widget selectOwnerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: Row(
        children: [
          Text('Select Owner: '),
          const Gap(8),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tbl_petowner')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else {
                List<CoolDropdownItem> ownerProfileItems = [];
                for (int index = 0;
                    index < snapshot.data!.docs.length;
                    index++) {
                  DocumentSnapshot snap = snapshot.data!.docs[index];
                  ownerProfileItems.add(CoolDropdownItem(
                      icon: Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              imageUrl: snap['OwnerImage'],
                              fit: BoxFit.cover,
                            ),
                          )),
                      label: snap['OwnerName'],
                      value: snap.id));
                }

                return DropdownButtonHideUnderline(
                  child: CoolDropdown(
                      defaultItem: ownerProfileItems[0],
                      dropdownList: ownerProfileItems,
                      controller: ownerListCoolDropDownButtonController,
                      onChange: (item) {
                        _ownerID.value = item;
                      }),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget petBirthDateColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Birthdate'),
          const Gap(8),
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(),
            value: [],
            onValueChanged: (dates) {
              _bDate.value = dates[0].toString();
            },
          )
        ],
      ),
    );
  }

  Widget petGenderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Gender'),
          Obx(
            () => Row(
              children: [
                Radio(
                    activeColor: Colors.black,
                    value: 'Male',
                    groupValue: _gender.value,
                    onChanged: (object) {
                      _gender.value = 'Male';
                    }),
                const Text('Male'),
                Radio(
                    activeColor: Colors.black,
                    value: 'Female',
                    groupValue: _gender.value,
                    onChanged: (object) {
                      _gender.value = 'Female';
                    }),
                const Text('Female')
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget textFieldFormat(
      String title,
      String placeholder,
      TextInputType textInputType,
      TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 36),
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
                value: _isActive.value,
                onChanged: (bool newValue) {
                  _isActive.value = newValue;
                }))
          ],
        ),
      ),
    );
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _petController.image = img;
        Navigator.pop(context);
        _petController.uploadFile(_petId);
      });
    } on PlatformException catch (e) {
      // print(e);
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
}
