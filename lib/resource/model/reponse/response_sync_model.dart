  
import 'package:gov_tongdtkt_tongiao/resource/model/sync/sync_result.dart';

class ResponseSyncModel {
  String? responseCode;
  String? responseMessage;
  bool? isSuccess;
  List<SyncResult>? syncResults; 
  ResponseSyncModel({
    this.responseCode,
    this.responseMessage,
    this.isSuccess,
    this.syncResults, 
  });
 
}
