import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:purrfect/controller/owner_controller.dart';
import 'package:purrfect/details/pet_details_screen.dart';
import 'package:purrfect/model/owner.dart';

import '../model/pet.dart';

class OwnerDetailsScreen extends StatefulWidget {
  const OwnerDetailsScreen(
      {super.key, required this.ownerId, required this.owner});

  final String ownerId;
  final Owner owner;

  @override
  State<OwnerDetailsScreen> createState() => _OwnerDetailsScreenState();
}

class _OwnerDetailsScreenState extends State<OwnerDetailsScreen> {
  final OwnerController _ownerController = Get.find<OwnerController>();
  final TextEditingController _editNameEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text('Owner Details'),
        actions: [
          InkWell(
            onTap: () {
              _showAlertDialog(context, widget.owner, widget.ownerId);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(
                    FluentIcons.delete_24_filled,
                    color: Colors.black,
                  ),
                  Gap(4),
                  Text('Remove')
                ],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75),
                  border: Border.all(color: Colors.grey.shade600, width: 5)),
              width: 150,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: CachedNetworkImage(
                    fit: BoxFit.cover, imageUrl: widget.owner.ownerImage),
              ),
            ),
            Text(
              widget.owner.ownerName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
            ),
            const Gap(8),
            Text(
              widget.owner.ownerEmail,
              style: TextStyle(
                  color: Colors.grey.shade900, fontStyle: FontStyle.italic),
            ),
            const Gap(2),
            InkWell(
              onTap: () {
                _displayTextInputDialog(
                    context, widget.ownerId, widget.owner.ownerMobileNo);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.owner.ownerMobileNo,
                    style: TextStyle(
                        color: Colors.grey.shade900,
                        fontStyle: FontStyle.italic),
                  ),
                  const Gap(8),
                  const Icon(FluentIcons.edit_24_regular, size: 18)
                ],
              ),
            ),
            const Gap(2),
            Text(
                '${widget.owner.ownerAddress}, ${widget.owner.ownerCity}, ${widget.owner.ownerZip}'),
            const Gap(16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            const Gap(16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Owned Pets',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('tbl_pet')
                    .where('PetOwnerID', isEqualTo: widget.ownerId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
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
                                  border: Border.all(
                                      color: Colors.grey, width: 0.1)),
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
                                            imageUrl:
                                                documentSnapshot['PetImage']),
                                      ),
                                      documentSnapshot['IsActive']
                                                  .toString()
                                                  .toLowerCase() !=
                                              'true'
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  top: 60),
                                              width: Get.width,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black87),
                                              child: const Center(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                    Icons.calendar_today),
                                                const Gap(10),
                                                Text(
                                                  '${DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(documentSnapshot['PetBdate']))}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
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
            ),
            const Row()
          ]),
        ),
      ),
    );
  }

  _showAlertDialog(BuildContext context, Owner owner, String ownerId) {
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
            .removeOwner(ownerId)
            .whenComplete(() => Navigator.pop(context))
            .whenComplete(() => Navigator.pop(context));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Remove ${owner.ownerName}"),
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

  Future<void> _displayTextInputDialog(
      BuildContext context, String ownerId, String oldValue) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Mobile Number'),
            content: TextField(
              onChanged: (value) {},
              controller: _editNameEditingController,
              decoration: InputDecoration(hintText: oldValue),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    _ownerController
                        .updateOwnerMobileNo(
                            ownerId, _editNameEditingController.text)
                        .whenComplete(() => Navigator.pop(context))
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }
}
