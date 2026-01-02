import 'package:flutter/material.dart';

/*
void main() {
  runApp(PetHostelApp());
}

class PetHostelApp extends StatelessWidget {
  const PetHostelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Hostel',
      theme: ThemeData(primarySwatch: Colors.brown, fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HostelListingPage(),
        '/detail': (context) => HostelDetailPage(),
        '/booking': (context) => BookingPage(),
        '/pricing': (context) => PricingPage(),
        '/confirmation': (context) => ConfirmationPage(),
      },
    );
  }
}
*/

// Data Model
class Hostel {
  final String name;
  final String location;
  final int price;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String description;
  final List<String> amenities;

  Hostel({
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

// Sample Data
final List<Hostel> hostelList = [
  Hostel(
    name: 'Raju Shrestha Pet Hostel',
    location: 'Nagpokhari Marg, Kathmandu 44600',
    price: 500,
    imageUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=800',
    rating: 4.7,
    reviews: 206,
    description:
        'Located in NarayanHiti Path, Kathmandu, Raju\'s pet hostel is a property with well-toned facilities.',
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
        'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?w=800',
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
        'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=800',
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

// Screen 1: Hostel Listing Page
class HostelListingPage extends StatefulWidget {
  const HostelListingPage({super.key});

  @override
  State<HostelListingPage> createState() => _HostelListingPageState();
}

class _HostelListingPageState extends State<HostelListingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        title: Text(
          'Pet Hostel',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          Icon(Icons.notifications_outlined, color: Colors.black),
          SizedBox(width: 12),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF7A4B3A),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Icon(
                Icons.message_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search your hostels',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: hostelList.length,
              itemBuilder: (context, index) {
                final hostel = hostelList[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          hostel.imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hostel.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              hostel.location,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Price: Rs.${hostel.price}/day',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/detail',
                                      arguments: hostel,
                                    );
                                  },
                                  child: const Text('Book Now'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Screen 2: Hostel Detail Page
class HostelDetailPage extends StatelessWidget {
  const HostelDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Hostel hostel = ModalRoute.of(context)!.settings.arguments as Hostel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                hostel.imageUrl,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flag, color: Color(0xFF7A4B3A), size: 20),
                      SizedBox(width: 8),
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
                  SizedBox(height: 12),
                  Text(
                    hostel.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'NarayanHiti Path, Nagpokhari -1,\nKathmandu 44600',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF7A4B3A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${hostel.rating}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.star, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '| (${hostel.reviews})',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Location',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    hostel.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Amenities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: hostel.amenities.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Icon(Icons.access_time, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              hostel.amenities[index],
                              style: TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NPR ${hostel.price}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Amount',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/booking',
                            arguments: hostel,
                          );
                        },
                        child: const Text(
                          'Book Now\n& pay at hostel',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'By proceeding, you agree to our ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Hostel Policies',
                            style: TextStyle(
                              color: Color(0xFF7A4B3A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

// Screen 3: Booking Page
class BookingPage extends StatelessWidget {
  BookingPage({super.key});

  final TextEditingController nameController = TextEditingController(
    text: 'Lendrick Kumar',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'lendrickkumar1@gmail.com',
  );

  @override
  Widget build(BuildContext context) {
    final Hostel hostel = ModalRoute.of(context)!.settings.arguments as Hostel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image.network(
            hostel.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flag, color: Color(0xFF7A4B3A), size: 20),
                      SizedBox(width: 8),
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
                  SizedBox(height: 12),
                  Text(
                    hostel.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'NarayanHiti Path, Nagpokhari -1,\nKathmandu 44600',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF7A4B3A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${hostel.rating}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.star, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '| (${hostel.reviews})',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Location',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    hostel.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Amenities',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: hostel.amenities.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Icon(Icons.access_time, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              hostel.amenities[index],
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  Text(
                    'View all amenities',
                    style: TextStyle(
                      color: Color(0xFF7A4B3A),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'User Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NPR ${hostel.price}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Amount',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/pricing',
                            arguments: hostel,
                          );
                        },
                        child: const Text(
                          'Book Now\n& pay at hostel',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'By proceeding, you agree to our ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Hostel Policies',
                            style: TextStyle(
                              color: Color(0xFF7A4B3A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

// Screen 4: Pricing Page
class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Hostel hostel = ModalRoute.of(context)!.settings.arguments as Hostel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          hostel.name,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.local_offer, color: Color(0xFF7A4B3A), size: 20),
                SizedBox(width: 12),
                Text('Apply Coupon', style: TextStyle(fontSize: 14)),
                Spacer(),
                Icon(Icons.copy, color: Colors.grey, size: 18),
              ],
            ),
            Divider(height: 32),
            Text(
              'More Offers',
              style: TextStyle(
                color: Color(0xFF7A4B3A),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price to Pay', style: TextStyle(fontSize: 14)),
                Row(
                  children: [
                    Text(
                      'NPR ${hostel.price}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/confirmation');
                },
                child: const Text('Book Now & pay at hostel'),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Rules & Policies',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check in After',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '10:00 AM',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check out Before',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '10:00 PM',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Important to Note',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _buildBulletPoint('Pets must be vaccinated (proof required).'),
            _buildBulletPoint('Aggressive pets may not be accepted.'),
            _buildBulletPoint('Drop-off and pick-up must be on time.'),
            _buildBulletPoint('Food can be provided or brought from home.'),
            _buildBulletPoint(
              'Personal items (beds, toys) allowed at owner\'s risk.',
            ),
            _buildBulletPoint('Emergency contact details are mandatory.'),
            _buildBulletPoint('Cancellation within 24 hrs may incur a fee.'),
            _buildBulletPoint(
              'We are not liable for pre-existing health issues.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

// Screen 5: Confirmation Page
class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFF7A4B3A),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.check, size: 60, color: Colors.white),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Congratulations !',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your hostel has been booked.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
