import 'package:flutter/material.dart';
import '../../widgets/collaborate_dialog.dart';
import '../notifications/notifications_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _collab = false;

  final List<Map<String, dynamic>> _projects = [
    {
      "title": "Echoes of Dawn",
      "role": "Director",
      "year": "2024",
      "status": "Completed"
    },
    {
      "title": "Urban Lens",
      "role": "Producer",
      "year": "2024",
      "status": "In Progress"
    },
    {
      "title": "Shadows & Light",
      "role": "Writer",
      "year": "2023",
      "status": "Completed"
    },
  ];

  void _showCollabPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (_, a, __, child) => ScaleTransition(
        scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: a, child: child),
      ),
      pageBuilder: (_, __, ___) => CollaborateDialog(
        onConfirm: () {
          setState(() => _collab = true);
          Navigator.pop(context);
          _snack(context);
        },
      ),
    );
  }

  void _snack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xff111111),
      margin: const EdgeInsets.all(16),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Row(children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [Color(0xffFF8C00), Color(0xffFF3D00)]),
          ),
          child: const Icon(Icons.check_rounded, size: 13, color: Colors.white),
        ),
        const SizedBox(width: 10),
        const Text("Collaboration request sent! 🎬",
            style: TextStyle(fontWeight: FontWeight.w600)),
      ]),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff09090B),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero app bar ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xff09090B),
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsPage()),
                  ),
                  child: Stack(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none_rounded),
                    ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            Color(0xffFF8C00),
                            Color(0xffFF3D00),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff8E2DE2), Color(0xff4A00E0)],
                    ),
                  ),
                ),
                Container(color: Colors.black.withOpacity(0.45)),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 80, left: 24, right: 24),
                  child: Column(children: [
                    Stack(children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                              colors: [
                                Color(0xff8E2DE2),
                                Color(0xff4A00E0)
                              ]),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff8E2DE2)
                                  .withOpacity(0.5),
                              blurRadius: 28,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.person_rounded, size: 48),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xff09090B),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: const Icon(Icons.edit_rounded, size: 14),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 14),
                    const Text("Vikram Nair",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text("Director & Screenwriter",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.75))),
                    const SizedBox(height: 12),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _hChip(Icons.location_on_rounded, "Mumbai"),
                          const SizedBox(width: 10),
                          _hChip(Icons.verified_rounded, "Verified Pro",
                              hi: true),
                        ]),
                  ]),
                ),
              ]),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats
                  Row(children: [
                    _statTile("62", "Projects",
                        Icons.movie_creation_rounded,
                        const Color(0xffFF8C00), const Color(0xffFF3D00)),
                    const SizedBox(width: 12),
                    _statTile("4.9", "Rating", Icons.star_rounded,
                        const Color(0xffF7971E), const Color(0xffFFD200)),
                    const SizedBox(width: 12),
                    _statTile("1.2K", "Followers", Icons.people_rounded,
                        const Color(0xff8E2DE2), const Color(0xff4A00E0)),
                  ]),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _collab
                            ? null
                            : () => _showCollabPopup(context),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: _collab
                                ? LinearGradient(colors: [
                                    Colors.white.withOpacity(0.07),
                                    Colors.white.withOpacity(0.07),
                                  ])
                                : const LinearGradient(colors: [
                                    Color(0xffFF8C00),
                                    Color(0xffFF3D00),
                                  ]),
                          ),
                          child: Center(
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _collab
                                        ? Icons.check_circle_rounded
                                        : Icons.handshake_rounded,
                                    size: 17,
                                    color: _collab
                                        ? Colors.greenAccent
                                        : Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _collab ? "Requested" : "Collaborate",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: _collab
                                          ? Colors.white.withOpacity(0.5)
                                          : Colors.white,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _iconBtn(Icons.chat_bubble_outline_rounded),
                    const SizedBox(width: 12),
                    _iconBtn(Icons.share_rounded),
                  ]),

                  const SizedBox(height: 26),

                  _sec("About"),
                  const SizedBox(height: 10),
                  Text(
                    "Award-winning director with 10+ years in independent cinema. Passionate about stories that challenge perspective. Known for visually rich narratives and strong character arcs. Open to collaboration across genres.",
                    style: TextStyle(
                        height: 1.75,
                        fontSize: 13.5,
                        color: Colors.white.withOpacity(0.68)),
                  ),

                  const SizedBox(height: 26),

                  _sec("Skills & Expertise"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      "Direction",
                      "Screenplay",
                      "Storyboarding",
                      "Final Cut Pro",
                      "VFX",
                      "Documentary",
                    ].map(_badge).toList(),
                  ),

                  const SizedBox(height: 26),

                  _sec("Recent Projects"),
                  const SizedBox(height: 12),
                  ..._projects.map(_projTile),

                  const SizedBox(height: 26),

                  // Availability banner
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(colors: [
                        const Color(0xff11998e).withOpacity(0.15),
                        const Color(0xff38ef7d).withOpacity(0.08),
                      ]),
                      border: Border.all(
                          color:
                              const Color(0xff38ef7d).withOpacity(0.3)),
                    ),
                    child: Row(children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(colors: [
                            Color(0xff11998e),
                            Color(0xff38ef7d),
                          ]),
                        ),
                        child: const Icon(
                            Icons.calendar_today_rounded, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Available for Projects",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14)),
                            Text(
                              "Open from June 2025",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.55)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(colors: [
                            Color(0xff11998e),
                            Color(0xff38ef7d),
                          ]),
                        ),
                        child: const Text("Open",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Private helpers ──────────────────────────────────────────────────

  Widget _hChip(IconData icon, String label, {bool hi = false}) =>
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: hi
              ? const Color(0xffFF8C00).withOpacity(0.18)
              : Colors.white.withOpacity(0.08),
          border: hi
              ? Border.all(
                  color: const Color(0xffFF8C00).withOpacity(0.4))
              : null,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon,
              size: 13,
              color:
                  hi ? const Color(0xffFF8C00) : Colors.white70),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: hi
                      ? const Color(0xffFF8C00)
                      : Colors.white70,
                  fontWeight: FontWeight.w600)),
        ]),
      );

  Widget _statTile(
          String v, String l, IconData icon, Color c1, Color c2) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(colors: [c1, c2]),
              ),
              child: Icon(icon, size: 17),
            ),
            const SizedBox(height: 8),
            Text(v,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(l,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.5))),
          ]),
        ),
      );

  Widget _iconBtn(IconData icon) => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Icon(icon),
      );

  Widget _sec(String t) =>
      Text(t, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700));

  Widget _badge(String s) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(colors: [
            const Color(0xff8E2DE2).withOpacity(0.2),
            const Color(0xff4A00E0).withOpacity(0.2),
          ]),
          border:
              Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Text(s,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600)),
      );

  Widget _projTile(Map<String, dynamic> p) {
    final done = p["status"] == "Completed";
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.04),
        border:
            Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Colors.white.withOpacity(0.07),
          ),
          child: const Icon(Icons.movie_creation_rounded, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p["title"],
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              Text("${p["role"]} · ${p["year"]}",
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5))),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: done
                ? const Color(0xff38ef7d).withOpacity(0.12)
                : const Color(0xffFF8C00).withOpacity(0.12),
          ),
          child: Text(
            p["status"],
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: done
                  ? const Color(0xff38ef7d)
                  : const Color(0xffFF8C00),
            ),
          ),
        ),
      ]),
    );
  }
}
