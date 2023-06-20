import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:purrfect/controller/pet_controller.dart';

class RegisterNewPetScreen extends StatefulWidget {
  const RegisterNewPetScreen({super.key});

  @override
  State<RegisterNewPetScreen> createState() => _RegisterNewPetScreenState();
}

class _RegisterNewPetScreenState extends State<RegisterNewPetScreen> {
  PetController _petController = Get.find<PetController>();

  final ownerListCoolDropDownButtonController = DropdownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Register New Pet'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(child: Text('Confirm')),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: const Center(child: Text('Tap to select image')),
                ),
                selectOwnerRow(),
                textFieldFormat('Name', 'Please enter name'),
                textFieldFormat('Pet Type', 'Please enter pet type'),
                textFieldFormat('Pet Breed', 'Please enter pet breed'),
                petGenderRow(),
                textFieldFormat('Notes', 'Please enter notes.'),
                petBirthDateColumn(),
                const Gap(8),
                floatingStatusBottom()
              ],
            ),
          ),
        ));
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
                      dropdownList: ownerProfileItems,
                      controller: ownerListCoolDropDownButtonController,
                      onChange: (item) {
                        print(item);
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
              _petController.dateSelected.value = dates.toString();
              print(_petController.dateSelected.value);
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
          Text('Gender'),
          Obx(
            () => Row(
              children: [
                Radio(
                    activeColor: Colors.black,
                    value: 0,
                    groupValue: _petController.genderIndex.value,
                    onChanged: (object) {
                      _petController.genderIndex.value = 0;
                    }),
                Text('Male'),
                Radio(
                    activeColor: Colors.black,
                    value: 1,
                    groupValue: _petController.genderIndex.value,
                    onChanged: (object) {
                      _petController.genderIndex.value = 1;
                    }),
                Text('Female')
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget textFieldFormat(String title, String placeholder) {
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
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: Get.width - 28,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Active',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            Spacer(),
            CupertinoSwitch(value: true, onChanged: (bool newValue) {})
          ],
        ),
      ),
    );
  }
}
