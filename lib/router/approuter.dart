import 'package:flutter_application_adminapp/data/model/ordermodeles/ordermodel.dart';
import 'package:flutter_application_adminapp/logic/auth/bloc/authbloc_bloc.dart';
import 'package:flutter_application_adminapp/logic/auth/bloc/authbloc_state.dart';
import 'package:flutter_application_adminapp/router/router_refreshsteream.dart';
import 'package:flutter_application_adminapp/view/addproductscreen/addproductscreen.dart';
import 'package:flutter_application_adminapp/view/dashbordscreen/dashbordscreen.dart';
import 'package:flutter_application_adminapp/view/loginscreen/loginscreen.dart';
import 'package:flutter_application_adminapp/view/orderdetailscreen/orderdetailscreen.dart';
import 'package:flutter_application_adminapp/view/orderscreen/orderscreen.dart';
import 'package:flutter_application_adminapp/view/productscreen/productscreen.dart';
import 'package:flutter_application_adminapp/view/splaschscreen/saplashscreen.dart';
import 'package:flutter_application_adminapp/view/usersscreen/usersscreen.dart';
import 'package:go_router/go_router.dart';

GoRouter createAdminRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/',

    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;

      // Never redirect away from splash
      if (location == '/') return null;

      // Not logged in
      if (authState is Unauthenticated || authState is AuthInitial) {
        if (location == '/login') return null;
        return '/login';
      }

      // Logged in
      if (authState is Authenticated) {
        // Non-admin tried to login
        if (authState.role != 'admin') {
          return '/login';
        }
        // Admin on login page → go to dashboard
        if (location == '/login') return '/dashboard';
      }

      return null;
    },

    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    routes: [
      GoRoute(path: '/', builder: (_, __) => const AdminSplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const AdminLoginScreen()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
      GoRoute(path: '/products', builder: (_, __) => const ProductsScreen()),
      GoRoute(
        path: '/add-product',
        builder: (_, __) => const AddProductScreen(),
      ),
      GoRoute(path: '/orders', builder: (_, __) => const OrdersScreen()),
      GoRoute(
        path: '/order-detail',
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return OrderDetailScreen(order: order);
        },
      ),
      // Add this import

      // Add this route inside routes list
      GoRoute(path: '/users', builder: (_, __) => const UsersScreen()),
    ],
  );
}
