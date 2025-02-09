import 'package:flutter/material.dart';
import 'package:geoshield/components/header.dart';
import 'package:google_fonts/google_fonts.dart';

class Credit extends StatelessWidget {
  const Credit({super.key, required this.name});

  final String name;
  final double _fontSize = 36;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/geoshield.png",
                height: 120,
              ),
              const SizedBox(width: 16),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DevTeamPage extends StatelessWidget {
  const DevTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background
      appBar: const Header(),
      body: const DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg.jpg"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Credit(name: "Nacim"),
              Credit(name: "Harry"),
              Credit(name: "Andreea"),
              Credit(name: "Selim"),
            ],
          ),
        ),
      ),
    );
  }
}
