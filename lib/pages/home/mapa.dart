import 'package:acagym_project/models/localizaciones_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN =
    "pk.eyJ1IjoibWFya2VzaWFubyIsImEiOiJjbHBxajdvaTEwMHczMmtvN3NoaWhldG1wIn0.ngKJEvlPmY9KYFsOQhh1sg";

class MapaPage extends StatefulWidget {
  final void Function(LatLng) onPositionChanged;
  const MapaPage({super.key, required this.onPositionChanged});

  void setMiPosition(LatLng miPosition) {
    _MapaPageState().miPosition = miPosition;
  }

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  // Se manda a llamar a la base de datos todos los registros de la colección de localizaciones de los gimnasios registrados
  Stream<List<LocalizacionesModel>> readLocalizaciones() =>
      FirebaseFirestore.instance.collection('gimnasiosACAGYM').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => LocalizacionesModel.fromJson(doc.data()))
              .toList());

  LatLng? miPosition;

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Debe permitir el acceso a la ubicación',
            ),
          ),
        );
        return Future.error(
            'Debe permitir el acceso a la ubicación'); // TODO: Mejorar
      }
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Debe permitir el acceso a la ubicación',
            ),
          ),
        );
        return Future.error(
            'Debe permitir el acceso a la ubicación'); // TODO: Mejorar
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentPosition() async {
    final position = await determinePosition();
    setState(() {
      miPosition = LatLng(position.latitude, position.longitude);
      super.widget.setMiPosition(LatLng(position.latitude, position.longitude));
      // Llama a la función de devolución de llamada para enviar la posición actualizada
      widget.onPositionChanged(miPosition!);
    });
  }

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return miPosition == null
        ? const Center(child: CircularProgressIndicator())
        : StreamBuilder(
            stream: readLocalizaciones(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error');
              } else if (snapshot.hasData) {
                final localizaciones =
                    snapshot.data as List<LocalizacionesModel>;

                // Escribimos de manera de debbug para ver que se esten obteniendo los datos de la base de datos

                return FlutterMap(
                  options: MapOptions(
                    initialCenter: miPosition!,
                    initialZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: miPosition!,
                          child: SvgPicture.asset(
                            'assets/icons/weight-lifter-svgrepo-com.svg',
                            height: 30,
                            width: 30,
                          ),
                        ),
                        // Se agregan los marcadores de los gimnasios registrados y se verifica que esten activos
                        for (int i = 0; i < localizaciones.length; i++)
                          if (localizaciones[i].status)
                            Marker(
                                width: 50.0,
                                height: 50.0,
                                point: LatLng(localizaciones[i].latitude,
                                    localizaciones[i].longitude),
                                child: SvgPicture.asset(
                                  'assets/icons/gym-near-svgrepo-com.svg',
                                  height: 30,
                                  width: 30,
                                )),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
  }
}
