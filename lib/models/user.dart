class UserModel {
  String _avatar;
  String _city;
  String _email;
  String _name;
  String _phone;
  String _plateNumber;
  String _street;
  int _timeStamp;
  String _uid;
  String _type;

  String get avatar => _avatar;

  String get city => _city;

  String get email => _email;

  String get name => _name;

  String get phone => _phone;

  String get plateNumber => _plateNumber;

  String get street => _street;

  int get timeStamp => _timeStamp;

  String get uid => _uid;

  String get type => _type;

  UserModel(this._avatar, this._city, this._email, this._name, this._phone, this._plateNumber,
      this._street, this._timeStamp, this._type, this._uid);

  UserModel.map(dynamic obj) {
    this._avatar = obj["Avatar"];
    this._city = obj["City"];
    this._email = obj["Email"];
    this._name = obj["Name"];
    this._phone = obj['Phone'];
    this._plateNumber = obj["Plate Number"];
    this._street = obj["Street"];
    this._timeStamp = obj['Timestamp'];
    this._type = obj["Type"];
    this._uid = obj["Uid"];
  }
}
