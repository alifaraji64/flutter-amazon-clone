import 'package:amazon_clone/features/account/widgets/account_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(onTap: () {}, text: 'your orders'),
            AccountButton(onTap: () {}, text: 'turn seller')
          ],
        ),
        Row(
          children: [
            AccountButton(onTap: () {}, text: 'Log Out'),
            AccountButton(onTap: () {}, text: 'Your Wish List')
          ],
        )
      ],
    );
  }
}
