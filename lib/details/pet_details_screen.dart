import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:purrfect/controller/pet_controller.dart';
import 'package:purrfect/model/pet.dart';
import 'package:purrfect/pet_list_screen/update_pet_screen.dart';

class PetDetailsScreen extends StatefulWidget {
  const PetDetailsScreen({
    super.key,
    required this.petId,
    required this.pet,
  });

  final String petId;
  final Pet pet;

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  PetController _petController = Get.find<PetController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingStatusBottom(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text('Details'),
          actions: [
            InkWell(
              onTap: () {
                Get.to(UpdatePetScreen(petId: widget.petId, pet: widget.pet));
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Center(child: Text('Edit')),
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            petImageInfo(widget.pet.petImage),
            petDetailsInfo(
                widget.pet.petName,
                widget.pet.petType,
                widget.pet.petBreed,
                widget.pet.petBdate,
                widget.pet.petGender,
                widget.pet.petNotes),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 54, vertical: 8),
                child: Divider(color: Colors.black)),
            ownerDetailsInfo(widget.pet.petOwnerID)
          ],
        ));
  }

  Widget petImageInfo(String imageLink) {
    return CachedNetworkImage(
        width: Get.width, height: 300, imageUrl: imageLink);
  }

  Widget petDetailsInfo(String petName, String petType, String petBreed,
      String petBDate, String petGender, String petNotes) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                petName,
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  _showAlertDialog(context, widget.pet, widget.petId);
                },
                child: Row(
                  children: [
                    Icon(
                      FluentIcons.delete_48_regular,
                      color: Colors.black,
                      size: 32,
                    ),
                    Text('Remove Pet')
                  ],
                ),
              )
            ],
          ),
          const Gap(8),
          Row(
            children: [
              const Icon(Icons.pets),
              const Gap(10),
              Text(
                '$petBreed',
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
          const Gap(4),
          Row(
            children: [
              const Icon(FluentIcons.calendar_checkmark_24_filled),
              const Gap(10),
              Text(
                'Born in ${DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(petBDate))}',
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
          const Gap(4),
          Row(
            children: [
              petGender == 'Male'
                  ? const Icon(Icons.male)
                  : const Icon(Icons.female),
              const Gap(10),
              Text(
                petGender,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
          const Gap(4),
          Row(
            children: [
              const Icon(Icons.notes),
              const Gap(10),
              Text(
                petNotes,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ],
      ),
    );
  }

  _showAlertDialog(BuildContext context, Pet pet, String petId) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Confirm"),
      onPressed: () {
        _petController
            .removePet(petId)
            .whenComplete(() => Navigator.pop(context))
            .whenComplete(() => Navigator.pop(context));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Remove ${pet.petName}"),
      content: Text("Would you like to continue?"),
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

  Widget ownerDetailsInfo(String ownerID) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Owner Details', style: TextStyle(fontSize: 14)),
          const Gap(8),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('tbl_petowner')
                  .doc(ownerID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var ownerDetails = snapshot.data;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: CachedNetworkImage(
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                            imageUrl: ownerDetails!['OwnerImage']),
                      ),
                      const Gap(8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(8),
                          Text(
                            '${ownerDetails['OwnerName']}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text('${ownerDetails['OwnerEmail']}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400)),
                          Text('${ownerDetails['OwnerMobileNo']}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const Text(''),
                          const Icon(FluentIcons.call_24_regular),
                          const Gap(4),
                          const Text('Call')
                        ],
                      )
                    ],
                  );
                } else {
                  return Center(child: Text('Data not found...'));
                }
              })
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
        height: 70,
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
            CupertinoSwitch(
                value: widget.pet.isActive.toLowerCase() == 'true',
                onChanged: (bool newValue) {
                  _petController
                      .updatePetActivityStatus(widget.petId, newValue)
                      .whenComplete(() => Navigator.pop(context));
                })
          ],
        ),
      ),
    );
  }
}
