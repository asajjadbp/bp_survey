import 'dart:convert';

class SaveSurveyRequest {
  final int visitId;
  final dynamic userId;
  final String checkoutGps;
  final List<SurveyAnswerRequest> surveyData;
  final String comment;
  final String companyId;

  SaveSurveyRequest({
    required this.visitId,
    required this.userId,
    required this.checkoutGps,
    required this.surveyData,
    this.comment = "",
    this.companyId = "",
  });

  Map<String, String> toJson() => {
        'visit_id': visitId.toString(),
        'user_id': userId.toString(),
        'checkout_gps': checkoutGps,
        'survey_data': jsonEncode(surveyData.map((e) => e.toJson()).toList()),
        'comment': comment,
        'company_id': companyId.toString(),
      };
}

class SurveyAnswerRequest {
  final int questionId;
  final String answerId;
  final String answer;
  final String comment;

  SurveyAnswerRequest({
    required this.questionId,
    required this.answerId,
    required this.answer,
    this.comment = "",
  });

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "answer_id": answerId,
        "answer": answer,
        "comment": comment,
      };
}
