import 'dart:convert';

class Usuario {
  bool online;
  String name;
  String email;
  String uid;
  String description;
  String photoUrl;
  List<Usuario> friends;

  Usuario({
    this.online,
    this.name,
    this.email,
    this.uid,
    this.description,
    this.photoUrl,
    this.friends,
  });

  @override
  String toString() {
    return 'Usuario(online: $online, name: $name, email: $email, uid: $uid, description: $description, photoUrl: $photoUrl, friends: $friends)';
  }

  Map<String, dynamic> toMap() {
    return {
      'online': online,
      'name': name,
      'email': email,
      'uid': uid,
      'description': description,
      'photoUrl': photoUrl,
      'friends': friends?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Usuario(
      online: map['online'],
      name: map['name'],
      email: map['email'],
      uid: map['uid'],
      description: map['description'],
      photoUrl: map['photoUrl'],
      friends: map.containsKey('friends')
          ? List<Usuario>.from(map['friends']?.map((x) => Usuario.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source));
}
