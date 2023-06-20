import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PetDetailsScreen extends StatefulWidget {
  const PetDetailsScreen({
    super.key,
    required this.petID,
  });

  final String petID;

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingStatusBottom(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Details'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tbl_pet')
              .doc(widget.petID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var userDocument = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  petImageInfo(userDocument!['PetImage']),
                  petDetailsInfo(
                      userDocument['PetName'],
                      userDocument['PetType'],
                      userDocument['PetBreed'],
                      userDocument['PetBdate'],
                      userDocument['PetGender'],
                      userDocument['PetNotes']),
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 54, vertical: 8),
                      child: Divider(color: Colors.black)),
                  ownerDetailsInfo(userDocument['PetOwnerID'])
                ],
              );
            } else {
              return const Center(child: Text('Data not found...'));
            }
          }),
    );
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
          Text(
            petName,
            style: const TextStyle(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          Row(
            children: [
              const Icon(Icons.pets),
              const Gap(10),
              Text(
                '$petType - $petBreed',
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
                'Born in $petBDate',
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
            CupertinoSwitch(value: true, onChanged: (bool newValue) {})
          ],
        ),
      ),
    );
  }
}
