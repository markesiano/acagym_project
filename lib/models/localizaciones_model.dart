class LocalizacionesModel {
  String nombre;
  double latitude;
  double longitude;
  bool status;

  LocalizacionesModel({
    required this.nombre,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory LocalizacionesModel.fromJson(Map<String, dynamic> json) =>
      LocalizacionesModel(
        nombre: json["nombre"],
        latitude: double.parse(json["latitude"].toString()),
        longitude: double.parse(json["longitude"].toString()),
        status: bool.parse(json["status"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
      };
}
