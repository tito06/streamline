import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_line/helper/responsive_helper.dart';
import 'package:stream_line/repo/dashboard_repository.dart';
import 'package:stream_line/screens/app_drawer.dart';

import '../cubit/dashboard/dashboard_metrics_cubit.dart';
import '../cubit/dashboard/dashboard_metrics_state.dart';
import '../models/AppointmentData.dart';
import '../models/DepartmentData.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardMetricsCubit(DashboardRepository())
        ..loadDashboardMetrics(),
      child: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);

    return Scaffold(
      appBar: isDesktop
          ? null // No AppBar for desktop, use side navigation
          : AppBar(
              title: const Text('Dashboard'),
              elevation: 2,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<DashboardMetricsCubit>().refreshDashBoardMetrics();
                  },
                ),
              ],
            ),
      drawer: (!isDesktop) ? const AppDrawer() : null,
      body: Row(
        children: [
          // Permanent Side Navigation for Desktop
          if (isDesktop)
            const SizedBox(
              width: 280,
              child: AppDrawer(),
            ),
          
          // Main Content
          Expanded(
            child: BlocBuilder<DashboardMetricsCubit, DashboardMetricsState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          state.error!,
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<DashboardMetricsCubit>().loadDashboardMetrics();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<DashboardMetricsCubit>().refreshDashBoardMetrics();
                  },
                  child: ResponsiveDashboardContent(state: state),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveDashboardContent extends StatelessWidget {
  final DashboardMetricsState state;

  const ResponsiveDashboardContent({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title for Desktop/Tablet
          if (isDesktop || isTablet) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dashboard Overview',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<DashboardMetricsCubit>().refreshDashBoardMetrics();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // Metrics Cards - Responsive Grid
          LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile) {
                // Mobile: 2 columns
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            title: 'Total Employees',
                            value: state.totalEmployees.toString(),
                            icon: Icons.people,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MetricCard(
                            title: 'Total Patients',
                            value: state.totalPatients.toString(),
                            icon: Icons.local_hospital,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _MetricCard(
                      title: 'Today\'s Revenue',
                      value: '₹${state.todayRevenue.toStringAsFixed(2)}',
                      icon: Icons.account_balance_wallet,
                      color: Colors.orange,
                      isFullWidth: true,
                    ),
                  ],
                );
              } else {
                // Tablet & Desktop: 3 cards in a row
                return Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: 'Total Employees',
                        value: state.totalEmployees.toString(),
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _MetricCard(
                        title: 'Total Patients',
                        value: state.totalPatients.toString(),
                        icon: Icons.local_hospital,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _MetricCard(
                        title: 'Today\'s Revenue',
                        value: '₹${state.todayRevenue.toStringAsFixed(2)}',
                        icon: Icons.account_balance_wallet,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 24),

          // Charts Section - Responsive Layout
          if (isDesktop || isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Appointments Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _AppointmentChart(appointmentData: state.appointmentChart),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Department Statistics',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _DepartmentChart(departmentData: state.departmentPieChart),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appointments Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _AppointmentChart(appointmentData: state.appointmentChart),
                const SizedBox(height: 24),
                const Text(
                  'Department Statistics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _DepartmentChart(departmentData: state.departmentPieChart),
              ],
            ),
        ],
      ),
    );
  }
}

// Updated Metric Card with responsive sizing
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isFullWidth;

  const _MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white, size: isDesktop ? 40 : 32),
                const Icon(Icons.trending_up, color: Colors.white),
              ],
            ),
            SizedBox(height: isDesktop ? 16 : 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: isDesktop ? 16 : 14,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isDesktop ? 32 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentChart extends StatelessWidget {
  final List<AppointmentData> appointmentData;

  const _AppointmentChart({
    super.key,
    required this.appointmentData,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          children: [
            if (appointmentData.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text('No appointment data available'),
              )
            else
              ...appointmentData.map((data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          data.status,
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: LinearProgressIndicator(
                          value: data.count / 50,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getStatusColor(data.status),
                          ),
                          minHeight: isDesktop ? 12 : 10,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 40,
                        child: Text(
                          data.count.toString(),
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'scheduled':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class _DepartmentChart extends StatelessWidget {
  final List<DepartmentData> departmentData;

  const _DepartmentChart({
    super.key,
    required this.departmentData,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final colors = [
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 16),
        child: Column(
          children: [
            if (departmentData.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text('No department data available'),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: departmentData.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final dept = departmentData[index];
                  final color = colors[index % colors.length];

                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 16 : 8,
                      vertical: 4,
                    ),
                    leading: CircleAvatar(
                      radius: isDesktop ? 24 : 20,
                      backgroundColor: color.withOpacity(0.2),
                      child: Icon(
                        Icons.medical_services,
                        color: color,
                        size: isDesktop ? 24 : 20,
                      ),
                    ),
                    title: Text(
                      dept.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isDesktop ? 16 : 14,
                      ),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 16 : 12,
                        vertical: isDesktop ? 8 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${dept.patients} patients',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: isDesktop ? 14 : 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

