import 'package:flutter/material.dart';

const Color primaryBrown = Color(0xFF7A4B3A);

class ServicesShell extends StatefulWidget {
  const ServicesShell({super.key});

  @override
  State<ServicesShell> createState() => _ServicesShellState();
}

class _ServicesShellState extends State<ServicesShell>
    with TickerProviderStateMixin {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _PlaceholderScreen(label: 'Home'),
      const ServicesHomeScreen(),
      const _PlaceholderScreen(label: 'Shop'),
      const _PlaceholderScreen(label: 'Hostel'),
      const _PlaceholderScreen(label: 'Profile'),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) {
          setState(() => _currentIndex = i);
        },
        backgroundColor: const Color(0xFFF7F1EA),
        indicatorColor: const Color(0x1A7A4B3A),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services_rounded),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag_rounded),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.house_outlined),
            selectedIcon: Icon(Icons.house_rounded),
            label: 'Hostel',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$label (UI not in scope)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

/// SERVICES HOME SCREEN

class ServicesHomeScreen extends StatefulWidget {
  const ServicesHomeScreen({super.key});

  @override
  State<ServicesHomeScreen> createState() => _ServicesHomeScreenState();
}

class _ServicesHomeScreenState extends State<ServicesHomeScreen>
    with TickerProviderStateMixin {
  bool hasUnreadMessages = true;

  final List<_PetVaccinationReminder> reminders = [
    _PetVaccinationReminder(
      petName: 'Milo',
      avatarColor: const Color(0xFFFFD9A0),
      nextVaccine: 'Rabies booster',
      dueInDays: 3,
      completion: 0.6,
      ageYears: 1,
      recommendedNext: ['DHPP booster'],
      pastVaccines: [
        _VaccineRecord(name: 'Rabies', date: '12 Jan 2025'),
        _VaccineRecord(name: 'DHPP', date: '10 Jan 2025'),
      ],
      remindersOn: true,
    ),
    _PetVaccinationReminder(
      petName: 'Luna',
      avatarColor: const Color(0xFFE8C2B3),
      nextVaccine: 'Parvo booster',
      dueInDays: 0,
      completion: 0.8,
      ageYears: 0.5,
      recommendedNext: ['Leptospirosis'],
      pastVaccines: [_VaccineRecord(name: 'Parvo', date: '02 Nov 2025')],
      remindersOn: true,
    ),
    _PetVaccinationReminder(
      petName: 'Rocky',
      avatarColor: const Color(0xFFD6E6FF),
      nextVaccine: 'Annual combo',
      dueInDays: -4,
      completion: 0.4,
      ageYears: 3,
      recommendedNext: ['Annual wellness panel'],
      pastVaccines: [_VaccineRecord(name: 'Rabies', date: '01 Aug 2024')],
      remindersOn: false,
    ),
  ];

  final List<_Clinic> clinics = [
    const _Clinic(
      name: 'Happy Paws Vet Clinic',
      distanceKm: 1.2,
      address: 'Sahid Maarg, Dharan',
      isOpen: true,
    ),
    const _Clinic(
      name: 'Koshi Animal Care Center',
      distanceKm: 2.8,
      address: 'Bhanuchok, Dharan',
      isOpen: false,
    ),
  ];

  final List<_Appointment> appointments = [
    _Appointment(
      id: '1',
      petName: 'Milo',
      serviceType: 'General Checkup',
      dateTime: '12 Jan • 10:30 AM',
      status: AppointmentStatus.upcoming,
      visitType: VisitType.atClinic,
    ),
  ];

  final ScrollController _scrollController = ScrollController();

  void _openVaccinationScreen() {
    Navigator.of(
      context,
    ).push(_fadeSlideRoute(VaccinationRemindersScreen(reminders: reminders)));
  }

  void _openClinicsScreen() {
    Navigator.of(
      context,
    ).push(_fadeSlideRoute(ClinicsScreen(clinics: clinics)));
  }

  void _openAppointmentFlow({VisitType? initialVisitType}) {
    Navigator.of(context).push(
      _fadeSlideRoute(
        BookAppointmentScreen(
          onAppointmentCreated: (appointment) {
            setState(() {
              appointments.insert(0, appointment);
            });
          },
          initialVisitType: initialVisitType,
        ),
      ),
    );
  }

  void _scrollToUpcomingAppointments() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Services'),
            Text(
              'Everything your pet needs',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.brown.shade400),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    setState(() => hasUnreadMessages = false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.message_outlined,
                      size: 22,
                      color: primaryBrown,
                    ),
                  ),
                ),
                if (hasUnreadMessages)
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8F0), Color(0xFFF7F1EA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: false,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 88)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _ServicesSummaryStrip(
                    onTapDetails: _openVaccinationScreen,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _QuickActionsStrip(
                    onBookVisit: () => _openAppointmentFlow(),
                    onVaccinationSchedule: _openVaccinationScreen,
                    onUpcomingReminder: _openVaccinationScreen,
                    onViewClinics: _openClinicsScreen,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _ServicesGrid(
                    onBookAppointment: () => _openAppointmentFlow(),
                    onVaccinationReminders: _openVaccinationScreen,
                    onClinicsNearMe: _openClinicsScreen,
                    onEmergencyHelp: () => _openAppointmentFlow(
                      initialVisitType: VisitType.emergencyAtHome,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: VaccinationRemindersSection(
                    reminders: reminders,
                    compact: true,
                    onTapSeeAll: _openVaccinationScreen,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: UpcomingAppointmentsSection(
                    appointments: appointments,
                    onTapViewAll: _scrollToUpcomingAppointments,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _HelpInfoSection(onBook: () => _openAppointmentFlow()),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

/// QUICK ACTIONS

class _QuickActionsStrip extends StatelessWidget {
  final VoidCallback onBookVisit;
  final VoidCallback onVaccinationSchedule;
  final VoidCallback onUpcomingReminder;
  final VoidCallback onViewClinics;

  const _QuickActionsStrip({
    required this.onBookVisit,
    required this.onVaccinationSchedule,
    required this.onUpcomingReminder,
    required this.onViewClinics,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);
    final pills = [
      _QuickActionPill(
        label: 'Book vet visit',
        icon: Icons.calendar_today_rounded,
        onTap: onBookVisit,
      ),
      _QuickActionPill(
        label: 'Vaccination schedule',
        icon: Icons.vaccines_rounded,
        onTap: onVaccinationSchedule,
      ),
      _QuickActionPill(
        label: 'Upcoming reminder',
        icon: Icons.notifications_active_rounded,
        onTap: onUpcomingReminder,
      ),
      _QuickActionPill(
        label: 'View clinics',
        icon: Icons.place_rounded,
        onTap: onViewClinics,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            for (final pill in pills) ...[
              _AnimatedTapScale(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 6,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5E9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryBrown.withOpacity(0.12)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: pill.onTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(pill.icon, size: 18, color: primaryBrown),
                        const SizedBox(width: 6),
                        Text(
                          pill.label,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: primaryBrown,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickActionPill {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  _QuickActionPill({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

/// SERVICE CARDS

class _ServicesGrid extends StatelessWidget {
  final VoidCallback onBookAppointment;
  final VoidCallback onVaccinationReminders;
  final VoidCallback onClinicsNearMe;
  final VoidCallback onEmergencyHelp;

  const _ServicesGrid({
    required this.onBookAppointment,
    required this.onVaccinationReminders,
    required this.onClinicsNearMe,
    required this.onEmergencyHelp,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ServiceCardData(
        title: 'Book appointment',
        description: 'Choose a time that suits you.',
        icon: Icons.event_available_rounded,
        onTap: onBookAppointment,
        heroTag: 'book_appointment_hero',
      ),
      _ServiceCardData(
        title: 'Vaccination reminders',
        description: 'We’ll remind you before it’s due.',
        icon: Icons.vaccines_rounded,
        onTap: onVaccinationReminders,
        heroTag: 'vaccination_reminders_hero',
      ),
      _ServiceCardData(
        title: 'Clinics near me',
        description: 'See trusted vets nearby.',
        icon: Icons.location_on_rounded,
        onTap: onClinicsNearMe,
        heroTag: 'clinics_near_me_hero',
      ),
      _ServiceCardData(
        title: 'Emergency help',
        description: 'Get urgent support fast.',
        icon: Icons.emergency_rounded,
        onTap: onEmergencyHelp,
        heroTag: 'emergency_help_hero',
      ),
    ];

    return GridView.builder(
      itemCount: cards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 150,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final data = cards[index];
        return _ServiceCard(data: data);
      },
    );
  }
}

class _ServiceCardData {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final String heroTag;

  _ServiceCardData({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    required this.heroTag,
  });
}

class _ServiceCard extends StatelessWidget {
  final _ServiceCardData data;

  const _ServiceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return _AnimatedTapScale(
      child: Hero(
        tag: data.heroTag,
        flightShuttleBuilder:
            (flightContext, animation, direction, fromContext, toContext) {
              return ScaleTransition(
                scale: animation.drive(
                  Tween<double>(
                    begin: 0.95,
                    end: 1.0,
                  ).chain(CurveTween(curve: Curves.easeOutBack)),
                ),
                child: toContext.widget,
              );
            },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: data.onTap,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFFFF6EC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AnimatedIconBubble(icon: data.icon),
                    const Spacer(),
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: primaryBrown,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.brown.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// VACCINATION REMINDERS

class VaccinationRemindersSection extends StatefulWidget {
  final List<_PetVaccinationReminder> reminders;
  final bool compact;
  final VoidCallback? onTapSeeAll;

  const VaccinationRemindersSection({
    super.key,
    required this.reminders,
    this.compact = false,
    this.onTapSeeAll,
  });

  @override
  State<VaccinationRemindersSection> createState() =>
      _VaccinationRemindersSectionState();
}

class _VaccinationRemindersSectionState
    extends State<VaccinationRemindersSection> {
  bool showSkeleton = false;

  @override
  void initState() {
    super.initState();
    // Mock small loading delay
    showSkeleton = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => showSkeleton = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasReminders = widget.reminders.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Vaccination reminders',
          subtitle: 'We’ll remind you before it’s due.',
          icon: Icons.vaccines_rounded,
          onTapSeeAll: widget.onTapSeeAll,
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: showSkeleton
              ? _VaccinationSkeletonList(compact: widget.compact)
              : (!hasReminders
                    ? const _VaccinationEmptyState()
                    : _VaccinationList(
                        reminders: widget.reminders,
                        compact: widget.compact,
                      )),
        ),
      ],
    );
  }
}

class _VaccinationSkeletonList extends StatelessWidget {
  final bool compact;

  const _VaccinationSkeletonList({required this.compact});

  @override
  Widget build(BuildContext context) {
    final itemCount = compact ? 2 : 4;
    return Column(
      children: List.generate(
        itemCount,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              _SkeletonBox(width: 40, height: 40, radius: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: const [
                        _SkeletonBox(width: 80, height: 10),
                        SizedBox(width: 8),
                        _SkeletonBox(width: 50, height: 10),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const _SkeletonBox(width: double.infinity, height: 8),
                    const SizedBox(height: 6),
                    const _SkeletonBox(width: 120, height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VaccinationList extends StatefulWidget {
  final List<_PetVaccinationReminder> reminders;
  final bool compact;

  const _VaccinationList({required this.reminders, required this.compact});

  @override
  State<_VaccinationList> createState() => _VaccinationListState();
}

class _VaccinationListState extends State<_VaccinationList> {
  @override
  Widget build(BuildContext context) {
    final list = widget.compact && widget.reminders.length > 2
        ? widget.reminders.take(2).toList()
        : widget.reminders;

    return Column(
      children: [
        for (final reminder in list)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _VaccinationReminderCard(
              reminder: reminder,
              onChangedReminder: (updated) {
                setState(() {
                  final idx = widget.reminders.indexWhere(
                    (r) => r.petName == updated.petName,
                  );
                  if (idx != -1) widget.reminders[idx] = updated;
                });
              },
            ),
          ),
      ],
    );
  }
}

class _VaccinationReminderCard extends StatefulWidget {
  final _PetVaccinationReminder reminder;
  final ValueChanged<_PetVaccinationReminder> onChangedReminder;

  const _VaccinationReminderCard({
    required this.reminder,
    required this.onChangedReminder,
  });

  @override
  State<_VaccinationReminderCard> createState() =>
      _VaccinationReminderCardState();
}

class _VaccinationReminderCardState extends State<_VaccinationReminderCard>
    with SingleTickerProviderStateMixin {
  late bool _remindersOn;

  @override
  void initState() {
    super.initState();
    _remindersOn = widget.reminder.remindersOn;
  }

  @override
  Widget build(BuildContext context) {
    final reminder = widget.reminder;
    final status = _statusForDays(reminder.dueInDays);

    Color chipColor;
    Color chipText;
    String statusText;

    switch (status) {
      case _ReminderStatus.upcoming:
        chipColor = const Color(0xFFFFE2B5);
        chipText = const Color(0xFF703418);
        statusText = 'Upcoming';
        break;
      case _ReminderStatus.today:
        chipColor = const Color(0xFF703418);
        chipText = Colors.white;
        statusText = 'Due today';
        break;
      case _ReminderStatus.overdue:
        chipColor = const Color(0xFFB65B5B);
        chipText = Colors.white;
        statusText = 'Overdue';
        break;
    }

    final countdownText = reminder.dueInDays > 0
        ? 'Due in ${reminder.dueInDays} days'
        : reminder.dueInDays == 0
        ? 'Due today'
        : '${reminder.dueInDays.abs()} days overdue';

    return _AnimatedTapScale(
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(_fadeSlideRoute(VaccinationDetailsScreen(reminder: reminder)));
        },
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: status == _ReminderStatus.overdue
                  ? const Color(0x33B65B5B)
                  : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Hero(
                  tag: 'pet_avatar_${reminder.petName}',
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: reminder.avatarColor,
                    child: Text(
                      reminder.petName[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF703418),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            reminder.petName,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: chipColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(fontSize: 11, color: chipText),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reminder.nextVaccine,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.brown.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Age: ${reminder.ageYears.toStringAsFixed(1)} years • Recommended: ${reminder.recommendedNext.join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.brown.shade400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        countdownText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: status == _ReminderStatus.overdue
                              ? const Color(0xFFB65B5B)
                              : const Color(0xFF703418),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutCubic,
                                tween: Tween<double>(
                                  begin: 0,
                                  end: reminder.completion,
                                ),
                                builder: (context, value, _) {
                                  return LinearProgressIndicator(
                                    minHeight: 6,
                                    value: value,
                                    backgroundColor: const Color(0xFFF3E2D6),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF703418),
                                        ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${(reminder.completion * 100).round()}%',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.brown.shade500),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _remindersOn ? 'On' : 'Off',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.brown.shade500,
                                        ),
                                  ),
                                  Switch(
                                    value: _remindersOn,
                                    activeThumbColor: const Color(0xFF703418),
                                    onChanged: (v) {
                                      setState(() => _remindersOn = v);
                                      widget.onChangedReminder(
                                        reminder.copyWith(remindersOn: v),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.brown),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _ReminderStatus _statusForDays(int days) {
    if (days > 0) return _ReminderStatus.upcoming;
    if (days == 0) return _ReminderStatus.today;
    return _ReminderStatus.overdue;
  }
}

enum _ReminderStatus { upcoming, today, overdue }

class _VaccinationEmptyState extends StatelessWidget {
  const _VaccinationEmptyState();

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.health_and_safety_rounded,
            size: 40,
            color: primaryBrown,
          ),
          const SizedBox(height: 8),
          Text(
            'No vaccination reminders yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: primaryBrown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add your pet to start gentle reminders for every important vaccine.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.brown.shade500),
          ),
          const SizedBox(height: 10),
          _PrimaryButton(label: 'Add pet profile', onPressed: () {}),
        ],
      ),
    );
  }
}

/// VACCINATION DETAILS SCREEN

class VaccinationDetailsScreen extends StatelessWidget {
  final _PetVaccinationReminder reminder;

  const VaccinationDetailsScreen({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return Scaffold(
      appBar: AppBar(title: Text('${reminder.petName} • Vaccines')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8F0), Color(0xFFF7F1EA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Hero(
              tag: 'pet_avatar_${reminder.petName}',
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: reminder.avatarColor,
                    child: Text(
                      reminder.petName[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryBrown,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.petName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Age: ${reminder.ageYears.toStringAsFixed(1)} years',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.brown.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: primaryBrown.withOpacity(0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Next recommended vaccines',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final rec in reminder.recommendedNext)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: Color(0xFF4CAF8A),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            rec,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.brown.shade600),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'We’ll remind you ahead of time so you never miss a dose.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.brown.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Past vaccinations',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (reminder.pastVaccines.isEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'No vaccination records added yet.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.brown.shade500),
                ),
              )
            else
              Column(
                children: [
                  for (int i = 0; i < reminder.pastVaccines.length; i++)
                    _TimelineTile(
                      title: reminder.pastVaccines[i].name,
                      subtitle: reminder.pastVaccines[i].date,
                      isLast: i == reminder.pastVaccines.length - 1,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// BOOK APPOINTMENT FLOW

enum VisitType { atClinic, vetAtHome, emergencyAtHome }

enum AppointmentStatus { upcoming, completed, cancelled }

class _Appointment {
  final String id;
  final String petName;
  final String serviceType;
  final String dateTime;
  final AppointmentStatus status;
  final VisitType visitType;

  _Appointment({
    required this.id,
    required this.petName,
    required this.serviceType,
    required this.dateTime,
    required this.status,
    required this.visitType,
  });
}

class BookAppointmentScreen extends StatefulWidget {
  final ValueChanged<_Appointment> onAppointmentCreated;
  final VisitType? initialVisitType;

  const BookAppointmentScreen({
    super.key,
    required this.onAppointmentCreated,
    this.initialVisitType,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen>
    with TickerProviderStateMixin {
  String? selectedService;
  int selectedDateIndex = 0;
  String? selectedTime;
  String period = 'Morning';
  VisitType visitType = VisitType.atClinic;

  bool isLoading = false;
  bool showSuccess = false;

  late AnimationController _checkController;
  late Animation<double> _checkAnimation;

  final List<String> services = [
    'General checkup',
    'Vaccination',
    'Emergency',
    'Follow-up',
  ];

  final List<String> morningSlots = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
  ];
  final List<String> afternoonSlots = [
    '12:30',
    '13:00',
    '14:00',
    '14:30',
    '15:00',
  ];
  final List<String> eveningSlots = ['16:30', '17:00', '17:30', '18:00'];

  @override
  void initState() {
    super.initState();
    visitType = widget.initialVisitType ?? VisitType.atClinic;
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  List<DateTime> get _dates {
    final now = DateTime.now();
    return List.generate(7, (i) => now.add(Duration(days: i)));
  }

  List<String> get _currentSlots {
    switch (period) {
      case 'Morning':
        return morningSlots;
      case 'Afternoon':
        return afternoonSlots;
      case 'Evening':
        return eveningSlots;
      default:
        return morningSlots;
    }
  }

  void _handleConfirm() async {
    if (selectedService == null || selectedTime == null) return;

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    setState(() {
      isLoading = false;
      showSuccess = true;
    });

    _checkController.forward();

    final date = _dates[selectedDateIndex];
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)}';
    final appointment = _Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      petName: 'Milo',
      serviceType: selectedService!,
      dateTime: '$formattedDate • $selectedTime',
      status: AppointmentStatus.upcoming,
      visitType: visitType,
    );

    widget.onAppointmentCreated(appointment);
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    if (showSuccess) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF3E5), Color(0xFFF7F1EA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _checkAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 42,
                      color: Color(0xFF4CAF8A),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Appointment booked',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: primaryBrown),
                ),
                const SizedBox(height: 6),
                Text(
                  'A nearby vet has been assigned.\nYour pet is in good hands.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.brown.shade500,
                  ),
                ),
                const SizedBox(height: 20),
                _PrimaryButton(
                  label: 'Back to services',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isButtonEnabled = selectedService != null && selectedTime != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Book appointment')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8F0), Color(0xFFF7F1EA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _StepLabel(
              number: 1,
              label: 'Select service',
              icon: Icons.medical_services_outlined,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final service = services[index];
                  final selected = service == selectedService;
                  final icon = switch (service) {
                    'General checkup' => Icons.medical_services_rounded,
                    'Vaccination' => Icons.vaccines_rounded,
                    'Emergency' => Icons.emergency_rounded,
                    'Follow-up' => Icons.replay_rounded,
                    _ => Icons.medical_services_rounded,
                  };
                  return _AnimatedTapScale(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedService = service;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 180,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFFFF1DE)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? primaryBrown
                                : Colors.grey.withOpacity(0.18),
                          ),
                          boxShadow: [
                            if (selected)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(icon, color: primaryBrown),
                            const Spacer(),
                            Text(
                              service,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: primaryBrown,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              service == 'Emergency'
                                  ? 'We’ll prioritize the soonest slot.'
                                  : 'Gentle, stress-free visit for your pet.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.brown.shade500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _StepLabel(
              number: 2,
              label: 'Choose date',
              icon: Icons.calendar_today_outlined,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final date = _dates[index];
                  final selected = index == selectedDateIndex;
                  final isToday = index == 0;
                  return _AnimatedTapScale(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDateIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 70,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? primaryBrown
                              : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? primaryBrown
                                : Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _weekdayName(date.weekday),
                              style: TextStyle(
                                fontSize: 11,
                                color: selected
                                    ? Colors.white
                                    : Colors.brown[500],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              date.day.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : Colors.brown[800],
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (isToday)
                              Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: selected
                                      ? Colors.white70
                                      : primaryBrown,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _StepLabel(
              number: 3,
              label: 'Select time',
              icon: Icons.access_time_outlined,
            ),
            const SizedBox(height: 8),
            _PeriodTabs(
              selected: period,
              onChanged: (value) {
                setState(() {
                  period = value;
                  selectedTime = null;
                });
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _currentSlots.map((slot) {
                final selected = slot == selectedTime;
                return _AnimatedTapScale(
                  child: ChoiceChip(
                    label: Text(slot),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => selectedTime = slot);
                    },
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF703418),
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    selectedColor: const Color(0xFF703418),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _StepLabel(
              number: 4,
              label: 'Visit type',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 8),
            _VisitTypeSelector(
              selected: visitType,
              onChanged: (value) {
                setState(() => visitType = value);
              },
            ),
            const SizedBox(height: 12),
            _VetAssignmentInfoCard(visitType: visitType),
            const SizedBox(height: 24),
            _PrimaryButton(
              label: isLoading ? 'Scheduling...' : 'Confirm appointment',
              isLoading: isLoading,
              onPressed: isButtonEnabled && !isLoading ? _handleConfirm : null,
            ),
          ],
        ),
      ),
    );
  }

  String _weekdayName(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }
}

class _StepLabel extends StatelessWidget {
  final int number;
  final String label;
  final IconData? icon;

  const _StepLabel({required this.number, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE2B5),
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryBrown,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (icon != null) ...[
          Icon(icon, size: 20, color: primaryBrown.withOpacity(0.7)),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: 16),
        ),
      ],
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PeriodTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const tabs = ['Morning', 'Afternoon', 'Evening'];
    const primaryBrown = Color(0xFF703418);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab == selected;
          return Expanded(
            child: _AnimatedTapScale(
              child: GestureDetector(
                onTap: () => onChanged(tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryBrown : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tab,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.brown.shade600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _VisitTypeSelector extends StatelessWidget {
  final VisitType selected;
  final ValueChanged<VisitType> onChanged;

  const _VisitTypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    Widget buildTile({
      required VisitType type,
      required String title,
      required String subtitle,
      required IconData icon,
    }) {
      final isSelected = type == selected;
      return _AnimatedTapScale(
        child: GestureDetector(
          onTap: () => onChanged(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFF1DE) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? primaryBrown
                    : Colors.grey.withOpacity(0.15),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: primaryBrown),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primaryBrown,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.brown.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF4CAF8A),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        buildTile(
          type: VisitType.atClinic,
          title: 'Visit clinic',
          subtitle: 'You’ll go to the clinic at your chosen time.',
          icon: Icons.local_hospital_rounded,
        ),
        buildTile(
          type: VisitType.vetAtHome,
          title: 'Vet visits home',
          subtitle: 'A vet visits your home at the scheduled time.',
          icon: Icons.home_repair_service_rounded,
        ),
        buildTile(
          type: VisitType.emergencyAtHome,
          title: 'Emergency home visit',
          subtitle: 'We’ll prioritize and send help to your home.',
          icon: Icons.emergency_rounded,
        ),
      ],
    );
  }
}

class _VetAssignmentInfoCard extends StatelessWidget {
  final VisitType visitType;

  const _VetAssignmentInfoCard({required this.visitType});

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    String visitCopy;
    switch (visitType) {
      case VisitType.atClinic:
        visitCopy =
            'You’ll visit the nearest clinic at your chosen time. We assign a nearby available vet automatically.';
        break;
      case VisitType.vetAtHome:
        visitCopy =
            'A qualified veterinarian will come to your home at the scheduled time. We choose the nearest available vet for you.';
        break;
      case VisitType.emergencyAtHome:
        visitCopy =
            'We’ll rush a nearby vet to your home as soon as possible based on availability.';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6EC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: primaryBrown.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE2B5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_rounded,
              size: 18,
              color: primaryBrown,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vet assignment',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'A qualified veterinarian will be automatically assigned based on your location and availability.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.brown.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  visitCopy,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.brown.shade500),
                ),
                const SizedBox(height: 6),
                Text(
                  'You never need to pick a vet manually — we’ll handle it for you.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.brown.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// CLINICS NEAR ME

class _Clinic {
  final String name;
  final double distanceKm;
  final String address;
  final bool isOpen;

  const _Clinic({
    required this.name,
    required this.distanceKm,
    required this.address,
    required this.isOpen,
  });
}

class ClinicsScreen extends StatelessWidget {
  final List<_Clinic> clinics;

  const ClinicsScreen({super.key, required this.clinics});

  @override
  Widget build(BuildContext context) {
    final hasClinics = clinics.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Clinics near me')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8F0), Color(0xFFF7F1EA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: hasClinics
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: clinics.length + 1,
                itemBuilder: (context, index) {
                  if (index == clinics.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        'Appointments are assigned automatically.\nClinics are shown for reference only.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.brown.shade500,
                        ),
                      ),
                    );
                  }
                  final clinic = clinics[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ClinicCard(clinic: clinic),
                  );
                },
              )
            : const _ClinicsEmptyState(),
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  final _Clinic clinic;

  const _ClinicCard({required this.clinic});

  @override
  Widget build(BuildContext context) {
    final isOpen = clinic.isOpen;
    final statusColor = isOpen
        ? const Color(0xFF4CAF8A)
        : Colors.grey.withOpacity(0.7);
    final statusText = isOpen ? 'Open now' : 'Closed';

    return _AnimatedTapScale(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE2B5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: Color(0xFF703418),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${clinic.distanceKm.toStringAsFixed(1)} km away • ${clinic.address}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.brown.shade500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            statusText,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: statusColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Map preview coming soon')),
                  );
                },
                icon: const Icon(Icons.map_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClinicsEmptyState extends StatelessWidget {
  const _ClinicsEmptyState();

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off_rounded,
              size: 48,
              color: primaryBrown,
            ),
            const SizedBox(height: 8),
            Text(
              'No clinics found nearby',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: primaryBrown),
            ),
            const SizedBox(height: 4),
            Text(
              'Try again later or adjust your location settings.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.brown.shade500),
            ),
            const SizedBox(height: 12),
            _PrimaryButton(label: 'Refresh list', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

/// UPCOMING APPOINTMENTS SECTION

class UpcomingAppointmentsSection extends StatefulWidget {
  final List<_Appointment> appointments;
  final VoidCallback? onTapViewAll;

  const UpcomingAppointmentsSection({
    super.key,
    required this.appointments,
    this.onTapViewAll,
  });

  @override
  State<UpcomingAppointmentsSection> createState() =>
      _UpcomingAppointmentsSectionState();
}

class _UpcomingAppointmentsSectionState
    extends State<UpcomingAppointmentsSection> {
  @override
  Widget build(BuildContext context) {
    final hasAppointments = widget.appointments.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Your upcoming appointments',
          subtitle: 'Don’t miss your pet’s visit.',
          icon: Icons.event_note_rounded,
          onTapSeeAll: widget.onTapViewAll,
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: hasAppointments
              ? Column(
                  children: [
                    for (final a in widget.appointments.take(
                      2,
                    )) // compact preview
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _AppointmentCard(appointment: a),
                      ),
                  ],
                )
              : const _AppointmentsEmptyState(),
        ),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final _Appointment appointment;

  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusChip(appointment.status);
    final visitInfo = switch (appointment.visitType) {
      VisitType.atClinic => 'Visit clinic',
      VisitType.vetAtHome => 'Vet visits home',
      VisitType.emergencyAtHome => 'Emergency home visit',
    };

    return _AnimatedTapScale(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.of(context).push(
            _fadeSlideRoute(AppointmentDetailsScreen(appointment: appointment)),
          );
        },
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFFFD9A0),
                child: Text(
                  appointment.petName[0],
                  style: const TextStyle(
                    color: Color(0xFF703418),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.petName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      appointment.serviceType,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.brown.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: Colors.brown,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          appointment.dateTime,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.brown.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_rounded,
                          size: 14,
                          color: Colors.brown,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          visitInfo,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.brown.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusInfo.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  statusInfo.text,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: statusInfo.color),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, color: Colors.brown),
            ],
          ),
        ),
      ),
    );
  }

  _StatusChipInfo _statusChip(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return _StatusChipInfo(
          text: 'Upcoming',
          color: const Color(0xFF4CAF8A),
          background: const Color(0xFFDCF6E9),
        );
      case AppointmentStatus.completed:
        return _StatusChipInfo(
          text: 'Completed',
          color: Colors.brown.shade600,
          background: const Color(0xFFE6E1DC),
        );
      case AppointmentStatus.cancelled:
        return _StatusChipInfo(
          text: 'Cancelled',
          color: const Color(0xFFB65B5B),
          background: const Color(0xFFF4DBDB),
        );
    }
  }
}

class _StatusChipInfo {
  final String text;
  final Color color;
  final Color background;

  _StatusChipInfo({
    required this.text,
    required this.color,
    required this.background,
  });
}

class _AppointmentsEmptyState extends StatelessWidget {
  const _AppointmentsEmptyState();

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_busy_rounded, size: 40, color: primaryBrown),
          const SizedBox(height: 8),
          Text(
            'No appointments yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: primaryBrown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Book your first appointment to see it here.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.brown.shade500),
          ),
        ],
      ),
    );
  }
}

class AppointmentDetailsScreen extends StatelessWidget {
  final _Appointment appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);
    final statusInfo = _AppointmentCard(
      appointment: appointment,
    )._statusChip(appointment.status);
    final visitInfo = switch (appointment.visitType) {
      VisitType.atClinic => 'You’ll visit the clinic.',
      VisitType.vetAtHome => 'Vet will visit your home.',
      VisitType.emergencyAtHome => 'Emergency home visit.',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment details')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E5), Color(0xFFF7F1EA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFFFD9A0),
                    child: Text(
                      appointment.petName[0],
                      style: const TextStyle(
                        color: primaryBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.petName,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          appointment.serviceType,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.brown.shade600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 16,
                              color: Colors.brown,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              appointment.dateTime,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.brown.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusInfo.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      statusInfo.text,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: statusInfo.color),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryBrown.withOpacity(0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vet assignment',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'A nearby veterinarian has been assigned based on your location and the chosen time.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.brown.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'You don’t have to choose a vet. We make sure your pet is in safe, trusted hands.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.brown.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_rounded,
                        size: 18,
                        color: primaryBrown,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        visitInfo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.brown.shade600,
                          fontWeight: FontWeight.w500,
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

/// SUMMARY STRIP

class _ServicesSummaryStrip extends StatelessWidget {
  final VoidCallback onTapDetails;

  const _ServicesSummaryStrip({required this.onTapDetails});

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return _AnimatedTapScale(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTapDetails,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryBrown.withOpacity(0.16)),
          ),
          child: Row(
            children: [
              const Icon(Icons.pets_rounded, color: primaryBrown),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next vaccine: Rabies booster',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: primaryBrown,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'In 3 days • Tap to see details and full schedule.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.brown.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: primaryBrown),
            ],
          ),
        ),
      ),
    );
  }
}

/// HELP / INFO

class _HelpInfoSection extends StatelessWidget {
  final VoidCallback onBook;

  const _HelpInfoSection({required this.onBook});

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.help_center_rounded,
              size: 22,
              color: primaryBrown,
            ),
            const SizedBox(width: 8),
            Text(
              'Need a hand?',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HelpRow(
                icon: Icons.help_outline_rounded,
                title: 'How appointments work',
                subtitle:
                    'You pick the time. We handle the vet assignment for you.',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    backgroundColor: const Color(0xFFF7F1EA),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'How appointments work',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: primaryBrown,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const _HelpBullet(
                              text:
                                  'You choose the service, date, and time that feel right.',
                            ),
                            const _HelpBullet(
                              text:
                                  'The system assigns a nearby available veterinarian automatically.',
                            ),
                            const _HelpBullet(
                              text:
                                  'You can choose if you go to the clinic or the vet visits your home.',
                            ),
                            const _HelpBullet(
                              text:
                                  'You’ll see all upcoming visits in the Services tab.',
                            ),
                            const SizedBox(height: 16),
                            _PrimaryButton(
                              label: 'Book an appointment',
                              onPressed: () {
                                Navigator.of(context).pop();
                                onBook();
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const Divider(height: 18),
              _HelpRow(
                icon: Icons.emergency_rounded,
                title: 'Emergency guidance',
                subtitle:
                    'If your pet is in distress, book an emergency visit right away.',
                onTap: onBook,
              ),
              const Divider(height: 18),
              _HelpRow(
                icon: Icons.support_agent_rounded,
                title: 'Contact support',
                subtitle:
                    'We’ll be here to guide you gently through next steps.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Support chat UI coming soon'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HelpRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return _AnimatedTapScale(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE2B5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: primaryBrown),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.brown.shade500),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.brown),
        onTap: onTap,
      ),
    );
  }
}

class _HelpBullet extends StatelessWidget {
  final String text;

  const _HelpBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          size: 18,
          color: Color(0xFF4CAF8A),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.brown.shade600),
          ),
        ),
      ],
    );
  }
}

/// SHARED UI

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final VoidCallback? onTapSeeAll;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.icon,
    this.onTapSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryBrown.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: primaryBrown),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.brown.shade500),
              ),
            ],
          ),
        ),
        if (onTapSeeAll != null)
          TextButton(onPressed: onTapSeeAll, child: const Text('See all')),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return _AnimatedTapScale(
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBrown,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onPressed,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Scheduling...'),
                    ],
                  )
                : Text(label),
          ),
        ),
      ),
    );
  }
}

class _AnimatedTapScale extends StatefulWidget {
  final Widget child;

  const _AnimatedTapScale({required this.child});

  @override
  State<_AnimatedTapScale> createState() => _AnimatedTapScaleState();
}

class _AnimatedTapScaleState extends State<_AnimatedTapScale> {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() => _scale = 0.97);
  }

  void _onTapUp(_) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onTapDown,
      onPointerUp: _onTapUp,
      onPointerCancel: (_) => _onTapCancel(),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

class _AnimatedIconBubble extends StatefulWidget {
  final IconData icon;

  const _AnimatedIconBubble({required this.icon});

  @override
  State<_AnimatedIconBubble> createState() => _AnimatedIconBubbleState();
}

class _AnimatedIconBubbleState extends State<_AnimatedIconBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);
    return ScaleTransition(
      scale: _scale,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE2B5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(widget.icon, size: 22, color: primaryBrown),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.16),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isLast;

  const _TimelineTile({
    required this.title,
    required this.subtitle,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF703418);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: primaryBrown,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 32, color: Colors.brown.shade200),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.brown.shade600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// FULL VACCINATION SCREEN

class VaccinationRemindersScreen extends StatelessWidget {
  final List<_PetVaccinationReminder> reminders;

  const VaccinationRemindersScreen({super.key, required this.reminders});

  @override
  Widget build(BuildContext context) {
    final hasReminders = reminders.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Vaccination reminders')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8F0), Color(0xFFF7F1EA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: hasReminders
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _VaccinationReminderCard(
                      reminder: reminder,
                      onChangedReminder: (updated) {},
                    ),
                  );
                },
              )
            : const _VaccinationEmptyState(),
      ),
    );
  }
}

/// MODELS

class _PetVaccinationReminder {
  final String petName;
  final Color avatarColor;
  final String nextVaccine;
  final int dueInDays;
  final double completion;
  final double ageYears;
  final List<String> recommendedNext;
  final List<_VaccineRecord> pastVaccines;
  final bool remindersOn;

  _PetVaccinationReminder({
    required this.petName,
    required this.avatarColor,
    required this.nextVaccine,
    required this.dueInDays,
    required this.completion,
    required this.ageYears,
    required this.recommendedNext,
    required this.pastVaccines,
    required this.remindersOn,
  });

  _PetVaccinationReminder copyWith({
    String? petName,
    Color? avatarColor,
    String? nextVaccine,
    int? dueInDays,
    double? completion,
    double? ageYears,
    List<String>? recommendedNext,
    List<_VaccineRecord>? pastVaccines,
    bool? remindersOn,
  }) {
    return _PetVaccinationReminder(
      petName: petName ?? this.petName,
      avatarColor: avatarColor ?? this.avatarColor,
      nextVaccine: nextVaccine ?? this.nextVaccine,
      dueInDays: dueInDays ?? this.dueInDays,
      completion: completion ?? this.completion,
      ageYears: ageYears ?? this.ageYears,
      recommendedNext: recommendedNext ?? this.recommendedNext,
      pastVaccines: pastVaccines ?? this.pastVaccines,
      remindersOn: remindersOn ?? this.remindersOn,
    );
  }
}

class _VaccineRecord {
  final String name;
  final String date;

  _VaccineRecord({required this.name, required this.date});
}

/// PAGE TRANSITION

PageRouteBuilder<T> _fadeSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween = Tween<Offset>(
        begin: const Offset(0, 0.03),
        end: Offset.zero,
      );
      final fadeTween = Tween<double>(begin: 0, end: 1);

      return SlideTransition(
        position: animation.drive(
          offsetTween.chain(CurveTween(curve: Curves.easeOutCubic)),
        ),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}
