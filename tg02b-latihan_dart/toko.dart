import 'package:intl/intl.dart';

void main2() {
  main();
}

void main() {
  // List yang berisi beberapa Map, di mana setiap Map adalah satu produk.

  List<Map<String, dynamic>> daftarProduk = [
    {'nama': 'Buku Tulis', 'harga': 5000, 'stok': 20, 'kategori': 'Alat Tulis'},
    {'nama': 'Pensil 2B', 'harga': 2000, 'stok': 50, 'kategori': 'Alat Tulis'},
    {
      'nama': 'Mouse Wireless',
      'harga': 150000,
      'stok': 8,
      'kategori': 'Aksesoris Komputer'
    },
    {
      'nama': 'Keyboard Mechanical',
      'harga': 350000,
      'stok': 4,
      'kategori': 'Aksesoris Komputer'
    },
    {'nama': 'Penghapus', 'harga': 1000, 'stok': 100, 'kategori': 'Alat Tulis'}
  ];

  // --- TULIS KODE JAWABANMU DI BAWAH INI ---
  double total = hitungTotalNilai(daftarProduk);
  var f = NumberFormat('#,##0.00', 'id_ID');
  String hasil = f.format(total);
  print("\n4. Total nilai inventaris Rp. $hasil");

  tampilkanProdukByKategori(daftarProduk, 'Alat Tulis');
}

// --- TULIS FUNGSI-FUNGSI TAMBAHANMU DI SINI ---
double hitungTotalNilai(List<Map<String, dynamic>> daftarProduk) {
  double total = 0;
  for (final produk in daftarProduk) {
    total += (produk['harga'] * produk['stok']);
  }
  return total;
}

void tampilkanProdukByKategori(
    List<Map<String, dynamic>> daftarProduk, String kategori) {
  print("\n5. Produk pertama kategori $kategori: ");
  for (final produk in daftarProduk) {
    if (produk['kategori'] == kategori) {
      print("- ${produk['nama']}");
    }
  }
}
