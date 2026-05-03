import 'package:flutter/material.dart';

enum PaymentMethod { cash, card, mobileMoney, airtelMoney }

extension PaymentMethodInfo on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.mobileMoney:
        return 'Mobile money';
      case PaymentMethod.airtelMoney:
        return 'Airtel money';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.payments_outlined;
      case PaymentMethod.card:
        return Icons.credit_card_outlined;
      case PaymentMethod.mobileMoney:
        return Icons.phone_android_outlined;
      case PaymentMethod.airtelMoney:
        return Icons.phone_iphone_outlined;
    }
  }
}
