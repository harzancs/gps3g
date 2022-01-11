class ItemsPosition {
  final String ID;
  final String DATE;
  final String TIME;
  final String TYPE;
  final String RISK;
  final String LATITUDE;
  final String LONGITUDE;
  final String DISTRICT;
  final String PROVINCE;

  ItemsPosition({
    required this.ID,
    required this.DATE,
    required this.TIME,
    required this.TYPE,
    required this.RISK,
    required this.LATITUDE,
    required this.LONGITUDE,
    required this.DISTRICT,
    required this.PROVINCE,
  });

  factory ItemsPosition.fromJson(Map<String, dynamic> json) {
    return ItemsPosition(
      ID: json['id'],
      DATE: json['date'],
      TIME: json['time'],
      TYPE: json['type'],
      RISK: json['risk'],
      LATITUDE: json['latitude'],
      LONGITUDE: json['longitude'],
      DISTRICT: json['district'],
      PROVINCE: json['province'],
    );
  }
}
