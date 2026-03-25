import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_adminapp/data/repositiores/authrepositiores/authrepositiores.dart';
import 'package:flutter_application_adminapp/data/repositiores/orderrepositiores/orderrepostiores.dart';
import 'package:flutter_application_adminapp/data/repositiores/productrepositiories/productrepositiores.dart';
import 'package:flutter_application_adminapp/data/repositiores/userrepositiores/userrepositiores.dart';
import 'package:flutter_application_adminapp/firebase_options.dart';
import 'package:flutter_application_adminapp/logic/auth/bloc/authbloc_bloc.dart';
import 'package:flutter_application_adminapp/logic/auth/bloc/authbloc_event.dart';
import 'package:flutter_application_adminapp/logic/order/bloc/orderbloc_bloc.dart';
import 'package:flutter_application_adminapp/logic/order/bloc/orderbloc_event.dart';
import 'package:flutter_application_adminapp/logic/product/bloc/product_bloc.dart';
import 'package:flutter_application_adminapp/logic/product/bloc/product_event.dart';
import 'package:flutter_application_adminapp/logic/users/bloc/usersbloc_bloc.dart';
import 'package:flutter_application_adminapp/logic/users/bloc/usersbloc_event.dart';
import 'package:flutter_application_adminapp/router/approuter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ── Repositories ───────────────────────────────────
  final _authRepository = AuthRepository();
  final _orderRepository = OrderRepository();
  final _productRepository = ProductRepository();
  final _userRepository = UserRepository(); // ← NEW

  // ── BLoCs ───────────────────────────────────────────
  late final AuthBloc _authBloc;
  late final AdminProductBloc _productBloc;
  late final AdminOrderBloc _orderBloc;
  late final AdminUserBloc _userBloc; // ← NEW
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(_authRepository)..add(CheckAuthStatus());
    _productBloc = AdminProductBloc(_productRepository)..add(LoadProducts());
    _orderBloc = AdminOrderBloc(_orderRepository)..add(LoadAllOrders());
    _userBloc = AdminUserBloc(_userRepository)..add(LoadCustomers()); // ← NEW
    _router = createAdminRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _productBloc.close();
    _orderBloc.close();
    _userBloc.close(); // ← NEW
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _orderRepository),
        RepositoryProvider.value(value: _productRepository),
        RepositoryProvider.value(value: _userRepository), // ← NEW
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authBloc),
          BlocProvider.value(value: _productBloc),
          BlocProvider.value(value: _orderBloc),
          BlocProvider.value(value: _userBloc), // ← NEW
        ],
        child: MaterialApp.router(
          title: 'Admin App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
          routerConfig: _router,
        ),
      ),
    );
  }
}
