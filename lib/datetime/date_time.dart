// Retornamos "hoy"

//Se convierte a String la fecha en formato YYYYMMDD

String getToday() {
  var dateTimeObject = DateTime.now();
  String year = dateTimeObject.year.toString();
  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}

// Convertir el String a objeto DateTime
DateTime createDateTimeObject(String date) {
  int yyyy = int.parse(date.substring(0, 4));
  int mm = int.parse(date.substring(4, 6));
  int dd = int.parse(date.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
}

// Convertir el DateTime a String

String createStringDate(DateTime dateTime) {
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
