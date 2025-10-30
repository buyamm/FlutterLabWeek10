import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final seed = Colors.indigo;

    final light = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textTheme: Typography.material2021().black.apply(fontFamily: null),
    );

    final dark = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F1724),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textTheme: Typography.material2021().white.apply(fontFamily: null),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Profile',
      themeMode: _themeMode,
      theme: light,
      darkTheme: dark,
      home: ProfilePage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final skills = <_Skill>[
      _Skill(name: 'Flutter', level: 0.9),
      _Skill(name: 'Dart', level: 0.88),
      _Skill(name: 'UI/UX Design', level: 0.78),
      _Skill(name: 'Firebase', level: 0.72),
      _Skill(name: 'REST APIs', level: 0.8),
      _Skill(name: 'Git & GitHub', level: 0.86),
    ];

    final socialLinks = <_SocialLink>[
      const _SocialLink(
        icon: Icons.web,
        label: 'Website',
        value: 'liamtruong.run.dev',
      ),
      const _SocialLink(
        icon: Icons.alternate_email,
        label: 'Email',
        value: 'truongcongly139@gmail.com',
      ),
      const _SocialLink(
        icon: Icons.camera_alt,
        label: 'Instagram',
        value: '@buyam_',
      ),
      const _SocialLink(
        icon: Icons.code,
        label: 'GitHub',
        value: 'github.com/buyam_',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liam — Personal Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Icon(Icons.light_mode_outlined, size: 20),
                Switch(value: isDarkMode, onChanged: onThemeChanged),
                const Icon(Icons.dark_mode_outlined, size: 20),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 820;
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child:
                    isWide
                        ? _buildWide(context, skills, socialLinks)
                        : _buildNarrow(context, skills, socialLinks),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWide(
    BuildContext context,
    List<_Skill> skills,
    List<_SocialLink> socialLinks,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // left column
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProfileCard(isWide: true),
              const SizedBox(height: 20),
              _ContactCard(),
            ],
          ),
        ),
        const SizedBox(width: 20),
        // right column
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AboutCard(),
              const SizedBox(height: 20),
              _SkillsCard(skills: skills),
              const SizedBox(height: 20),
              _SocialCard(links: socialLinks),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrow(
    BuildContext context,
    List<_Skill> skills,
    List<_SocialLink> socialLinks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProfileCard(isWide: false),
        const SizedBox(height: 18),
        _AboutCard(),
        const SizedBox(height: 18),
        _SkillsCard(skills: skills),
        const SizedBox(height: 18),
        _ContactCard(),
        const SizedBox(height: 18),
        _SocialCard(links: socialLinks),
      ],
    );
  }
}

class _ProfileCard extends StatefulWidget {
  const _ProfileCard({required this.isWide});

  final bool isWide;

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  bool _showDetails = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = 56.0;

    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        'assets/3x4.jpg',
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: radius * 2,
            height: radius * 2,
            alignment: Alignment.center,
            color: Colors.grey.shade300,
            child: const Icon(Icons.person, size: 48),
          );
        },
      ),
    );

    return Card(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child:
            widget.isWide
                ? Row(
                  children: [
                    // avatar + quick actions
                    Column(
                      children: [
                        avatar,
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showDetails = !_showDetails;
                            });
                          },
                          icon: Icon(
                            _showDetails
                                ? Icons.expand_less
                                : Icons.expand_more,
                          ),
                          label: Text(_showDetails ? 'Hide' : 'Show'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            minimumSize: const Size(140, 36),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    // details
                    Expanded(
                      child: AnimatedCrossFade(
                        firstChild: _buildDetails(
                          textTheme,
                          CrossAxisAlignment.start,
                        ),
                        secondChild: _buildCompact(textTheme),
                        crossFadeState:
                            _showDetails
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    avatar,
                    const SizedBox(height: 12),
                    Text(
                      'Liam Truong',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mobile Developer & Designer',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        Chip(label: Text('Open to collaborate')),
                        Chip(label: Text('Remote & On-site')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download CV'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(160, 44),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildDetails(TextTheme textTheme, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          'Liam Truong',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text('Mobile Developer & Designer', style: textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: const [
            Chip(label: Text('Open to collaborate')),
            Chip(label: Text('Remote & On-site')),
            Chip(label: Text('Freelance')),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _StatItem(label: 'Experience', value: '3 yrs'),
            const SizedBox(width: 18),
            _StatItem(label: 'Projects', value: '12'),
            const SizedBox(width: 18),
            _StatItem(label: 'Followers', value: '1.2k'),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.mail_outline),
              label: const Text('Contact'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.link),
              label: const Text('Portfolio'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompact(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Liam Truong',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text('Mobile Dev — UI/UX', style: textTheme.bodyMedium),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(label, style: t.bodySmall),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              'Hi! I am Liam Truong, a fourth-year computer science student passionate about crafting delightful mobile experiences. I enjoy building immersive UIs, experimenting with smooth animations, and sharing knowledge with the community.',
              style: t.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillsCard extends StatelessWidget {
  const _SkillsCard({required this.skills});

  final List<_Skill> skills;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Core Skills',
              style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...skills.map((s) => _SkillRow(skill: s)).toList(),
          ],
        ),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.skill});

  final _Skill skill;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(skill.name, style: t.bodyMedium)),
          const SizedBox(width: 12),
          Expanded(
            flex: 7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: skill.level,
                minHeight: 10,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.08),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Text(
              '${(skill.level * 100).round()}%',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          children: const [
            ListTile(
              leading: CircleAvatar(child: Icon(Icons.phone)),
              title: Text('Phone'),
              subtitle: Text('+84 90 564 0692'),
            ),
            Divider(height: 0),
            ListTile(
              leading: CircleAvatar(child: Icon(Icons.email_outlined)),
              title: Text('Email'),
              subtitle: Text('truongcongly139@gmail.com'),
            ),
            Divider(height: 0),
            ListTile(
              leading: CircleAvatar(child: Icon(Icons.location_on_outlined)),
              title: Text('Location'),
              subtitle: Text('Da Nang, Vietnam'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  const _SocialCard({required this.links});

  final List<_SocialLink> links;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: const [
                SizedBox(width: 8),
                Icon(Icons.people_alt),
                SizedBox(width: 8),
                Text(
                  'Social',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...links.map((link) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      // placeholder for click action (open url / mailto).
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Open ${link.label}: ${link.value}'),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: ListTile(
                      leading: CircleAvatar(child: Icon(link.icon)),
                      title: Text(link.label),
                      subtitle: Text(link.value),
                      trailing: IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied ${link.value}')),
                          );
                        },
                        icon: const Icon(Icons.copy),
                        tooltip: 'Copy',
                      ),
                    ),
                  ),
                  if (link != links.last) const Divider(height: 0),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class _SocialLink {
  const _SocialLink({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;
}

class _Skill {
  final String name;
  final double level;
  _Skill({required this.name, required this.level});
}
