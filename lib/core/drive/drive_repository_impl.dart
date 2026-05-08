import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;
import 'drive_repository.dart';

class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class DriveRepositoryImpl implements DriveRepository {
  final drive.DriveApi _api;
  final StreamController<void> _changeController = StreamController<void>.broadcast();

  DriveRepositoryImpl(String accessToken)
      : _api = drive.DriveApi(_GoogleAuthClient({
          'Authorization': 'Bearer $accessToken',
          'X-Goog-Api-Client': 'gl-dart/2.12.0 gdcl/1.12.0',
        }));

  Future<String?> _getFileId(String path, {bool createMissingFolders = false}) async {
    if (path.isEmpty || path == '/') return 'appDataFolder';

    final parts = path.split('/').where((p) => p.isNotEmpty).toList();
    String currentParent = 'appDataFolder';

    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      final isLast = i == parts.length - 1;
      final q = "name='$part' and '$currentParent' in parents and trashed=false";

      final fileList = await _api.files.list(q: q, spaces: 'appDataFolder');

      if (fileList.files == null || fileList.files!.isEmpty) {
        if (createMissingFolders && !isLast) {
          final newFolder = drive.File()
            ..name = part
            ..parents = [currentParent]
            ..mimeType = 'application/vnd.google-apps.folder';
          final created = await _api.files.create(newFolder);
          currentParent = created.id!;
        } else {
          return null;
        }
      } else {
        currentParent = fileList.files!.first.id!;
      }
    }
    return currentParent;
  }

  @override
  Future<T?> readFile<T>(String path) async {
    final fileId = await _getFileId(path);
    if (fileId == null) return null;

    final media = await _api.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
    final chunks = await media.stream.toList();
    final bytes = chunks.expand((c) => c).toList();

    if (T == String) {
      return utf8.decode(bytes) as T;
    } else if (T == Uint8List) {
      return Uint8List.fromList(bytes) as T;
    } else {
      return jsonDecode(utf8.decode(bytes)) as T;
    }
  }

  @override
  Future<void> writeFile(String path, Object data) async {
    final parts = path.split('/');
    final fileName = parts.removeLast();
    final parentPath = parts.join('/');
    
    final parentId = await _getFileId(parentPath, createMissingFolders: true) ?? 'appDataFolder';
    final existingFileId = await _getFileId(path);

    List<int> bytes;
    if (data is String) {
      bytes = utf8.encode(data);
    } else if (data is Uint8List) {
      bytes = data;
    } else {
      bytes = utf8.encode(jsonEncode(data));
    }

    final media = drive.Media(Stream.value(bytes), bytes.length);

    if (existingFileId != null) {
      await _api.files.update(drive.File(), existingFileId, uploadMedia: media);
    } else {
      final newFile = drive.File()
        ..name = fileName
        ..parents = [parentId];
      await _api.files.create(newFile, uploadMedia: media);
    }
    
    _changeController.add(null);
  }

  @override
  Future<void> deleteFile(String path) async {
    final fileId = await _getFileId(path);
    if (fileId != null) {
      await _api.files.delete(fileId);
      _changeController.add(null);
    }
  }

  @override
  Future<List<String>> listFiles(String folder) async {
    final folderId = await _getFileId(folder);
    if (folderId == null) return [];

    final result = await _api.files.list(
      q: "'$folderId' in parents and trashed=false",
      spaces: 'appDataFolder',
    );

    return result.files?.map((f) => f.name ?? '').where((n) => n.isNotEmpty).toList() ?? [];
  }

  @override
  Future<String> uploadBinary(String path, Uint8List bytes) async {
    await writeFile(path, bytes);
    return await _getFileId(path) ?? '';
  }

  @override
  Stream<void> watchChanges() => _changeController.stream;
}
