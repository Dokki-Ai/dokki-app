import 'dart:io';
import 'package:excel/excel.dart';

class PriceParser {
  static Future<List<Map<String, dynamic>>> parseFile(String filePath) async {
    if (filePath.endsWith('.csv')) {
      return _parseCsv(filePath);
    } else {
      return _parseExcel(filePath);
    }
  }

  static Future<List<Map<String, dynamic>>> _parseExcel(String filePath) async {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables.keys.first;
    final rows = excel.tables[sheet]!.rows;

    if (rows.isEmpty) return [];

    final products = <Map<String, dynamic>>[];
    
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty || row[0]?.value == null) continue;

      products.add({
        'name': row[0]?.value?.toString() ?? '',
        'price': _parsePrice(row.length > 1 ? row[1]?.value : null),
        'category': row.length > 2 ? row[2]?.value?.toString() : null,
        'description': row.length > 3 ? row[3]?.value?.toString() : null,
      });
    }

    return products;
  }

  static Future<List<Map<String, dynamic>>> _parseCsv(String filePath) async {
    final lines = await File(filePath).readAsLines();
    if (lines.isEmpty) return [];

    final products = <Map<String, dynamic>>[];
    
    for (int i = 1; i < lines.length; i++) {
      final parts = lines[i].split(',');
      if (parts.isEmpty || parts[0].trim().isEmpty) continue;

      products.add({
        'name': parts[0].trim(),
        'price': _parsePrice(parts.length > 1 ? parts[1] : null),
        'category': parts.length > 2 ? parts[2].trim() : null,
        'description': parts.length > 3 ? parts[3].trim() : null,
      });
    }

    return products;
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    final str = value.toString().replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(str) ?? 0.0;
  }
}
