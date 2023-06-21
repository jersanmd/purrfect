import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  final String petName;
  final String petBdate;
  final String petGender;
  final String petBreed;
  final String petType;
  final String petImage;
  final String petOwnerID;
  final String petNotes;
  final String isActive;

  Pet(
      {required this.petName,
      required this.petBdate,
      required this.petGender,
      required this.petBreed,
      required this.petType,
      required this.petImage,
      required this.petOwnerID,
      required this.petNotes,
      required this.isActive});

  factory Pet.fromFirestore(DocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Pet(
        petName: data['PetName'],
        petBdate: data['PetBdate'],
        petGender: data['PetGender'],
        petBreed: data['PetBreed'],
        petType: data['PetType'],
        petImage: data['PetImage'],
        petOwnerID: data['PetOwnerID'],
        petNotes: data['PetNotes'],
        isActive: data['IsActive']);
  }

  factory Pet.fromMap(Map<String, dynamic> data) {
    return Pet(
        petName: data['PetName'],
        petBdate: data['PetBdate'],
        petGender: data['PetGender'],
        petBreed: data['PetBreed'],
        petType: data['PetType'],
        petImage: data['PetImage'],
        petOwnerID: data['PetOwnerID'],
        petNotes: data['PetNotes'],
        isActive: data['IsActive']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'PetName': petName,
      'PetBdate': petBdate,
      'PetGender': petGender,
      'PetBreed': petBreed,
      'PetType': petType,
      'PetImage': petImage,
      'PetOwnerID': petOwnerID,
      'PetNotes': petNotes,
      'IsActive': isActive
    };
  }
}
