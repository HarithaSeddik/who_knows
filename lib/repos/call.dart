class Call{
  String callerId;
  String callerName;
  String callerPic;

  String receiverUsername;
  String receiverId;
  String receiverName;
  String receiverPic;

  String channelId;
  String callTopic;

  bool hasDialled;
  bool isVideo;
  String hasEnded;

  Call({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.receiverUsername,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
    this.channelId,
    this.callTopic,
    this.hasDialled,
    this.isVideo,
    this.hasEnded,
  });

  // To map
  Map<String, dynamic> toMap(Call call){
    Map<String, dynamic> callMap = Map();
    callMap['caller_id'] = call.callerId;
    callMap['caller_name'] = call.callerName;
    callMap['caller_pic'] = call.callerPic;
    callMap['receiver_username'] = call.receiverUsername;
    callMap['receiver_id'] = call.receiverId;
    callMap['receiver_name'] = call.receiverName;
    callMap['receiver_pic'] = call.receiverPic;
    callMap['channel_id'] = call.channelId;
    callMap['call_topic'] = call.callTopic;
    callMap['has_dialled'] = call.hasDialled;
    callMap['is_video'] = call.isVideo;
    callMap['has_ended'] = call.hasEnded;
    return callMap;
  }

  // From map
  Call.fromMap(Map callMap){
    this.callerId= callMap['caller_id'];
    this.callerName = callMap['caller_name'];
    this.callerPic = callMap['caller_pic'];
    this.receiverUsername = callMap['receiver_username'];
    this.receiverId = callMap['receiver_id'];
    this.receiverName = callMap['receiver_name'];
    this.receiverPic = callMap['receiver_pic'];
    this.channelId = callMap['channel_id'];
    this.callTopic = callMap['call_topic'];
    this.hasDialled = callMap['has_dialled'];
    this.isVideo = callMap['is_video'];
    this.hasEnded = callMap['has_ended'];
  }
}