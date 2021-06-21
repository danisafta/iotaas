import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String? svgSrc, title, subtitle;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.subtitle,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "MASTER1",
    subtitle: "master",
    svgSrc: "assets/icons/raspberry.svg",
    color: primaryColor,
  ),
  CloudStorageInfo(
    title: "WORKER1",
    subtitle: "worker01",
    svgSrc: "assets/icons/raspberry.svg",
    color: primaryColor,
  ),
  CloudStorageInfo(
    title: "WORKER2",
    subtitle: "worker02",
    svgSrc: "assets/icons/raspberry.svg",
    color: primaryColor,
  ),
];
