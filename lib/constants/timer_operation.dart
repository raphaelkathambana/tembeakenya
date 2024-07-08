
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

String text = '00:00:00\n00:00:00\n00:00:00';
late DateTime totalTime;
late DateTime startTime;
late DateTime pauseTime;

List<String> lineText = [
  '00:00:00',
  '00:00:00',
  '00:00:00',
];

write(String thisText) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/time.txt');
  await file.writeAsString(thisText);
}

Future<String> read() async {
  String data;
  final Directory directory = await getApplicationDocumentsDirectory();
  data = await File('${directory.path}/time.txt').readAsString();

  return data;
}

startCountUp(String startTimeText) {
  startTime = DateTime.parse(startTimeText);
  Duration duration = DateTime.now().difference(startTime);
  DateTime durationTime = DateFormat('HH:mm:ss').parse(duration.toString());
  String durationTimeString = DateFormat('HH:mm:ss').format(durationTime);
  return durationTimeString;
}

pauseCountUp(String pauseTimeText) {
  pauseTime = DateTime.parse(pauseTimeText);
  var pauseDuration = DateTime.now().difference(pauseTime);
  return pauseDuration;
}

subtractTime() async {
  DateTime time0 = DateTime.parse(lineText[0]);
  DateTime time1 = DateTime.parse(lineText[1]);

  Duration difference = DateTime.now().difference(time1);
  var diffDT = time0.add(difference);
  await write('$diffDT\n${DateTime.now()}\n${lineText[2]}');
}
  // *********************************** //