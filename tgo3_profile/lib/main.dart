//Interaksi Pengguna & Navigasi Antar Halaman -----class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Halaman Utama')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push( // digunakan untuk berpindah ke halaman lain.
              context, 
              MaterialPageRoute(builder: (context) => DetailPage()),
            ); // MaterialPageRoute mendefinisikan halaman tujuan.
          },
          child: Text('Ke Halaman Detail'),
        ),),);}}
class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Page')),
      body: Center(child: Text('Ini halaman detail')),
    );
  }
}
//Penanganan Input Pengguna -----------------------
class InputExample extends StatefulWidget {
  @override
  _InputExampleState createState() => _InputExampleState();
}
class _InputExampleState extends State<InputExample> {
  final TextEditingController _controller = TextEditingController();
  String hasil = ''; // TextEditingController mengontrol teks input.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Pengguna')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: InputDecoration(labelText: 'Masukkan nama')),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() => hasil = _controller.text);// memperbarui tampilan berdasarkan input pengguna.
              },
              child: Text('Tampilkan'),
            ),
            Text('Halo, $hasil'),
          ],),),);}}

// Membangun List Dinamis & Kelola Koleksi Data ---
class ListDynamic extends StatefulWidget {
  @override
  _ListDynamicState createState() => _ListDynamicState();
}

class _ListDynamicState extends State<ListDynamic> {
  List<String> items = ['Apel', 'Jeruk', 'Mangga'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Dinamis')),
      body: ListView.builder( // membangun list berdasarkan jumlah data.
        itemCount: items.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(items[index]),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => setState(() => items.removeAt(index)),
          ),// setState() digunakan untuk menambah/menghapus item secara dinamis.
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => items.add('Buah Baru')),
        child: Icon(Icons.add),
      ),
    );}}