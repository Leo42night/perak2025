import 'toko.dart';

double hitungLuasPersegiPanjang(double panjang, double lebar) {
  return panjang * lebar;
}

void cekGanjilGenap(int angka) {
  if(angka % 2 == 0) {
    print('- $angka: GENAP');
  } else {
    print('- $angka: GANJIL');
  }
}

void main() {
  double panjang = 10.5;
  double lebar = 4.0;

  double luas = hitungLuasPersegiPanjang(panjang, lebar);

  // tugas 1
  print("\n1. Luas persegi panjang [$panjang * $lebar] adalah $luas");

  // tugas 2
  var angkas = [7, 12, 99];
  print("\n2. Angka ganjil genap: [${angkas.join(', ')}]");
  for(final angka in angkas) {
    cekGanjilGenap(angka);
  }

  // tugas 3
  print("\n3. Persegi Panjang Dengan Luas $luas");
  int angka = luas.toInt();
  cekGanjilGenap(angka);

  main2();
}