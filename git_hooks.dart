import 'package:git_hooks/git_hooks.dart';
import 'package:process_run/process_run.dart';
// import 'dart:io';

void main(List<String> arguments) {
  // ignore: omit_local_variable_types
  Map<Git, UserBackFun> params = {
    Git.commitMsg: commitMsg,
    Git.postCommit: postCommit
  };
  GitHooks.call(arguments, params);
}

Future<bool> commitMsg() async {
  return true;
}

Future<bool> postCommit() async {
  try {
    final shell = Shell();
    var result = await shell.run('sh scripts/set_version.sh');
    print('$result');
  } catch (e) {
    return false;
  }
  return true;
}
