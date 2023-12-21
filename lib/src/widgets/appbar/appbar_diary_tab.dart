import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';

class DiaryTabBar extends StatelessWidget implements PreferredSizeWidget {
  const DiaryTabBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      splashBorderRadius: BorderRadius.circular(20),
      splashFactory: InkSplash.splashFactory,
      labelColor: Colors.white,
      indicatorColor: Colors.white,
      unselectedLabelColor: Colors.grey.shade400,

      indicatorWeight: 2,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 30),
      indicatorSize: TabBarIndicatorSize.tab,
      // isScrollable: true,
      // ignore: prefer_const_literals_to_create_immutables
      tabs: [
        if (globalRemoteConfig.visitas == true)
          Tab(text: AppLocalizations.of(context)!.visits),
        Tab(text: AppLocalizations.of(context)!.orders),
        Tab(text: "Pagos"),
        // Tab(text: AppLocalizations.of(context)!.invoices),
      ],
    );
  }
}
