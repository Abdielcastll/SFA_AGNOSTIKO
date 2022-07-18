import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

class PromotionSwiper extends StatelessWidget {
  const PromotionSwiper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> promotions = [
      'https://blog.magezon.com/wp-content/uploads/2020/08/fashion-banner.png',
      'https://www.feedough.com/wp-content/uploads/2019/07/sales-promotion.png',
      'https://cdn.snov.io/blog/wp-content/uploads/2021/08/Webp.net-resizeimage3.png',
      'https://image.shutterstock.com/image-vector/brush-sale-banner-promotion-ribbon-260nw-1182942766.jpg',
      'http://bloomidea.com/sites/default/files/styles/og_image/public/blog/9_tipos_de_promocoes_que_pode_fazer_numa_loja_online.png?itok=k8-76_yR',
      'https://turboinventory.com/wp-content/uploads/2020/08/5-Types-of-Sales-Promotions.jpg',
      'https://www.edrawsoft.com/templates/images/horizontal-promotion-banner.png',
      'https://c8.alamy.com/comp/2D838G0/black-friday-sales-banners-for-the-promotion-of-your-goods-and-products-a-very-good-and-efficient-sales-banner-for-marketing-your-product-2D838G0.jpg'
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Swiper(
          autoplay: true,
          autoplayDisableOnInteraction: true,
          autoplayDelay: 5000,
          layout: SwiperLayout.STACK,
          itemWidth: 330.0,
          itemHeight: 115.0,
          itemCount: promotions.length,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () {
                  print('promotion tapped');
                },
                child: Image.network(
                  promotions[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
