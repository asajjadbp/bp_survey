class GetSurveyDetailsResponse {
  final bool status;
  final String msg;
  final SurveyDetailsData? data;

  GetSurveyDetailsResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory GetSurveyDetailsResponse.fromJson(Map<String, dynamic> json) {
    return GetSurveyDetailsResponse(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      data: json['data'] != null ? SurveyDetailsData.fromJson(json['data']) : null,
    );
  }
}

class SurveyDetailsData {
  final int visitId;
  final dynamic userId;
  final int totalQuestions;
  final List<SurveyAnswerDetail> surveyData;

  SurveyDetailsData({
    required this.visitId,
    required this.userId,
    required this.totalQuestions,
    required this.surveyData,
  });

  factory SurveyDetailsData.fromJson(Map<String, dynamic> json) {
    return SurveyDetailsData(
      visitId: json['visit_id'] ?? 0,
      userId: json['user_id'],
      totalQuestions: json['total_questions'] ?? 0,
      surveyData: (json['survey_data'] as List?)
              ?.map((e) => SurveyAnswerDetail.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SurveyAnswerDetail {
  final int questionId;
  final String enQuestion;
  final String arQuestion;
  final String answerType;
  final int listOrder;
  final AccessPoint accessPoint;
  final AnswerDetail answer;

  SurveyAnswerDetail({
    required this.questionId,
    required this.enQuestion,
    required this.arQuestion,
    required this.answerType,
    required this.listOrder,
    required this.accessPoint,
    required this.answer,
  });

  factory SurveyAnswerDetail.fromJson(Map<String, dynamic> json) {
    return SurveyAnswerDetail(
      questionId: json['question_id'] ?? 0,
      enQuestion: json['en_question'] ?? '',
      arQuestion: json['ar_question'] ?? '',
      answerType: json['answer_type'] ?? '',
      listOrder: json['list_order'] ?? 0,
      accessPoint: AccessPoint.fromJson(json['access_point'] ?? {}),
      answer: AnswerDetail.fromJson(json['answer'] ?? {}),
    );
  }
}

class AccessPoint {
  final String enName;
  final String arName;

  AccessPoint({
    required this.enName,
    required this.arName,
  });

  factory AccessPoint.fromJson(Map<String, dynamic> json) {
    return AccessPoint(
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
    );
  }
}

class AnswerDetail {
  final dynamic answerId;
  final dynamic answer;
  final String comment;

  AnswerDetail({
    required this.answerId,
    required this.answer,
    required this.comment,
  });

  factory AnswerDetail.fromJson(Map<String, dynamic> json) {
    return AnswerDetail(
      answerId: json['answer_id'],
      answer: json['answer'],
      comment: json['comment'] ?? '',
    );
  }
}
