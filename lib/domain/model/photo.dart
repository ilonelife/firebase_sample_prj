class Photo {
  late final String url;
  late final String title;

  Photo({required this.url, required this.title});

  Photo.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['url'] = url;
    _data['title'] = title;
    return _data;
  }
}
