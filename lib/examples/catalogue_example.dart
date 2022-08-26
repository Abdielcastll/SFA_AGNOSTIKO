import 'package:flutter/material.dart';

class CatalogueExample {
  final String categorie;
  final String imageUrl;

  CatalogueExample({
    required this.categorie,
    required this.imageUrl,
  });
}

final allCategories = [
  CatalogueExample(
    categorie: 'SABANAS',
    imageUrl:
        'https://s3-alpha-sig.figma.com/img/e635/6704/763efb57dfc709e70cd86f44e10e0021?Expires=1662336000&Signature=Uc~W1GyR1E7tiXkyBUA8SKQ29or-72cygesktvWERYfkpSDbgTPfN9YMTRtsVRltL-rt8uhdZTWfHgUO5eItRPMJybLyV08KAK0zYE3fNGP1SayHh9i0CsgYAY693SEn09Xx54QZXidNzzeUyXNUE-~wJ9yoqkpCsyiSNJZaAGWXE5sfUSWq5O4J6umxY~5dOC12KIZ0Eu56VRAUP-JaurEg3R5NHB8EN4x5qdHdU1gNb0MVhRUdWjZ8A3Tgy0ZeX1a-pZv69HCZF7UA6HjrMwmMQaXkBHuAh1o4wpCJF97Qv5m7hmcU8pZwUjQW~~tSUiwYUkQWWAPT39uXxTFUEQ__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
  ),
  CatalogueExample(
    categorie: 'TOALLA',
    imageUrl:
        'https://s3-alpha-sig.figma.com/img/0d11/bcfd/092ead551cb8998c124740bd05d86c12?Expires=1662336000&Signature=fRLexpaK-4B05I12le~cHe8D2qBIpBmrC0dCMHYlL0MmjZtS7-wZD-gj63N24Je9ztlHgkDTb6L6K8v1DHYHhH0N6uH27CiHQQw7e9oSl7vinwruadEcuVCX107QZu0bgSsCVSDId7ZoonvB639oUb5m6B9dD7X-m8jdhM1TCNwUxxtiQmNmrXtNl3Y~drnV4iCUpDKnBWxLSACmXpI-T49b2uW3QmS8bGsj4gqJI2QPy8ZdOZKXYfKAoyffDflMPrV3jIXhW2fC-1T1wvCimJx1lqFfv2i1~lNVFOKIFy7A-IiaDBnUQrsissOteaNNEFZ~KvimGQnFv8vrhR3p7Q__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
  ),
  CatalogueExample(
    categorie: 'CONSUMIBLES',
    imageUrl:
        'https://s3-alpha-sig.figma.com/img/1fb7/e7de/0e410fd7fb9dd60131d3de2ab770c253?Expires=1662336000&Signature=JjrGDn2M8eSGxRw2mMO4MuWNzLNLK0x3wDA-eJG1O2HNlIBZqQ4-W39YnnY6RQqKVUtp~gUZxbBuDJGITcdYkkXP4lBHJPEKjbdpxMJik-nu4J1yul4cCMJcl48u84WexsCB-Xo4rqqldVkVug7KZJKspYqGLP0oKwwi8wFYBOV9RrmP5eBjyAtSGwO-7lerqDrm86OtdHzfYoCwC~L~dcAjqZa5soReexRxjxJSu07NGZ23PCrs-ClhG9GLmZB9Jmo8dsO34glR4XOv3YmOZgwv5S3GIAroL0CyfWloxCZrpSHxJK6CpqsJErqUFei7OnHBImOKNonLVfIxj9Ky5g__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
  ),
  CatalogueExample(
    categorie: 'LENTES',
    imageUrl:
        'https://s3-alpha-sig.figma.com/img/9213/c188/69520f7526708bcb4c278fd5c9c780e6?Expires=1662336000&Signature=GV1XMoVpW0brpoIzHnEYqcy7FBBgMj4Mlq1xrQgFcZQB46jqxFtgLypm1q0Kq1cxLvSFze~8xUOUHaSy0IGeemK684GBfbfECYnKVQei0g0eKb3W6ImwmXeWdrmQzCKciqbmyWyDwSR8~0K8gftdtul54BzQFrP8rwdWM9bmkn1NkfKHAmGwAS7Y43G1W-sCJnCqqI-8wFY5GIaGVTdT9Y3NUY9RZLZSOJ0kRgcA1wez8pUPn-IrpbWfL48Gz3upS~xpRdgsKCfkhy1875gPnvxFyfIt~w0UqHVm1CgBwLDkPEpze1imUM3MhlKJ7nNq13oqkdggY3iMLE7oUUscRg__&Key-Pair-Id=APKAINTVSUGEWH5XD5UA',
  ),
];
