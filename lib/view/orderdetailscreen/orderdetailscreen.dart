import 'package:flutter/material.dart';
import 'package:flutter_application_adminapp/data/model/ordermodeles/ordermodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application_adminapp/logic/order/bloc/orderbloc_bloc.dart';
import 'package:flutter_application_adminapp/logic/order/bloc/orderbloc_event.dart';
import 'package:flutter_application_adminapp/logic/order/bloc/orderbloc_state.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not yet';
    return '${date.day}/${date.month}/${date.year}  '
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AdminOrderBloc, AdminOrderState>(
        listener: (context, state) {
          if (state is AdminOrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
          if (state is AdminOrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderId.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(order.orderedAt),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Customer Details ──────────────────
              _SectionCard(
                title: 'Customer Details',
                icon: Icons.person_outline,
                child: Column(
                  children: [
                    _InfoRow(label: 'Name', value: order.userName),
                    _InfoRow(label: 'Email', value: order.userEmail),
                    _InfoRow(
                      label: 'Phone',
                      value: order.userPhone.isNotEmpty
                          ? order.userPhone
                          : 'Not provided',
                    ),
                    _InfoRow(label: 'Address', value: order.address),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Order Items ───────────────────────
              _SectionCard(
                title: 'Order Items',
                icon: Icons.shopping_bag_outlined,
                child: Column(
                  children: order.items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  item.product.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[100],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '\$${item.product.price.toStringAsFixed(2)} × ${item.quantity}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),

              // ── Total ─────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${order.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Status Timeline ───────────────────
              _SectionCard(
                title: 'Order Timeline',
                icon: Icons.timeline_outlined,
                child: Column(
                  children: [
                    _TimelineRow(
                      label: 'Order Placed',
                      date: _formatDate(order.orderedAt),
                      isCompleted: true,
                      color: Colors.indigo,
                      icon: Icons.shopping_bag_outlined,
                    ),
                    _TimelineRow(
                      label: 'Confirmed',
                      date: _formatDate(order.confirmedAt),
                      isCompleted: order.confirmedAt != null,
                      color: Colors.blue,
                      icon: Icons.check_circle_outline,
                    ),
                    _TimelineRow(
                      label: 'Shipped',
                      date: _formatDate(order.shippedAt),
                      isCompleted: order.shippedAt != null,
                      color: Colors.purple,
                      icon: Icons.local_shipping_outlined,
                    ),
                    _TimelineRow(
                      label: 'Delivered',
                      date: _formatDate(order.deliveredAt),
                      isCompleted: order.deliveredAt != null,
                      color: Colors.green,
                      icon: Icons.done_all,
                    ),
                    if (order.cancelledAt != null)
                      _TimelineRow(
                        label: 'Cancelled',
                        date: _formatDate(order.cancelledAt),
                        isCompleted: true,
                        color: Colors.red,
                        icon: Icons.cancel_outlined,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Update Status Buttons ─────────────
              const Text(
                'Update Order Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatusButton(
                    label: 'Confirm',
                    color: Colors.blue,
                    icon: Icons.check_circle_outline,
                    isActive: order.status == 'confirmed',
                    onTap: () => context.read<AdminOrderBloc>().add(
                      UpdateOrderStatus(
                        orderId: order.orderId,
                        status: 'confirmed',
                      ),
                    ),
                  ),
                  _StatusButton(
                    label: 'Ship',
                    color: Colors.purple,
                    icon: Icons.local_shipping_outlined,
                    isActive: order.status == 'shipped',
                    onTap: () => context.read<AdminOrderBloc>().add(
                      UpdateOrderStatus(
                        orderId: order.orderId,
                        status: 'shipped',
                      ),
                    ),
                  ),
                  _StatusButton(
                    label: 'Deliver',
                    color: Colors.green,
                    icon: Icons.done_all,
                    isActive: order.status == 'delivered',
                    onTap: () => context.read<AdminOrderBloc>().add(
                      UpdateOrderStatus(
                        orderId: order.orderId,
                        status: 'delivered',
                      ),
                    ),
                  ),
                  _StatusButton(
                    label: 'Cancel',
                    color: Colors.red,
                    icon: Icons.cancel_outlined,
                    isActive: order.status == 'cancelled',
                    onTap: () => _showCancelDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              context.read<AdminOrderBloc>().add(CancelOrder(order.orderId));
              Navigator.pop(context);
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.indigo, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          const Text(': ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final String label;
  final String date;
  final bool isCompleted;
  final Color color;
  final IconData icon;

  const _TimelineRow({
    required this.label,
    required this.date,
    required this.isCompleted,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted ? color : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: isCompleted ? Colors.white : Colors.grey[400],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isCompleted ? Colors.black87 : Colors.grey[400],
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          if (isCompleted) Icon(Icons.check, size: 16, color: color),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isActive ? null : onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? color : Colors.white,
        foregroundColor: isActive ? Colors.white : color,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
