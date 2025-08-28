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

void main() {
  var laptop1 = Laptop("Asus", 8);
  var laptop2 = Laptop.khususGaming("MSI");

  laptop1.info();
  laptop2.info();
}
