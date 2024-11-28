import 'package:quiver/strings.dart';

String verifyMnemonics(String me) {
  if (isBlank(me)) {
    return "请输入助记词";
  }
  if (me.split(" ").length != 24) {
    return "助记词不合法";
  }
  return "";
}
