class UIChangeEvent {
  final int event;

  UIChangeEvent({required this.event});

  bool isChangeMainUser() => event == _changeMainUser;
  bool isChangeCurrentYearAndTerm() => event == _changeCurrentYearAndTerm;
  bool isChangeTermStartDate() => event == _changeTermStartDate;
  bool isShowNotThisWeek() => event == _showNotThisWeek;
  bool isShowStatus() => event == _showStatus;
  bool isMultiModeChanged() => event == _multiModeChanged;
  bool isChangeCustomAccountTitle() => event == _changeCustomAccountTitle;
  bool isChangeCampus() => event == _changeCampus;
  bool isChangeBackground() => event == _changeBackground;
  bool isChangeCourseColor() => event == _changeCourseColor;
  bool isChangeShowCustomThing() => event == _changeShowCustomThing;

  factory UIChangeEvent.changeMainUser() =>
      UIChangeEvent(event: _changeMainUser);
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
  factory UIChangeEvent.changeBackground() =>
      UIChangeEvent(event: _changeBackground);
  factory UIChangeEvent.changeCourseColor() =>
      UIChangeEvent(event: _changeCourseColor);
  factory UIChangeEvent.changeShowCustomThing() =>
      UIChangeEvent(event: _changeShowCustomThing);
}

var _changeMainUser = 1;
var _changeCurrentYearAndTerm = 3;
var _changeTermStartDate = 4;
var _showNotThisWeek = 5;
var _showStatus = 6;
var _multiModeChanged = 7;
var _changeCustomAccountTitle = 8;
var _changeCampus = 9;
var _changeBackground = 10;
var _changeCourseColor = 11;
var _changeShowCustomThing = 12;
