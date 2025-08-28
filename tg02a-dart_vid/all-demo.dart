// =============================
// Bagian 1: Dasar Class dan OOP
// =============================

// Class Mobil: contoh class sederhana
class Mobil {
  // Properti (variabel dalam class)
  String warna;
  int kecepatan;

  // Constructor
  Mobil(this.warna, this.kecepatan);

  // Method (fungsi dalam class)
  void maju() {
    print("Mobil $warna melaju dengan kecepatan $kecepatan km/jam");
  }

  void rem() {
    print("Mobil $warna berhenti.");
  }
}

// Class Laptop: contoh constructor + named constructor
class Laptop {
  String merek;
  int ram;

  // Constructor biasa
  Laptop(this.merek, this.ram);

  // Named constructor
  Laptop.khususGaming(String merek) : this(merek, 32);

  void info() {
    print("Laptop $merek dengan RAM $ram GB");
  }
}

// ===================================
// Bagian 2: Konsep Lanjutan OOP
// ===================================

// Inheritance (pewarisan)
class Hewan {
  String nama;
  Hewan(this.nama);

  void suara() {
    print("$nama mengeluarkan suara...");
  }
}

// Kucing mewarisi sifat Hewan
class Kucing extends Hewan {
  Kucing(String nama) : super(nama); // super() memanggil constructor induk

  @override
  void suara() {
    print("$nama mengeong: Meong!");
  }
}

// Abstract Class
abstract class Bentuk {
  void gambar(); // method abstract, tidak memiliki isi
}

class Lingkaran extends Bentuk {
  @override
  void gambar() {
    print("Menggambar Lingkaran...");
  }
}

// Interface menggunakan implements
class BisaTerbang {
  void terbang() {} // method kosong yang wajib diimplementasikan
}

class Pesawat implements BisaTerbang {
  @override
  void terbang() {
    print("Pesawat terbang tinggi di langit!");
  }
}

// Mixin
mixin BisaRenang {
  void renang() => print("Berenang di air...");
}

class Bebek with BisaRenang {
  @override
  void renang() => print("Berenang di air baku...");
} // Bebek menempelkan kemampuan renang

// ===================================
// Bagian 3: Error Handling
// ===================================

void contohErrorHandling() {
  try {
    var hasil = 10 ~/ 0; // Pembagian dengan nol akan error
    print("Hasil: $hasil");
  } on UnsupportedError {
    // Menangani error spesifik
    print("Tidak bisa membagi dengan nol!");
  } catch (e) {
    // Menangani error umum
    print("Terjadi error: $e");
  } finally {
    // Akan selalu dijalankan
    print("Selesai mencoba operasi.");
  }
}

// Melempar kesalahan secara manual
void cekUmur(int umur) {
  if (umur < 18) {
    throw Exception("Umur harus minimal 18 tahun");
  } else {
    print("Umur valid: $umur tahun");
  }
}

// =============================
// Main Program (demo semua)
// =============================
void main() {
  print("=== Bagian 1: Dasar OOP ===");
  // Instansiasi object dari class Mobil
  var mobilMerah = Mobil("Merah", 100);
  mobilMerah.maju();
  mobilMerah.rem();

  // Constructor dan Named Constructor
  var laptop1 = Laptop("Asus", 8);
  var laptop2 = Laptop.khususGaming("MSI");
  laptop1.info();
  laptop2.info();

  print("\n=== Bagian 2: Konsep Lanjutan OOP ===");
  // Inheritance
  var kucing = Kucing("Mimi");
  kucing.suara();

  // Abstract Class
  var lingkaran = Lingkaran();
  lingkaran.gambar();

  // Interface
  var pesawat = Pesawat();
  pesawat.terbang();

  // Mixin
  var bebek = Bebek();
  bebek.renang();

  print("\n=== Bagian 3: Error Handling ===");
  // Try-catch-finally
  contohErrorHandling();

  // Throw exception manual
  try {
    cekUmur(15);
  } catch (e) {
    print("Error: $e");
  }

  try {
    cekUmur(20);
  } catch (e) {
    print("Error: $e");
  }
}
