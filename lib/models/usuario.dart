import 'dart:convert';

class Usuario {
  bool online;
  String name;
  String email;
  String uid;
  String description;
  String photoUrl;
  String avatarPreset;
  List<Usuario> friends;

  Usuario({
    this.online,
    this.name,
    this.email,
    this.uid,
    this.description,
    this.photoUrl,
    this.avatarPreset,
    this.friends,
  });

  @override
  String toString() {
    return 'Usuario(online: $online, name: $name, email: $email, uid: $uid, description: $description, photoUrl: $photoUrl, avatarPreset: $avatarPreset, friends: $friends)';
  }

  Map<String, dynamic> toMap() {
    return {
      'online': online,
      'name': name,
      'email': email,
      'uid': uid,
      'description': description,
      'photoUrl': photoUrl,
      'avatarPreset': avatarPreset,
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
      avatarPreset: map['avatarPreset'],
      friends: map['friends'] != null ?
          List<Usuario>.from(map['friends']?.map((x) => Usuario.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source));
}
