import 'package:flutter/material.dart';

class PrestasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 100,
                color: Colors.amber,
              ),
              SizedBox(height: 20),
              Text(
                'Prestasi Kami',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Berikut adalah daftar prestasi yang telah diraih:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Tambahkan daftar prestasi di sini
              Expanded(
                child: ListView.builder(
                  itemCount: 5, // Misalnya, ada 5 prestasi
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Icon(Icons.star, color: Colors.amber),
                        title: Text('Prestasi ${index + 1}'),
                        subtitle: Text('Deskripsi singkat mengenai prestasi ${index + 1}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
