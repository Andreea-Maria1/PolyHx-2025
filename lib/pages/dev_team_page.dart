import 'package:flutter/material.dart';
import 'package:geoshield/components/header.dart';
import 'package:google_fonts/google_fonts.dart';

class Credit extends StatelessWidget {
  const Credit({super.key, required this.firstName, required this.lastName});

  final String firstName;
  final String lastName;
  final double _fontSize = 20; // Taille ajustée

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 0.9;
        if (cardWidth > 500) cardWidth = 500; // Limite max

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Image.asset(
                      "assets/geoshield.png",
                      height: 85,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: firstName,
                            style: GoogleFonts.poppins(
                              fontSize: _fontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const TextSpan(text: " "),
                          TextSpan(
                            text: lastName,
                            style: GoogleFonts.poppins(
                              fontSize: _fontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DevTeamPage extends StatelessWidget {
  const DevTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const Header(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: const SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    Credit(firstName: "Nacim", lastName: "BOURELAM"),
                    Credit(firstName: "Harry", lastName: "LAW-YEN"),
                    Credit(firstName: "Andreea", lastName: "GHIOLTAN"),
                    Credit(firstName: "Selim", lastName: "LAKEHAL"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
