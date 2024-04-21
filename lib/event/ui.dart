class UIChangeEvent {
  final int event;

  UIChangeEvent({required this.event});

  bool isChangeMainUser() => event == _changeMainUser;
  bool isMainUserLogout() => event == _mainUserLogout;
  bool isChangeCurrentYearAndTerm() => event == _changeCurrentYearAndTerm;
  bool isChangeTermStartDate() => event == _changeTermStartDate;
  bool isShowNotThisWeek() => event == _showNotThisWeek;
  bool isShowStatus() => event == _showStatus;

  factory UIChangeEvent.changeMainUser() =>
      UIChangeEvent(event: _changeMainUser);
  factory UIChangeEvent.mainUserLogout() =>
      UIChangeEvent(event: _mainUserLogout);
  factory UIChangeEvent.changeCurrentYearAndTerm() =>
      UIChangeEvent(event: _changeCurrentYearAndTerm);
  factory UIChangeEvent.changeTermStartDate() =>
      UIChangeEvent(event: _changeTermStartDate);
  factory UIChangeEvent.showNotThisWeek() =>
      UIChangeEvent(event: _showNotThisWeek);
  factory UIChangeEvent.showStatus() => UIChangeEvent(event: _showStatus);
}

var _changeMainUser = 1;
var _mainUserLogout = 2;
var _changeCurrentYearAndTerm = 3;
var _changeTermStartDate = 4;
var _showNotThisWeek = 5;
var _showStatus = 6;
