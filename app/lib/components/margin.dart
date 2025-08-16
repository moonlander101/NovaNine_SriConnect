import 'package:flutter/material.dart';

import '../theme/dimens.dart';

class Margin extends StatelessWidget {
  const Margin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: Dimens.defaultScreenMarginSM);
  }
}