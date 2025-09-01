import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // widget Scaffold butuh berada di dalam MaterialApp (atau WidgetsApp) supaya ada Directionality, Theme, dll.
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF4F4FB),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4FB), // abu-abu muda modern
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Logo di kiri atas
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  "ConnectID",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7B68EE),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Foto Profil
            CircleAvatar(
              radius: 60,
              backgroundImage: const NetworkImage(
                "https://placehold.co/150x150/7B68EE/FFFFFF?text=Profil",
              ),
            ),

            const SizedBox(height: 20),

            // Nama Pengguna
            Text(
              "Leo Prangs Tobing",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3E3C61), // ungu tua modern
              ),
            ),

            const SizedBox(height: 8),

            // Email
            Text(
              "leo@example.com",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 16),

            // Informasi Tambahan (Row)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF7B68EE)),
                      const SizedBox(width: 6),
                      Text(
                        "Pontianak, Indonesia",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF3E3C61),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF7B68EE),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Bergabung sejak 2024",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF3E3C61),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Bio Singkat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "“Belajar setiap hari, berkembang setiap saat.”",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
