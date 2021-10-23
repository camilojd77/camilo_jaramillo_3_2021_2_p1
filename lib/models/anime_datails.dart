class AnimeDetails {
  int fact_id = 0;
  String fact = '';

  AnimeDetails({required this.fact_id, required this.fact});

  AnimeDetails.fromJson(Map<String, dynamic> json) {
    fact_id = json['fact_id'];
    fact = json['fact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fact_id'] = this.fact_id;
    data['fact'] = this.fact;
    return data;
  }
}
