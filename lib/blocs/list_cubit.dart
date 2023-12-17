import 'package:flutter_bloc/flutter_bloc.dart';

class ListCubit extends Cubit<int> {
  ListCubit() : super(0);

  void update() => emit(state + 1);
}