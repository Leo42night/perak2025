class Mobil {
  String warna;
  int kecepatan;

  Mobil(this.warna, this.kecepatan);

  void maju() {
    print("Mobil $warna melaju dengan kecepatan $kecepatan km/jam");
  }

  void rem() {
    print("Mobil $warna berhenti.");
  }
}


void main() {
  // Membuat object pertama
  var mobilMerah = Mobil("Merah", 120);
  mobilMerah.maju();
  mobilMerah.rem();

  print(""); // spasi biar lebih rapi outputnya

  // Membuat object kedua
  var mobilBiru = Mobil("Biru", 80);
  mobilBiru.maju();
  mobilBiru.rem();
}
