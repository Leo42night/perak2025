class AkunBank {
  // Properti private (tidak bisa langsung diakses dari luar file)
  double _saldo = 0;

  // Method public untuk akses saldo
  double getSaldo() => _saldo;

  void setor(double jumlah) {
    _saldo += jumlah;
    print("Setor Rp$jumlah, saldo sekarang: Rp$_saldo");
  }

  void tarik(double jumlah) {
    if (jumlah <= _saldo) {
      _saldo -= jumlah;
      print("Tarik Rp$jumlah, saldo sekarang: Rp$_saldo");
    } else {
      print("Saldo tidak cukup!");
    }
  }
}

void main() {
  var akun = AkunBank();
  akun.setor(500000);
  akun.tarik(200000);

  // print(akun._saldo); ❌ error karena _saldo bersifat private
  print("Saldo akhir: Rp${akun.getSaldo()}");
}
