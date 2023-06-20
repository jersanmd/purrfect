import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RegisterNewOwnerScreen extends StatefulWidget {
  const RegisterNewOwnerScreen({super.key});

  @override
  State<RegisterNewOwnerScreen> createState() => _RegisterNewOwnerScreenState();
}

class _RegisterNewOwnerScreenState extends State<RegisterNewOwnerScreen> {
  final TextEditingController _phoneCodeEditingController =
      TextEditingController();
  final TextEditingController _phoneNumberEditingController =
      TextEditingController();

  RxInt phoneNumberLength = 1.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _phoneCodeEditingController.text = "+63";
    _phoneNumberEditingController.text = "9";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingStatusBottom(),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Register New Owner'),
          actions: [
            InkWell(
              onTap: () {
                print('New Owner Registering....');
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8, left: 8),
                child: Center(child: Text('Confirm')),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(12),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                  child: const Center(child: Text('Tap to select image')),
                ),
                const Gap(24),
                textFieldFormat('Email address', 'Please enter email address'),
                textFieldFormat('Full name', 'First Last'),
                phoneNumberTextFieldFormat(),
                addressTextField(),
                Row(
                  children: [
                    cityMunicipalityTextField(),
                    postalCodeTextField()
                  ],
                ),
                Row()
              ],
            ),
          ),
        ));
  }

  Widget addressTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('House/Unit/Flr #, Bldg Name, Blk or Lot #'),
          const Gap(4),
          Container(
            width: Get.width,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300, width: 1)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: InputDecoration.collapsed(
                      hintText: 'Please enter exact address'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cityMunicipalityTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 36, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('City/Municipality'),
          const Gap(4),
          Container(
            width: Get.width / 2 - 30,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300, width: 1)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: InputDecoration.collapsed(
                      hintText: 'City/Municipality of the address'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget postalCodeTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Postal Code'),
          const Gap(4),
          Container(
            width: Get.width / 2 - 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300, width: 1)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration:
                      InputDecoration.collapsed(hintText: 'Postal Code'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneNumberTextFieldFormat() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone Number'),
            const Gap(16),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 21,
                            width: 42,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/ph_flag.jpeg'))),
                          ),
                          const Gap(10),
                          Container(
                              alignment: Alignment.center,
                              width: 35,
                              child: TextField(
                                maxLength: 3,
                                keyboardType: TextInputType.number,
                                controller: _phoneCodeEditingController,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    border: InputBorder.none,
                                    enabled: false),
                              )),
                        ],
                      ),
                      Container(
                        width: 90,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: Get.width - 190,
                          child: TextField(
                            onChanged: (value) {
                              phoneNumberLength.value = value.length;
                            },
                            maxLength: 10,
                            controller: _phoneNumberEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              border: InputBorder.none,
                            ),
                          )),
                      Container(
                        width: 200,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }

  Widget textFieldFormat(String title, String placeholder) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const Gap(4),
          Container(
            width: Get.width,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade300, width: 1)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: InputDecoration.collapsed(hintText: placeholder),
                ),
              ),
            ),
          ),
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
        height: 60,
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
