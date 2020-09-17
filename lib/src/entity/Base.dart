class Base {
  int id;
  String slug;

  Base(Map<String, dynamic> json) {
    id = json["id"];
    slug = json["slug"];
  }

}