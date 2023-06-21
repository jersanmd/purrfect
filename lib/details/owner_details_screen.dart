import 'package:flutter/material.dart';
import 'package:purrfect/model/owner.dart';

class OwnerDetailsScreen extends StatefulWidget {
  const OwnerDetailsScreen(
      {super.key, required this.ownerId, required this.owner});

  final String ownerId;
  final Owner owner;

  @override
  State<OwnerDetailsScreen> createState() => _OwnerDetailsScreenState();
}

class _OwnerDetailsScreenState extends State<OwnerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('Owner Details'),
      ),
      body: SafeArea(
        child: Column(children: []),
      ),
    );
  }
}
