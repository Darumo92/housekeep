import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Android widget metadata', () {
    test('declares prototype cell sizes for the three widgets', () {
      final mainInfo = _read(
        'android/app/src/main/res/xml/housekeep_widget_info.xml',
      );
      final nextInfo = _read(
        'android/app/src/main/res/xml/housekeep_widget_next_info.xml',
      );
      final countInfo = _read(
        'android/app/src/main/res/xml/housekeep_widget_count_info.xml',
      );

      expect(mainInfo, contains('android:targetCellWidth="4"'));
      expect(mainInfo, contains('android:targetCellHeight="2"'));
      expect(mainInfo, contains('android:minWidth="250dp"'));

      expect(nextInfo, contains('android:targetCellWidth="2"'));
      expect(nextInfo, contains('android:targetCellHeight="2"'));
      expect(nextInfo, contains('android:minWidth="110dp"'));

      expect(countInfo, contains('android:targetCellWidth="2"'));
      expect(countInfo, contains('android:targetCellHeight="2"'));
    });

    test('medium layout has a hideable divider for secondary rows', () {
      final medium = _read(
        'android/app/src/main/res/layout/housekeep_widget_medium.xml',
      );

      expect(medium, contains('@+id/widget_event_divider'));
    });
  });
}

String _read(String path) => File(path).readAsStringSync();
