import 'package:intl/intl.dart';

class stepsRestModel {
  final int code;
  final List<BucketData> message;

  stepsRestModel({required this.code, required this.message});

  factory stepsRestModel.fromJson(Map<String, dynamic> parsedJson) {
    List<BucketData> bucketDataList = [];

    var list = parsedJson['bucket'] as List;
    bucketDataList = list.map((i) => BucketData.fromJson(i)).toList();
    return stepsRestModel(code: parsedJson['code'], message: bucketDataList);
  }
}

class BucketData {
  final String endTime;
  final List<DataSetData> dataset;

  BucketData({required this.endTime, required this.dataset});

  factory BucketData.fromJson(Map<String, dynamic> parsedJson) {
    List<DataSetData> dataSetList = [];
    var list = parsedJson['dataset'] as List;
    dataSetList = list.map((i) => DataSetData.fromJson(i)).toList();
    return BucketData(
        endTime: parsedJson['endTimeMillis'], dataset: dataSetList);
  }
}

class DataSetData {
  final String dataSourceId;
  final List<PointData> pointList;

  DataSetData({required this.dataSourceId, required this.pointList});

  factory DataSetData.fromJson(Map<String, dynamic> parsedJson) {
    List<PointData> pointDataList = [];
    var list = parsedJson['point'] as List;
    pointDataList = list.map((i) => PointData.fromJson(i)).toList();
    return DataSetData(
        dataSourceId: parsedJson['dataSourceId'], pointList: pointDataList);
  }
}

class PointData {
  final String endTimeNanos;
  final List<ValueData> valueList;

  PointData({required this.endTimeNanos, required this.valueList});

  factory PointData.fromJson(Map<String, dynamic> parsedJson) {
    List<ValueData> valueDataList = [];
    var list = parsedJson['value'] as List;
    valueDataList = list.map((i) => ValueData.fromJson(i)).toList();
    return PointData(
        endTimeNanos: parsedJson['endTimeNanos'], valueList: valueDataList);
  }
}

class ValueData {
  final String endTimeNanos;
  final int intVal;

  ValueData({required this.endTimeNanos, required this.intVal});

  factory ValueData.fromJson(Map<String, dynamic> parsedJson) {
    return ValueData(
        endTimeNanos: parsedJson['endTimeNanos'], intVal: parsedJson['intVal']);
  }
}
