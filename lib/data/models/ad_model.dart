import 'package:gas_admin_app/core/extensions/prefix_url_image_extension.dart';

class AdModel {
  final int idAd;
  final String title;
  final String description;
  final String? image;
  final String link;

  AdModel({
    required this.idAd,
    required this.title,
    required this.description,
    this.image,
    required this.link,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      idAd: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      image: (json['image'] as String?)?.withImagePrefix,
      link: json['link'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'link': link};
  }
}
