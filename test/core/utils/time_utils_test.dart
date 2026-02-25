import 'package:flutter_test/flutter_test.dart';
import 'package:isitaperotime/core/utils/time_utils.dart';

void main() {
  group('TimeUtils.whatToDo', () {
    test('returns Pastis for pastis minutes (6, 10, 26, 36, 46, 56)', () {
      for (final minute in [6, 10, 26, 36, 46, 56]) {
        expect(TimeUtils.whatToDo(14, minute), contains('Pastis'));
        expect(TimeUtils.whatToDo(8, minute), contains('Pastis'));
      }
    });

    test('returns Ricard for minute 15', () {
      expect(TimeUtils.whatToDo(9, 15), contains('Ricard'));
      expect(TimeUtils.whatToDo(14, 15), contains('Ricard'));
    });

    test('returns Ap\u00e9ro between 11:00-12:00', () {
      expect(TimeUtils.whatToDo(11, 0), contains('Ap\u00e9ro'));
      expect(TimeUtils.whatToDo(11, 45), contains('Ap\u00e9ro'));
    });

    test('returns Ap\u00e9ro with saucisson between 17:00-20:00', () {
      expect(TimeUtils.whatToDo(17, 0), contains('saucisson'));
      expect(TimeUtils.whatToDo(19, 30), contains('saucisson'));
    });

    test('returns vin between 12:00-13:30', () {
      expect(TimeUtils.whatToDo(12, 0), contains('vin'));
      expect(TimeUtils.whatToDo(13, 20), contains('vin'));
    });

    test('returns vin between 20:00-22:00', () {
      expect(TimeUtils.whatToDo(20, 0), contains('vin'));
      expect(TimeUtils.whatToDo(21, 30), contains('vin'));
    });

    test('returns dijo between 13:30-15:00', () {
      expect(TimeUtils.whatToDo(13, 30), contains('dijo'));
      expect(TimeUtils.whatToDo(14, 0), contains('dijo'));
      expect(TimeUtils.whatToDo(14, 45), contains('dijo'));
    });

    test('returns cocktail between 22:00 and 03:00 (overnight fix)', () {
      expect(TimeUtils.whatToDo(22, 0), contains('cocktail'));
      expect(TimeUtils.whatToDo(23, 30), contains('cocktail'));
      expect(TimeUtils.whatToDo(0, 0), contains('cocktail'));
      expect(TimeUtils.whatToDo(1, 30), contains('cocktail'));
      expect(TimeUtils.whatToDo(2, 59), contains('cocktail'));
    });

    test('returns dodo between 03:00 and 07:00', () {
      expect(TimeUtils.whatToDo(3, 0), contains('dodo'));
      expect(TimeUtils.whatToDo(5, 30), contains('dodo'));
    });

    test('returns not yet time for other hours', () {
      expect(TimeUtils.whatToDo(8, 0), contains('pas encore'));
      expect(TimeUtils.whatToDo(10, 0), contains('pas encore'));
    });

    test('pastis takes priority over other time ranges', () {
      // 11:06 should be Pastis (minute 6), not Ap\u00e9ro
      expect(TimeUtils.whatToDo(11, 6), contains('Pastis'));
      // 22:10 should be Pastis (minute 10), not cocktail
      expect(TimeUtils.whatToDo(22, 10), contains('Pastis'));
    });
  });

  group('TimeUtils.formatTime', () {
    test('pads single digit with zero', () {
      expect(TimeUtils.formatTime(0), '00');
      expect(TimeUtils.formatTime(5), '05');
      expect(TimeUtils.formatTime(9), '09');
    });

    test('does not pad double digit', () {
      expect(TimeUtils.formatTime(10), '10');
      expect(TimeUtils.formatTime(12), '12');
      expect(TimeUtils.formatTime(23), '23');
    });
  });
}
