import 'package:flutter/material.dart';

/// يربط مفتاح الأيقونة المخزّن بقاعدة البيانات (نفس المفاتيح المتاحة
/// باختيار الأدمن عند إضافة ميزة جديدة) بأيقونة Material مناسبة.
/// لازم يبقى متزامن مع Amenity::availableIcons() بالباك اند.
IconData amenityIconFor(String? key) {
  switch (key) {
    case 'parking':
      return Icons.local_parking;
    case 'pool':
      return Icons.pool;
    case 'garden':
      return Icons.park;
    case 'elevator':
      return Icons.elevator;
    case 'security':
      return Icons.security;
    case 'gym':
      return Icons.fitness_center;
    case 'wifi':
      return Icons.wifi;
    case 'ac':
      return Icons.ac_unit;
    case 'balcony':
      return Icons.balcony;
    case 'maid_room':
      return Icons.cleaning_services;
    case 'basement':
      return Icons.stairs;
    case 'furnished':
      return Icons.chair;
    case 'playground':
      return Icons.child_friendly;
    case 'mosque':
      return Icons.mosque;
    default:
      return Icons.check_circle_outline;
  }
}
