import 'package:flutter/material.dart';
import 'package:sqflitecrud/models/contact.dart';
import 'package:sqflitecrud/service.dart/dbHelper.dart';
import 'package:sqflitecrud/ui/entryForm.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController searchController = TextEditingController();

  int count = 0;
  Dbhelper db = Dbhelper();
  List<Contact> hasilData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.brown[200],
        centerTitle: true,
        title: Text("Database Sqlite QRUD"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 18),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    hasilData;
                  } else {
                    cariData(value);
                  }
                },
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: count,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.brown[200],
                          child: Icon(Icons.person),
                        ),
                        title: Text("${hasilData[index].nama}"),
                        subtitle: Text("${hasilData[index].phone}"),
                        trailing: GestureDetector(
                          child: Icon(Icons.delete),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Konfirmasi!!"),
                                  content: Text(
                                    "Apakah yakin ingin menghapus data ${hasilData[index].nama}?",
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(75, 38)
                                          ),
                                          onPressed: () {
                                            deleteContact(hasilData[index]);
                                            Navigator.pop(context);
                                          },
                                          child: Text("Ya"),
                                        ),
                                        SizedBox(width: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Tidak"),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        onTap: () async {
                          var result = await navigateEntryForm(
                            context,
                            hasilData[index],
                          );
                          if (result.nama != null && result.phone != null) {
                            updateContact(result);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[200],
        onPressed: () async {
          var contact = await navigateEntryForm(context, null);
          if (contact.nama != null && contact.phone != null) {
            addContact(contact);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<Contact> navigateEntryForm(
    BuildContext context,
    Contact? contact,
  ) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Entryform(contact)),
    );
    return result;
  }

  void addContact(Contact contact) async {
    var result = await db.insertContact(contact);
    if (result > 0) {
      updateListView();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
          backgroundColor: Colors.green,
          content: Text("Data berhasil ditambah"),
        ),
      );
    }
  }

  void deleteContact(Contact contact) async {
    var result = await db.deleteContact(contact.id!);
    if (result > 0) {
      updateListView();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
          backgroundColor: Colors.red,
          content: Text("Data berhasil dihapus"),
        ),
      );
    }
  }

  void cariData(String keyword) async {
    List<Contact> hasilPencarian = await db.searchKeyword(keyword);
    setState(() {
      hasilData = hasilPencarian;
      count = hasilData.length;
    });
  }

  void updateContact(Contact contact) async {
    var result = await db.updateContact(contact);
    if (result > 0) {
      updateListView();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15),
          backgroundColor: Colors.green,
          content: Text("Data berhasil diupdate"),
        ),
      );
    }
  }

  void updateListView() async {
    List<Contact> result = await db.getAllData();
    setState(() {
      hasilData = result;
      count = hasilData.length;
    });
  }
}
