import '../../utils/equality.dart';

class Address extends Equality {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final LatLng geo;

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  @override
  List<Object?> get props => [street, suite, city, zipcode, geo];
}

class LatLng {
  final double lat;
  final double lng;

  LatLng(this.lat, this.lng);
}
