import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purrfect/model/owner.dart';

class OwnerController extends RxController {
  File? image;
  UploadTask? uploadTask;
  var imageDownloadUrl = ''.obs;
  RxString uploadStatus = 'Tap image to upload photo.'.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Future<void> uploadFile(String ownerId) async {
    final path = 'files/${ownerId}';
    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask = ref.putFile(image!);

    final snapshot = await uploadTask!.whenComplete(() {
      Get.snackbar('Upload', 'Image uploaded...');
    });

    imageDownloadUrl.value = await snapshot.ref.getDownloadURL();
    uploadStatus.value = 'Image Uploaded.';
    uploadTask = null;
  }

  Future<void> addOwner(Owner owner) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('tbl_petowner').doc();
    await documentReference.set(owner.toFirestore());
  }

  Future<void> removeOwner(String id) async {
    final ref = FirebaseFirestore.instance.collection('tbl_petowner').doc(id);
    await ref
        .delete()
        .whenComplete(() => Get.snackbar('Owner', 'Owner removed...'));
  }

  Future<void> updateOwnerDetails(Owner owner, String ownerId) async {
    final ref =
        FirebaseFirestore.instance.collection('tbl_petowner').doc(ownerId);
    await ref
        .update(owner.toFirestore())
        .whenComplete(() => Get.snackbar('Owner', 'Owner details updated.'));
  }
}
