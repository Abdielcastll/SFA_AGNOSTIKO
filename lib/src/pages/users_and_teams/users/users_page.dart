import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/examples/usesrs_example.dart';
import 'package:pwa_sales2go_flutter/src/pages/role_manager/role_manager.dart';
import 'package:pwa_sales2go_flutter/src/pages/users_and_teams/users/new_user/new_user_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({
    Key? key,
    required this.userZoneDocument,
  }) : super(key: key);

  final userZoneDocument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FloatingActionButton(
                elevation: 2,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                backgroundColor: myTheme.colorScheme.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const NewUserPage(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FloatingActionButton(
                heroTag: '2',
                elevation: 0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                backgroundColor: myTheme.colorScheme.secondary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          RolesManagerPage(userZoneDocument: userZoneDocument),
                    ),
                  );
                },
                child: const Icon(
                  Icons.manage_accounts,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: const UserBody(),
    );
  }
}

class UserBody extends StatefulWidget {
  const UserBody({
    Key? key,
  }) : super(key: key);

  @override
  State<UserBody> createState() => _UserBodyState();
}

class _UserBodyState extends State<UserBody> {
  List<UserExample> listOfUsers = allUsers;

  identifyCharge(isManager, isAdmin, isSeller) {
    if (isAdmin == true) {
      return 'Administrador';
    } else if (isManager == true && isAdmin == false && isSeller == false) {
      return 'Gerente';
    } else if (isManager == false && isAdmin == false && isSeller == true) {
      return 'Vendedor';
    } else {
      return 'Cobrador';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.76,
            alignment: Alignment.center,
            child: ListView.builder(
              itemCount: listOfUsers.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, index) {
                final user = listOfUsers[index];
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'CI: ${user.ci}',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontFamily: 'Poppins-regular',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              user.email,
                              style: const TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            width: 100,
                            child: Text(
                              identifyCharge(
                                  user.isManager, user.isAdmin, user.isSeller),
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 12,
                                color: Colors.purple.shade500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
