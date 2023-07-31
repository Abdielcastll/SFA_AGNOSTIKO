import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';

class RolesManagerPage extends StatefulWidget {
  const RolesManagerPage({super.key, required this.userZoneDocument});

  final userZoneDocument;

  @override
  State<RolesManagerPage> createState() => _RolesManagerPageState();
}

class _RolesManagerPageState extends State<RolesManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBarNavigation(
        message: 'Roles de Usuario',
        userZoneDocument: widget.userZoneDocument,
      ),
      body: RolesManagerBody(),
    );
  }
}

class RolesManagerBody extends StatefulWidget {
  const RolesManagerBody({
    Key? key,
  }) : super(key: key);

  @override
  State<RolesManagerBody> createState() => _RolesManagerBodyState();
}

class _RolesManagerBodyState extends State<RolesManagerBody> {
  //storage
  bool storageAdd = false;
  bool storageSee = false;
  bool storageDelete = false;
  bool storageEdit = false;
  //Catalogo
  bool catalogueAdd = false;
  bool catalogueSee = false;
  bool catalogueDelete = false;
  bool catalogueEdit = false;
  //Productos
  bool productsAdd = false;
  bool productsSee = false;
  bool productsDelete = false;
  bool productsEdit = false;
  //Facturas
  bool invoicesAdd = false;
  bool invoicesSee = false;
  bool invoicesDelete = false;
  bool invoicesEdit = false;
  //Pedidos
  bool ordersAdd = false;
  bool ordersSee = false;
  bool ordersDelete = false;
  bool ordersEdit = false;
  //Visitas
  bool visitsAdd = false;
  bool visitsSee = false;
  bool visitsDelete = false;
  bool visitsEdit = false;
  //clientes
  bool clientsAdd = false;
  bool clientsSee = false;
  bool clientsDelete = false;
  bool clientsEdit = false;
  //bancos
  bool banksAdd = false;
  bool banksSee = false;
  bool banksDelete = false;
  bool banksEdit = false;
  //promociones
  bool promocionesAdd = false;
  bool promocionesSee = false;
  bool promocionesDelete = false;
  bool promocionesEdit = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.add_box_outlined,
                  color: Colors.grey.shade400,
                ),
                Text(
                  'Agregar',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
                Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.grey.shade400,
                ),
                Text(
                  'Borrar',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: Colors.grey.shade400,
                ),
                Text(
                  'Editar',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
                Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.grey.shade400,
                ),
                Text(
                  'Ver',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Text(
                    'Debt Collector',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                      color: myTheme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Scrollbar(
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 30,
                            child: Text(
                              'Storage',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                color: myTheme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              Icon(
                                Icons.add_box_outlined,
                                color: Colors.grey.shade400,
                              ),
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: storageAdd,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      storageAdd = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.grey.shade400,
                              ),
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: storageDelete,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      storageDelete = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.grey.shade400,
                              ),
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: storageEdit,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      storageEdit = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.grey.shade400,
                              ),
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: storageSee,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      storageSee = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Scrollbar(
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 30,
                            child: Text(
                              'Catalogo',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                color: myTheme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Container(
                            height: 40,
                            child: Checkbox(
                              checkColor: Colors.white,
                              // fillColor: MaterialStateProperty.resolveWith(),
                              value: catalogueAdd,
                              onChanged: (bool? value) {
                                setState(() {
                                  catalogueAdd = value!;
                                });
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            child: Checkbox(
                              checkColor: Colors.white,
                              // fillColor: MaterialStateProperty.resolveWith(),
                              value: catalogueDelete,
                              onChanged: (bool? value) {
                                setState(() {
                                  catalogueDelete = value!;
                                });
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            child: Checkbox(
                              checkColor: Colors.white,
                              // fillColor: MaterialStateProperty.resolveWith(),
                              value: catalogueEdit,
                              onChanged: (bool? value) {
                                setState(() {
                                  catalogueEdit = value!;
                                });
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            child: Checkbox(
                              checkColor: Colors.white,
                              // fillColor: MaterialStateProperty.resolveWith(),
                              value: catalogueSee,
                              onChanged: (bool? value) {
                                setState(() {
                                  catalogueSee = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Scrollbar(
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 30,
                            child: Text(
                              'Productos',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                color: myTheme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: productsAdd,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      productsAdd = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: productsDelete,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      productsDelete = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: productsEdit,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      productsEdit = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: productsSee,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      productsSee = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Scrollbar(
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 30,
                            child: Text(
                              'Facturas',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                color: myTheme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: invoicesAdd,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      invoicesAdd = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: invoicesDelete,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      invoicesDelete = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: invoicesEdit,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      invoicesEdit = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: invoicesSee,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      invoicesSee = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Scrollbar(
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 30,
                            child: Text(
                              'Pedidos',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                color: myTheme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: ordersAdd,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      ordersAdd = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: ordersDelete,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      ordersDelete = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: ordersEdit,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      ordersEdit = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: ordersSee,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      ordersSee = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Scrollbar(
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          Container(
                            width: 90,
                            height: 30,
                            child: Text(
                              'Visitas',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                color: myTheme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: visitsAdd,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      visitsAdd = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: visitsDelete,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      visitsDelete = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: visitsEdit,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      visitsEdit = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 40,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  // fillColor: MaterialStateProperty.resolveWith(),
                                  value: visitsSee,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      visitsSee = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
