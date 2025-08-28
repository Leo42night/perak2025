abstract class Bentuk {
  void gambar(); // method abstract, tidak ada isi
}

class Lingkaran extends Bentuk {
  @override
  void gambar() {
    print("Menggambar Lingkaran...");
  }
}

void main() {
  var lingkaran = Lingkaran(); // membuat object
  lingkaran.gambar(); // memanggil method gambar()
}