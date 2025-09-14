import 'package:flutter/material.dart';

void main() {
  runApp(const KatalogJurusanApp());
}

class KatalogJurusanApp extends StatelessWidget {
  const KatalogJurusanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katalog Jurusan',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DaftarFakultasPage(),
    );
  }
}

// Data utama
final List<Map<String, dynamic>> daftarFakultas = [
  {
    'nama': 'Fakultas Teknik',
    'icon': Icons.engineering,
    'jurusan': [
      {'nama': 'Teknik Informatika', 'icon': Icons.computer},
      {'nama': 'Teknik Sipil', 'icon': Icons.construction},
      {'nama': 'Teknik Mesin', 'icon': Icons.settings},
      {'nama': 'Teknik Elektro', 'icon': Icons.flash_on},
      {'nama': 'Arsitektur', 'icon': Icons.architecture},
    ],
  },
  {
    'nama': 'Fakultas Ekonomi dan Bisnis',
    'icon': Icons.business,
    'jurusan': [
      {'nama': 'Akuntansi', 'icon': Icons.account_balance},
      {'nama': 'Manajemen', 'icon': Icons.manage_accounts},
      {'nama': 'Ekonomi Pembangunan', 'icon': Icons.show_chart},
    ],
  },
  {
    'nama': 'Fakultas MIPA',
    'icon': Icons.science,
    'jurusan': [
      {'nama': 'Matematika', 'icon': Icons.calculate},
      {'nama': 'Fisika', 'icon': Icons.thermostat},
      {'nama': 'Kimia', 'icon': Icons.biotech},
      {'nama': 'Biologi', 'icon': Icons.eco},
    ],
  },
  {
    'nama': 'Fakultas Ilmu Sosial dan Politik',
    'icon': Icons.groups,
    'jurusan': [
      {'nama': 'Ilmu Komunikasi', 'icon': Icons.chat},
      {'nama': 'Sosiologi', 'icon': Icons.people},
      {'nama': 'Hubungan Internasional', 'icon': Icons.public},
    ],
  },
];

// Halaman 1: Daftar Fakultas
class DaftarFakultasPage extends StatelessWidget {
  const DaftarFakultasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Fakultas')),
      body: ListView.separated(
        itemCount: daftarFakultas.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final fakultas = daftarFakultas[index];
          return ListTile(
            leading: Icon(fakultas['icon']),
            title: Text(fakultas['nama']),
            subtitle: Text('${fakultas['jurusan'].length} Jurusan'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailJurusanPage(
                    namaFakultas: fakultas['nama'],
                    jurusan: List<Map<String, dynamic>>.from(fakultas['jurusan']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Halaman 2: Detail Jurusan
class DetailJurusanPage extends StatelessWidget {
  final String namaFakultas;
  final List<Map<String, dynamic>> jurusan;

  const DetailJurusanPage({
    super.key,
    required this.namaFakultas,
    required this.jurusan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(namaFakultas)),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 kolom
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: jurusan.length,
        itemBuilder: (context, index) {
          final item = jurusan[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'], size: 48, color: Colors.blue),
                const SizedBox(height: 8),
                Text(
                  item['nama'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}