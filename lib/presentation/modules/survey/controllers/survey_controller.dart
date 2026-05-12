import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bpsurveys/data/repositories/survey_repository.dart';
import 'package:bpsurveys/data/models/response_models/survey_questions_response_model.dart';
import 'package:bpsurveys/data/models/request_models/save_survey_request_model.dart';
import 'package:bpsurveys/core/utils/result.dart';
import 'package:bpsurveys/data/sources/local/storage_service.dart';
import 'package:bpsurveys/core/services/location_service.dart';

class SurveyController extends GetxController {
  final SurveyRepository _repository = Get.find<SurveyRepository>();
  final storage = StorageService();

  // --- Observable State ---
  final isLoading = false.obs;
  final visitId = 0.obs;
  final currentIndex = 0.obs;
  
  final categories = <SurveyCategory>[].obs;
  final allQuestions = <Question>[].obs;
  
  // Data Storage
  final answers = <int, dynamic>{}.obs; // Global Index -> Answer Value
  final optionComments = <int, String>{}.obs; // Option ID -> Comment Text

  // --- Persistent UI Controllers ---
  final Map<int, TextEditingController> _questionControllers = {};
  final Map<int, TextEditingController> _commentControllers = {};

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _disposeControllers() {
    for (var c in _questionControllers.values) {
      c.dispose();
    }
    for (var c in _commentControllers.values) {
      c.dispose();
    }
    _questionControllers.clear();
    _commentControllers.clear();
  }

  // --- API Methods ---

  Future<void> fetchQuestions() async {
    final user = storage.getUser();
    if (user == null) {
      Get.snackbar("Error".tr, "User session expired".tr);
      return;
    }

    isLoading.value = true;
    
    final locationResult = await LocationService.getCurrentLocation();
    
    switch (locationResult) {
      case Success<String>(data: final gps):
        final result = await _repository.getQuestions(userId: user.username, checkinGps: gps);
        isLoading.value = false;

        switch (result) {
          case Success<SurveyQuestionsResponse>(data: final response):
            visitId.value = response.data.visitId;
            categories.assignAll(response.data.questions);
            _initializeSurveyWizard();
            break;
          case Failure<SurveyQuestionsResponse>(message: final msg):
            Get.snackbar("Error".tr, msg);
            break;
        }
        break;
      case Failure<String>(message: final msg):
        isLoading.value = false;
        Get.snackbar("Location Required".tr, msg);
        break;
    }
  }

  Future<void> submitSurvey() async {
    if (visitId.value == 0) return;
    
    final user = storage.getUser();
    if (user == null) return;

    isLoading.value = true;

    final locationResult = await LocationService.getCurrentLocation();
    
    switch (locationResult) {
      case Success<String>(data: final gps):
        final request = SaveSurveyRequest(
          visitId: visitId.value,
          userId: user.username,
          checkoutGps: gps,
          surveyData: _buildSubmissionData(),
        );

        final result = await _repository.saveSurvey(request);
        isLoading.value = false;

        switch (result) {
          case Success(data: final response):
            Get.back();
            // Get.snackbar("Success".tr, response.msg);
            Get.snackbar("Success".tr, "Survey Submitted Successfully".tr);
            break;
          case Failure(message: final msg):
            Get.snackbar("Error".tr, msg);
            break;
        }
        break;
      case Failure<String>(message: final msg):
        isLoading.value = false;
        Get.snackbar("Location Required".tr, msg);
        break;
    }
  }

  // --- Core Logic ---

  void _initializeSurveyWizard() {
    _disposeControllers();
    allQuestions.clear();
    answers.clear();
    optionComments.clear();

    int index = 0;
    for (var cat in categories) {
      for (var q in cat.questions) {
        allQuestions.add(q);
        
        final type = q.answerType.toLowerCase();
        if (type == 'text' || type == 'numeric') {
          _questionControllers[index] = TextEditingController();
        }

        for (var opt in q.options) {
          if (opt.type == "comment") {
            _commentControllers[opt.id] = TextEditingController();
          }
        }
        index++;
      }
    }
  }

  List<SurveyAnswerRequest> _buildSubmissionData() {
    List<SurveyAnswerRequest> surveyData = [];
    final isAr = storage.getLanguage() == 'ar';
    
    for (int i = 0; i < allQuestions.length; i++) {
      final question = allQuestions[i];
      final val = answers[i];
      
      if (val == null) continue;

      String answerId = "";
      String answerText = "";
      String commentText = "";

      final type = question.answerType.toLowerCase();

      if (type == 'text' || type == 'numeric') {
        // Pure text/numeric: Answer contains the value, ID is empty
        answerText = val.toString();
      } else if (type == 'radio') {
        // Radio: ID is the selected option ID, Answer is the option label
        answerId = val.toString();
        final opt = question.options.firstWhereOrNull((o) => o.id == val);
        answerText = isAr ? (opt?.arName ?? "") : (opt?.enName ?? "");
        if (opt?.type == "comment") {
          commentText = optionComments[val] ?? "";
        }
      } else if (type == 'checkbox') {
        // Checkbox: ID is joined IDs, Answer is joined labels
        final ids = List<int>.from(val);
        answerId = ids.join(",");
        
        List<String> labels = [];
        List<String> comments = [];
        
        for (var id in ids) {
          final opt = question.options.firstWhereOrNull((o) => o.id == id);
          if (opt != null) {
            labels.add(isAr ? opt.arName : opt.enName);
            if (opt.type == "comment") {
              final comment = optionComments[id] ?? "";
              if (comment.isNotEmpty) comments.add(comment);
            }
          }
        }
        answerText = labels.join(", ");
        commentText = comments.join(", ");
      }

      surveyData.add(SurveyAnswerRequest(
        questionId: question.questionId,
        answerId: answerId,
        answer: answerText,
        comment: commentText,
      ));
    }
    return surveyData;
  }

  // --- UI Actions ---

  void onOptionSelected(int globalIndex, dynamic value, String type) {
    if (type == 'checkbox') {
      final question = allQuestions[globalIndex];
      final selectedOption = question.options.firstWhereOrNull((o) => o.id == value);
      final current = List<int>.from(answers[globalIndex] ?? []);

      if (selectedOption?.type == 'none') {
        // If "none" is selected, clear everything else and just keep "none" (or toggle it)
        if (current.contains(value)) {
          current.remove(value);
        } else {
          current.clear();
          current.add(value);
        }
      } else {
        // If a normal option is selected, remove any "none" options first
        current.removeWhere((id) {
          final opt = question.options.firstWhereOrNull((o) => o.id == id);
          return opt?.type == 'none';
        });

        if (current.contains(value)) {
          current.remove(value);
        } else {
          current.add(value);
        }
      }
      answers[globalIndex] = current;
    } else {
      answers[globalIndex] = value;
    }
  }

  void onTextChanged(int globalIndex, String text) {
    answers[globalIndex] = text;
  }

  void onCommentChanged(int optionId, String text) {
    optionComments[optionId] = text;
  }

  void nextQuestion() => currentIndex.value < allQuestions.length - 1 ? currentIndex.value++ : null;
  void previousQuestion() => currentIndex.value > 0 ? currentIndex.value-- : null;

  // --- Getters ---

  TextEditingController? getQuestionController(int index) => _questionControllers[index];
  TextEditingController? getCommentController(int optId) => _commentControllers[optId];

  SurveyCategory? getCategoryForCurrent() {
    int count = 0;
    for (var cat in categories) {
      if (currentIndex.value >= count && currentIndex.value < count + cat.questions.length) {
        return cat;
      }
      count += cat.questions.length;
    }
    return null;
  }

  bool get isCurrentQuestionValid {
    if (allQuestions.isEmpty) return false;
    final index = currentIndex.value;
    final question = allQuestions[index];
    final val = answers[index];

    // Check if main answer is provided
    if (val == null) return false;
    if (val is String && val.trim().isEmpty) return false;
    if (val is List && val.isEmpty) return false;

    // Check if required comments are filled
    if (question.answerType.toLowerCase() == 'radio') {
      final opt = question.options.firstWhereOrNull((o) => o.id == val);
      if (opt?.type == 'comment') {
        final comment = optionComments[val] ?? "";
        if (comment.trim().isEmpty) return false;
      }
    } else if (question.answerType.toLowerCase() == 'checkbox') {
      final selectedIds = List<int>.from(val);
      for (var id in selectedIds) {
        final opt = question.options.firstWhereOrNull((o) => o.id == id);
        if (opt?.type == 'comment') {
          final comment = optionComments[id] ?? "";
          if (comment.trim().isEmpty) return false;
        }
      }
    }

    return true;
  }

  bool get isFirst => currentIndex.value == 0;
  bool get isLast => allQuestions.isNotEmpty && currentIndex.value == allQuestions.length - 1;
  int get totalQuestions => allQuestions.length;
  String getLanguage() => storage.getLanguage();

  int get completedQuestions => answers.values.where((v) {
    if (v is List) return v.isNotEmpty;
    return v.toString().trim().isNotEmpty;
  }).length;

  double get progress => totalQuestions == 0 ? 0 : completedQuestions / totalQuestions;
}
