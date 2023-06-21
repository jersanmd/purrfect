import 'package:cloud_firestore/cloud_firestore.dart';

class Owner {
  final String ownerName;
  final String ownerEmail;
  final String ownerImage;
  final String ownerMobileNo;
  final String ownerAddress;
  final String ownerCity;
  final String ownerZip;
  final String isActive;

  Owner(
      {required this.ownerName,
      required this.ownerEmail,
      required this.ownerImage,
      required this.ownerMobileNo,
      required this.ownerAddress,
      required this.ownerCity,
      required this.ownerZip,
      required this.isActive});

  factory Owner.fromFirestore(DocumentSnapshot<Object?> snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Owner(
        ownerName: data['OwnerName'],
        ownerEmail: data['OwnerEmail'],
        ownerImage: data['OwnerImage'],
        ownerMobileNo: data['OwnerMobileNo'],
        ownerAddress: data['OwnerAddress'],
        ownerCity: data['OwnerCity'],
        ownerZip: data['OwnerZip'],
        isActive: data['IsActive']);
  }

  factory Owner.fromMap(Map<String, dynamic> data) {
    return Owner(
        ownerName: data['OwnerName'],
        ownerEmail: data['OwnerEmail'],
        ownerImage: data['OwnerImage'],
        ownerMobileNo: data['OwnerMobileNo'],
        ownerAddress: data['OwnerAddress'],
        ownerCity: data['OwnerCity'],
        ownerZip: data['OwnerZip'],
        isActive: data['IsActive']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'OwnerName': ownerName,
      'OwnerEmail': ownerEmail,
      'OwnerImage': ownerImage,
      'OwnerMobileNo': ownerMobileNo,
      'OwnerAddress': ownerAddress,
      'OwnerCity': ownerCity,
      'OwnerZip': ownerZip,
      'IsActive': isActive
    };
  }
}
