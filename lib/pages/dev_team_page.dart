import 'package:flutter/material.dart';
import 'package:geoshield/components/header.dart';

class DevTeamPage extends StatelessWidget {
  const DevTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Header(),
      body: Center(
        child: Text('This is the team presentation page.'),
      ),
    );
  }
}
