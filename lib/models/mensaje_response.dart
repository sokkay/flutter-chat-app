import 'dart:convert';

import 'message.dart';

class MensajesResponse {
  MensajesResponse({
    this.messages,
  });

  List<Message> messages;

  factory MensajesResponse.fromJson(String str) =>
      MensajesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MensajesResponse.fromMap(Map<String, dynamic> json) =>
      MensajesResponse(
        messages:
            List<Message>.from(json["messages"].map((x) => Message.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "messages": List<dynamic>.from(messages.map((x) => x.toMap())),
      };
}
