import 'package:elaichi/domain/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const HomeState.loading());

  void checkIfVerified() {
    if (_userRepository.rollNumber != null) {
      emit(const HomeState.isVerified());
    } else {
      emit(const HomeState.initial());
    }
  }

  final UserRepository _userRepository;
}
