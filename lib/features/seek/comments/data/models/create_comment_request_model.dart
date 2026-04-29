class CreateCommentRequestModel {
  const CreateCommentRequestModel({
    required this.reportId,
    required this.comment,
  });

  final String reportId;
  final String comment;

  Map<String, dynamic> toJson() {
    return {'reportId': reportId, 'comment': comment};
  }
}
