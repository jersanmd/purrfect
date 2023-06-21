import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:purrfect/details/owner_details_screen.dart';
import 'package:purrfect/model/owner.dart';
import 'package:purrfect/owner_list_screen/register_new_owner_screen.dart';

class OwnerListScreen extends StatefulWidget {
  const OwnerListScreen({super.key});

  @override
  State<OwnerListScreen> createState() => _OwnerListScreenState();
}

class _OwnerListScreenState extends State<OwnerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Text('Pet Owners Management',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Get.to(const RegisterNewOwnerScreen());
                  },
                  child: const Text('Register New Owner',
                      style: TextStyle(fontSize: 16, color: Colors.black87)),
                ),
              ],
            ),
          ),
          searchAndFilterRow(),
          listOfOwnersNoFilter()
        ],
      )),
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
                  Row(
                    children: const [
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

  Widget listOfOwnersNoFilter() {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tbl_petowner')
                .orderBy('OwnerName')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    return InkWell(
                      onTap: () {
                        Owner owner = Owner.fromFirestore(documentSnapshot);
                        Get.to(OwnerDetailsScreen(
                            ownerId: documentSnapshot.id, owner: owner));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Card(
                          child: SizedBox(
                            width: Get.width,
                            height: 200,
                            // decoration: const BoxDecoration(color: Colors.red),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(12),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 12),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              documentSnapshot['OwnerImage'],
                                        ),
                                      ),
                                      const Gap(8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(documentSnapshot['OwnerName'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16)),
                                          Text(documentSnapshot['OwnerEmail']),
                                        ],
                                      ),
                                      const Spacer(),
                                      const SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Icon(
                                          FluentIcons.edit_24_filled,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 36),
                                  child: Text('Pets:'),
                                ),
                                SizedBox(
                                    width: Get.width,
                                    height: 50,
                                    // color: Colors.amberAccent,
                                    child:
                                        _petStreamBuilder(documentSnapshot.id)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('Cannot find users.'),
                );
              }
            },
          )),
    );
  }

  Widget _petStreamBuilder(String ownerId) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('tbl_pet')
          .where('PetOwnerID', isEqualTo: ownerId)
          .snapshots(),
      builder: (context, snapshot2) {
        if (snapshot2.hasData && snapshot2.data!.size > 0) {
          return ListView.builder(
            padding: const EdgeInsets.only(left: 24),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot2.data!.size,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot2 = snapshot2.data!.docs[index];
              return InkWell(
                onTap: () {},
                child: SizedBox(
                  width: 180,
                  // color: Colors.blue,
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: documentSnapshot2['PetImage'],
                        width: 75,
                      ),
                      const Gap(5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(documentSnapshot2['PetName']),
                          Text(
                              '${documentSnapshot2['PetType']} - ${documentSnapshot2['PetBreed']}')
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No pet yet.'));
        }
      },
    );
  }
}
