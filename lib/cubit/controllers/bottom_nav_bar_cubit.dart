import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBarCubit extends Cubit<int> {
  BottomNavBarCubit({int initialIndex = 0}) : super(initialIndex);
  void updateIndex(int index) {
    emit(index);
  }
}
