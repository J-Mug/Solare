import 'dart:typed_data';

abstract class DriveRepository {
  /// Reads a file from the given path within appDataFolder.
  /// Throws if not found or on error.
  Future<T?> readFile<T>(String path);

  /// Writes data to a file at the given path within appDataFolder.
  /// Overwrites if it already exists, creates it and any missing parent folders if not.
  Future<void> writeFile(String path, Object data);

  /// Deletes a file or folder at the given path within appDataFolder.
  Future<void> deleteFile(String path);

  /// Returns a list of file/folder names under the specified path within appDataFolder.
  Future<List<String>> listFiles(String folder);

  /// Uploads binary data to the given path within appDataFolder.
  /// Returns the file ID.
  Future<String> uploadBinary(String path, Uint8List bytes);

  /// Emits an event whenever a change is detected in the watched files or folders.
  Stream<void> watchChanges();
}
