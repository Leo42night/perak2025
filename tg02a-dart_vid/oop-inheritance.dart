class Mobil {
  String warna;
  int kecepatan;

  Mobil(this.warna, this.kecepatan);

  void maju() {
    print("Mobil $warna melaju dengan kecepatan $kecepatan km/jam");
  }
}

class MobilSport extends Mobil {
  MobilSport(String warna, int kecepatan) : super(warna, kecepatan);

  void turbo() {
    print("Mobil sport $warna mengaktifkan turbo! 🚀");
  }
}

void main() {
  var sport = MobilSport("Merah", 200);
  sport.maju();
  sport.turbo();
}
