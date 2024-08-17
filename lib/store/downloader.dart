import 'package:background_downloader/background_downloader.dart';

TaskQueue? _taskQueue;

void initDownloader() {
  final tq = MemoryTaskQueue();
  tq.maxConcurrent = 5;
  tq.maxConcurrentByHost = 5;
  tq.maxConcurrentByGroup = 3;
  FileDownloader().updates.listen((update) {});
  _taskQueue = tq;
}

void enqueueTask(DownloadTask task) {
  if (_taskQueue == null) {
    throw Exception('Task queue not initialized');
  }
  FileDownloader().enqueue(task);
}
