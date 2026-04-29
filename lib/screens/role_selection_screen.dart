import 'dart:ui';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _bgAnimController;
  late Animation<Alignment> _topAlignment;
  late Animation<Alignment> _bottomAlignment;

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _topAlignment = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(_bgAnimController);

    _bottomAlignment = Tween<Alignment>(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ).animate(_bgAnimController);
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    super.dispose();
  }

  Future<void> _selectRole(String role) async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userRole', role);
      await prefs.setBool('isFirstTime', false);
      
      if (!mounted) return;

      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        Navigator.pushReplacementNamed(
          context, 
          role == 'merchant' ? '/merchant-home' 
            : role == 'job_seeker' ? '/job-search-map' 
            : '/customer-home'
        );
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : Stack(
              children: [
                // خلفية متدرجة متحركة فخمة
                AnimatedBuilder(
                  animation: _bgAnimController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: _topAlignment.value,
                          end: _bottomAlignment.value,
                          colors: isDark 
                            ? [const Color(0xFF002919), const Color(0xFF001209), const Color(0xFF00213B)]
                            : [const Color(0xFFE8F5E9), const Color(0xFFA5D6A7), const Color(0xFFC8E6C9)],
                        ),
                      ),
                    );
                  },
                ),
                
                // دوائر ضوئية ناعمة
                Positioned(
                  top: -100,
                  right: -100,
                  child: _buildBlurCircle(Colors.green.withValues(alpha: 0.15), 400),
                ),



                SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                        
                        // أيقونة ترحيبية بنمط زجاجي
                        Hero(
                          tag: 'app_logo',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                ),
                                child: Icon(
                                  Icons.rocket_launch_rounded,
                                  size: 80,
                                  color: isDark ? Colors.greenAccent : Colors.green.shade900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        Text(
                          l10n.roleSelectionTitle,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.roleSelectionSubtitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isDark ? Colors.white70 : Colors.black54,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 60),
                        
                         _buildAnimatedCard(
                          index: 0,
                          child: _buildGlassCard(
                            context,
                            title: l10n.customerRole,
                            description: l10n.customerRoleDesc,
                            icon: Icons.shopping_basket_rounded,
                            accentColor: Colors.greenAccent,
                            onTap: () => _selectRole('customer'),
                            isDark: isDark,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        _buildAnimatedCard(
                          index: 1,
                          child: _buildGlassCard(
                            context,
                            title: l10n.merchantRole,
                            description: l10n.merchantRoleDesc,
                            icon: Icons.storefront_rounded,
                            accentColor: Colors.orangeAccent,
                            onTap: () => _selectRole('merchant'),
                            isDark: isDark,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        _buildAnimatedCard(
                          index: 2,
                          child: _buildGlassCard(
                            context,
                            title: l10n.jobSeekerRole,
                            description: l10n.jobSeekerRoleDesc,
                            icon: Icons.work_rounded,
                            accentColor: Colors.purpleAccent,
                            onTap: () => _selectRole('job_seeker'),
                            isDark: isDark,
                          ),
                        ),
                        
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 50,
                  right: 20,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.language_rounded),
                        color: isDark ? Colors.white : Colors.black87,
                        onPressed: () {
                          context.read<LocaleProvider>().cycleLocale();
                        },
                      ),
                      IconButton(
                        icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                        color: isDark ? Colors.white : Colors.black87,
                        onPressed: () {
                          final provider = context.read<ThemeProvider>();
                          provider.toggleTheme(!provider.isDarkMode);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAnimatedCard({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildGlassCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.6),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(icon, size: 40, color: isDark ? accentColor : Colors.black87),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded, 
                      size: 18,
                      color: isDark ? Colors.white54 : Colors.black38,
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

  Widget _buildBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
