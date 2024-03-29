import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:donation_flutter/app/modules/home/views/donations_view.dart';
import 'package:donation_flutter/app/modules/home/views/my_paint.dart';
import 'package:donation_flutter/app/modules/home/views/svg_wrapper.dart';
import 'package:donation_flutter/utils/constants.dart';
import 'package:donation_flutter/utils/font_styles.dart';
import 'package:donation_flutter/utils/input_decorations.dart';
import 'package:donation_flutter/utils/remove_scroll_glow.dart';
import 'package:donation_flutter/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final homeController = Get.put(HomeController(), permanent: true);
  final avatarSize = 100.0;

  Widget _avatarPreview() {
    return GetBuilder<HomeController>(
      builder: (_) => Container(
        height: avatarSize,
        width: avatarSize,
        child: _.svgRoot == null
            ? const SizedBox.shrink()
            : Material(
                elevation: 8,
                shape: const CircleBorder(),
                child: CustomPaint(
                  painter: MyPainter(_.svgRoot!, Size(avatarSize, avatarSize)),
                  child: Container(),
                ),
              ),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an account to make a Donation', style: bodySemiBoldBig),
        centerTitle: true,
        backgroundColor: primaryColor,
        
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: ScrollConfiguration(
            behavior: RemoveScrollGlow(),
            child: RefreshIndicator(
              onRefresh: homeController.reloadContract,
              color: primaryColor,
              child: ListView(
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      'Enter your private key',
                      style: bodySemiBold,
                    ),
                  ).paddingOnly(top: 16),
                  TextField(
                    controller: homeController.keyController,
                    decoration: borderedInputDecoration(
                      fillColor: primaryColor,
                      hint: 'Copy private key from Metamask and paste here',
                      icon: const Icon(
                        FontAwesomeIcons.userLock,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: homeController.keyController.clear,
                        icon: const Icon(
                          Icons.clear,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  // MaterialButton(
                  //   onPressed: homeController.initWallet,
                  //   color: primaryColor,
                  //   textColor: Colors.white,
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(32)),
                  //   child: Text(
                  //     'Fetch account details',
                  //     style: bodySemiBoldSmall,
                  //   ).paddingAll(12),
                  // ).paddingSymmetric(vertical: 2),
                  MaterialButton(
                          onPressed: homeController.initWallet,
                          color: primaryColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          child: const Text(
                            'Fetch account details',
                            style: bodySemiBold,
                          ).paddingAll(12),
                        ).paddingSymmetric(vertical: 16, horizontal: 8),
                  Obx(
                    () => homeController.loading.value &&
                            homeController.userAddress.isEmpty
                        ? const ListTileShimmer(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.symmetric(vertical: 8),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => homeController.userAddress.value.isNotEmpty
                        ? ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: const Icon(
                              FontAwesomeIcons.userAlt,
                              color: primaryColor,
                            ),
                            title: const Text(
                              'Account Address',
                              style: bodySemiBold,
                            ),
                            subtitle: Text(
                              homeController.userAddress.value,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => homeController.loading.value &&
                            homeController.userBalance.isEmpty
                        ? const ListTileShimmer(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.symmetric(vertical: 8),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => homeController.userBalance.value.isNotEmpty
                        ? ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: const Icon(
                              FontAwesomeIcons.ethereum,
                              color: primaryColor,
                            ),
                            title: const Text(
                              'Account Balance',
                              style: bodySemiBold,
                            ),
                            subtitle: Text(
                              homeController.userBalance.value,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => homeController.loading.value
                        ? const ListTileShimmer(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.symmetric(vertical: 8),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => homeController.userBalance.value.isNotEmpty &&
                            !homeController.loading.value
                        ? const ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              'Enter Account Name',
                              style: bodySemiBold,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => homeController.userBalance.value.isNotEmpty &&
                            !homeController.loading.value
                        ? TextField(
                            controller: homeController.nameController,
                            decoration: borderedInputDecoration(
                                fillColor: primaryColor,
                                hint: "What's your name?",
                                icon: const Icon(
                                  FontAwesomeIcons.userAstronaut,
                                  color: primaryColor,
                                )),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => homeController.loading.value
                        ? const ProfileShimmer(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.symmetric(vertical: 8),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => homeController.userAddress.value.isNotEmpty &&
                            homeController.userBalance.value.isNotEmpty &&
                            !homeController.loading.value
                        ? Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: homeController.check.value
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.spaceAround,
                              children: [
                                if (!homeController.check.value)
                                  IconButton(
                                      onPressed: () => homeController
                                          .generateSvg(force: true),
                                      icon: const Icon(Icons.refresh)),
                                GestureDetector(
                                    onTap: homeController.check.toggle,
                                    child: _avatarPreview()),
                                if (!homeController.check.value)
                                  IconButton(
                                      onPressed: () {
                                        homeController.check.value = true;
                                      },
                                      icon: const Icon(Icons.check)),
                                if (homeController.check.value)
                                  const SizedBox(
                                    width: 32,
                                  ),
                                if (homeController.check.value)
                                  Expanded(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          title: const Text(
                                            'Address',
                                            style: bodySemiBold,
                                          ),
                                          subtitle: Text(
                                            homeController.userAddress.value,
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          title: const Text(
                                            'Balance',
                                            style: bodySemiBold,
                                          ),
                                          subtitle: Text(
                                            homeController.userBalance.value,
                                          ),
                                        ),
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          title: const Text(
                                            'Account Name',
                                            style: bodySemiBold,
                                          ),
                                          subtitle: Text(
                                            homeController.name.value,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ).paddingAll(16),
                          )
                        : const SizedBox.shrink(),
                  ).paddingOnly(top: 16),
                  
                  Obx(() => (!homeController.loading.value &&
                          homeController.userAddress.value.isNotEmpty &&
                          !homeController.loading.value)
                      ? MaterialButton(
                          onPressed: () => Get.to(() => DonationView()),
                          color: Colors.green,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          child: const Text(
                            'Make your Donation',
                            style: bodySemiBold,
                          ).paddingAll(12),
                        ).paddingSymmetric(vertical: 4, horizontal: 8)
                      : const SizedBox.shrink()),
                  ListTile(
                    title: Text(
                      homeController.message.value,
                      style: bodySemiBold,
                    ),
                  )
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }
}
