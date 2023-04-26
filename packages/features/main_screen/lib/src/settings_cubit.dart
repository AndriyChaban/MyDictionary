// import 'dart:async';
//
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'package:user_repository/user_repository.dart';
//
// part 'settings_state.dart';
//
// class SettingsCubit extends Cubit<SettingsState> {
//   SettingsCubit({
//     required this.userRepository,
//     // required this.dictionaryProvider
//   }) : super(SettingsStateInitial()) {
//     // print('init MSBloc');
//   }
//
//   // final DictionaryProvider dictionaryProvider;
//   final UserRepository userRepository;
//
//   @override
//   Future<void> close() {
//     // _progressStreamController.close();
//     return super.close();
//   }
//
//   // Future<void> _handleFakeLoading(Emitter emitter) async {
//   //   print('start');
//   //   emitter(state.copyWith(isLoading: true));
//   //   await Future.delayed(const Duration(seconds: 3));
//   //   emitter(state.copyWith(isLoading: false));
//   //   print('finish');
//   // }
// }
