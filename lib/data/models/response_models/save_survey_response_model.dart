class SaveSurveyResponse {
  final bool status;
  final String msg;
  final SaveSurveyData? data;

  SaveSurveyResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory SaveSurveyResponse.fromJson(Map<String, dynamic> json) {
    return SaveSurveyResponse(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      data: json['data'] != null ? SaveSurveyData.fromJson(json['data']) : null,
    );
  }
}

class SaveSurveyData {
  final int visitId;
  final int inserted;
  final int updated;
  final int totalQuestions;
  final int workingMinutes;
  final String checkIn;
  final String checkOut;
  final dynamic userId;
  final dynamic companyId;
  final List<dynamic> errors;

  SaveSurveyData({
    required this.visitId,
    required this.inserted,
    required this.updated,
    required this.totalQuestions,
    required this.workingMinutes,
    required this.checkIn,
    required this.checkOut,
    required this.userId,
    required this.companyId,
    required this.errors,
  });

  factory SaveSurveyData.fromJson(Map<String, dynamic> json) {
    return SaveSurveyData(
      visitId: json['visit_id'] ?? 0,
      inserted: json['inserted'] ?? 0,
      updated: json['updated'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      workingMinutes: json['working_minutes'] ?? 0,
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      userId: json['user_id'],
      companyId: json['company_id'],
      errors: json['errors'] ?? [],
    );
  }
}
