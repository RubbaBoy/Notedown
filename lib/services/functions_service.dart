import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final HttpsCallable _addCategoryCallable =
      CloudFunctions.instance.getHttpsCallable(functionName: 'addCategory');
  final HttpsCallable _getCategoriesCallable =
      CloudFunctions.instance.getHttpsCallable(functionName: 'getCategories');
  final HttpsCallable _removeCategoryCallable =
      CloudFunctions.instance.getHttpsCallable(functionName: 'removeCategory');
  final HttpsCallable _editNoteCallable =
      CloudFunctions.instance.getHttpsCallable(functionName: 'editNote');
  final HttpsCallable _getNotesCallable =
      CloudFunctions.instance.getHttpsCallable(functionName: 'getNotes');
  final HttpsCallable _removeNoteCallable =
      CloudFunctions.instance.getHttpsCallable(functionName: 'removeNote');

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

      return data['categories']
          .map<FetchedCategory>(
              (category) => FetchedCategory(category['id'], category['name']))
          .toList();
    } on CloudFunctionsException catch (e) {
      throw FailedFunctionException('getCategories', e.message);
    }
  }

  /// Removes the given category. Notes with the category will not be affected
  /// whatsoever, as that would be an easy way to use up all the Firebase
  /// reads/writes.
  Future removeCategory(String categoryId) async {
    try {
      // Returns a list of new categories as data['categories'] however this is useless for now
      var data =
          (await _removeCategoryCallable.call({'category': categoryId})).data;
      if (!data['success']) {
        throw FailedFunctionException('removeCategory', data['error']);
      }
    } on CloudFunctionsException catch (e) {
      throw FailedFunctionException('removeCategory', e.message);
    }
  }

  /// Edits or creates the note by ID. Returns the note's ID.
  Future<String> editNote(
      {String id, String categoryId, String title, String content}) async {
    try {
      var data = (await _editNoteCallable.call({
        'id': id,
        'category': categoryId,
        'title': title,
        'content': content
      }))
          .data;
      if (!data['success']) {
        throw FailedFunctionException('editNote', data['error']);
      }

      return data['id'];
    } on CloudFunctionsException catch (e) {
      throw FailedFunctionException('editNote', e.message);
    }
  }

  Future<List<FetchedNote>> getNotes([String categoryId]) async {
    try {
      var data = (await _getNotesCallable.call({'category': categoryId})).data;
      if (!data['success']) {
        throw FailedFunctionException('getNotes', data['error']);
      }

      return data['notes']
          .map<FetchedNote>((category) => FetchedNote(
              category['id'],
              category['categoryId'] ?? '',
              category['title'] ?? '',
              category['content'] ?? ''))
          .toList();
    } on CloudFunctionsException catch (e) {
      throw FailedFunctionException('getNotes', e.message);
    }
  }

  /// Removes the given note.
  Future removeNote(String noteId) async {
    try {
      var data =
          (await _removeNoteCallable.call({'note': noteId})).data;
      if (!data['success']) {
        throw FailedFunctionException('removeNote', data['error']);
      }
    } on CloudFunctionsException catch (e) {
      throw FailedFunctionException('removeNote', e.message);
    }
  }
}

class FetchedCategory {
  String id;
  String name;

  FetchedCategory(this.id, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetchedCategory &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FetchedCategory[id=$id,name=$name]';
}

class FetchedNote {
  String id;
  String category;
  String title;
  String content;

  FetchedNote(this.id, this.category, this.title, this.content);
}

class FailedFunctionException implements Exception {
  final String function;
  final String cause;

  const FailedFunctionException(this.function, [this.cause = '']);

  @override
  String toString() =>
      'The invocation of the function $function was unsuccessful${cause != '' ? ' for the reason: $cause' : ''}';
}
