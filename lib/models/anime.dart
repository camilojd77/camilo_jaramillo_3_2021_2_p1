class Anime {
  int anime_id = 0;
  String anime_name = '';
  String anime_img = '';

  Anime(
      {required this.anime_id,
      required this.anime_name,
      required this.anime_img});

  Anime.fromJson(Map<String, dynamic> json) {
    anime_id = json['anime_id'];
    anime_name = json['anime_name'];
    anime_img = json['anime_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.anime_id;
    data['name'] = this.anime_name;
    data['img'] = this.anime_img;
    return data;
  }
}
