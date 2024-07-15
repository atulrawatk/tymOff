import 'package:tymoff/BLOC/BlocBase.dart';
import 'package:tymoff/Utils/AppEnums.dart';
import 'package:rxdart/rxdart.dart';

class DashboardBloc extends BlocBase {
  StateOfDashboard _dashboardState;

  final _dashboardStateFetcher = PublishSubject<StateOfDashboard>();

  Stream<StateOfDashboard> get dashboardStateObservable =>
      _dashboardStateFetcher.stream;

  DashboardBloc() {
    resetDashboardState();
  }

  void resetDashboardState() async {
    _dashboardState = await StateOfDashboard().reset();
    _dashboardStateFetcher.add(_dashboardState);
  }

  StateOfDashboard getDashboardState() {
    return _dashboardState;
  }

  void changeDashboardState(DashboardActiveTab stateOfDashboard) {
    _dashboardState.changeState(stateOfDashboard);
    _dashboardStateFetcher.add(_dashboardState);
  }

  @override
  void dispose() {
    _dashboardStateFetcher.close();
  }
}

class StateOfDashboard {
  DashboardActiveTab _dashboard;

  StateOfDashboard();

  Future<StateOfDashboard> reset() async {
    _dashboard = DashboardActiveTab.NONE;
    return this;
  }

  DashboardActiveTab getDashboard() {
    return _dashboard;
  }

  changeState(DashboardActiveTab state) {
    this._dashboard = state;
  }
}
