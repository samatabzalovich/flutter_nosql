class UserModel {
  late final String firstName;
  late final String lastName;
  late final String phoneNumber;
  late final String address;
  late final String email;
  late final String password;
  String? id;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.address,
      required this.email,
      required this.password, this.id});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      'email': email,
      'password': password
    };
  }

  UserModel.fromMap(dynamic map) {
    firstName = map['firstName'];
    lastName = map['lastName'];
    phoneNumber = map['phoneNumber'];
    address = map['address'];
    email = map['email'];
    password = map['password'];
  }

  UserModel toEntity() => UserModel(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
        email: email,
        password: password,
      );
}
