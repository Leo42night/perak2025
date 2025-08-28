// Mixin memungkinkan kita menempelkan kemampuan tambahan ke class lain
mixin BisaRenang {
  void renang() => print("Berenang di air...");
}

class Bebek with BisaRenang {}

void main() {
  var bebek = Bebek();
  bebek.renang();
}
