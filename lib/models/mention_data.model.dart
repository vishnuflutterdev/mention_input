// ignore_for_file: public_member_api_docs, sort_constructors_first
class MentionData {
  String id;
  String display;
  String? imageUrl;
  Map<String, dynamic>? customData;

  MentionData({
    required this.id,
    required this.display,
    this.imageUrl,
    this.customData,
  });
}
