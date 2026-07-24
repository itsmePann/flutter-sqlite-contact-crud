class Contact {
  int? id;
  String? nama;
  String? phone;

  Contact({
    this.id,
    required this.nama,
    required this.phone
  });

  Contact.fromJson(Map<String, dynamic>json){
    id = json["id"];
    nama = json["nama"];
    phone = json["phone"];
  }

  Map<String, dynamic>toJson(){
    return{
      "id" : id,
      "nama" : nama,
      "phone" : phone
    };
  }
}