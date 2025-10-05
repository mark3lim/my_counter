import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

class SystemInfoRepository {
  static const String _folderName = 'sys_info';
  static const String _fileName = 'system_info.json';
  final Lock _lock = Lock();

  // 시스템 정보 파일이 저장될 디렉토리 경로를 가져옵니다.
  Future<String> get _directoryPath async {
    final appDir = await getApplicationDocumentsDirectory();
    final sysDir = Directory('${appDir.path}/$_folderName');
    if (!await sysDir.exists()) {
      await sysDir.create(recursive: true);
    }
    return sysDir.path;
  }

  // 시스템 정보 파일의 전체 경로를 가져옵니다.
  Future<String> get _filePath async {
    final dirPath = await _directoryPath;
    return '$dirPath/$_fileName';
  }

  // 현재 저장된 카테고리 개수를 가져옵니다.
  Future<int> getCategoryCount() async {
    return await _lock.synchronized(() async {
      try {
        final file = File(await _filePath);
        if (!await file.exists()) {
          return 0;
        }
        
        final contents = await file.readAsString();
        final data = json.decode(contents);
        print("========[START SYS INFO]========");
        print(data);
        print("=========[END SYS INFO]=========");
        return data['categoryCount'] as int? ?? 0;
      } catch (e) {
        return 0;
      }
    });
  }

  // 카테고리 개수를 업데이트합니다.
  Future<void> updateCategoryCount(int count) async {
    await _lock.synchronized(() async {
      final file = File(await _filePath);
      final data = {'categoryCount': count};
      await file.writeAsString(json.encode(data));
    });
  }

  // 시스템 정보를 초기화합니다.
  Future<void> resetSystemInfo() async {
    await _lock.synchronized(() async {
      final file = File(await _filePath);
      if (await file.exists()) {
        await file.delete();
      }
    });
  }
}