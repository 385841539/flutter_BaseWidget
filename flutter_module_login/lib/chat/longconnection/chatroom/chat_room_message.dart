class MessageType {
  static const String Text = 'text';
  static const String Image = 'image';
  static const String Audio = 'audio';
  static const String Video = 'video';
  static const String Call = 'call';
  static const String MedicalRecord = 'medicalRecord';
  static const String Prescription = 'prescription';
  static const String Evaluation = 'evaluation';
  static const String Init = 'init';
  static const String Rating = 'rating';
  static const String RecommendMedicine = 'recommendMedicine';
  static const String HealthFile = 'healthFile';
  static const String CompleteHealthFile = 'completeHealthFile';
  static const String Accept = 'accept';
  static const String Reject = 'reject';
  static const String EndCall = 'endcall';
  static const String MedicalReport = 'medicalReport';
  static const String DoctorFirstReply = 'doctorFirstReply';
  static const String BeforeInquiry = 'beforeInquiry';
}

//enum ChatRecordType {
//  TEXT = 'text', //文本
//IMAGE = 'image', //图片
//AUDIO = 'audio', //音频
//VIDEO = 'video', //视频
//CALL = 'call', //发起对话
//MEDICALRECORD = 'medicalRecord', //病历
//PRESCRIPTIONS = 'prescription', //处方单
//RECOMMENDMEDICINE = 'recommendMedicine', //药品推荐
//EVALUATION = 'evaluation', //评价
//ENDCALL = 'endcall', //终止对话
//INIT = 'init', //聊天初始信息
//HEALTHFILE = 'healthFile', //健康档案
//NOANSWER = 'noanswer', //视频呼叫未接听
//RATING = 'rating', //评价信息
//accept {status:accept}
//reject {status:reject}
//endcall {duration:xx} 秒数
//}
class Message {
  String dialogueId;
  String roomId;
  String senderId;
  String senderType = 'patient'; // patient：患者，doctor：医生
  String type;
  MessagePayload payload;

  // 由服务器生成
  String id;
  DateTime createdAt;

  Message(
    this.roomId,
    this.senderId,
    this.senderType,
    this.type,
    this.payload, {
    this.dialogueId,
  });

  Message.sendMessageWithPayload(this.roomId, MessagePayload payload,
      {this.dialogueId}) {
    final typeMap = {
      TextMessagePayload: MessageType.Text,
      ImageMessagePayload: MessageType.Image,
      AudioMessagePayload: MessageType.Audio,
      VideoMessagePayload: MessageType.Video,
      CallMessagePayload: MessageType.Call,
      MedicalRecordMessagePayload: MessageType.MedicalRecord,
      PrescriptionMessagePayload: MessageType.Prescription,
      InitMessagePayload: MessageType.Init,
      EndMessagePayload: MessageType.Evaluation,
      RatingMessagePayload: MessageType.Rating,
      EndCallMessagePayload: MessageType.EndCall,
      RecommendMedicineMessagePayload: MessageType.RecommendMedicine,
      HealthFileMessagePayload: MessageType.HealthFile,
      CompleteHealthFileMessagePayload: MessageType.CompleteHealthFile,
      AcceptMessagePayload: MessageType.Accept,
      RejectMessagePayload: MessageType.Reject,
      MedicalReportMessagePayload: MessageType.MedicalReport,
      DoctorFirstReplyMessagePayload: MessageType.DoctorFirstReply,
      BeforeInquiryMessagePayload: MessageType.BeforeInquiry,
    };

    this.type = typeMap[payload.runtimeType];
    assert(this.type != null, 'unrecongized payload');

    this.payload = payload;
  }

  Message.fromJSON(Map json) {
    this.roomId = json['roomId'];
    this.dialogueId = json['dialogueId'];
    this.senderId = json['senderId'];
    this.senderType = json['senderType'];
    this.type = json['type'];

    final decoders = {
      MessageType.Text: () => TextMessagePayload.fromJSON(json['payload']),
      MessageType.Image: () => ImageMessagePayload.fromJSON(json['payload']),
      MessageType.Audio: () => AudioMessagePayload.fromJSON(json['payload']),
      MessageType.Call: () => CallMessagePayload.fromJSON(json['payload']),
      MessageType.Video: () => VideoMessagePayload.fromJSON(json['payload']),
      MessageType.MedicalRecord: () =>
          MedicalRecordMessagePayload.fromJSON(json['payload']),
      MessageType.Prescription: () =>
          PrescriptionMessagePayload.fromJSON(json['payload']),
      MessageType.Init: () => InitMessagePayload.fromJSON(json['payload']),
      MessageType.Evaluation: () => EndMessagePayload.fromJSON(json['payload']),
      MessageType.Rating: () => RatingMessagePayload.fromJSON(json['payload']),
      MessageType.EndCall: () =>
          EndCallMessagePayload.fromJSON(json['payload']),
      MessageType.RecommendMedicine: () =>
          RecommendMedicineMessagePayload.fromJSON(json['payload']),
      MessageType.HealthFile: () =>
          HealthFileMessagePayload.fromJSON(json['payload']),
      MessageType.CompleteHealthFile: () =>
          CompleteHealthFileMessagePayload.fromJSON(json['payload']),
      MessageType.Accept: () => AcceptMessagePayload.fromJSON(json['payload']),
      MessageType.Reject: () => RejectMessagePayload.fromJSON(json['payload']),
      MessageType.MedicalReport: () =>
          MedicalReportMessagePayload.fromJSON(json['payload']),
      MessageType.DoctorFirstReply: () =>
          DoctorFirstReplyMessagePayload.fromJSON(json['payload']),
      MessageType.BeforeInquiry: () =>
          BeforeInquiryMessagePayload.fromJSON(json['payload']),
    };

    this.payload = decoders[this.type]();

    this.id = json['id'];
    this.createdAt = DateTime.parse(json['createdAt']);
  }

  Map toJSON() {
    Map result = new Map();

    result['roomId'] = this.roomId;
    result['dialogueId'] = this.dialogueId;
    result['senderId'] = this.senderId;
    result['senderType'] = this.senderType;
    result['type'] = this.type;
    result['payload'] = this.payload.toJSON();

    if (this.id != null) {
      result['id'] = this.id;
    }

    if (this.createdAt != null) {
      result['createdAt'] = this.createdAt.toIso8601String();
    }

    return result;
  }
}

class MessagePayload {
  MessagePayload();

  MessagePayload.fromJSON(Map json);

  Map toJSON() {
    return null;
  }
}

class TextMessagePayload extends MessagePayload {
  String text;

  TextMessagePayload(this.text);

  TextMessagePayload.fromJSON(Map json) {
    this.text = json['text'];
  }

  Map toJSON() {
    return {"text": this.text};
  }
}

class ImageMessagePayload extends MessagePayload {
  String imageURL;

  ImageMessagePayload(this.imageURL);

  ImageMessagePayload.fromJSON(Map json) {
    this.imageURL = json['imageURL'];
  }

  Map toJSON() {
    return {"imageURL": this.imageURL};
  }
}

class AudioMessagePayload extends MessagePayload {
  String audioURL;
  num audioLength;

  AudioMessagePayload(this.audioURL, this.audioLength);

  AudioMessagePayload.fromJSON(Map json) {
    this.audioURL = json['audioURL'];
    this.audioLength = json['audioLength'];
  }

  Map toJSON() {
    return {"audioURL": this.audioURL, "audioLength": audioLength};
  }
}

class VideoMessagePayload extends MessagePayload {
  String videoURL;

  VideoMessagePayload(this.videoURL);

  VideoMessagePayload.fromJSON(Map json) {
    this.videoURL = json['vidoeURL'];
  }

  Map toJSON() {
    return {"videoURL": this.videoURL};
  }
}

/**
 * 音视频呼叫记录
 */
class CallMessagePayload extends MessagePayload {
  // TODO:

  DateTime callAt;

  CallMessagePayload(this.callAt);

  CallMessagePayload.fromJSON(Map json) {
    this.callAt = json['callAt'];
  }

  Map toJSON() {
    return {"callAt": this.callAt.millisecondsSinceEpoch};
  }
}

/**
 * 病历
 */
class MedicalRecordMessagePayload extends MessagePayload {
  int visitType; // 就诊类型
  String chiefComplaint; // 主诉/现病史
  String pastHistory; // 既往史
  String allergyHistory; // 过敏史
  String personalMedicalHistory; // 个人史
  String familyMedicalHistory; // 家族史
  String diagnosis; // 诊断
  String advice; // 医嘱
  num bodyTemperature; // 体格检查 - 体温
  num bodyWeight; // 体格检查 - 体重
  num heartRate; // 体格检查 - 心率
  num systolicBloodPressure; // 体格检查 - 收缩压
  num diastolicBloodPressure; // 体格检查 - 舒张压
  dynamic prescription; // 处方
  String patientId; // 用户 id
  String employeeId; // 医生 id

  MedicalRecordMessagePayload();

  MedicalRecordMessagePayload.fromJSON(Map json) {
    // TODO:
  }

  Map toJSON() {
    // TODO:
    return {};
  }
}

class PrescriptionMessagePayload extends MessagePayload {
  String medicalRecordId;
  String text;

  PrescriptionMessagePayload();

  PrescriptionMessagePayload.fromJSON(Map json) {
    medicalRecordId = json['medicalRecordId'];
    text = json['text'];
  }

  Map toJSON() {
    return {};
  }
}

class InitMessagePayload extends MessagePayload {
  String patientInfo;

  InitMessagePayload();

  InitMessagePayload.fromJSON(Map json) {
    this.patientInfo = json['message'];
  }

  Map toJSON() {
    return {};
  }
}

class EndMessagePayload extends MessagePayload {
  String evaluationId;

  EndMessagePayload();

  EndMessagePayload.fromJSON(Map json) {
    this.evaluationId = json['evaluationId'];
  }

  Map toJSON() {
    return {};
  }
}

class RatingMessagePayload extends MessagePayload {
  num rating;
  String description;
  var evaluationId;

  RatingMessagePayload(this.rating, this.description, this.evaluationId);

  RatingMessagePayload.fromJSON(Map json) {
    this.rating = json['rating'];
    this.description = json['description'];
    this.evaluationId = json['evaluationId'];
  }

  Map toJSON() {
    return {
      'rating': rating,
      'description': description,
      'evaluationId': this.evaluationId
    };
  }
}

class EndCallMessagePayload extends MessagePayload {
  num duration;

  EndCallMessagePayload(this.duration);

  EndCallMessagePayload.fromJSON(Map json) {
    this.duration = json['duration'];
  }

  Map toJSON() {
    return {'duration': duration};
  }
}

class RecommendMedicineMessagePayload extends MessagePayload {
  String text;
  String medicalRecordId;

  RecommendMedicineMessagePayload(this.text, this.medicalRecordId);

  RecommendMedicineMessagePayload.fromJSON(Map json) {
    this.text = json['text'];
    this.medicalRecordId = json['medicalRecordId'];
  }

  Map toJSON() {
    return {'text': text, 'medicalRecordId': medicalRecordId};
  }
}

class HealthFileMessagePayload extends MessagePayload {
  var duration;

  // todo 修改内容
  HealthFileMessagePayload(this.duration);

  HealthFileMessagePayload.fromJSON(Map json) {
    this.duration = json['duration'];
  }

  Map toJSON() {
    return {'duration': duration};
  }
}

class CompleteHealthFileMessagePayload extends MessagePayload {
  CompleteHealthFileMessagePayload();

  CompleteHealthFileMessagePayload.fromJSON(Map json);

  Map toJSON() {
    return null;
  }
}

class AcceptMessagePayload extends MessagePayload {
  var status;

  AcceptMessagePayload(this.status);

  AcceptMessagePayload.fromJSON(Map json) {
    this.status = json['status'];
  }

  Map toJSON() {
    return {'status': status};
  }
}

class RejectMessagePayload extends MessagePayload {
  var status;

  RejectMessagePayload(this.status);

  RejectMessagePayload.fromJSON(Map json) {
    status = json['status'];
  }

  Map toJSON() {
    return {'status': status};
  }
}

class MedicalReportMessagePayload extends MessagePayload {
  var imageURLs;

  MedicalReportMessagePayload(this.imageURLs);

  MedicalReportMessagePayload.fromJSON(Map json) {
    imageURLs = json['imageURLs'];
  }

  Map toJSON() {
    return {'imageURLs': imageURLs};
  }
}

class BeforeInquiryMessagePayload extends MessagePayload {
  var text;

  BeforeInquiryMessagePayload(this.text);

  BeforeInquiryMessagePayload.fromJSON(Map json) {
    text = json['text'];
  }

  Map toJSON() {
    return {'text': text};
  }
}

class DoctorFirstReplyMessagePayload extends MessagePayload {
  var id;
  var roomId;
  var employeeId;

  DoctorFirstReplyMessagePayload(this.id, this.roomId, this.employeeId);

  DoctorFirstReplyMessagePayload.fromJSON(Map json) {
    id = json['id'];
    roomId = json['roomId'];
    employeeId = json['employeeId'];
  }

  Map toJSON() {
    return {'id': id, 'roomId': roomId, 'employeeId': employeeId};
  }
}
