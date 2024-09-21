class UIChangeEvent {
  final int event;

  UIChangeEvent({required this.event});

  bool isChangeMainUser() => event == _changeMainUser;
  bool isMainUserLogout() => event == _mainUserLogout;
  bool isChangeCurrentYearAndTerm() => event == _changeCurrentYearAndTerm;
  bool isChangeTermStartDate() => event == _changeTermStartDate;
  bool isShowNotThisWeek() => event == _showNotThisWeek;
  bool isShowStatus() => event == _showStatus;
  bool isMultiModeChanged() => event == _multiModeChanged;
  bool isChangeCustomAccountTitle() => event == _changeCustomAccountTitle;
  bool isChangeCampus() => event == _changeCampus;

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
  factory UIChangeEvent.multiModeChanged() =>
      UIChangeEvent(event: _multiModeChanged);
  factory UIChangeEvent.changeCustomAccountTitle() =>
      UIChangeEvent(event: _changeCustomAccountTitle);
  factory UIChangeEvent.changeCampus() => UIChangeEvent(event: _changeCampus);
}

var _changeMainUser = 1;
var _mainUserLogout = 2;
var _changeCurrentYearAndTerm = 3;
var _changeTermStartDate = 4;
var _showNotThisWeek = 5;
var _showStatus = 6;
var _multiModeChanged = 7;
var _changeCustomAccountTitle = 8;
var _changeCampus = 9;
