class GetVisitsResponse {
  final bool status;
  final String msg;
  final VisitData? data;

  GetVisitsResponse({
    required this.status,
    required this.msg,
    this.data,
  });

  factory GetVisitsResponse.fromJson(Map<String, dynamic> json) {
    return GetVisitsResponse(
      status: json['status'] ?? false,
      msg: json['msg'] ?? '',
      data: json['data'] != null ? VisitData.fromJson(json['data']) : null,
    );
  }
}

class VisitData {
  final dynamic userId;
  final int totalVisits;
  final List<VisitItem> visits;

  VisitData({
    required this.userId,
    required this.totalVisits,
    required this.visits,
  });

  factory VisitData.fromJson(Map<String, dynamic> json) {
    return VisitData(
      userId: json['user_id'],
      totalVisits: json['total_visits'] ?? 0,
      visits: (json['visits'] as List?)
              ?.map((e) => VisitItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class VisitItem {
  final int visitId;
  final String checkIn;
  final String checkOut;
  final String checkinGps;
  final String checkoutGps;
  final int workingMinutes;
  final String workingDate;
  final String? comment;
  final int visitStatus;

  VisitItem({
    required this.visitId,
    required this.checkIn,
    required this.checkOut,
    required this.checkinGps,
    required this.checkoutGps,
    required this.workingMinutes,
    required this.workingDate,
    this.comment,
    required this.visitStatus,
  });

  factory VisitItem.fromJson(Map<String, dynamic> json) {
    return VisitItem(
      visitId: json['visit_id'] ?? 0,
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      checkinGps: json['checkin_gps'] ?? '',
      checkoutGps: json['checkout_gps'] ?? '',
      workingMinutes: json['working_minutes'] ?? 0,
      workingDate: json['working_date'] ?? '',
      comment: json['comment'],
      visitStatus: json['visit_status'] ?? 0,
    );
  }
}
