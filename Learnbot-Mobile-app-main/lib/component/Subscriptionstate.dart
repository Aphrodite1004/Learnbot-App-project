import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'dart:async';

class SubcsriptionStatus {
  static Future<bool> subscriptionStatus(
      String sku,
      [Duration duration = const Duration(days: 30),
        Duration grace = const Duration(days: 0)]) async {
    if (Platform.isIOS) {
      var history = await FlutterInappPurchase.instance.getAvailablePurchases();

      for (var purchase in history) {
        if( purchase.productId == sku) return true;
      }
      return false;
    } else if (Platform.isAndroid) {
      var purchases = await FlutterInappPurchase.instance.getPurchaseHistory();

      print(purchases.length);
      for (var purchase in purchases) {
        if (purchase.productId == sku) return true;
      }
      return false;
    }
    throw PlatformException(
        code: Platform.operatingSystem, message: "platform not supported");
  }
}