import 'package:git_hooks/git_hooks.dart';
import 'package:process_run/process_run.dart';

void main(List<String> arguments) {
  Map<Git, UserBackFun> params = {
    Git.prePush: prePush,
  };
  GitHooks.call(arguments, params);
}

Future<bool> prePush() async {
  try {
    final shell = Shell();
    var result = await shell.run('sh scripts/set_version.sh');
    print('$result');
  } catch (e) {
    return false;
  }
  return true;
}
