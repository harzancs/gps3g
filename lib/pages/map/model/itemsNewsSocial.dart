class ItemsNewsSocial {
  final String ID;
  final String DESCRIPTION;
  final String HASTAGS;

  ItemsNewsSocial({
    required this.ID,
    required this.DESCRIPTION,
    required this.HASTAGS,
  });

  factory ItemsNewsSocial.fromJson(Map<String, dynamic> json) {
    return ItemsNewsSocial(
      ID: json['id'],
      DESCRIPTION: json['description'],
      HASTAGS: json['hashtags'],
    );
  }
}
