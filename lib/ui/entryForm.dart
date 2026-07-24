import 'package:flutter/material.dart';
import 'package:sqflitecrud/models/contact.dart';

class Entryform extends StatefulWidget {
  final Contact? contact;

  const Entryform(this.contact, {super.key});

  @override
  State<Entryform> createState() => _EntryformState();
}

class _EntryformState extends State<Entryform> {
  final GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController hpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!.nama!;
      hpController.text = widget.contact!.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown[200],
        title: widget.contact == null ? Text("Tambah Data") : Text("Edit Data"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "nama wajib diisi!";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Masukkan nama kontak",
                  labelText: "Nama kontak",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: hpController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "No hp wajib diisi";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Masukkan no hp",
                  labelText: "No Hp",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      minimumSize: Size(130, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      if (keyForm.currentState!.validate()) {
                        if (widget.contact == null) {
                          Contact contact = Contact(
                            nama: nameController.text,
                            phone: hpController.text,
                          );
                          Navigator.pop(context, contact);
                        } else {
                          Contact contact = Contact(
                            id: widget.contact!.id,
                            nama: nameController.text,
                            phone: hpController.text,
                          );
                          Navigator.pop(context, contact);
                        }
                      }
                    },
                    child: Text(
                      "Simpan",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Batal",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
