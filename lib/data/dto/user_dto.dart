import '../../utils/equality.dart';
import '../../utils/functional/may_fail.dart';
import '../../utils/json_utils.dart';
import '../model/address.dart';
import '../model/user.dart';

class UserDto extends Equality {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final AddressDto address;
  final CompanyDto company;

  const UserDto._({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  static May<UserDto> fromJson(Json json) {
    return AddressDto.fromJson(json['address']).onSuccess(
      (address) {
        return CompanyDto.fromJson(json['company']).onSuccess(
          (company) {
            return JsonUtils.i.fromJson(
              json,
              (json) {
                return UserDto._(
                  id: json['id'],
                  name: json['name'],
                  username: json['username'],
                  email: json['email'],
                  phone: json['phone'],
                  website: json['website'],
                  address: address,
                  company: company,
                );
              },
            );
          },
        );
      },
    );
  }

  May<User> toModel() {
    return address.toModel().onSuccess(
          (address) => Success(
            User(
              id,
              name,
              username,
              email,
              phone,
              website,
              address,
              company.toModel(),
            ),
          ),
        );
  }

  @override
  List<Object?> get props =>
      [id, name, username, email, phone, website, address, company];
}

class AddressDto extends Equality {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final GeoDto geo;

  const AddressDto._({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  static May<AddressDto> fromJson(Json json) {
    return GeoDto.fromJson(json['geo']).onSuccess(
      (geo) {
        return JsonUtils.i.fromJson(
          json,
          (json) {
            return AddressDto._(
              street: json['street'],
              suite: json['suite'],
              city: json['city'],
              zipcode: json['zipcode'],
              geo: geo,
            );
          },
        );
      },
    );
  }

  May<Address> toModel() {
    return geo.toModel().onSuccess(
          (geo) => Success(
            Address(
              street: street,
              suite: suite,
              city: city,
              zipcode: zipcode,
              geo: geo,
            ),
          ),
        );
  }

  @override
  List<Object?> get props => [street, suite, city, zipcode, geo];
}

class GeoDto extends Equality {
  final String lat;
  final String lng;

  const GeoDto._({
    required this.lat,
    required this.lng,
  });

  static May<GeoDto> fromJson(Json json) {
    return JsonUtils.i.fromJson(
      json,
      (json) {
        return GeoDto._(
          lat: json['lat'],
          lng: json['lng'],
        );
      },
    );
  }

  May<LatLng> toModel() {
    final parsedLat = double.tryParse(lat);
    final parsedLng = double.tryParse(lng);
    final isFail = parsedLat == null || parsedLng == null;
    return isFail ? Fail.of(this) : Success(LatLng(parsedLat, parsedLng));
  }

  @override
  List<Object?> get props => [lat, lng];
}

class CompanyDto extends Equality {
  final String name;
  final String catchPhrase;
  final String bs;

  const CompanyDto._({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  static May<CompanyDto> fromJson(Json json) {
    return JsonUtils.i.fromJson(
      json,
      (json) {
        return CompanyDto._(
          name: json['name'],
          catchPhrase: json['catchPhrase'],
          bs: json['bs'],
        );
      },
    );
  }

  Company toModel() {
    return Company(name, catchPhrase, bs);
  }

  @override
  List<Object?> get props => [name, catchPhrase, bs];
}
