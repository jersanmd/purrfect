import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:purrfect/model/pet.dart';

class PetController extends RxController {
  RxInt ownerId = 0.obs;
  RxString selectedOwnerName = 'Tom Cruise'.obs;

  File? image;
  UploadTask? uploadTask;
  var imageDownloadUrl = ''.obs;
  RxString uploadStatus = 'Tap image to upload photo.'.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  Future<void> uploadFile(String petId) async {
    final path = 'files/$petId';
    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask = ref.putFile(image!);

    final snapshot = await uploadTask!.whenComplete(() {
      Get.snackbar('Upload', 'Image uploaded...');
    });

    imageDownloadUrl.value = await snapshot.ref.getDownloadURL();
    uploadStatus.value = 'Image Uploaded.';
    uploadTask = null;
  }

  Future addPet(Pet pet) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('tbl_pet').doc();
    await documentReference.set(pet.toFirestore());
  }

  Future<void> removePet(String id) async {
    final ref = FirebaseFirestore.instance.collection('tbl_pet').doc(id);
    await ref
        .delete()
        .whenComplete(() => Get.snackbar('Pet', 'Pet removed...'));
  }

  Future<void> updatePetDetails(Pet pet, String petId) async {
    final ref = FirebaseFirestore.instance.collection('tbl_pet').doc(petId);
    await ref
        .update(pet.toFirestore())
        .whenComplete(() => Get.snackbar('Pet', 'Pet details updated.'));
  }

  Future<void> updatePetActivityStatus(String petId, bool statusValue) async {
    final ref = FirebaseFirestore.instance.collection('tbl_pet').doc(petId);
    await ref.update({'IsActive': '${statusValue.toString()}'}).whenComplete(
        () => Get.snackbar('Pet Status', 'Pet Status Updated'));
  }
}
