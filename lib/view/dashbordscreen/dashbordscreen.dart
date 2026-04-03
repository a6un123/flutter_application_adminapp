import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_adminapp/logic/auth/bloc/authbloc_bloc.dart';
import 'package:flutter_application_adminapp/logic/auth/bloc/authbloc_event.dart';
import 'package:flutter_application_adminapp/logic/auth/bloc/authbloc_state.dart';
import 'package:flutter_application_adminapp/logic/order/bloc/orderbloc_bloc.dart';
import 'package:flutter_application_adminapp/logic/order/bloc/orderbloc_state.dart';
import 'package:flutter_application_adminapp/logic/product/bloc/product_bloc.dart';
import 'package:flutter_application_adminapp/logic/product/bloc/product_state.dart';
import 'package:flutter_application_adminapp/logic/users/bloc/usersbloc_bloc.dart';
import 'package:flutter_application_adminapp/logic/users/bloc/usersbloc_state.dart';
import 'package:flutter_application_adminapp/view/notificationscreen/notificationscreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final adminName = authState is Authenticated ? authState.name : 'Admin';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          // ── Notification Bell ───────────────────
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('admin_notifications')
                .where('isRead', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              final count = snapshot.data?.docs.length ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminNotificationScreen(),
                      ),
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // ── Logout ─────────────────────────────
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthBloc>().add(LogoutEvent()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome Card ──────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: Colors.indigo[200],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        adminName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Unread Notifications Banner ───────
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('admin_notifications')
                  .where('isRead', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                final count = snapshot.data?.docs.length ?? 0;
                if (count == 0) return const SizedBox();
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminNotificationScreen(),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You have $count unread notification${count > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // ── Stats Row 1 ───────────────────────
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<AdminProductBloc, AdminProductState>(
                    builder: (context, state) {
                      final count = state is AdminProductLoaded
                          ? state.products.length
                          : 0;
                      return _StatCard(
                        title: 'Products',
                        value: '$count',
                        icon: Icons.inventory_2_outlined,
                        color: Colors.blue,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocBuilder<AdminOrderBloc, AdminOrderState>(
                    builder: (context, state) {
                      final count = state is AdminOrderLoaded
                          ? state.orders.length
                          : 0;
                      return _StatCard(
                        title: 'Orders',
                        value: '$count',
                        icon: Icons.receipt_long_outlined,
                        color: Colors.orange,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Stats Row 2 ───────────────────────
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<AdminOrderBloc, AdminOrderState>(
                    builder: (context, state) {
                      final count = state is AdminOrderLoaded
                          ? state.orders
                                .where((o) => o.status == 'pending')
                                .length
                          : 0;
                      return _StatCard(
                        title: 'Pending',
                        value: '$count',
                        icon: Icons.pending_outlined,
                        color: Colors.red,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocBuilder<AdminOrderBloc, AdminOrderState>(
                    builder: (context, state) {
                      final count = state is AdminOrderLoaded
                          ? state.orders
                                .where((o) => o.status == 'delivered')
                                .length
                          : 0;
                      return _StatCard(
                        title: 'Delivered',
                        value: '$count',
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Stats Row 3 — Customers ───────────
            BlocBuilder<AdminUserBloc, AdminUserState>(
              builder: (context, state) {
                final count = state is AdminUserLoaded ? state.users.length : 0;
                return _StatCard(
                  title: 'Customers',
                  value: '$count',
                  icon: Icons.people_outline,
                  color: Colors.teal,
                );
              },
            ),

            const SizedBox(height: 24),

            // ── Quick Actions ─────────────────────
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: 'Products',
                    subtitle: 'Add, edit, delete',
                    icon: Icons.inventory_2_outlined,
                    color: Colors.blue,
                    onTap: () => context.go('/products'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    title: 'Orders',
                    subtitle: 'View, update status',
                    icon: Icons.receipt_long_outlined,
                    color: Colors.orange,
                    onTap: () => context.go('/orders'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: 'Customers',
                    subtitle: 'View registered users',
                    icon: Icons.people_outline,
                    color: Colors.teal,
                    onTap: () => context.go('/users'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    title: 'Add Product',
                    subtitle: 'Upload image and details',
                    icon: Icons.add_box_outlined,
                    color: Colors.green,
                    onTap: () => context.go('/add-product'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Notifications Action Card ─────────
            _ActionCard(
              title: 'Notifications',
              subtitle: 'View all alerts and updates',
              icon: Icons.notifications_outlined,
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminNotificationScreen(),
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Bottom Navigation ─────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) context.go('/products');
          if (index == 2) context.go('/orders');
          if (index == 3) context.go('/users');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Customers',
          ),
        ],
      ),
    );
  }
}

// ── Stat Card ──────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Action Card ────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
