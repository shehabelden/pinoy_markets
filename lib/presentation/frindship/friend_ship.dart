import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base/markets_data.dart';
import 'friends_ship_view.dart';

class FriendShip extends StatelessWidget {
  const FriendShip({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketsData>(builder: (context, marketsData, index) {
      marketsData.paymentUserInfo();
      if (marketsData.status == "active") {
        return const FriendShipView();
      } else {
        return const FriendShipView();
      }
    });
  }
}
