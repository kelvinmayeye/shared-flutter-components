import 'package:flutter/material.dart';
// import 'package:google_ui/google_ui.dart';

import 'package:shared_component/shared_component.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'loading_environment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initApp(
      appName: 'Shared Components',
      loadEnvFile: () async {
        // debugDisableShadows = true;
        await loadingInvironment(
            devEnvFile: ".env.development", prodEnvFile: ".env.production");
      },
      routes: [
        ChildRoute('/landing',
            child: (context, args) => SideNavigation(
                  appBarPosition: AppBarPosition.side,
                  version: '2.0.3',
                  topAppBarDetails: TopAppBarDetails(
                      title: 'Top Bar',
                      menuItems: [
                        MenuItem<String>(
                            title: 'Change Password',
                            icon: Icons.logo_dev,
                            value: 'password'),
                        MenuItem<String>(
                            title: 'Profile',
                            icon: Icons.details,
                            value: 'profile'),
                      ],
                      onTap: (value) {},
                      userProfileDetails: UserProfileItem(
                          onLogout: () {
                            SettingsService.use
                                .logout(Modular.initialRoute, context);
                          },
                          email: 'Jimmysonblack@gmail.com',
                          userName: 'Jimmyson Jackson Mnunguri')),
                  sideMenuTile: [
                    SideMenuTile(
                        title: 'Dashboard',
                        icon: Icons.dashboard,
                        permissions: ['ACCESS_BILLS']),
                    SideMenuTile(
                        title: 'Users',
                        icon: Icons.people,
                        permissions: ['ACCESS_ROLE', 'ACCESS']),
                    SideMenuTile(
                        title: 'Facility', icon: Icons.abc, permissions: []),
                  ],
                  body: const UserManager(),
                ),
            guards: [AuthGuard()]),

        ChildRoute('/login',
            child: (context, args) => Login(
                navigateTo: 'landing',
                backgroundTheme: BackgroundTheme.techTheme)),

        RedirectRoute(Modular.initialRoute, to: 'login')

        // ChildRoute('tiles',
        //     child: (context, args) => TilesSearch(
        //           showGradient: true,
        //           // gradientColors: [Colors.grey, Colors.yellow],
        //           titleColor: Colors.white,

        //           // tileColor: Colors.brown,
        //           tileFields: [
        //             TileFields(
        //                 icon: Icons.login,
        //                 title: 'Logout',
        //                 url: '/login',
        //                 permissions: ['John']),
        //             TileFields(
        //                 icon: Icons.people,
        //                 title: 'User Management',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.car_crash,
        //                 title: 'Repair',
        //                 url: '/login',
        //                 permissions: ['David', 'Juma']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: ['Mary']),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: []),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: []),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: []),
        //             TileFields(
        //                 icon: Icons.timer_off,
        //                 title: 'Taiwan',
        //                 url: '/login',
        //                 permissions: []),
        //           ],
        //         )),

        // ChildRoute('/login',
        //     child: (context, args) => Login(
        //           backgroundTheme: BackgroundTheme.techTheme,
        //           navigateTo: '',
        //         ))
      ]);
}

Map<int, Color> colorMap = {
  50: const Color.fromRGBO(147, 205, 72, .1),
  100: const Color.fromRGBO(147, 205, 72, .2),
  200: const Color.fromRGBO(147, 205, 72, .3),
  300: const Color.fromRGBO(147, 205, 72, .4),
  400: const Color.fromRGBO(147, 205, 72, .5),
  500: const Color.fromRGBO(147, 205, 72, .6),
  600: const Color.fromRGBO(147, 205, 72, .7),
  700: const Color.fromRGBO(147, 205, 72, .8),
  800: const Color.fromRGBO(147, 205, 72, .9),
  900: const Color.fromRGBO(147, 205, 72, 1),
};

class UsersWidget extends StatelessWidget {
  const UsersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageableDataTable(
      endPointName: 'getUsers',
      queryFields: "name email uid",
      // mapFunction: (item) => {'userName': item['name']},
      deleteEndPointName: 'deleteUser',
      deleteUidFieldName: 'userUid',
      actionButtons: [
        ActionButtonItem(
            icon: Icons.edit_document,
            name: 'Edit User',
            onPressed: (value) {
              saveAndUpdateUser(context, value);
            })
      ],
      tableAddButton: TableAddButton(
          onPressed: () {
            saveAndUpdateUser(context, null);
          },
          buttonName: 'Create User'),
      topActivityButtons: [
        TopActivityButton(
            onTap: () {
              saveAndUpdateUser(context, null);
            },
            buttonName: 'Create User',
            // iconData: Icons.create,
            toolTip: 'Adding new User'),
      ],
      headColumns: [
        HeadTitleItem(
          titleKey: 'name',
          titleName: 'User Name',
        ),
        HeadTitleItem(
          titleKey: 'email',
          titleName: 'Email Address',
        ),
      ],
    );
  }

  saveAndUpdateUser(context, data) {
    PopupModel(
        buildContext: context,
        buttonLabel: 'Save User',
        checkUnSavedData: true,
        endpointName: 'saveUser',
        title: 'Create User',
        queryFields: 'uid',
        formGroup: FormGroup(
          updateFields: data,
          group: [
            Group(children: [
              Field.use.input(
                context: context,
                label: 'Fullname',
                key: 'fullName',
                validate: true,
                // fieldInputType: FieldInputType
              ),
              Field.use.input(
                  context: context,
                  label: 'Description',
                  key: 'description',
                  validate: true,
                  fieldInputType: FieldInputType.FullName),
              Field.use.input(
                  context: context,
                  label: 'Imail',
                  key: 'email',
                  validate: true,
                  fieldInputType: FieldInputType.EmailAddress),
            ])
          ],
        )).show();
  }

  setRoles(context, data) {
    PopupModel(
        buildContext: context,
        title: 'Set Permission to ${data['name']}',
        formGroup: const FormGroup(
          group: [
            Group(children: [
              PermissionSettings(
                endPointName: 'savePermissions',
                roleUid: '',
              )
            ])
          ],
        )).show();
  }
}


// const ExpansionTileCard(
//   initialElevation: 1,
//   title: Text('Card title'),
//   subtitle: Text('Subtitle'),
//   leading: Icon(Icons.data_thresholding_sharp),
//   children: [
//     Divider(
//       height: 1,
//       thickness: 1,
//     ),
//     ListTile(
//       title: Text('Title'),
//       subtitle: Text('Subtitle'),
//     ),
//     ListTile(
//       title: Text('Title1'),
//       subtitle: Text('Subtitle1'),
//     ),
//     ListTile(
//       title: Text('Title2'),
//       subtitle: Text('Subtitle2'),
//     ),
//   ],
// );



