// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_component/shared_component.dart';

import '../../themes/theme.dart';
import 'helper-classes.dart';
import 'role-list-widget.dart';
import 'selected-roles-widget.dart';
import 'user-roles-controller.dart';
import 'package:intl/intl.dart';

class DetailCard extends StatefulWidget {
  final double height;
  final double width;
  final bool showDetails;
  final bool shakeIt;
  final String userUid;
  final LoggedInUserDetails? loggedInUserDetails;
  final Map<String, dynamic> user;
  final UserDetails? userDetails;
  final Function() onDeleteUser;

  final Function(Map<String, dynamic> data) onEditUser;
  const DetailCard(
      {super.key,
      required this.height,
      required this.userUid,
      this.userDetails,
      required this.user,
      this.loggedInUserDetails,
      required this.width,
      required this.shakeIt,
      required this.onEditUser,
      required this.onDeleteUser,
      required this.showDetails});

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  List<Map<String, dynamic>> selectedList = [];

  bool animateSelected = false;
  bool animateRoleList = false;
  Map<String, dynamic> selectedData = {};
  UserRolesController controller = Get.put(UserRolesController());
  double? userDetailHeight;
  double? roleDetailHeight;
  double opacityLevel = 1.0;
  Curve curves = Curves.easeInToLinear;
  int duration = 500;

  bool deleteUserLoader = false;
  bool resetUserLoader = false;
  bool saveUserLoader = false;

  @override
  void initState() {
    controller.getUserRolesByUser(widget.userUid, context);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        width: widget.width,
        curve: Curves.fastOutSlowIn,
        child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: widget.shakeIt ? 0.8 : 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: SizedBox(
                  child: AnimatedCrossFade(
                      firstChild: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: SizedBox(
                            height: widget.height,
                            // width: width,
                            child:
                                LayoutBuilder(builder: (context, constraint) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor:
                                                ThemeController.getInstance()
                                                    .darkMode(
                                                        darkColor:
                                                            Colors.white24,
                                                        lightColor:
                                                            Colors.black12),
                                            child: Icon(
                                              Icons.person,
                                              size: 60,
                                              color:
                                                  ThemeController.getInstance()
                                                      .darkMode(
                                                          darkColor:
                                                              Colors.white38,
                                                          lightColor:
                                                              Colors.black26),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    widget.userDetails
                                                            ?.fullName ??
                                                        ' Name Not Available',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            color: ThemeController
                                                                    .getInstance()
                                                                .darkMode(
                                                                    darkColor:
                                                                        Colors
                                                                            .white54,
                                                                    lightColor:
                                                                        Colors
                                                                            .grey)),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Tooltip(
                                                    message: 'Edit User',
                                                    child: IconButton(
                                                        onPressed: () =>
                                                            widget.onEditUser(
                                                                widget.user),
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color:
                                                              Colors.red[500],
                                                        )),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                '${widget.userDetails?.email ?? ' Not Available'}  |  ${widget.userDetails?.phone ?? 'Not Provided'}',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                widget.userDetails?.region ??
                                                    'Not Provided',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          deleteUserLoader
                                              ? Container(
                                                  width: 150,
                                                  alignment: Alignment.center,
                                                  child: IndicateProgress
                                                      .circular())
                                              : TextButton(
                                                  style: TextButton.styleFrom(
                                                    fixedSize:
                                                        const Size(150, 40),
                                                    // shadowColor: Colors.black,
                                                    foregroundColor:
                                                        ThemeController
                                                                .getInstance()
                                                            .darkMode(
                                                                darkColor: Colors
                                                                    .white54,
                                                                lightColor: Colors
                                                                    .black87),
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.3),
                                                  ),
                                                  onPressed: () {
                                                    deleteUser(widget.userUid);
                                                  },
                                                  child: const Text(
                                                      'Delete User')),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          resetUserLoader
                                              ? Container(
                                                  width: 150,
                                                  alignment: Alignment.center,
                                                  child: IndicateProgress
                                                      .circular(),
                                                )
                                              : TextButton(
                                                  style: TextButton.styleFrom(
                                                    fixedSize:
                                                        const Size(150, 40),
                                                    // shadowColor: Colors.black,
                                                    foregroundColor:
                                                        ThemeController
                                                                .getInstance()
                                                            .darkMode(
                                                                darkColor: Colors
                                                                    .white54,
                                                                lightColor: Colors
                                                                    .black87),
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                                255,
                                                                54,
                                                                209,
                                                                244)
                                                            .withOpacity(0.3),
                                                  ),
                                                  onPressed: () {
                                                    resetUser(widget.userUid);
                                                  },
                                                  child: const Text(
                                                      'Reset Password')),
                                        ],
                                      ),
                                    ],
                                  ),

                                  ///IS LOCKED ACTION
                                  SizedBox(
                                    height: constraint.maxHeight * 0.05,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'User is Locked',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Switch.adaptive(
                                          value: widget.userDetails?.isLoked ??
                                              false,
                                          onChanged: (value) => widget
                                              .userDetails
                                              ?.onLocked(value))
                                    ],
                                  ),
                                  const Divider(),

                                  ///USER ACCESS ACTIONS
                                  SizedBox(
                                    height: constraint.maxHeight * 0.02,
                                  ),
                                  AnimatedOpacity(
                                    curve: curves,
                                    duration: Duration(milliseconds: duration),
                                    opacity: opacityLevel,
                                    child: AnimatedContainer(
                                      curve: curves,
                                      duration:
                                          Duration(milliseconds: duration),
                                      height: userDetailHeight ??
                                          constraint.maxHeight * 0.3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'User Access Actions',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),

                                                  ///USER DISABLED
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'User Is Disabled',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium,
                                                      ),
                                                      Checkbox(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        onChanged: (value) =>
                                                            widget
                                                                .userDetails
                                                                ?.onDisabled(
                                                                    value!),
                                                        value: widget
                                                                .userDetails
                                                                ?.disabled ??
                                                            false,
                                                      )
                                                    ],
                                                  ),

                                                  ///PASSWORD CAN EXPIRE
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'User Password Can Expire',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium,
                                                      ),
                                                      Checkbox(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        onChanged: (value) => widget
                                                            .userDetails
                                                            ?.onPasswordCanExpire(
                                                                value!),
                                                        value: widget
                                                                .userDetails
                                                                ?.passwordCanExpire ??
                                                            false,
                                                      )
                                                    ],
                                                  ),

                                                  ///IF PASSWORD EXPIRED
                                                  widget.userDetails
                                                              ?.passwordExpired ==
                                                          false
                                                      ? Text(
                                                          'Password Expired',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .labelSmall
                                                              ?.copyWith(
                                                                  color: Colors
                                                                          .red[
                                                                      400]),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 100,
                                            width: 1,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                  color: ThemeController
                                                          .getInstance()
                                                      .darkMode(
                                                          darkColor:
                                                              Colors.white38,
                                                          lightColor:
                                                              Colors.black38)),
                                            ),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Last Login',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                            'MMM d, yyyy HH:mm')
                                                        .format(DateTime.parse(widget
                                                                .loggedInUserDetails
                                                                ?.lastLogin ??
                                                            '2022-03-27 0814')),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Logged In Device',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    widget.loggedInUserDetails ==
                                                            null
                                                        ? 'Not Provided'
                                                        : '${widget.loggedInUserDetails?.loggedInDevice?.devicename} | Mac: ${widget.loggedInUserDetails?.loggedInDevice?.macAddress} | OS: ${widget.loggedInUserDetails?.loggedInDevice?.operatingSystem} | IP: ${widget.loggedInUserDetails?.loggedInDevice?.ipAddress}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Last Logged In Location',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    widget.loggedInUserDetails
                                                            ?.lastLoginLocation ??
                                                        'Not Provided',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Authenticated Divice',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    widget.loggedInUserDetails ==
                                                            null
                                                        ? 'Not Provided'
                                                        : '${widget.loggedInUserDetails?.authenticatedDevice?.devicename} | Mac: ${widget.loggedInUserDetails?.authenticatedDevice?.macAddress} | OS: ${widget.loggedInUserDetails?.authenticatedDevice?.operatingSystem} | IP: ${widget.loggedInUserDetails?.authenticatedDevice?.ipAddress}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraint.maxHeight * 0.02,
                                  ),
                                  const Divider(),

                                  SizedBox(
                                    height: constraint.maxHeight * 0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Role Section',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      TextButton(
                                          style: TextButton.styleFrom(
                                            fixedSize: const Size(150, 40),
                                            // shadowColor: Colors.black,
                                            foregroundColor:
                                                ThemeController.getInstance()
                                                    .darkMode(
                                                        darkColor:
                                                            Colors.white54,
                                                        lightColor:
                                                            Colors.black87),
                                            backgroundColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.3),
                                          ),
                                          onPressed: () {},
                                          child: const Text('Save Changes')),
                                    ],
                                  ),
                                  Flexible(
                                    child: AnimatedContainer(
                                      curve: curves,
                                      duration:
                                          Duration(milliseconds: duration),
                                      height: roleDetailHeight,
                                      child: MouseRegion(
                                        onEnter: (value) {
                                          setState(() {
                                            roleDetailHeight =
                                                constraint.maxHeight * 0.8;
                                            userDetailHeight =
                                                constraint.maxHeight * 0.03;
                                            opacityLevel = 0;
                                          });
                                        },
                                        onExit: (value) {
                                          setState(() {
                                            userDetailHeight = null;
                                            roleDetailHeight = null;
                                            opacityLevel = 1.0;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: RolesListWidget(
                                                animate: selectedData,
                                                onSearch: (searchKey) {
                                                  var roleList =
                                                      controller.storedRoles;
                                                  setState(() {
                                                    if (searchKey.isNotEmpty) {
                                                      controller.unAssignedRoleList = roleList
                                                          .where((element) => element[
                                                                  'name']
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(searchKey
                                                                  .toLowerCase()))
                                                          .toList();
                                                    }
                                                  });
                                                },
                                                roleList: controller
                                                    .unAssignedRoleList,
                                                onSelected: (data) {
                                                  controller.assgnedRoleList
                                                      .add(data);
                                                  controller.unAssignedRoleList
                                                      .remove(data);
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: Obx(() {
                                                return SelectedRoleWidget(
                                                  animate: selectedData,
                                                  selectedList: controller
                                                      .assgnedRoleList.value,
                                                  onDelete: (data) {
                                                    controller.assgnedRoleList
                                                        .remove(data);
                                                    controller
                                                        .unAssignedRoleList
                                                        .insert(0, data);
                                                    setState(() {});
                                                  },
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                      secondChild: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: widget.height,
                          ),
                        ),
                      ),
                      crossFadeState: widget.showDetails
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 1000)),
                ),
              );
            }));
  }

  deleteUser(String userUid) {
    // deleteUserLoader = true;
    NotificationService.confirmWarn(
        context: context,
        title: 'You\'re Deleting This User!',
        content: 'Are You Sure?',
        cancelBtnText: 'No',
        confirmBtnText: 'Yes',
        buttonColor: const Color.fromARGB(172, 243, 92, 81),
        showCancelBtn: true,
        onConfirmBtnTap: () {
          setState(() {
            deleteUserLoader = true;
          });
          Navigator.pop(NavigationService.navigatorKey.currentContext!, true);
          GraphQLService.mutate(
              successMessage: 'User is deleted Successfully',
              response: (value, loader) {
                setState(() {
                  deleteUserLoader = loader;
                  if (value != null) {
                    controller.getUsers(context,
                        updateUserList: true, removeUserUid: widget.userUid);
                    widget.onDeleteUser();
                  }
                });
              },
              endPointName: 'deleteUser',
              queryFields: 'uid',
              inputs: [
                InputParameter(
                    fieldName: 'userUid',
                    inputType: 'String',
                    fieldValue: userUid)
              ],
              context: context);
        });
  }

  resetUser(String userUid) {
    NotificationService.confirmInfo(
        context: context,
        title: 'Are You Sure?',
        content:
            'You\'re about to reset a password for this user! \n Do you want to Proceed??',
        cancelBtnText: 'No',
        confirmBtnText: 'Yes',
        showCancelBtn: true,
        onConfirmBtnTap: () {
          setState(() {
            resetUserLoader = true;
          });
          Navigator.pop(NavigationService.navigatorKey.currentContext!, true);
          GraphQLService.mutate(
              successMessage: 'Reset Completed Successfully',
              response: (data, loader) {
                setState(() {
                  resetUserLoader = loader;
                  if (data != null) {
                    NotificationService.info(
                        center: true,
                        context: context,
                        title: data['data']['otp'],
                        content:
                            'One Time Password (OTP) can only be used once and can expire after 30 minutes');
                  }
                });
              },
              endPointName: 'resetPassword',
              queryFields: 'uid otp',
              inputs: [
                InputParameter(
                    fieldName: 'userUid',
                    inputType: 'String',
                    fieldValue: userUid)
              ],
              context: context);
        });
  }

  saveChanges() {}
}
