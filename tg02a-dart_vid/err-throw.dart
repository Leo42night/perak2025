void cekUmur(int umur) {
  if (umur < 18) {
    throw Exception("Umur harus minimal 18 tahun");
  } else {
    print("Umur valid: $umur tahun");
  }
}

void main() {
  try {
    cekUmur(15);
  } catch (e) {
    print("Error: $e");
  }
}
