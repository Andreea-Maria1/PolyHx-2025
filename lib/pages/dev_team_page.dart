import 'package:flutter/material.dart';

class DevTeamPage extends StatelessWidget {
  const DevTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Équipe Dev'),
      ),
      body: const Center(
        child: Text('This is the team presentation page.'),
      ),
    );
  }
}
