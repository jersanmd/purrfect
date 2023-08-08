import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../details/pet_details_screen.dart';
import '../model/pet.dart';

class PetsListerTypes extends StatefulWidget {
  const PetsListerTypes({super.key, required this.petType});

  final String petType;

  @override
  State<PetsListerTypes> createState() => _PetsListerTypesState();
}

class _PetsListerTypesState extends State<PetsListerTypes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(widget.petType),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            width: Get.width,
            height: Get.height,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('tbl_pet')
                  .where('PetType', isEqualTo: widget.petType)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.length < 1) {
                    EasyLoading.showError('No data found.',
                        duration: const Duration(seconds: 1));
                    Timer.periodic(const Duration(seconds: 1), (timer) {
                      Navigator.pop(context);
                    });
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];

                      if (documentSnapshot['IsActive']
                              .toString()
                              .toLowerCase() !=
                          'true') {
                        return Container();
                      } else {
                        return InkWell(
                          onTap: () {
                            Pet petDetails =
                                Pet.fromFirestore(documentSnapshot);
                            Get.to(PetDetailsScreen(
                                petId: documentSnapshot.id, pet: petDetails));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 3),
                            child: SizedBox(
                              width: Get.width,
                              // height: 450,
                              // color: Colors.blueGrey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: Get.width,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              documentSnapshot['PetImage']),
                                    ),
                                  ),
                                  const Gap(12),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: Get.width - 200,
                                        child: Text(
                                            '${documentSnapshot['PetName']}',
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      const Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        width: 150,
                                        height: 50,
                                        child: const Center(
                                          child: Text(
                                            'View',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Gap(10),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.pets_outlined),
                                          const Gap(10),
                                          Text(
                                            '${documentSnapshot['PetType']} - ${documentSnapshot['PetBreed']}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today),
                                          const Gap(10),
                                          Text(
                                            '${DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(documentSnapshot['PetBdate']))}',
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  const Gap(12),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width / 3),
                                    child: const Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Gap(6)
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return const Text(
                    'No data found...',
                    style: TextStyle(color: Colors.black),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
