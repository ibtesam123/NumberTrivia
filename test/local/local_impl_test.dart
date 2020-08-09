import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/constants.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/data/local/local_impl.dart';
import 'package:number_trivia/domain/model/Number.dart';

import '../raw/json_reader.dart';
import '../raw/single_number_response.dart';

class MockBox extends Mock implements Box {}

void main() {
  MockBox box;
  LocalImpl local;

  setUp(() {
    box = MockBox();
    local = LocalImpl(numberBox: box);
  });

  test(
    'test local if Number found',
    () async {
      // arrange
      Number tNumber = Number.fromMap(jsonReader(single_number_response));

      when(box.get(kNumber)).thenAnswer((_) => tNumber);

      // act
      Number number = local.getNumberFromLocalStorage();

      // assert
      verify(box.get(kNumber));
      expect(number, tNumber);
      verifyNoMoreInteractions(box);
    },
  );

  test(
    'test local if Number not found',
    () async {
      // arrange
      when(box.get(kNumber)).thenAnswer((_) => null);

      // act
      final call = local.getNumberFromLocalStorage;

      // assert
      expect(() => call(), throwsA(isA<DataNotFoundException>()));
      verify(box.get(kNumber));
      verifyNoMoreInteractions(box);
    },
  );
}
