import 'package:flutter/material.dart';

class LocaleDropdown extends StatelessWidget {
  const LocaleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      elevation: 2,
      underline: const SizedBox(),
      icon: Icon(Icons.keyboard_arrow_down_rounded),
      iconSize: 20,
      borderRadius: BorderRadius.circular(10),
      value: Locale('en'),
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('ta'),
          child: Text('தமிழ்'),
        ),
        DropdownMenuItem(
          value: Locale('si'),
          child: Text('සිංහල'),
        ),
      ],
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
        }
      },
    );
  }
}
