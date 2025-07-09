import 'package:flutter/material.dart';

class Nav extends StatefulWidget {
  final String? chordUrl;

  const Nav({
    Key? key,
    this.chordUrl,
  }) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> with TickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _closeMenu() {
    if (_isMenuOpen) {
      setState(() {
        _isMenuOpen = false;
        _animationController.reverse();
      });
    }
  }

  bool _isCurrentRoute(String route) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    return currentRoute.startsWith(route);
  }

  void _navigateTo(String route) {
    _closeMenu();
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              GestureDetector(
                onTap: () => _navigateTo('/'),
                child: const Text(
                  'PianoChord.io',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Desktop Navigation
              if (isDesktop) ...[
                Row(
                  children: [
                    _buildNavLink(
                      'Chords',
                      widget.chordUrl ?? '/',
                      _isCurrentRoute('/chord'),
                    ),
                    const SizedBox(width: 24),
                    _buildNavLink(
                      'Whiteboard',
                      '/whiteboard',
                      _isCurrentRoute('/whiteboard'),
                    ),
                    const SizedBox(width: 24),
                    _buildNavLink(
                      'About',
                      '/about',
                      _isCurrentRoute('/about'),
                    ),
                  ],
                ),
              ] else ...[
                // Mobile Hamburger Menu
                GestureDetector(
                  onTap: _toggleMenu,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animation,
                    size: 24,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(String title, String route, bool isActive) {
    return GestureDetector(
      onTap: () => _navigateTo(route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? Colors.blue : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// Mobile Navigation Drawer (Alternative approach)
class MobileNavDrawer extends StatelessWidget {
  final String? chordUrl;
  final Function(String) onNavigate;

  const MobileNavDrawer({
    Key? key,
    this.chordUrl,
    required this.onNavigate,
  }) : super(key: key);

  bool _isCurrentRoute(BuildContext context, String route) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    return currentRoute.startsWith(route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PianoChord.io',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Piano Chord Reference',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  'Chords',
                  Icons.music_note,
                  chordUrl ?? '/',
                  _isCurrentRoute(context, '/chord'),
                ),
                _buildDrawerItem(
                  context,
                  'Whiteboard',
                  Icons.dashboard,
                  '/whiteboard',
                  _isCurrentRoute(context, '/whiteboard'),
                ),
                _buildDrawerItem(
                  context,
                  'About',
                  Icons.info,
                  '/about',
                  _isCurrentRoute(context, '/about'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context,
      String title,
      IconData icon,
      String route,
      bool isActive,
      ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Colors.blue : Colors.grey.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          color: isActive ? Colors.blue : Colors.black87,
        ),
      ),
      selected: isActive,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onNavigate(route);
      },
    );
  }
}

// Usage in your main app structure
class AppWithNavigation extends StatelessWidget {
  const AppWithNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: const Nav(),
      ),
      drawer: MediaQuery.of(context).size.width <= 768
          ? MobileNavDrawer(
        onNavigate: (route) => Navigator.pushNamed(context, route),
      )
          : null,
      body: const YourMainContent(),
    );
  }
}

class YourMainContent extends StatelessWidget {
  const YourMainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Your app content here'),
    );
  }
}