import 'dart:convert';

class FileModel {
  late String fileName;
  late String dataFileContent;

  FileModel({
    required this.fileName,
    required this.dataFileContent
  });


  Map<String, dynamic> toJson() {
    return {
      'FileName': fileName,
      'DataFileContent' : dataFileContent
    };
  }

  factory FileModel.fromJson(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return FileModel.fromMap(json);
  }

  factory FileModel.fromMap(Map<String, dynamic> json) {
    return FileModel(
        fileName: json['FileName'],
        dataFileContent: json['DataFileContent']
    );
  }
}