class BisaTerbang {
  void terbang() {}
}

class Pesawat implements BisaTerbang {
  @override
  void terbang() {
    print("Pesawat terbang tinggi di langit!");
  }
}
// Dengan implements, 
// sebuah class dipaksa untuk mengimplementasikan method dari interface

void main() {
  var pesawat = Pesawat();
  pesawat.terbang();
}