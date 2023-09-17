import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Pesan> dataPesan = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/v1/pesan?limit=1000&offset=0'));
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        dataPesan =
            (data['data'] as List).map((data) => Pesan.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Messages Board'),
        ),
        body: ListView.builder(
          itemCount: dataPesan.length,
          itemBuilder: (context, index) {
            return Card(
              // Mengelilingi setiap item dengan widget Card
              elevation: 3, // Tambahkan bayangan card
              margin: EdgeInsets.all(10), // Tambahkan margin untuk card
              child: ListTile(
                title:
                    Text(dataPesan[index].nama + ' ' + dataPesan[index].email),
                subtitle: Text(dataPesan[index].isi),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Pesan {
  final int id;
  final String nama;
  final String isi;
  final String email;

  Pesan(
      {required this.id,
      required this.nama,
      required this.isi,
      required this.email});

  factory Pesan.fromJson(Map<String, dynamic> json) {
    return Pesan(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      isi: json['isi'],
    );
  }
}
