import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_line/helper/responsive_helper.dart';
import 'package:stream_line/screens/manage_employee.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Container(
      decoration: isDesktop
          ? BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            )
          : null,
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Custom Header
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.local_hospital,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Health ERP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Admin Dashboard',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _DrawerMenuItem(
                      icon: Icons.dashboard,
                      title: 'Dashboard',
                      onTap: () {
                        if (!isDesktop) Navigator.pop(context);
                      },
                    ),
                    const Divider(height: 1),
                    _DrawerMenuItem(
                      icon: Icons.people,
                      title: 'Manage Employee',
                      onTap: () {
                        if (!isDesktop) Navigator.pop(context);
                        Navigator.push(
                            context,
                            (MaterialPageRoute(
                                builder: (context) => const ManageEmployee())));
                      },
                    ),
                    _DrawerMenuItem(
                      icon: Icons.assessment,
                      title: 'Generate Reports',
                      onTap: () {
                        if (!isDesktop) Navigator.pop(context);
                      },
                    ),
                    _DrawerMenuItem(
                      icon: Icons.trending_up,
                      title: 'Today\'s Engagement',
                      onTap: () {
                        if (!isDesktop) Navigator.pop(context);
                      },
                    ),
                    _DrawerMenuItem(
                      icon: Icons.notifications_active,
                      title: 'Add Notifications',
                      subtitle: 'Holidays & Updates',
                      onTap: () {
                        if (!isDesktop) Navigator.pop(context);
                      },
                    ),
                    _DrawerMenuItem(
                      icon: Icons.inventory_2,
                      title: 'Stocks',
                      onTap: () {
                        if (!isDesktop) Navigator.pop(context);
                      },
                    ),
                    const Divider(height: 1),
                    _DrawerMenuItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        if (!isDesktop) Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),

              // Footer
              const Divider(height: 1),
              _DrawerMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                iconColor: Colors.red,
                onTap: () {
                  if (!isDesktop) Navigator.pop(context);
                  _showLogoutDialog(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.blue.shade700,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            )
          : null,
      onTap: onTap,
      dense: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 4,
      ),
    );
  }
}
