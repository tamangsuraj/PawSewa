import 'package:flutter/material.dart';

void main() {
  runApp(const PetHostelApp());
}

const Color kPawBrown = Color(0xFF7A4B3A);
const Color kBgColor = Colors.white;

class PetHostelApp extends StatelessWidget {
  const PetHostelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawSewa Pet Hostel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPawBrown,
        scaffoldBackgroundColor: kBgColor,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPawBrown,
          primary: kPawBrown,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPawBrown,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
      routes: {
        '/': (_) => const _RootWithBottomNav(),
        HostelDetailPage.routeName: (_) => const HostelDetailPage(),
        BookingPage.routeName: (_) => const BookingPage(),
        PricingPage.routeName: (_) => const PricingPage(),
        ConfirmationPage.routeName: (_) => const ConfirmationPage(),
      },
    );
  }
}

/// SIMPLE ROOT WITH BOTTOM NAV (only Hostel tab is fully functional UI)
class _RootWithBottomNav extends StatefulWidget {
  const _RootWithBottomNav();

  @override
  State<_RootWithBottomNav> createState() => _RootWithBottomNavState();
}

class _RootWithBottomNavState extends State<_RootWithBottomNav> {
  int _index = 4; // 0‑Home,1‑Shop,2‑Care,3‑Vet,4‑Hostel

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_index) {
      case 4:
        body = HostelListingPage(
          onMenuPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Drawer / menu (UI only).')),
            );
          },
        );
        break;
      default:
        body = Center(
          child: Text(
            ['Home', 'Shop', 'Care', 'Vet'][_index],
            style: const TextStyle(fontSize: 18),
          ),
        );
    }

    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: _BottomNavBar(
        current: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int current;
  final ValueChanged<int> onChanged;

  const _BottomNavBar({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(Icons.home_rounded, 'Home'),
      _NavItem(Icons.shopping_bag_outlined, 'Shop'),
      _NavItem(Icons.pets_rounded, 'Care'),
      _NavItem(Icons.healing_outlined, 'Vet'),
      _NavItem(Icons.house_rounded, 'Hostel'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int i = 0; i < items.length; i++)
            InkWell(
              onTap: () => onChanged(i),
              borderRadius: BorderRadius.circular(40),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[i].icon,
                      size: 22,
                      color: i == current ? kPawBrown : Colors.grey.shade600,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      items[i].label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: i == current
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: i == current ? kPawBrown : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

/// DATA MODEL
class Hostel {
  final String name;
  final String location;
  final int price;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String description;
  final List<String> amenities;

  const Hostel({
    required this.name,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.amenities,
  });
}

/// SAMPLE LIST (you can replace URLs with asset images in production)
const List<Hostel> hostelList = [
  Hostel(
    name: 'Raju Shrestha Pet Hostel',
    location: 'NarayanHiti Path, Nagpokhari -1, Kathmandu 44600',
    price: 500,
    imageUrl:
        'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=900&q=80',
    rating: 4.7,
    reviews: 206,
    description:
        'Located in NarayanHiti Path, Kathmandu, Raju’s pet hostel is a property with well-toned facilities.',
    amenities: [
      '24/7 Supervision',
      'Play & Exercise Time',
      'Custom Feeding Plans',
      'Experienced Staff',
      'Live Updates',
      'Clean & Cozy Stays',
    ],
  ),
  Hostel(
    name: 'Paw Care Pet Hostel',
    location: 'Nagpokhari Marg, Kathmandu 44600',
    price: 500,
    imageUrl:
        'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?w=900&q=80',
    rating: 4.8,
    reviews: 189,
    description: 'Premium pet care facility with spacious accommodations.',
    amenities: [
      '24/7 Supervision',
      'Play & Exercise Time',
      'Custom Feeding Plans',
      'Experienced Staff',
    ],
  ),
  Hostel(
    name: 'Happy Tails Pet Lodge',
    location: 'Nagpokhari Marg, Kathmandu 44600',
    price: 500,
    imageUrl:
        'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=900&q=80',
    rating: 4.6,
    reviews: 142,
    description: 'Cozy and comfortable pet boarding with loving care.',
    amenities: [
      '24/7 Supervision',
      'Play & Exercise Time',
      'Custom Feeding Plans',
      'Experienced Staff',
    ],
  ),
];

/// SCREEN 1 – LISTING
class HostelListingPage extends StatefulWidget {
  final VoidCallback? onMenuPressed;
  const HostelListingPage({super.key, this.onMenuPressed});

  @override
  State<HostelListingPage> createState() => _HostelListingPageState();
}

class _HostelListingPageState extends State<HostelListingPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = hostelList
        .where(
          (h) =>
              h.name.toLowerCase().contains(_search.toLowerCase()) ||
              h.location.toLowerCase().contains(_search.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed:
              widget.onMenuPressed ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu tapped (UI only).')),
                );
              },
        ),
        title: const Text(
          'Pet Hostel',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: kPawBrown.withValues(alpha: 0.2),
              child: const Icon(Icons.person, color: kPawBrown, size: 18),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search your hostels',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemBuilder: (context, index) {
                final hostel = filtered[index];
                return _HostelCard(hostel: hostel);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: filtered.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _HostelCard extends StatelessWidget {
  final Hostel hostel;
  const _HostelCard({required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            HostelDetailPage.routeName,
            arguments: hostel,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // fixed height image, same for all
            SizedBox(
              height: 170,
              width: double.infinity,
              child: Image.network(
                hostel.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hostel.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hostel.location,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Price: Rs.${hostel.price}/day',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              HostelDetailPage.routeName,
                              arguments: hostel,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPawBrown,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text('Book Now'),
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
    );
  }
}

/// SCREEN 2 – DETAIL
class HostelDetailPage extends StatelessWidget {
  static const routeName = '/detail';
  const HostelDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Hostel hostel = ModalRoute.of(context)!.settings.arguments as Hostel;

    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
        children: [
          // top image with back icon over it
          Stack(
            children: [
              SizedBox(
                height: 260,
                width: double.infinity,
                child: Image.network(
                  hostel.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 12,
                child: SafeArea(
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flag_rounded, size: 18, color: kPawBrown),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'A modern and standard property with essential amenities',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hostel.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hostel.location,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: kPawBrown,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hostel.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '(${hostel.reviews})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hostel.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Amenities',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: hostel.amenities.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4.1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 8,
                        ),
                    itemBuilder: (_, index) {
                      final text = hostel.amenities[index];
                      final icon = _amenityIcon(text);
                      return Row(
                        children: [
                          Icon(icon, size: 18, color: Colors.black87),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              text,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NPR ${hostel.price}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              BookingPage.routeName,
                              arguments: hostel,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPawBrown,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            'Book Now & pay at hostel',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By proceeding, you agree to our ',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Hostel Policies',
                            style: TextStyle(
                              color: kPawBrown,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _amenityIcon(String text) {
    if (text.contains('24/7')) return Icons.shield_moon_outlined;
    if (text.contains('Play')) return Icons.sports_esports_outlined;
    if (text.contains('Feeding')) return Icons.ramen_dining_outlined;
    if (text.contains('Experienced')) return Icons.verified_user_outlined;
    if (text.contains('Live')) return Icons.camera_alt_outlined;
    if (text.contains('Clean')) return Icons.cleaning_services_outlined;
    return Icons.pets;
  }
}

/// SCREEN 3 – USER DETAILS
class BookingPage extends StatefulWidget {
  static const routeName = '/booking';
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late TextEditingController _name;
  late TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: 'Lendrick Kumar');
    _email = TextEditingController(text: 'lendrickkumar1@gmail.com');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Hostel hostel = ModalRoute.of(context)!.settings.arguments as Hostel;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Booking details',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.network(
              hostel.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flag_rounded, size: 18, color: kPawBrown),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'A modern and standard property with essential amenities',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hostel.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hostel.location,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: kPawBrown,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hostel.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '(${hostel.reviews})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'User Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  _label('Name'),
                  const SizedBox(height: 6),
                  _filledField(_name),
                  const SizedBox(height: 14),
                  _label('Email'),
                  const SizedBox(height: 6),
                  _filledField(_email),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NPR ${hostel.price}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_name.text.trim().isEmpty ||
                                _email.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please fill in your name and email.',
                                  ),
                                ),
                              );
                              return;
                            }
                            Navigator.pushNamed(
                              context,
                              PricingPage.routeName,
                              arguments: hostel,
                            );
                          },
                          child: const Text(
                            'Book Now & pay at hostel',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By proceeding, you agree to our ',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Hostel Policies',
                            style: TextStyle(
                              color: kPawBrown,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      color: Colors.grey.shade700,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _filledField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}

/// SCREEN 4 – PRICING & POLICIES
class PricingPage extends StatelessWidget {
  static const routeName = '/pricing';
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Hostel hostel = ModalRoute.of(context)!.settings.arguments as Hostel;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          hostel.name,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pricing details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.local_offer_outlined,
                  size: 20,
                  color: kPawBrown,
                ),
                const SizedBox(width: 10),
                const Text('Apply Coupon', style: TextStyle(fontSize: 13)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coupon code copied (UI only).'),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'More Offers',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kPawBrown,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price to Pay', style: TextStyle(fontSize: 14)),
                Row(
                  children: [
                    Text(
                      'NPR ${hostel.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ConfirmationPage.routeName);
                },
                child: const Text('Book Now & pay at hostel'),
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'Rules & Policies',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Check in After',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '10:00 AM',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Check out Before',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '10:00 PM',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Important to Note',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            ..._notes().map((e) => _bullet(e)).toList(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  List<String> _notes() => const [
    'Pets must be vaccinated (proof required).',
    'Aggressive pets may not be accepted.',
    'Drop-off and pick-up must be on time.',
    'Food can be provided or brought from home.',
    'Personal items (beds, toys) allowed at owner’s risk.',
    'Emergency contact details are mandatory.',
    'Cancellation within 24 hrs may incur a fee.',
    'We are not liable for pre-existing health issues.',
  ];

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

/// SCREEN 5 – CONFIRMATION
class ConfirmationPage extends StatelessWidget {
  static const routeName = '/confirmation';
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                color: kPawBrown,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.check_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Congratulations !',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Your hostel has been booked.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
