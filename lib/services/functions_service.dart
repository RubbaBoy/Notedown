import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final HttpsCallable _addCategoryCallable =
      CloudFunctions.instance.getHttpsCallable(functionName: 'addCategory');
  final HttpsCallable _getCategoriesCallable =
      CloudFunctions.instance.getHttpsCallable(functionName: 'getCategories');
  final HttpsCallable _editNoteCallable =
      CloudFunctions.instance.getHttpsCallable(functionName: 'editNote');

  /// Returns the created category ID.
  Future<String> addCategory(String name) async {
    try {
      var data = (await _addCategoryCallable.call({'name': name})).data;
      if (!data['success']) {
        throw FailedFunctionException('addCategory', data['error']);
      }

      return data['id'];
    } on CloudFunctionsException catch (e) {
      throw FailedFunctionException('addCategory', e.message);
    }
  }

  /// Returns a list of fetched [FetchedCategory]s.
  Future<List<FetchedCategory>> getCategories() async {
    try {
      var data = (await _getCategoriesCallable.call()).data;
      if (!data['success']) {
        throw FailedFunctionException('getCategories', data['error']);
      }

      return data['categories'].map<FetchedCategory>((category) => FetchedCategory(category['id'], category['name'])).toList();
    } on CloudFunctionsException catch (e) {
      throw FailedFunctionException('getCategories', e.message);
    }
  }

  /// Edits or creates the note by ID. Returns the note's ID.
  Future<String> editNote({String id, String category, String title, String content}) async {
    try {
      var data = (await _editNoteCallable
              .call({'id': id, 'category': category, 'title': title, 'content': content}))
          .data;
      if (!data['success']) {
        throw FailedFunctionException('editNote', data['error']);
      }

      return data['id'];
    } on CloudFunctionsException catch (e) {
      throw FailedFunctionException('editNote', e.message);
    }
  }
}

class FetchedCategory {
  String id;
  String name;

  FetchedCategory(this.id, this.name);
}

class FailedFunctionException implements Exception {
  final String function;
  final String cause;

  const FailedFunctionException(this.function, [this.cause = '']);

  @override
  String toString() =>
      'The invocation of the function $function was unsuccessful${cause != '' ? ' for the reason: $cause' : ''}';
}
