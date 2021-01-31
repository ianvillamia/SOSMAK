import 'package:flutter/material.dart';

class MedicalReportModel {
  bool isHIV,
      isTB,
      isHeartDisease,
      isHighBlood,
      isMalaria,
      isLiverFunction,
      isVDRL,
      isTPA;

  MedicalReportModel.getData(data) {
    this.isHIV = data['isHIV'];
    this.isTB = data['isTB'];
    this.isHeartDisease = data['isHeartDisease'];
    this.isHighBlood = data['isHighBlood'];
    this.isMalaria = data['isMalaria'];
    this.isLiverFunction = data['isLiverFunction'];
    this.isVDRL = data['isVDRL'];
    this.isTPA = data['isTPA'];
  }

  MedicalReportModel();
  toMap({@required MedicalReportModel medical}) {
    var map = {
      'isHIV': this.isHIV,
      'isTB': this.isTB,
      'isHeartDisease': this.isHeartDisease,
      'isHighBlood': this.isHighBlood,
      'isMalaria': this.isMalaria,
      'isLiverFunction': this.isLiverFunction,
      'isVDRL': this.isVDRL,
      'isTPA': this.isTPA,
    };
    return map;
  }
}
