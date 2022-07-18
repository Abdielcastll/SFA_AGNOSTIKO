// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ClientListView extends StatelessWidget {
  const ClientListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categoriesList = [
      {
        'name': 'Cliente 1',
        'picture':
            'https://www.tophoy.com/wp-content/uploads/2019/06/tienda-zapatos.jpg.webp',
      },
      {
        'name': 'Cliente 2',
        'picture':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnO8le2AWamrna2gmvj1AcxLL5dKXXI_n0Eg&usqp=CAU',
      },
      {
        'name': 'Cliente 3',
        'picture':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrRdQFKgATKJ-5RAVZ-ftSPK6chgGKV579gA&usqp=CAU',
      },
      {
        'name': 'Cliente 4',
        'picture':
            'https://previews.123rf.com/images/sergantstar/sergantstar1504/sergantstar150400121/38668659-amplia-selecci%C3%B3n-de-zapatos-de-mujer-en-la-estanter%C3%ADa-en-la-tienda.jpg?fj=1',
      },
      {
        'name': 'Cliente 5',
        'picture': 'https://www.65ymas.com/uploads/s1/10/57/80/stil-peu.jpeg',
      },
    ];

    return Container(
      color: Colors.grey[200],
      height: 210,
      width: double.infinity,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categoriesList.length,
        itemBuilder: (BuildContext context, int i) {
          final cImg = categoriesList[i];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                _CategoryListViewButton(
                  imgCategory: cImg['picture'],
                  imgName: cImg['name'],
                ),
                // SizedBox(
                //   height: 8.0,
                // ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 8.0),
                //   child: Text(
                //     cImg['name'],
                //     style: TextStyle(
                //       fontSize: 14.0,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryListViewButton extends StatelessWidget {
  const _CategoryListViewButton({
    Key? key,
    required this.imgCategory,
    required this.imgName,
  }) : super(key: key);

  final String imgCategory;
  final String imgName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Redireccionar a Cliente
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            // color: Colors.grey[500],
            height: 180.0,
            width: 150.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                imgCategory,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 160, left: 10),
          child: Text(
            imgName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              // foreground: Paint()
              //   ..style = PaintingStyle.stroke
              //   ..strokeWidth = 2
              //   ..color = Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
