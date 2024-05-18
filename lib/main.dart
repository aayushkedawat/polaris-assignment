import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:polairs_assignment/features/form/presentation/pages/home/home_screen.dart';
import 'amplifyconfiguration.dart';
import 'features/form/presentation/bloc/form_data/form_data_bloc.dart';
import 'features/form/presentation/bloc/remote/form_bloc.dart';

import 'package:polairs_assignment/features/splash/splash_screen.dart';

import 'features/form/presentation/bloc/remote/form_event.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialiseDependencies();
  await configureAmplify();

  runApp(MyApp());
}

Future<void> configureAmplify() async {
  AmplifyStorageS3 storage = AmplifyStorageS3();
  AmplifyAuthCognito auth = AmplifyAuthCognito();

  Amplify.addPlugins([auth, storage]);

  try {
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    Fluttertoast.showToast(msg: 'Amplify was already configured.');
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Connectivity connectivity = Connectivity();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteFormBloc>(
          create: (context) => sl(),
        ),
        BlocProvider<FormDataBloc>(
          create: (context) => sl(),
        ),
        // BlocProvider<LocalFormBloc>(
        //   create: (context) => sl(),
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder<List<ConnectivityResult>>(
          stream: connectivity.onConnectivityChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (!snapshot.data!.contains(ConnectivityResult.none)) {
                sl<RemoteFormBloc>().add(const SyncData());
                return const HomeScreen();
              }
            }
            return const SplashScreen();
          },
        ),
      ),
    );
  }
}
