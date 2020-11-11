class Posts {
  int id;

  String name;
  String body;
  Posts({this.body, this.id, this.name});

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(id: json['id'], name: json['name'], body: json['body']);
  }
}
