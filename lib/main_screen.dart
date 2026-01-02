import 'package:flutter/material.dart';
import 'shop.dart';
import 'auth_service.dart';

import 'pet_hostel.dart';
import 'services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _drawerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _drawerSlideAnimation;
  late Animation<double> _drawerFadeAnimation;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _drawerController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _drawerSlideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _drawerController,
            curve: Curves.easeOutCubic,
          ),
        );

    _drawerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _drawerController, curve: Curves.easeIn));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _drawerController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _drawerController.forward();
      } else {
        _drawerController.reverse();
      }
    });
  }

  void _signOut() async {
    try {
      await authService.signOut();
      // Navigation will be handled automatically by AuthLayout
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: _selectedIndex == 1
                ? const ServicesHomeScreen()
                : _selectedIndex == 2
                ? const ShopScreen()
                : _selectedIndex == 4
                ? const HostelListingPage()
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildHomeContent(),
                    ),
                  ),
          ),
          // Drawer overlay
          if (_isDrawerOpen)
            GestureDetector(
              onTap: _toggleDrawer,
              child: FadeTransition(
                opacity: _drawerFadeAnimation,
                child: Container(color: Colors.black),
              ),
            ),
          // Animated Drawer
          SlideTransition(
            position: _drawerSlideAnimation,
            child: _buildDrawer(),
          ),
        ],
      ),
      bottomNavigationBar: _buildAnimatedBottomNav(),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPromoBanner(),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildQuickServices(),
                const SizedBox(height: 32),
                _buildRecommendedSection(),
                const SizedBox(height: 32),
                _buildPetHealthTips(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: _toggleDrawer,
          ),
          const Text(
            'Home',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black87,
                ),
                onPressed: () {},
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7A4B3A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A4B3A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.message_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lendrick Kumar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7A4B3A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildDrawerSection(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Pet Supply Order',
                      iconColor: const Color(0xFF7A4B3A),
                      subItems: [
                        _buildDrawerSubItem(Icons.home_outlined, 'Home'),
                        _buildDrawerSubItem(Icons.history, 'Order History'),
                      ],
                    ),
                    _buildDrawerSection(
                      icon: Icons.calendar_today_outlined,
                      title: 'Appointments',
                      iconColor: const Color(0xFF7A4B3A),
                      subItems: [
                        _buildDrawerSubItem(Icons.home_outlined, 'Home'),
                        _buildDrawerSubItem(
                          Icons.history,
                          'Appointments History',
                        ),
                      ],
                    ),
                    _buildDrawerSection(
                      icon: Icons.hotel_outlined,
                      title: 'Pet Hostel',
                      iconColor: const Color(0xFF7A4B3A),
                      subItems: [
                        _buildDrawerSubItem(Icons.home_outlined, 'Home'),
                        _buildDrawerSubItem(Icons.history, 'Booking History'),
                      ],
                    ),
                    _buildDrawerItem(
                      icon: Icons.chat_bubble_outline,
                      title: 'Contact Us',
                      iconColor: Colors.green,
                    ),
                    _buildDrawerItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      iconColor: Colors.orange,
                    ),
                    _buildDrawerItem(
                      icon: Icons.help_outline,
                      title: 'FAQs',
                      iconColor: Colors.blue,
                    ),
                    _buildDrawerItem(
                      icon: Icons.star_outline,
                      title: 'Rate our app',
                      iconColor: Colors.amber,
                    ),
                    const Divider(),
                    _buildDrawerItem(
                      icon: Icons.bug_report,
                      title: 'Auth Test (Debug)',
                      iconColor: Colors.purple,
                      onTap: () {
                        Navigator.of(context).pushNamed('/auth-test');
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.g_mobiledata,
                      title: 'Google Sign-In Test',
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.of(context).pushNamed('/google-signin-test');
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      iconColor: Colors.red,
                      onTap: _signOut,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerSection({
    required IconData icon,
    required String title,
    required Color iconColor,
    required List<Widget> subItems,
  }) {
    return ExpansionTile(
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      childrenPadding: const EdgeInsets.only(left: 20),
      children: subItems,
    );
  }

  Widget _buildDrawerSubItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600, size: 20),
      title: Text(
        title,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      dense: true,
      onTap: () {},
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildPromoBanner() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF7A4B3A), const Color(0xFF8B5A42)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7A4B3A).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GIVE \'EM BETTER',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'FREE HEALTH\nCHECKUP !',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A4B3A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          // Inherits padding & shape from Theme
                        ),
                        child: const Text('Book Now'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Image.network(
                  'https://placeholder.com/100x100',
                  width: 90,
                  height: 85,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 85,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.pets,
                        size: 35,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search for tips or services...',
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.grey),
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickServices() {
    final services = [
      {
        'icon': Icons.calendar_today,
        'label': 'Book a\nVet',
        'color': Colors.pink,
      },
      {'icon': Icons.hotel, 'label': 'Hostel', 'color': Colors.orange},
      {'icon': Icons.lightbulb_outline, 'label': 'Tips', 'color': Colors.blue},
      {'icon': Icons.restaurant, 'label': 'Food', 'color': Colors.yellow},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'Quick Services',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: services.asMap().entries.map((entry) {
              int idx = entry.key;
              Map service = entry.value;
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 400 + (idx * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: _buildServiceCard(
                      service['icon'] as IconData,
                      service['label'] as String,
                      service['color'] as Color,
                      () {
                        if (service['label'] == 'Book a\nVet') {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        }
                      },
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection() {
    final products = [
      {'name': 'Milkbone', 'price': 'Rs. 700', 'color': Colors.red},
      {'name': 'Himal Treats', 'price': 'Rs. 200', 'color': Colors.teal},
      {'name': 'Pup-peroni', 'price': 'Rs. 400', 'color': Colors.orange},
      {'name': 'Dog chew toy', 'price': 'Rs. 600', 'color': Colors.blue},
      {'name': 'Pet Shampoo', 'price': 'Rs. 350', 'color': Colors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recommended for your pet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See more >',
                  style: TextStyle(
                    color: const Color(0xFF7A4B3A),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            // Calculate width to show 4.5 items dynamically if needed, or fixed width that fits roughly 2.5 on mobile
            // User requested 4.5 items. Detailed math: Screen width / 4.5 - padding.
            // Simplified: Just use a smaller fixed width.
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 600 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(50 * (1 - value), 0),
                      child: _buildProductCard(
                        products[index]['name'] as String,
                        products[index]['price'] as String,
                        products[index]['color'] as Color,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(String name, String price, Color color) {
    return Container(
      width: 85, // Reduced width to fit 4.5 items
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Left aligned
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Icon(Icons.pets, color: color, size: 28),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetHealthTips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pet Health Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See more >',
                  style: TextStyle(color: const Color(0xFF7A4B3A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Container(
                            height: 180,
                            color: Colors.brown.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.pets,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'How to groom your pet at home by Dr. Juliana Silva',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Dr. Juliana Silva',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '3.2K',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.medical_services_outlined, 'Services', 1),
              _buildNavItem(Icons.shopping_bag_outlined, 'Shop', 2),
              _buildNavItem(Icons.favorite_outline, 'Saved', 3),
              _buildNavItem(Icons.hotel, 'Hostel', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
        builder: (context, value, child) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12 + (8 * value),
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.brown.withValues(alpha: 0.1 * value),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Color.lerp(
                    Colors.grey.shade600,
                    const Color(0xFF7A4B3A),
                    value,
                  ),
                  size: 24,
                ),
                if (value > 0.5) ...[
                  SizedBox(width: 8 * value),
                  Opacity(
                    opacity: (value - 0.5) * 2,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: const Color(0xFF7A4B3A),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
