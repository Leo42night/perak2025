void main() {
  try {
    var hasil = 10 ~/ 0; // pembagian nol
    print("Hasil: $hasil");
  } on UnsupportedError {
    print("Tidak bisa membagi dengan nol!");
  } catch (e) {
    print("Terjadi error: $e");
  } finally {
    print("Selesai mencoba operasi.");
  }
}
