import 'package:controlx/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/control/presentation/bloc/control_bloc.dart';
import 'features/control/presentation/pages/splash_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  } catch (e) {
    debugPrint('Firebase not configured. Please run flutterfire configure: $e');
  }
  
  await di.init();
  runApp(const ControlXApp());
}

class ControlXApp extends StatelessWidget {
  const ControlXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<ControlBloc>()),
      ],
      child: MaterialApp(
        title: 'ControlX',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const _MobileFrame(),  // <-- changed
      ),
    );
  }
}

class _MobileFrame extends StatelessWidget {
  const _MobileFrame();

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 500;

    if (!isWeb) {
      // On actual mobile — show normally
      return const SplashPage();
    }

    // On web/desktop — show inside a centered mobile frame
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 430,
            maxHeight: 932,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: const SplashPage(),
          ),
        ),
      ),
    );
  }
}