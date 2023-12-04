import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Contactos extends StatefulWidget {
  const Contactos({Key? key}) : super(key: key);

  @override
  _ContactosState createState() => _ContactosState();
}

class _ContactosState extends State<Contactos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: () {},
          // ),
        ],
        centerTitle: true,
        title: Text('Contactos'),
      ),
      body: Container(
        child: FutureBuilder(
            future: getContacts(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // Se genera una nueva lista solo con los contactos que cumplen con snapshot.data.phones != null && snapshot.data.isNotEmpty
                // Y que los números sean igual o mayor a 10
                // Y se ordenan de forma alfabética

                List<Contact> contactos = [];
                for (int i = 0; i < snapshot.data.length; i++) {
                  if (snapshot.data[i].phones != null &&
                      snapshot.data[i].phones.isNotEmpty &&
                      snapshot.data[i].phones.first.number.length >= 10) {
                    contactos.add(snapshot.data[i]);
                  }
                }
                contactos
                    .sort((a, b) => a.displayName.compareTo(b.displayName));

                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
                  itemCount: contactos.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        // Se abre la aplicación de mensajes con el número del contacto seleccionado
                        // Se enviará un mensaje que diga "Descarga mi app de Acagym: https://play.google.com/store/apps/details?id=com.acagym.acagym_project"

                        final Uri url = Uri(
                          scheme: 'sms',
                          path: contactos[index].phones.first.number.toString(),
                          query: encodeQueryParameters(
                            <String, String>{
                              'body':
                                  'Descarga mi app de Acagym: https://play.google.com/store/apps/details?id=com.acagym.acagym_project'
                            },
                          ),
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch ${url}';
                        }
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(contactos[index].displayName),
                        subtitle: Text(
                            contactos[index].phones.first.number.toString()),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

Future<List<Contact>> getContacts() async {
  bool isGranted = await Permission.contacts.status.isGranted;
  if (!isGranted) {
    await Permission.contacts.request();
  }
  if (isGranted) {
    return await FastContacts.getAllContacts();
  }
  return [];
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
