import 'package:flutter/material.dart';

const Color kPawBrown = Color(0xFF703418);

/// Call this from your bottom nav as the Shop tab:
/// body: const PawSewaShopScreen()
class PawSewaShopScreen extends StatefulWidget {
  final VoidCallback? onMenuPressed;
  final String? initialCategory;

  const PawSewaShopScreen({
    super.key,
    this.onMenuPressed,
    this.initialCategory,
  });

  @override
  State<PawSewaShopScreen> createState() => _PawSewaShopScreenState();
}

/// SIMPLE MODELS

class PetProduct {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final int price;
  final String emoji;
  final String? image;

  const PetProduct({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.emoji,
    this.image,
  });
}

class CategoryMeta {
  final String id;
  final String label;
  final String emoji;
  final String? image;

  const CategoryMeta({
    required this.id,
    required this.label,
    required this.emoji,
    this.image,
  });
}

/// DUMMY DATA

const List<CategoryMeta> kCategories = [
  CategoryMeta(id: 'favourites', label: 'My Favourites', emoji: '⭐'),
  CategoryMeta(
    id: 'petFood',
    label: 'Pet Food',
    emoji: '🍲',
    image: 'assets/images/petfooddisplay.png',
  ),
  CategoryMeta(
    id: 'medicines',
    label: 'Medicines',
    emoji: '💊',
    image: 'assets/images/petmedicinedisplay.png',
  ),
  CategoryMeta(
    id: 'grooming',
    label: 'Grooming',
    emoji: '🛁',
    image: 'assets/images/petgroomingdisplay.png',
  ),
  CategoryMeta(
    id: 'accessories',
    label: 'Accessories',
    emoji: '🦴',
    image: 'assets/images/petaccessoriesdisplay.png',
  ),
  CategoryMeta(
    id: 'essentials',
    label: 'Essentials',
    emoji: '🎒',
    image: 'assets/images/petessentialsdisplay.png',
  ),
];

const List<PetProduct> kProducts = [
  // Pet Food Products
  PetProduct(
    id: 'puppy-dry-food',
    name: 'Puppy Dry Food',
    subtitle: '2 KG · Complete nutrition',
    category: 'petFood',
    price: 1200,
    emoji: '🐶',
    image: 'assets/foodimages/adult-dog.png.webp',
  ),
  PetProduct(
    id: 'adult-dog-dry-food',
    name: 'Adult Dog Dry Food',
    subtitle: '3 KG · Chicken & Rice',
    category: 'petFood',
    price: 1600,
    emoji: '🐕',
    image: 'assets/foodimages/b03b5594fe8c2cbc66d24f4ed4c110aa.jpg',
  ),
  PetProduct(
    id: 'puppy-wet-food',
    name: 'Puppy Wet Food (Gravy)',
    subtitle: '400g · Rich gravy',
    category: 'petFood',
    price: 350,
    emoji: '🥫',
    image: 'assets/foodimages/images (1).jpg',
  ),
  PetProduct(
    id: 'adult-wet-food',
    name: 'Adult Wet Food (Chunks)',
    subtitle: '400g · Meat chunks',
    category: 'petFood',
    price: 380,
    emoji: '🥫',
    image: 'assets/foodimages/images (2).jpg',
  ),
  PetProduct(
    id: 'kitten-dry-food',
    name: 'Kitten Dry Food',
    subtitle: '1.5 KG · DHA enriched',
    category: 'petFood',
    price: 1100,
    emoji: '🐱',
    image: 'assets/foodimages/images (3).jpg',
  ),
  PetProduct(
    id: 'adult-cat-dry-food',
    name: 'Adult Cat Dry Food',
    subtitle: '2 KG · Hairball care',
    category: 'petFood',
    price: 1380,
    emoji: '🐈',
    image: 'assets/foodimages/images (4).jpg',
  ),
  PetProduct(
    id: 'puppy-starter-food',
    name: 'Puppy Starter Food',
    subtitle: '1 KG · Easy digest',
    category: 'petFood',
    price: 950,
    emoji: '🍼',
    image: 'assets/foodimages/images (5).jpg',
  ),
  PetProduct(
    id: 'weaning-food',
    name: 'Weaning Food (Soft)',
    subtitle: '500g · Soft texture',
    category: 'petFood',
    price: 650,
    emoji: '🥄',
    image: 'assets/foodimages/images (6).jpg',
  ),
  PetProduct(
    id: 'training-treats',
    name: 'Training Treats',
    subtitle: '200g · Reward treats',
    category: 'petFood',
    price: 450,
    emoji: '🦴',
    image: 'assets/foodimages/images.jpg',
  ),
  PetProduct(
    id: 'dental-chews',
    name: 'Dental Chews',
    subtitle: '10 pieces · Oral care',
    category: 'petFood',
    price: 550,
    emoji: '🦷',
    image: 'assets/foodimages/adult-dog.png.webp',
  ),
  PetProduct(
    id: 'calcium-chews',
    name: 'Calcium Chews',
    subtitle: '15 pieces · Bone health',
    category: 'petFood',
    price: 480,
    emoji: '🦴',
    image: 'assets/foodimages/b03b5594fe8c2cbc66d24f4ed4c110aa.jpg',
  ),
  PetProduct(
    id: 'puppy-milk-replacer',
    name: 'Puppy Milk Replacer',
    subtitle: '500g · Complete nutrition',
    category: 'petFood',
    price: 850,
    emoji: '🍼',
    image: 'assets/foodimages/images (1).jpg',
  ),
  PetProduct(
    id: 'kitten-milk-replacer',
    name: 'Kitten Milk Replacer',
    subtitle: '400g · Essential nutrients',
    category: 'petFood',
    price: 780,
    emoji: '🍼',
    image: 'assets/foodimages/images (2).jpg',
  ),

  // Medicine Products
  PetProduct(
    id: 'rabies-vaccine',
    name: 'Rabies Vaccine',
    subtitle: '1 dose · Annual protection',
    category: 'medicines',
    price: 1200,
    emoji: '💉',
    image: 'assets/medicineimages/aa.webp',
  ),
  PetProduct(
    id: 'dhppi-vaccine',
    name: 'DHPPi Vaccine',
    subtitle: '1 dose · 5-in-1 protection',
    category: 'medicines',
    price: 1500,
    emoji: '💉',
    image: 'assets/medicineimages/ab.jpg',
  ),
  PetProduct(
    id: 'leptospirosis-vaccine',
    name: 'Leptospirosis Vaccine',
    subtitle: '1 dose · Bacterial protection',
    category: 'medicines',
    price: 1100,
    emoji: '💉',
    image: 'assets/medicineimages/abc.jpg',
  ),
  PetProduct(
    id: 'pyrantel-pamoate',
    name: 'Pyrantel Pamoate',
    subtitle: '50ml · Deworming syrup',
    category: 'medicines',
    price: 480,
    emoji: '💊',
    image: 'assets/medicineimages/abcd.jpg',
  ),
  PetProduct(
    id: 'fenbendazole',
    name: 'Fenbendazole',
    subtitle: '100ml · Broad spectrum',
    category: 'medicines',
    price: 650,
    emoji: '💊',
    image: 'assets/medicineimages/asd.jpg',
  ),
  PetProduct(
    id: 'tick-flea-shampoo',
    name: 'Tick & Flea Shampoo',
    subtitle: '250ml · Medicated',
    category: 'medicines',
    price: 420,
    emoji: '🧴',
    image: 'assets/medicineimages/bb.webp',
  ),
  PetProduct(
    id: 'tick-flea-spray',
    name: 'Tick & Flea Spray',
    subtitle: '200ml · Instant relief',
    category: 'medicines',
    price: 380,
    emoji: '🧴',
    image: 'assets/medicineimages/ss.webp',
  ),
  PetProduct(
    id: 'amoxicillin',
    name: 'Amoxicillin',
    subtitle: '10 tablets · Antibiotic',
    category: 'medicines',
    price: 320,
    emoji: '💊',
    image: 'assets/medicineimages/st.webp',
  ),
  PetProduct(
    id: 'cephalexin',
    name: 'Cephalexin',
    subtitle: '10 capsules · Antibiotic',
    category: 'medicines',
    price: 380,
    emoji: '💊',
    image: 'assets/medicineimages/aa.webp',
  ),
  PetProduct(
    id: 'meloxicam',
    name: 'Meloxicam',
    subtitle: '30ml · Pain relief',
    category: 'medicines',
    price: 450,
    emoji: '💊',
    image: 'assets/medicineimages/ab.jpg',
  ),
  PetProduct(
    id: 'carprofen',
    name: 'Carprofen',
    subtitle: '20 tablets · Anti-inflammatory',
    category: 'medicines',
    price: 520,
    emoji: '💊',
    image: 'assets/medicineimages/abc.jpg',
  ),
  PetProduct(
    id: 'probiotics',
    name: 'Probiotics for Pets',
    subtitle: '30 sachets · Gut health',
    category: 'medicines',
    price: 680,
    emoji: '💊',
    image: 'assets/medicineimages/abcd.jpg',
  ),
  PetProduct(
    id: 'anti-diarrheal',
    name: 'Anti-diarrheal Syrups',
    subtitle: '100ml · Digestive aid',
    category: 'medicines',
    price: 350,
    emoji: '💊',
    image: 'assets/medicineimages/asd.jpg',
  ),
  PetProduct(
    id: 'pet-toothpaste',
    name: 'Pet Toothpaste',
    subtitle: '75g · Dental care',
    category: 'medicines',
    price: 280,
    emoji: '🦷',
    image: 'assets/medicineimages/bb.webp',
  ),
  PetProduct(
    id: 'digestive-enzyme',
    name: 'Digestive Enzyme Powder',
    subtitle: '50g · Enzyme supplement',
    category: 'medicines',
    price: 580,
    emoji: '💊',
    image: 'assets/medicineimages/ss.webp',
  ),
  PetProduct(
    id: 'calcium-syrup',
    name: 'Calcium Syrup/Tablets',
    subtitle: '200ml · Bone health',
    category: 'medicines',
    price: 420,
    emoji: '💊',
    image: 'assets/medicineimages/st.webp',
  ),
  PetProduct(
    id: 'eye-drops',
    name: 'Eye Drops',
    subtitle: '10ml · Eye care',
    category: 'medicines',
    price: 320,
    emoji: '👁️',
    image: 'assets/medicineimages/aa.webp',
  ),

  // Grooming Products
  PetProduct(
    id: 'bath-blow-dry',
    name: 'Bath & Blow Dry',
    subtitle: 'Professional service',
    category: 'grooming',
    price: 800,
    emoji: '🛁',
    image: 'assets/groomingimages/71NcjJPa95L._AC_UF1000,1000_QL80_.jpg',
  ),
  PetProduct(
    id: 'nail-trimming',
    name: 'Nail Trimming',
    subtitle: 'Professional service',
    category: 'grooming',
    price: 300,
    emoji: '✂️',
    image: 'assets/groomingimages/images (1).jpg',
  ),
  PetProduct(
    id: 'ear-cleaning',
    name: 'Ear Cleaning',
    subtitle: 'Professional service',
    category: 'grooming',
    price: 250,
    emoji: '👂',
    image: 'assets/groomingimages/images (2).jpg',
  ),
  PetProduct(
    id: 'eye-cleaning',
    name: 'Eye Cleaning',
    subtitle: 'Professional service',
    category: 'grooming',
    price: 200,
    emoji: '👁️',
    image: 'assets/groomingimages/images (3).jpg',
  ),
  PetProduct(
    id: 'full-grooming',
    name: 'Full Body Grooming',
    subtitle: 'Bath + Trim + Nails + Ears',
    category: 'grooming',
    price: 1500,
    emoji: '✨',
    image: 'assets/groomingimages/images (4).jpg',
  ),
  PetProduct(
    id: 'puppy-shampoo',
    name: 'Puppy Shampoo',
    subtitle: '250ml · Gentle formula',
    category: 'grooming',
    price: 380,
    emoji: '🧴',
    image: 'assets/groomingimages/images (6).jpg',
  ),
  PetProduct(
    id: 'kitten-shampoo',
    name: 'Kitten Shampoo',
    subtitle: '200ml · Mild & safe',
    category: 'grooming',
    price: 350,
    emoji: '🧴',
    image: 'assets/groomingimages/images.jpg',
  ),
  PetProduct(
    id: 'grooming-brush',
    name: 'Grooming Brush',
    subtitle: 'Professional quality',
    category: 'grooming',
    price: 450,
    emoji: '🪥',
    image: 'assets/groomingimages/71NcjJPa95L._AC_UF1000,1000_QL80_.jpg',
  ),
  PetProduct(
    id: 'deshedding-comb',
    name: 'De-shedding Comb',
    subtitle: 'Reduces shedding',
    category: 'grooming',
    price: 520,
    emoji: '🪥',
    image: 'assets/groomingimages/images (1).jpg',
  ),

  // Accessories Products
  PetProduct(
    id: 'dog-collar',
    name: 'Dog Collar',
    subtitle: 'Adjustable · Durable',
    category: 'accessories',
    price: 450,
    emoji: '🎽',
    image: 'assets/accessoriesimages/817aYsCc2PL._AC_SL1500_.jpg',
  ),
  PetProduct(
    id: 'cat-collar',
    name: 'Cat Collar',
    subtitle: 'Soft & comfortable',
    category: 'accessories',
    price: 320,
    emoji: '🎽',
    image:
        'assets/accessoriesimages/close-up-dog-accessories_23-2150959988.avif',
  ),
  PetProduct(
    id: 'food-bowl',
    name: 'Food Bowl',
    subtitle: 'Stainless steel',
    category: 'accessories',
    price: 280,
    emoji: '🥣',
    image: 'assets/accessoriesimages/images (1).jpg',
  ),
  PetProduct(
    id: 'water-bowl',
    name: 'Water Bowl',
    subtitle: 'Non-slip base',
    category: 'accessories',
    price: 250,
    emoji: '🥣',
    image: 'assets/accessoriesimages/images (2).jpg',
  ),
  PetProduct(
    id: 'dog-bed',
    name: 'Dog Bed',
    subtitle: 'Medium size · Washable',
    category: 'accessories',
    price: 1200,
    emoji: '🛏️',
    image: 'assets/accessoriesimages/images (3).jpg',
  ),
  PetProduct(
    id: 'cat-bed',
    name: 'Cat Bed',
    subtitle: 'Cozy & warm',
    category: 'accessories',
    price: 850,
    emoji: '🛏️',
    image: 'assets/accessoriesimages/images (4).jpg',
  ),
  PetProduct(
    id: 'chew-toys',
    name: 'Chew Toys',
    subtitle: 'Dental health',
    category: 'accessories',
    price: 380,
    emoji: '🦴',
    image: 'assets/accessoriesimages/images.jpg',
  ),
  PetProduct(
    id: 'rubber-toys',
    name: 'Rubber Toys',
    subtitle: 'Interactive play',
    category: 'accessories',
    price: 320,
    emoji: '🎾',
    image: 'assets/accessoriesimages/817aYsCc2PL._AC_SL1500_.jpg',
  ),
  PetProduct(
    id: 'seat-belt-harness',
    name: 'Seat Belt Harness',
    subtitle: 'Car safety',
    category: 'accessories',
    price: 680,
    emoji: '🚗',
    image:
        'assets/accessoriesimages/close-up-dog-accessories_23-2150959988.avif',
  ),
  PetProduct(
    id: 'car-seat-cover',
    name: 'Car Seat Cover',
    subtitle: 'Waterproof',
    category: 'accessories',
    price: 950,
    emoji: '🚗',
    image: 'assets/accessoriesimages/images (1).jpg',
  ),
  PetProduct(
    id: 'poop-scooper',
    name: 'Poop Scooper',
    subtitle: 'Easy cleanup',
    category: 'accessories',
    price: 420,
    emoji: '🧹',
    image: 'assets/accessoriesimages/images (2).jpg',
  ),
  PetProduct(
    id: 'waste-bags',
    name: 'Waste Bags',
    subtitle: '100 pieces · Biodegradable',
    category: 'accessories',
    price: 180,
    emoji: '🗑️',
    image: 'assets/accessoriesimages/images (3).jpg',
  ),

  // Essentials Products
  PetProduct(
    id: 'pet-wipes-general',
    name: 'Pet Wipes (General)',
    subtitle: '80 wipes · Multi-use',
    category: 'essentials',
    price: 280,
    emoji: '🧻',
    image: 'assets/essentialsimages/images (1).jpg',
  ),
  PetProduct(
    id: 'pet-wipes-antibacterial',
    name: 'Pet Wipes (Anti-bacterial)',
    subtitle: '60 wipes · Sanitizing',
    category: 'essentials',
    price: 320,
    emoji: '🧻',
    image: 'assets/essentialsimages/images (2).jpg',
  ),
  PetProduct(
    id: 'dry-bath-powder',
    name: 'Dry Bath Powder',
    subtitle: '200g · Waterless cleaning',
    category: 'essentials',
    price: 380,
    emoji: '🧴',
    image: 'assets/essentialsimages/images (3).jpg',
  ),
  PetProduct(
    id: 'urine-cleaner',
    name: 'Urine Cleaner / Odor Remover',
    subtitle: '500ml · Enzyme formula',
    category: 'essentials',
    price: 450,
    emoji: '🧴',
    image: 'assets/essentialsimages/images (4).jpg',
  ),
  PetProduct(
    id: 'floor-surface-cleaner',
    name: 'Floor & Surface Pet Cleaner',
    subtitle: '750ml · Pet-safe',
    category: 'essentials',
    price: 520,
    emoji: '🧴',
    image: 'assets/essentialsimages/images (5).jpg',
  ),
  PetProduct(
    id: 'litter-deodorizer',
    name: 'Litter Deodorizer',
    subtitle: '400g · Odor control',
    category: 'essentials',
    price: 350,
    emoji: '🧴',
    image: 'assets/essentialsimages/images (7).jpg',
  ),
  PetProduct(
    id: 'paw-balm',
    name: 'Paw Balm / Paw Butter',
    subtitle: '50g · Moisturizing',
    category: 'essentials',
    price: 420,
    emoji: '🐾',
    image: 'assets/essentialsimages/images.jpg',
  ),
  PetProduct(
    id: 'nose-balm',
    name: 'Nose Balm',
    subtitle: '30g · Healing formula',
    category: 'essentials',
    price: 380,
    emoji: '👃',
    image: 'assets/essentialsimages/images (1).jpg',
  ),
  PetProduct(
    id: 'anti-dryness-cream',
    name: 'Anti-Dryness Cream',
    subtitle: '100g · Skin care',
    category: 'essentials',
    price: 480,
    emoji: '🧴',
    image: 'assets/essentialsimages/images (2).jpg',
  ),
  PetProduct(
    id: 'coat-shine-spray',
    name: 'Coat Shine Spray',
    subtitle: '200ml · Glossy finish',
    category: 'essentials',
    price: 420,
    emoji: '✨',
    image: 'assets/essentialsimages/images (3).jpg',
  ),
  PetProduct(
    id: 'fur-detangler',
    name: 'Fur Detangler Spray',
    subtitle: '250ml · Easy brushing',
    category: 'essentials',
    price: 450,
    emoji: '🪥',
    image: 'assets/essentialsimages/images (4).jpg',
  ),
];

class _PawSewaShopScreenState extends State<PawSewaShopScreen> {
  String _selectedCategoryId = 'petFood';
  final Map<String, int> _cart = {}; // productId -> qty

  // FILTER STATE (only UI; no real filtering yet)
  String _sortBy = 'Relevance';
  bool _moveUnavailableToBottom = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategoryId = widget.initialCategory!;
    }
  }

  int get _totalItems =>
      _cart.values.fold(0, (previous, element) => previous + element);

  int get _subtotal {
    int sum = 0;
    _cart.forEach((id, qty) {
      final p = kProducts.firstWhere((e) => e.id == id);
      sum += p.price * qty;
    });
    return sum;
  }

  int get _deliveryFee => 80;
  int get _grandTotal => _subtotal + _deliveryFee;

  List<PetProduct> get _visibleProducts {
    // Only category filter; you can extend with sort logic later.
    return kProducts.where((p) => p.category == _selectedCategoryId).toList();
  }

  void _updateQty(PetProduct product, int qty) {
    setState(() {
      if (qty <= 0) {
        _cart.remove(product.id);
      } else {
        _cart[product.id] = qty;
      }
    });
  }

  void _openAddSheet(PetProduct product) {
    showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddToCartSheet(product: product),
    ).then((qty) {
      if (qty != null && qty > 0) {
        _updateQty(product, (_cart[product.id] ?? 0) + qty);
      }
    });
  }

  void _openFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FilterSheet(
        initialSortBy: _sortBy,
        initialMoveUnavailable: _moveUnavailableToBottom,
        onChanged: (sort, moveToBottom) {
          setState(() {
            _sortBy = sort;
            _moveUnavailableToBottom = moveToBottom;
          });
        },
      ),
    );
  }

  void _openPromoSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _PromoSheet(),
    );
  }

  void _openAddressSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AddressSheet(),
    );
  }

  void _openPaymentSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PaymentSheet(
        amount: _grandTotal,
        onConfirmed: () {
          Navigator.of(ctx).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment method saved (UI only).')),
          );
        },
      ),
    );
  }

  void _openCheckoutSheet() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your basket is empty.')));
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CheckoutSheet(
        cart: _cart,
        subtotal: _subtotal,
        deliveryFee: _deliveryFee,
        onChangeAddress: _openAddressSheet,
        onApplyPromo: _openPromoSheet,
        onSelectPayment: _openPaymentSheet,
        onChangeItemQty: (product, qty) => _updateQty(product, qty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(
                  child: _CategoryCircleStrip(
                    selectedId: _selectedCategoryId,
                    onChanged: (id) => setState(() => _selectedCategoryId = id),
                  ),
                ),
                SliverToBoxAdapter(child: _buildSectionTitle()),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = _visibleProducts[index];
                      final qty = _cart[product.id] ?? 0;
                      return _ProductCard(
                        product: product,
                        quantity: qty,
                        onTapAdd: () {
                          if (qty == 0) {
                            _openAddSheet(product);
                          } else {
                            _updateQty(product, qty + 1);
                          }
                        },
                        onTapMinus: qty > 0
                            ? () => _updateQty(product, qty - 1)
                            : null,
                        onTapImage: () => _openAddSheet(product),
                      );
                    }, childCount: _visibleProducts.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 0.75,
                        ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
            if (_cart.isNotEmpty)
              _FloatingCartBar(
                totalItems: _totalItems,
                subtotal: _subtotal,
                onTap: _openCheckoutSheet,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (widget.onMenuPressed != null) ...[
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onPressed: widget.onMenuPressed,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/logo/main_logo.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'PawSewa Shop',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_rounded),
              ),
              IconButton(
                onPressed: _openFilterSheet,
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivering within a day (10am–5pm)
              Row(
                children: const [
                  Text(
                    'Delivering within ',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    'a day',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kPawBrown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '10:00 AM to 5:00 PM',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  const SizedBox(width: 6),
                  const Text('•', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.delivery_dining_rounded,
                    size: 16,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Rs. $_deliveryFee',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Free delivery banner (brown themed)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7EFE8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kPawBrown.withValues(alpha: 0.55),
                    width: 0.9,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: kPawBrown,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.percent_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Free delivery',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Enjoy FREE delivery on orders above Rs. 1000',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade800,
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
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSectionTitle() {
    final catMeta = kCategories.firstWhere((c) => c.id == _selectedCategoryId);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            catMeta.label,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            _selectedCategoryId == 'petFood'
                ? 'Balanced meals tailored for dogs and cats.'
                : _selectedCategoryId == 'medicines'
                ? 'Vet‑approved essentials for safe treatment.'
                : _selectedCategoryId == 'grooming'
                ? 'Keep coats shiny, skin calm, and paws clean.'
                : _selectedCategoryId == 'accessories'
                ? 'Comfortable, durable daily‑use gear.'
                : 'Everyday supplies your pet depends on.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

/// CATEGORY STRIP (circular with label, like OneMart)

class _CategoryCircleStrip extends StatelessWidget {
  final String selectedId;
  final ValueChanged<String> onChanged;

  const _CategoryCircleStrip({
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final meta = kCategories[index];
          final isActive = meta.id == selectedId;
          return GestureDetector(
            onTap: () => onChanged(meta.id),
            child: SizedBox(
              width: 70,
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive ? kPawBrown : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    child: ClipOval(
                      child: meta.image != null
                          ? Image.asset(meta.image!, fit: BoxFit.cover)
                          : Container(
                              color: const Color(0xFFF5F0EB),
                              child: Center(
                                child: Text(
                                  meta.emoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      meta.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive ? Colors.black87 : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: kCategories.length,
      ),
    );
  }
}

/// PRODUCT CARD (optimized for 3-column layout)

class _ProductCard extends StatelessWidget {
  final PetProduct product;
  final int quantity;
  final VoidCallback onTapAdd;
  final VoidCallback? onTapMinus;
  final VoidCallback onTapImage;

  const _ProductCard({
    required this.product,
    required this.quantity,
    required this.onTapAdd,
    required this.onTapMinus,
    required this.onTapImage,
  });

  @override
  Widget build(BuildContext context) {
    final hasQty = quantity > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: onTapImage,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F1EC),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: product.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          product.image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Text(
                            product.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      )
                    : Text(product.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Flexible(
                  child: Text(
                    product.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 8, color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rs. ${product.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    if (!hasQty)
                      InkWell(
                        onTap: onTapAdd,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: kPawBrown,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else
                      _QtyPill(
                        qty: quantity,
                        onMinus: onTapMinus!,
                        onPlus: onTapAdd,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyPill extends StatelessWidget {
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _QtyPill({
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconButton(Icons.remove, onMinus),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$qty',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
            ),
          ),
          _iconButton(Icons.add, onPlus),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(icon, size: 12, color: kPawBrown),
      ),
    );
  }
}

/// FLOATING CART BAR

class _FloatingCartBar extends StatelessWidget {
  final int totalItems;
  final int subtotal;
  final VoidCallback onTap;

  const _FloatingCartBar({
    required this.totalItems,
    required this.subtotal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kPawBrown,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: kPawBrown.withValues(alpha: 0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  '$totalItems item${totalItems == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Rs. $subtotal.00/-',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const Text(
                  'View basket',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ADD TO CART BOTTOM SHEET

class _AddToCartSheet extends StatefulWidget {
  final PetProduct product;

  const _AddToCartSheet({required this.product});

  @override
  State<_AddToCartSheet> createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<_AddToCartSheet> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.8,
      minChildSize: 0.45,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Add item to basket',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F1EC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: widget.product.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                widget.product.image!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Text(
                                  widget.product.emoji,
                                  style: const TextStyle(fontSize: 80),
                                ),
                              ),
                            )
                          : Text(
                              widget.product.emoji,
                              style: const TextStyle(fontSize: 80),
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Rs. ${widget.product.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        _QtyPill(
                          qty: _qty,
                          onMinus: () {
                            if (_qty > 1) setState(() => _qty--);
                          },
                          onPlus: () => setState(() => _qty++),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(_qty);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: kPawBrown,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: kPawBrown.withValues(alpha: 0.4),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Add to basket • Rs. ${widget.product.price * _qty}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// FILTER SHEET (OneMart style)

class _FilterSheet extends StatefulWidget {
  final String initialSortBy;
  final bool initialMoveUnavailable;
  final void Function(String sortBy, bool moveUnavailable) onChanged;

  const _FilterSheet({
    required this.initialSortBy,
    required this.initialMoveUnavailable,
    required this.onChanged,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String _sortBy;
  late bool _moveUnavailable;

  final List<String> _sortOptions = const [
    'Relevance',
    'Price (low to high)',
    'Price (high to low)',
    'Discount (high to low)',
  ];

  @override
  void initState() {
    super.initState();
    _sortBy = widget.initialSortBy;
    _moveUnavailable = widget.initialMoveUnavailable;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Filter',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: [
                    const Text(
                      'Sort by',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sortOptions.map((option) {
                        final isActive = option == _sortBy;
                        return GestureDetector(
                          onTap: () => setState(() => _sortBy = option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.black87
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 12,
                                color: isActive ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Move unavailable products to bottom',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(
                            () => _moveUnavailable = !_moveUnavailable,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 44,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _moveUnavailable
                                  ? kPawBrown
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            alignment: _moveUnavailable
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Pet brands (UI only)',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _BrandChip(label: 'Royal Canin'),
                        _BrandChip(label: 'Drools'),
                        _BrandChip(label: 'Whiskas'),
                        _BrandChip(label: 'Pedigree'),
                        _BrandChip(label: 'Farmina'),
                        _BrandChip(label: 'Himalaya'),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            setState(() {
                              _sortBy = 'Relevance';
                              _moveUnavailable = true;
                            });
                            widget.onChanged(_sortBy, _moveUnavailable);
                          },
                          child: const Text(
                            'Clear all',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPawBrown,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            widget.onChanged(_sortBy, _moveUnavailable);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Apply',
                            style: TextStyle(fontWeight: FontWeight.w700),
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
      },
    );
  }
}

class _BrandChip extends StatelessWidget {
  final String label;

  const _BrandChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

/// PROMO SHEET (like “Use Promo Code” modal)

class _PromoSheet extends StatelessWidget {
  const _PromoSheet();

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.75,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Use promo code',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: 'Enter promo code',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (controller.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Enter a code to apply.'),
                                ),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Promo validation is UI only in this build.',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.grey.shade700,
                          ),
                          child: const Text('APPLY'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.local_activity_outlined,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No available promos',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
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
    );
  }
}

/// ADDRESS SHEET (Add address UI)

class _AddressSheet extends StatelessWidget {
  const _AddressSheet();

  @override
  Widget build(BuildContext context) {
    final addressTitleController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Add address',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: [
                    Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Map preview (UI only)',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Dharan, Sunsari · Nepal',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Set location is UI only in this build.',
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'SET LOCATION',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: kPawBrown,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _addressField(
                      label: 'Address title e.g. Home, Clinic',
                      controller: addressTitleController,
                      isRequired: true,
                    ),
                    const SizedBox(height: 10),
                    _addressField(
                      label: 'Full name',
                      controller: nameController,
                      isRequired: true,
                    ),
                    const SizedBox(height: 10),
                    _addressField(
                      label: 'Mobile number',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPawBrown,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      minimumSize: const Size.fromHeight(44),
                    ),
                    onPressed: () {
                      if (addressTitleController.text.trim().isEmpty ||
                          nameController.text.trim().isEmpty ||
                          phoneController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all required fields.'),
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Address saved locally (UI only).'),
                        ),
                      );
                    },
                    child: const Text(
                      'SAVE ADDRESS',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _addressField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}

/// CHECKOUT SHEET (mirrors checkout & confirmation)

class _CheckoutSheet extends StatefulWidget {
  final Map<String, int> cart;
  final int subtotal;
  final int deliveryFee;
  final VoidCallback onChangeAddress;
  final VoidCallback onApplyPromo;
  final VoidCallback onSelectPayment;
  final void Function(PetProduct product, int qty) onChangeItemQty;

  const _CheckoutSheet({
    required this.cart,
    required this.subtotal,
    required this.deliveryFee,
    required this.onChangeAddress,
    required this.onApplyPromo,
    required this.onSelectPayment,
    required this.onChangeItemQty,
  });

  @override
  State<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<_CheckoutSheet> {
  String _selectedDay = 'Today';
  String _selectedSlot = 'As soon as possible';

  int get _grandTotal => widget.subtotal + widget.deliveryFee;

  @override
  Widget build(BuildContext context) {
    final entries = widget.cart.entries.toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.96,
      minChildSize: 0.7,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Text(
                      'Checkout & confirmation',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: [
                    const SizedBox(height: 8),
                    // Address
                    GestureDetector(
                      onTap: widget.onChangeAddress,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.add_location_alt_outlined,
                              color: kPawBrown,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Add delivery address',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Delivery date & time',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _dayChip('Today'),
                        const SizedBox(width: 8),
                        _dayChip('Tomorrow'),
                        const SizedBox(width: 8),
                        _dayChip('Day after'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _slotChip('As soon as possible'),
                        _slotChip('10:00–11:00'),
                        _slotChip('13:00–14:00'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Items
                    Row(
                      children: [
                        Text(
                          'Your items (${entries.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.expand_less_rounded),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ...entries.map((e) {
                      final product = kProducts.firstWhere(
                        (p) => p.id == e.key,
                      );
                      final qty = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F1EC),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                product.emoji,
                                style: const TextStyle(fontSize: 26),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Rs. ${product.price}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _QtyPill(
                              qty: qty,
                              onMinus: () =>
                                  widget.onChangeItemQty(product, qty - 1),
                              onPlus: () =>
                                  widget.onChangeItemQty(product, qty + 1),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 18),
                    // Promo
                    const Text(
                      'Promo code',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: widget.onApplyPromo,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.local_offer_outlined, color: kPawBrown),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Apply promo code',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Bill details',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _billRow('Items total', widget.subtotal),
                    const SizedBox(height: 4),
                    _billRow('Delivery charge', widget.deliveryFee),
                    const SizedBox(height: 6),
                    const Divider(height: 1, color: Color(0xFFE3E0DD)),
                    const SizedBox(height: 6),
                    _billRow('Grand total', _grandTotal, isEmphasis: true),
                    const SizedBox(height: 18),
                    const Text(
                      'Payment method',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: widget.onSelectPayment,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.credit_card_outlined, color: kPawBrown),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Select payment method',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPawBrown,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      minimumSize: const Size.fromHeight(44),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order review complete (UI only).'),
                        ),
                      );
                    },
                    child: const Text(
                      'Confirm order',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dayChip(String label) {
    final isSelected = _selectedDay == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDay = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? const Color(0xFFF6F1EC) : Colors.white,
            border: Border.all(
              color: isSelected ? kPawBrown : const Color(0xFFE3E0DD),
              width: isSelected ? 1.4 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? kPawBrown : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label == 'Today'
                    ? 'Selected'
                    : label == 'Tomorrow'
                    ? 'Next day'
                    : 'Later',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slotChip(String label) {
    final isSelected = _selectedSlot == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedSlot = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? const Color(0xFFF6F1EC) : Colors.white,
          border: Border.all(
            color: isSelected ? kPawBrown : const Color(0xFFE3E0DD),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? kPawBrown : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _billRow(String label, int amount, {bool isEmphasis = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isEmphasis ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          'Rs. $amount',
          style: TextStyle(
            fontSize: isEmphasis ? 15 : 13,
            fontWeight: isEmphasis ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// PAYMENT SHEET (local + international methods)

class _PaymentSheet extends StatefulWidget {
  final int amount;
  final VoidCallback onConfirmed;

  const _PaymentSheet({required this.amount, required this.onConfirmed});

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  String _selected = 'Cash on Delivery';

  final List<String> _local = const [
    'Cash on Delivery',
    'eSewa',
    'Khalti',
    'Fonepay',
    'ConnectIPS',
    'Credit / Debit Card (NP)',
    'Nepal Pay',
  ];

  final List<String> _intl = const ['PayPal', 'Credit / Debit Card'];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.7,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Payment method',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: [
                    const Text(
                      'Local users',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _local
                          .map((m) => _paymentTile(label: m))
                          .toList(),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'International users',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _intl
                          .map((m) => _paymentTile(label: m))
                          .toList(),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('To pay', style: TextStyle(fontSize: 13)),
                          const Spacer(),
                          Text(
                            'Rs. ${widget.amount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPawBrown,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          minimumSize: const Size.fromHeight(44),
                        ),
                        onPressed: () {
                          widget.onConfirmed();
                        },
                        child: const Text(
                          'Confirm payment method',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _paymentTile({required String label}) {
    final isSelected = _selected == label;
    return GestureDetector(
      onTap: () => setState(() => _selected = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF6F1EC) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kPawBrown : const Color(0xFFE3E0DD),
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        width: 110,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: kPawBrown,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
