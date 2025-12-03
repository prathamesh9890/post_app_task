import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_test/repositories/post_repository.dart';
import 'package:test_test/screens/post_list_screen.dart';
import 'bloc/post_list/post_list_bloc.dart';
import 'bloc/post_list/post_list_event.dart';
import 'cubit/post_timer_cubit.dart';
import 'datasources/shared_preference.dart';
import 'datasources/post_remote_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final prefs = await SharedPreferences.getInstance();
  final remoteDataSource = PostRemoteDataSource();
  final localDataSource = PostLocalDataSource(prefs: prefs);
  final repository = PostRepository(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final PostRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            PostListBloc(repository: repository)..add(LoadPostsEvent()),
          ),
          BlocProvider(
            create: (context) => PostTimerCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
          ),
          home: const PostListScreen(),
        ),
      ),
    );
  }

}
