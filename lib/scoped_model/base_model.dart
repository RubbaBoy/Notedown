import 'package:notedown/enums/view_states.dart';
import 'package:notedown/scoped_model/note_list_model.dart';
import 'package:notedown/service_locator.dart';
import 'package:notedown/services/authentication_service.dart';
import 'package:notedown/services/navigation_service.dart';
import 'package:scoped_model/scoped_model.dart';

///
/// A model that handles the [ViewState] and basic navigation.
///
class BaseModel extends Model {
  NavigationService navigationService = locator<NavigationService>();
  AuthService authService = locator<AuthService>();

  ViewState _state;
  ViewState get state => _state;

  Future<List<NoteCategory>> get categories async => navigationService.getCachedCategories();

  void setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  String getProfilePicture() => authService.getUser()?.photoUrl ?? '';

  String getProfileName() => authService.getUser()?.displayName ?? '-';

  String getProfileEmail() => authService.getUser()?.email ?? '-';
}
