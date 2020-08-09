import '../../domain/model/Number.dart';

abstract class Local {
  void storeNumberOffline(Number number);

  Number getNumberFromLocalStorage();
}
