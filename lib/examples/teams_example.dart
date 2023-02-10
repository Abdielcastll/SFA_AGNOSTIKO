import 'package:cloud_firestore/cloud_firestore.dart';

class TeamsExample {
  final bool active;
  final String manager;
  final List sellers;
  final String zone;
  final String name;

  TeamsExample(
      {required this.active,
      required this.manager,
      required this.sellers,
      required this.zone,
      required this.name});
}

List<TeamsExample> allTeams = [
  TeamsExample(
      active: true,
      manager: 'Ana Avila',
      sellers: [
        'Cobrador 1',
        'Vendedor 1',
      ],
      zone: 'TERRITORIO1',
      name: 'Equipo 1'),
  TeamsExample(
      active: true,
      manager: 'Manager 1',
      sellers: [
        'Cobrador 2',
        'Vendedor 2',
      ],
      zone: 'TERRITORIO2',
      name: 'Equipo 2'),
  TeamsExample(
      active: true,
      manager: 'Manager 2',
      sellers: [
        'Cobrador 3',
        'Vendedor 3',
      ],
      zone: 'TERRITORIO3',
      name: 'Equipo 3')
];
