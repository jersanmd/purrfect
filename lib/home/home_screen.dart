import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:purrfect/controller/home_screen_controller.dart';
import 'package:purrfect/owner_list_screen/owner_list_screen.dart';
import 'package:purrfect/pet_list_screen/pet_list_screen.dart';
import 'package:purrfect/user_profile_screen/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final icons = <IconData>[
    FluentIcons.collections_24_regular,
    FluentIcons.home_24_regular,
    FluentIcons.people_team_24_regular,
  ];

  HomeScreenController _homeScreenController = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        bottomNavigationBar: Obx(() => _navigationBar()),
        body: PageView(
          controller: _homeScreenController.pageController,
          onPageChanged: (pageNumber) {
            _homeScreenController.selectedIndex.value = pageNumber;
          },
          children: [
            _homePage(),
            const PetListScreen(),
            const OwnerListScreen(),
          ],
        ));
  }

  Widget _homePage() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      primary: true,
      child: SafeArea(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            greetingsAndNotificationRow(),
            searchAndFilterRow(),
            petTypeListsRow(),
            recentPopularSeeAllRow()
          ],
        ),
      ),
    );
  }

  DotNavigationBar _navigationBar() {
    return DotNavigationBar(
        currentIndex: _homeScreenController.selectedIndex.value,
        onTap: (int index) {
          _homeScreenController.selectedIndex.value = index;
          _homeScreenController.pageController.animateToPage(index,
              duration: Duration(seconds: 1), curve: Curves.ease);
        },
        dotIndicatorColor: Colors.black,
        enableFloatingNavBar: true,
        enablePaddingAnimation: true,
        items: [
          DotNavigationBarItem(
            icon: const Icon(FluentIcons.home_24_filled),
            unselectedColor: Colors.grey,
            selectedColor: Colors.black,
          ),
          DotNavigationBarItem(
            icon: const Icon(FluentIcons.animal_dog_24_filled),
            unselectedColor: Colors.grey,
            selectedColor: Colors.black,
          ),
          DotNavigationBarItem(
            icon: const Icon(FluentIcons.people_search_24_filled),
            unselectedColor: Colors.grey,
            selectedColor: Colors.black,
          ),
        ]);
  }

  Widget greetingsAndNotificationRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width - 50,
            child: Row(
              children: const [
                Text(
                  'Hi, ',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text('Riko Sapto',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Spacer(),
                Icon(Icons.notifications_none_outlined)
              ],
            ),
          )
        ],
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

  Widget petTypeListsRow() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        width: Get.width,
        height: 200,
        // color: Colors.red,
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('tbl_pet_type').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 12),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      width: 150,
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                                width: 150,
                                height: 200,
                                fit: BoxFit.cover,
                                imageUrl: documentSnapshot['image']),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Text(
                              '${documentSnapshot['name']}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                        // bottomLeft
                                        offset: Offset(-2, -2),
                                        color: Colors.black12),
                                    Shadow(
                                        // bottomRight
                                        offset: Offset(2, -2),
                                        color: Colors.black12),
                                    Shadow(
                                        // topRight
                                        offset: Offset(2, 2),
                                        color: Colors.black12),
                                    Shadow(
                                        // topLeft
                                        offset: Offset(-2, 2),
                                        color: Colors.black12),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text('No data available.');
            }
          },
        ));
  }

  Widget recentPopularSeeAllRow() {
    return SizedBox(
      width: Get.width,
      // height: 10000,
      child: Padding(
          padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Text(
                    'Popular',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  Spacer(),
                  Text(
                    'See all',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ],
              ),
              const Gap(12),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('tbl_pet')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 3),
                          child: SizedBox(
                            width: Get.width,
                            // height: 450,
                            // color: Colors.blueGrey,
                            child: Column(
                              children: [
                                Container(
                                  width: Get.width,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: documentSnapshot['PetImage']),
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
                                        Icon(Icons.pets_outlined),
                                        Gap(10),
                                        Text(
                                          '${documentSnapshot['PetType']} - ${documentSnapshot['PetBreed']}',
                                          style: TextStyle(fontSize: 16),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today),
                                        Gap(10),
                                        Text(
                                          '${documentSnapshot['PetBdate']}',
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
                                  child: Divider(
                                    color: Colors.grey,
                                  ),
                                ),
                                const Gap(6)
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No data found...');
                  }
                },
              )
            ],
          )),
    );
  }
}
