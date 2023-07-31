class UserExample {
  final bool active;
  final String email;
  final bool isManager;
  final bool isSeller;
  final bool isAdmin;
  final String name;
  final int ci;
  //final rol;
  final String zone;

  UserExample({
    required this.active,
    required this.email,
    required this.isManager,
    required this.isSeller,
    required this.name,
    required this.ci,
    required this.zone,
    required this.isAdmin,
  });
}

List<UserExample> allUsers = [
  UserExample(
    active: true,
    email: 'ana.avila@gmail.com',
    isManager: true,
    isSeller: false,
    name: 'Ana avila',
    ci: 26314578,
    zone: 'TERRITORIO1',
    isAdmin: true,
  ),
  UserExample(
    active: true,
    email: 'manager1@example.com',
    isManager: true,
    isSeller: false,
    name: 'Manager 1',
    ci: 123456,
    zone: 'TERRITORIO1',
    isAdmin: false,
  ),
  UserExample(
    active: true,
    email: 'manager2@example.com',
    isManager: true,
    isSeller: false,
    name: 'Manager 2',
    ci: 123456,
    zone: 'TERRITORIO2',
    isAdmin: false,
  ),
  UserExample(
    active: true,
    email: 'manager3@example.com',
    isManager: true,
    isSeller: false,
    name: 'Manager 3',
    ci: 123456,
    zone: 'TERRITORIO3',
    isAdmin: false,
  ),
  UserExample(
      active: true,
      email: 'seller1@example.com',
      isManager: false,
      isSeller: true,
      name: 'Vendedor 1',
      ci: 123456,
      zone: 'TERRITORIO1',
      isAdmin: false),
  UserExample(
      active: true,
      email: 'seller2@example.com',
      isManager: false,
      isSeller: true,
      name: 'Vendedor 2',
      ci: 123456,
      zone: 'TERRITORIO2',
      isAdmin: false),
  UserExample(
      active: true,
      email: 'seller3@example.com',
      isManager: false,
      isSeller: true,
      name: 'Vendedor 3',
      ci: 123456,
      zone: 'TERRITORIO3',
      isAdmin: false),
  UserExample(
      active: true,
      email: 'debtcollector1@example.com',
      isManager: false,
      isSeller: false,
      name: 'Cobrador 1',
      ci: 123456,
      zone: 'TERRITORIO1',
      isAdmin: false),
  UserExample(
      active: true,
      email: 'debtcollector2@example.com',
      isManager: false,
      isSeller: false,
      name: 'Cobrador 2',
      ci: 123456,
      zone: 'TERRITORIO2',
      isAdmin: false),
  UserExample(
      active: true,
      email: 'debtcollector2@example.com',
      isManager: false,
      isSeller: false,
      name: 'Cobrador 3',
      ci: 123456,
      zone: 'TERRITORIO3',
      isAdmin: false),
];
