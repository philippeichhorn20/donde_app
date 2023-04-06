
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactFunctions{



  Future<List<String>> getContacts()async{
    return (await FlutterContacts.getContacts()).map((e) => e.phones.first.normalizedNumber).toList();
  }
}