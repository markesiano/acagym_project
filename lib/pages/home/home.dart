import 'package:acagym_project/models/qr_modeL.dart';
import 'package:acagym_project/pages/home/agregar_gimnasio.dart';
import 'package:acagym_project/pages/home/contactos.dart';
import 'package:acagym_project/pages/home/drawer_header.dart';
import 'package:acagym_project/pages/home/mapa.dart';
import 'package:acagym_project/pages/home/qr.dart';
import 'package:acagym_project/pages/home/rutinas.dart';
import 'package:acagym_project/pages/rutinas/listaRutinas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = 'homepage_screen';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  LatLng? miPosition;
  bool? isScanning = false;

  var currentPage = MenuOption.perfil;
  var paginaLabel = "Tus rutinas";
  List<String> paginas = [
    "Tus rutinas",
    "QR",
    "Mapa de gimnasios",
  ];

  void updatePosition(LatLng newPosition) {
    miPosition = newPosition;
  }

  void updateIsScanning(bool newIsScanning) {
    isScanning = newIsScanning;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const RutinasPage(),
      QrPage(),
      MapaPage(
        onPositionChanged: updatePosition,
      ),
    ];
    return Consumer<QrModel>(
      builder: (context, value, child) => Scaffold(
        appBar: appBar(),
        backgroundColor: Colors.white,
        body: _pages[_selectedIndex],
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  MyHeader(),
                  drawerList(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.black,
              activeColor: Colors.black,
              tabBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.all(15),
              gap: 8,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  paginaLabel = paginas[index];
                });
              },
              tabs: const [
                GButton(icon: Icons.fitness_center, text: 'Rutinas'),
                GButton(icon: Icons.qr_code, text: 'QR'),
                GButton(icon: Icons.map, text: 'Mapa'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        paginaLabel,
        style: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
      actions: [
        GestureDetector(
            onTap: () {
              if (paginaLabel == "Tus rutinas") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListaRutinas(),
                  ),
                );
              }
              if (paginaLabel == "Mapa de gimnasios") {
                // Se convierten los datos de la posición actual a double para poder enviarlos a la pantalla de agregar gimnasio
                double latitude = miPosition!.latitude;
                double longitude = miPosition!.longitude;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgregarGimnasio(
                      latitude: latitude,
                      longitude: longitude,
                    ),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent),
              child: (paginaLabel == "Tus rutinas")
                  ? SvgPicture.asset(
                      'assets/icons/add-square-svgrepo-com.svg',
                      height: 30,
                      width: 30,
                    )
                  : (paginaLabel == "QR")
                      ? null
                      : SvgPicture.asset(
                          'assets/icons/add-to-map-svgrepo-com.svg',
                          height: 30,
                          width: 30,
                        ),
            )),
      ],
    );
  }

  Widget drawerList() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              // menuItem(1, 'Perfil', Icons.person,
              //     currentPage == MenuOption.perfil ? true : false),
              menuItem(2, 'Cerrar sesión', Icons.logout,
                  currentPage == MenuOption.cerrarSesion ? true : false),
            ],
          ),
          menuItem(3, 'Invitar a tus amigos', Icons.message_outlined,
              currentPage == MenuOption.invitar ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
        child: InkWell(
      splashColor: Colors.grey[100],
      onTap: () {
        if (id == 1) {
          setState(() {
            currentPage = MenuOption.perfil;
          });
        } else if (id == 2) {
          FirebaseAuth.instance.signOut();
        } else if (id == 3) {
          setState(() {
            currentPage = MenuOption.invitar;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Contactos(),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 20,
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

enum MenuOption { perfil, cerrarSesion, rutinas, qr, mapa, invitar }



  // Column _rutinasSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 20, right: 20),
  //         child: Text(
  //           'Rutinas',
  //           style: TextStyle(
  //               color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 15,
  //       ),
  //       Container(
  //         height: 120,
  //         child: ListView.separated(
  //           itemCount: rutinas.length,
  //           scrollDirection: Axis.horizontal,
  //           padding: EdgeInsets.only(left: 20, right: 20),
  //           separatorBuilder: (context, index) => SizedBox(
  //             width: 25,
  //           ),
  //           itemBuilder: (context, index) {
  //             return Container(
  //               width: 100,
  //               decoration: BoxDecoration(
  //                 color: rutinas[index].boxColor.withOpacity(0.8),
  //                 borderRadius: BorderRadius.circular(15),
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   Container(
  //                     width: 50,
  //                     height: 50,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       shape: BoxShape.circle,
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: SvgPicture.asset(
  //                         rutinas[index].iconPath,
  //                         height: 30,
  //                         width: 30,
  //                       ),
  //                     ),
  //                   ),
  //                   Text(
  //                     rutinas[index].name,
  //                     style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w400),
  //                   )
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }