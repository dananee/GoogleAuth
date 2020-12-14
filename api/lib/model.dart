class Lang {
  int id;
  String name;
  String body;

  Lang({this.id, this.name, this.body});

  Lang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['body'] = this.body;
    return data;
  }
}
