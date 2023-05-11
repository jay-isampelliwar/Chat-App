import 'package:get_it/get_it.dart';
import 'package:socket_io_test/features/lobby/bloc/lobby_bloc.dart';

GetIt locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<LobbyBloc>(() => LobbyBloc());
}
