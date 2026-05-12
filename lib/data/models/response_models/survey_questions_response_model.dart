class SurveyQuestionsResponse {
  final bool status;
  final String msg;
  final SurveyData data;

  SurveyQuestionsResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory SurveyQuestionsResponse.fromJson(Map<String, dynamic> json) {
    return SurveyQuestionsResponse(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      data: SurveyData.fromJson(json['data'] ?? {}),
    );
  }
}

class SurveyData {
  final int visitId;
  final List<SurveyCategory> questions;

  SurveyData({
    required this.visitId,
    required this.questions,
  });

  factory SurveyData.fromJson(Map<String, dynamic> json) {
    return SurveyData(
      visitId: json['visit_id'] ?? 0,
      questions: (json['questions'] as List?)
              ?.map((e) => SurveyCategory.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SurveyCategory {
  final int accessPointId;
  final String enAccessType;
  final String arAccessType;
  final List<Question> questions;

  SurveyCategory({
    required this.accessPointId,
    required this.enAccessType,
    required this.arAccessType,
    required this.questions,
  });

  factory SurveyCategory.fromJson(Map<String, dynamic> json) {
    return SurveyCategory(
      accessPointId: json['access_point_id'] ?? 0,
      enAccessType: json['en_access_type'] ?? '',
      arAccessType: json['ar_access_type'] ?? '',
      questions: (json['questions'] as List?)
              ?.map((e) => Question.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Question {
  final int questionId;
  final String enQuestion;
  final String arQuestion;
  final String answerType;
  final int listOrder;
  final List<QuestionOption> options;

  Question({
    required this.questionId,
    required this.enQuestion,
    required this.arQuestion,
    required this.answerType,
    required this.listOrder,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['question_id'] ?? 0,
      enQuestion: json['en_question'] ?? '',
      arQuestion: json['ar_question'] ?? '',
      answerType: json['answer_type'] ?? 'text',
      listOrder: json['list_order'] ?? 0,
      options: (json['options'] as List?)
              ?.map((e) => QuestionOption.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class QuestionOption {
  final int id;
  final String enName;
  final String arName;
  final String? type;

  QuestionOption({
    required this.id,
    required this.enName,
    required this.arName,
    this.type,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] ?? 0,
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
      type: json['type'],
    );
  }
}
