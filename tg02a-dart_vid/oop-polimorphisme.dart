// Method maju() bisa punya bentuk berbeda di class turunan.
class Mobil {
  String warna;
  Mobil(this.warna);

  void maju() {
    print("Mobil $warna melaju biasa...");
  }
}

class MobilSport extends Mobil {
  MobilSport(String warna) : super(warna);

  @override
  void maju() {
    print("Mobil sport $warna melaju super cepat! 🚀");
  }
}

class MobilListrik extends Mobil {
  MobilListrik(String warna) : super(warna);

  @override
  void maju() {
    print("Mobil listrik $warna melaju dengan senyap ⚡");
  }
}

void main() {
  List<Mobil> garasi = [
    Mobil("Biru"),
    MobilSport("Merah"),
    MobilListrik("Putih")
  ];

  for (var m in garasi) {
    m.maju(); // setiap object punya bentuk perilaku sendiri (polimorfisme)
  }
}