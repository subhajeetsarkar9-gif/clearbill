import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class GoogleDriveBackupService {
  static const String _folderName = 'Clear Bill Backup';
  static const String _fileName = 'clearbill_backup.json';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveFileScope,
      drive.DriveApi.driveAppdataScope,
    ],
  );

  static Future<drive.DriveApi?> _getDriveApi() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      account ??= await _googleSignIn.signIn();

      if (account == null) return null;

      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      return drive.DriveApi(authenticateClient);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> backupToGoogleDrive(Map<String, dynamic> allData) async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return false;

      String? folderId;
      final folderList = await driveApi.files.list(
        q: "mimeType = 'application/vnd.google-apps.folder' and name = '$_folderName' and trashed = false",
      );

      if (folderList.files != null && folderList.files!.isNotEmpty) {
        folderId = folderList.files!.first.id;
      } else {
        final folderToCreate = drive.File()
          ..name = _folderName
          ..mimeType = 'application/vnd.google-apps.folder';
        final folderCreated = await driveApi.files.create(folderToCreate);
        folderId = folderCreated.id;
      }

      final jsonString = jsonEncode(allData);
      final bytes = utf8.encode(jsonString);
      final stream = Stream.value(bytes);
      final media = drive.Media(stream, bytes.length);

      final fileList = await driveApi.files.list(
        q: "name = '$_fileName' and '$folderId' in parents and trashed = false",
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        final existingFileId = fileList.files!.first.id!;
        final fileToUpdate = drive.File()..name = _fileName;
        await driveApi.files.update(fileToUpdate, existingFileId, uploadMedia: media);
      } else {
        final fileToCreate = drive.File()
          ..name = _fileName
          ..parents = [folderId!];
        await driveApi.files.create(fileToCreate, uploadMedia: media);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> restoreFromGoogleDrive() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return null;

      final fileList = await driveApi.files.list(
        q: "name = '$_fileName' and trashed = false",
      );

      if (fileList.files == null || fileList.files!.isEmpty) return null;

      final fileId = fileList.files!.first.id!;
      final drive.Media file = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final List<int> dataStore = [];
      await file.stream.forEach(dataStore.addAll);
      final content = utf8.decode(dataStore);

      return jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> getLastBackupDate() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return null;

      final fileList = await driveApi.files.list(
        q: "name = '$_fileName' and trashed = false",
        $fields: 'files(id, modifiedTime)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        final modifiedTime = fileList.files!.first.modifiedTime;
        if (modifiedTime != null) {
          return modifiedTime.toLocal().toString().split('.')[0];
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
