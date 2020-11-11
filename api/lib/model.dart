class Model {
  final int id;
  final int user;
  final String title;
  final String body;

  Model({this.body, this.id, this.title, this.user});

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      body: json['body'],
      id: json['id'],
      title: json['title'],
      user: json['userId'],
    );
  }
}
