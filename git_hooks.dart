import 'package:git_hooks/git_hooks.dart';
import 'package:process_run/process_run.dart';

void main(List<String> arguments) {
  Map<Git, UserBackFun> params = {
    Git.preCommit: preCommit,
  };
  GitHooks.call(arguments, params);
}

Future<bool> preCommit() async {
  try {
    final shell = Shell();
    var result = await shell.run('sh scripts/set_version.sh');
    // ignore: avoid_print
    print('$result');
  } catch (e) {
    return false;
  }
  return true;
}
