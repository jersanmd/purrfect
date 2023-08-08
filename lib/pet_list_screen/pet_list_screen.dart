import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:purrfect/details/pet_details_screen.dart';
import 'package:purrfect/pet_list_screen/register_new_pet_screen.dart';

import '../model/pet.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Text('Pet Management',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Get.to(const RegisterNewPetScreen());
                    },
                    child: const Text('Register New Pet',
                        style: TextStyle(fontSize: 16, color: Colors.black87)),
                  ),
                ],
              ),
            ),
            searchAndFilterRow(),
            _listOfPetsFilteredWithTypes('Dog'),
            _listOfPetsFilteredWithTypes('Cat')
          ],
        )),
      ),
    );
  }

  Widget searchAndFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          SizedBox(
              width: Get.width - 120,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    width: Get.width,
                    height: 50,
                  ),
                  const Row(
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(FluentIcons.search_24_regular),
                      ),
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.blueAccent,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            fillColor: Colors.transparent,
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
          const Gap(20),
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200, width: 2)),
              child: const Icon(FluentIcons.apps_list_detail_24_regular))
        ],
      ),
    );
  }

  Widget _listOfPetsFilteredWithTypes(String petType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Text(
                petType,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              const Text(
                'See all',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        SizedBox(
          width: Get.width,
          height: 390,
          // color: Colors.red,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tbl_pet')
                .where('PetType', isEqualTo: petType)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        Pet pet = Pet.fromFirestore(documentSnapshot);
                        Get.to(PetDetailsScreen(
                            petId: documentSnapshot.id, pet: pet));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.1)),
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                        height: 200,
                                        width: Get.width,
                                        fit: BoxFit.cover,
                                        imageUrl: documentSnapshot['PetImage']),
                                  ),
                                  documentSnapshot['IsActive']
                                              .toString()
                                              .toLowerCase() !=
                                          'true'
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(top: 60),
                                          width: Get.width,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.black87),
                                          child: Center(
                                            child: Text(
                                              'INACTIVE',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${documentSnapshot['PetName']}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700)),
                                    const Gap(10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.pets_outlined),
                                            const Gap(10),
                                            Text(
                                              '${documentSnapshot['PetBreed']}',
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
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    ownerDetailsInfo(
                                        documentSnapshot['PetOwnerID']),
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
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Text('Cannot find pets.');
              }
            },
          ),
        )
      ],
    );
  }

  Widget ownerDetailsInfo(String ownerID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tbl_petowner')
                .doc(ownerID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var ownerDetails = snapshot.data;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                          height: 30,
                          width: 30,
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
                          ownerDetails['OwnerName'],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const Text('Owner')
                      ],
                    )
                  ],
                );
              } else {
                return const Center(child: Text('Data not found.'));
              }
            })
      ],
    );
  }
}
