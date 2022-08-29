// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/examples/teams_example.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FloatingActionButton(
                elevation: 2,
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                backgroundColor: myTheme.colorScheme.primary,
                onPressed: () {
                  // BottomSheetMenu para crear equipos
                },
                child: Icon(
                  AntDesign.addusergroup,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: TeamsBody(),
    );
  }
}

class TeamsBody extends StatefulWidget {
  const TeamsBody({
    Key? key,
  }) : super(key: key);

  @override
  State<TeamsBody> createState() => _TeamsBodyState();
}

class _TeamsBodyState extends State<TeamsBody> {
  List<TeamsExample> listOfTeams = allTeams;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.77,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: ListView.builder(
              itemCount: listOfTeams.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, index) {
                final team = listOfTeams[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(
                      team.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-regular',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              team.zone,
                              style: TextStyle(
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
                              '${team.sellers.length.toString()} miembros',
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
                    onTap: () {
                      // Dialog para ver los teams
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              team.name,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                color: myTheme.colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Container(
                              width: 200,
                              height: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gerente: ${team.manager}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      color: myTheme.colorScheme.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Text(
                                      'Integrantes',
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        color: myTheme.colorScheme.secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    height: 200,
                                    width: 200,
                                    child: ListView.builder(
                                      itemCount: team.sellers.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        final member = team.sellers[index];
                                        return Text(
                                          member,
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: myTheme.colorScheme.primary,
                                            fontSize: 14,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
