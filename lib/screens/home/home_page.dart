import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

// ─────────────────────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────────────────────
class _Story {
  final String title;
  final String subtitle;
  final Color accent;
  final Color accentDark;
  final IconData icon;
  final String badge;
  _Story(this.title, this.subtitle, this.accent, this.accentDark, this.icon,
      this.badge);
}

class _Post {
  final String userName;
  final String handle;
  final String timeAgo;
  final String content;
  final String? imagePlaceholderLabel;
  final Color avatarColor;
  final bool isSponsored;
  final bool isVerified;
  final bool isFilmmaker;
  final int likes;
  final int comments;
  final int shares;
  final int views;
  final List<String> tags;
  final String? genre;
  int likeCount;
  bool liked;
  bool bookmarked;
  bool following;

  _Post({
    required this.userName,
    required this.handle,
    required this.timeAgo,
    required this.content,
    this.imagePlaceholderLabel,
    required this.avatarColor,
    this.isSponsored = false,
    this.isVerified = false,
    this.isFilmmaker = false,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.views,
    this.tags = const [],
    this.genre,
    this.liked = false,
    this.bookmarked = false,
    this.following = false,
  }) : likeCount = likes;
}

// ─────────────────────────────────────────────────────────────
//  HOME PAGE
// ─────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // ── Design tokens ─────────────────────────────────────────
  static const _bg = Color(0xFF080810);
  static const _surface = Color(0xFF0F0F1A);
  static const _card = Color(0xFF13131F);
  static const _cardBorder = Color(0xFF1E1E30);
  static const _accent = Color(0xFF6C47FF);
  static const _accentGlow = Color(0xFF8B6FFF);
  static const _gold = Color(0xFFFFB830);
  static const _rose = Color(0xFFFF4F7B);
  static const _teal = Color(0xFF00D4AA);
  static const _textPrimary = Color(0xFFF5F3FF);
  static const _textSecondary = Color(0xFF9895B5);
  static const _textMuted = Color(0xFF5A577A);

  // ── Controllers ───────────────────────────────────────────
  late final TabController _tabController;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _headerCtrl;
  final _scrollController = ScrollController();

  final _tabs = const ['For You', 'Trending', 'New Releases', 'Festivals'];
  bool _isLoading = false;
  bool _showSearchBar = false;
  late List<_Post> _posts;

  // ── Stories ───────────────────────────────────────────────
  final _stories = [
    _Story('Casting Call\nMumbai', 'Drama · Open Roles',
        Color(0xFF6C47FF), Color(0xFF4B2FCC), Icons.person_search_rounded, 'URGENT'),
    _Story('Short Film\nFestival', 'Sundance · All Genres',
        Color(0xFFFF4F7B), Color(0xFFCC2E56), Icons.emoji_events_rounded, 'HOT'),
    _Story('Director\'s\nMasterclass', 'Free · Online',
        Color(0xFF00D4AA), Color(0xFF009E7D), Icons.school_rounded, 'FREE'),
    _Story('Indie Feature\nFunding', 'Grant · ₹50L',
        Color(0xFFFFB830), Color(0xFFCC8A00), Icons.attach_money_rounded, 'NEW'),
    _Story('VFX Workshop\nDelhi', 'Advanced · 3 Days',
        Color(0xFFFF6B35), Color(0xFFCC4A0F), Icons.auto_fix_high_rounded, 'LIVE'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _shimmerCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1600),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _headerCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600),
    )..forward();
    _posts = _buildPosts();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 400 &&
        !_isLoading) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _posts.addAll(_buildPosts(seed: _posts.length));
        _isLoading = false;
      });
    }
  }

  List<_Post> _buildPosts({int seed = 0}) {
    final r = Random(seed);
    final data = [
      (
        name: 'Meera Krishnan',
        handle: '@meera.lens',
        content:
            'Just wrapped our 21-day shoot across Kerala backwaters 🎬 Every frame felt like a painting. This project pushed me beyond every limit I knew.\n\nWaiting to submit to MAMI — fingers crossed! 🙏',
        image: 'BACKWATERS\nCinematography',
        genre: 'Drama',
        tags: ['#IndieFilm', '#Kerala', '#MAMI2025'],
        color: Color(0xFF7C3AED),
        verified: true,
        filmmaker: true,
        views: 42800,
      ),
      (
        name: 'Arjun Mehta',
        handle: '@arjun.director',
        content:
            'Acting tip that changed my life: Stop trying to "act" and start trying to "live" in the scene. Your body knows what to do when your mind gets out of the way. 🎭\n\nThread on Stanislavski method ↓',
        image: null,
        genre: null,
        tags: ['#ActingTips', '#Stanislavski', '#FilmIndustry'],
        color: Color(0xFF1D4ED8),
        verified: true,
        filmmaker: false,
        views: 19200,
      ),
      (
        name: 'Priya Nair Films',
        handle: '@priya.nair.films',
        content:
            'OPEN CALL: We are casting for our psychological thriller "The Last Signal". Looking for:\n• Lead actress (25-35)\n• Supporting cast (any age)\n• No experience required — raw talent welcome 🎬',
        image: 'CASTING ROOM\nAudition Setup',
        genre: 'Thriller',
        tags: ['#Casting', '#OpenCall', '#Thriller'],
        color: Color(0xFFBE185D),
        verified: false,
        filmmaker: true,
        views: 88500,
      ),
      (
        name: 'Ravi Sharma DOP',
        handle: '@ravi_dop',
        content:
            'Golden hour in Rajasthan is something else entirely ☀️ 4am call time, 3 minutes of magic, and this is what you get. The Thar desert has a soul.\n\nShot on ARRI Alexa Mini LF · Cooke S7/i lenses',
        image: 'GOLDEN HOUR\nThar Desert · Rajasthan',
        genre: 'Documentary',
        tags: ['#Cinematography', '#GoldenHour', '#ARRI'],
        color: Color(0xFF92400E),
        verified: true,
        filmmaker: true,
        views: 31600,
      ),
      (
        name: 'Aisha Kapoor',
        handle: '@aisha.scripts',
        content:
            'My screenplay "Lighthouse" just placed in the top 10 at Nicholl Fellowship 🏆 Three years of rewrites, 47 drafts, countless rejections — and here we are.\n\nNever stop writing. Never stop submitting. ✍️',
        image: null,
        genre: 'Thriller',
        tags: ['#Screenwriting', '#NichollFellowship', '#Screenplay'],
        color: Color(0xFF0369A1),
        verified: true,
        filmmaker: false,
        views: 24100,
      ),
      (
        name: 'Lucas Fernandez',
        handle: '@lucas.frames',
        content:
            'Behind-the-scenes: building our entire VFX pipeline in Blender for under ₹5000 💻 Indie doesn\'t mean low quality — it means creative problem solving.\n\nFull tutorial dropping this weekend 🔥',
        image: 'VFX BREAKDOWN\nBlender Pipeline',
        genre: 'Sci-Fi',
        tags: ['#VFX', '#Blender', '#IndieFilm'],
        color: Color(0xFF065F46),
        verified: false,
        filmmaker: true,
        views: 56300,
      ),
    ];

    return List.generate(data.length, (i) {
      final d = data[(i + seed ~/ 6) % data.length];
      return _Post(
        userName: d.name,
        handle: d.handle,
        timeAgo: '${r.nextInt(22) + 1}h',
        content: d.content,
        imagePlaceholderLabel: d.image,
        avatarColor: d.color,
        isSponsored: i == 0 && seed == 0,
        isVerified: d.verified,
        isFilmmaker: d.filmmaker,
        likes: r.nextInt(9800) + 500,
        comments: r.nextInt(980) + 40,
        shares: r.nextInt(490) + 20,
        views: d.views + r.nextInt(5000),
        tags: d.tags,
        genre: d.genre,
      );
    });
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _posts = _buildPosts());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _shimmerCtrl.dispose();
    _pulseCtrl.dispose();
    _headerCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: _accentGlow,
          backgroundColor: _card,
          displacement: 60,
          strokeWidth: 2.5,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              // ── App Bar ────────────────────────────────────
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _headerCtrl,
                  child: _AppBar(
                    showSearch: _showSearchBar,
                    onSearchToggle: () =>
                        setState(() => _showSearchBar = !_showSearchBar),
                    pulseCtrl: _pulseCtrl,
                  ),
                ),
              ),
              // ── Search Bar ─────────────────────────────────
              if (_showSearchBar)
                SliverToBoxAdapter(child: _SearchBar()),
              // ── Tab Bar ────────────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  controller: _tabController,
                  tabs: _tabs,
                ),
              ),
              // ── Stories ────────────────────────────────────
              SliverToBoxAdapter(
                child: _StoriesSection(stories: _stories),
              ),
              // ── Trending Banner ────────────────────────────
              SliverToBoxAdapter(
                child: _TrendingBanner(shimmerCtrl: _shimmerCtrl),
              ),
              // ── Post Composer ──────────────────────────────
              SliverToBoxAdapter(child: _PostComposer()),
              // ── Feed Header ────────────────────────────────
              SliverToBoxAdapter(child: _FeedHeader()),
              // ── Posts ──────────────────────────────────────
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= _posts.length) {
                      return _isLoading
                          ? _SkeletonLoader(ctrl: _shimmerCtrl)
                          : const SizedBox(height: 80);
                    }
                    return _AnimatedPostCard(
                      key: ValueKey('p_${seed}_$index'),
                      post: _posts[index],
                      index: index,
                      onLike: () => setState(() {
                        _posts[index].liked = !_posts[index].liked;
                        _posts[index].likeCount +=
                            _posts[index].liked ? 1 : -1;
                        HapticFeedback.lightImpact();
                      }),
                      onBookmark: () {
                        setState(() =>
                            _posts[index].bookmarked =
                                !_posts[index].bookmarked);
                        HapticFeedback.selectionClick();
                      },
                      onFollow: () => setState(() =>
                          _posts[index].following =
                              !_posts[index].following),
                    );
                  },
                  childCount: _posts.length + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
int get seed => DateTime.now().millisecondsSinceEpoch;

// ─────────────────────────────────────────────────────────────
//  APP BAR
// ─────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final bool showSearch;
  final VoidCallback onSearchToggle;
  final AnimationController pulseCtrl;
  static const _bg = Color(0xFF080810);
  static const _card = Color(0xFF13131F);
  static const _accent = Color(0xFF6C47FF);
  static const _gold = Color(0xFFFFB830);
  static const _textPrimary = Color(0xFFF5F3FF);

  const _AppBar({
    required this.showSearch,
    required this.onSearchToggle,
    required this.pulseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          // Live badge + logo
          Row(
            children: [
              AnimatedBuilder(
                animation: pulseCtrl,
                builder: (_, __) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      const Color(0xFFFF4F7B).withOpacity(0.15),
                      const Color(0xFFFF4F7B).withOpacity(0.3),
                      pulseCtrl.value,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFFF4F7B).withOpacity(
                          0.4 + pulseCtrl.value * 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF4F7B),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('LIVE',
                          style: TextStyle(
                              color: Color(0xFFFF4F7B),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF8B6FFF), Color(0xFFFF4F7B)],
                ).createShader(bounds),
                child: const Text('CineHub',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0)),
              ),
            ],
          ),
          const Spacer(),
          _AppBarBtn(
            icon: Icons.search_rounded,
            onTap: onSearchToggle,
            active: showSearch,
          ),
          const SizedBox(width: 8),
          _AppBarBtn(
              icon: Icons.chat_bubble_outline_rounded, badge: 3),
          const SizedBox(width: 8),
          _AppBarBtn(
              icon: Icons.notifications_none_rounded, badge: 7),
          const SizedBox(width: 8),
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF6C47FF), Color(0xFFFF4F7B)],
              ),
              border: Border.all(color: _accent, width: 1.5),
            ),
            child: const Icon(Icons.person_rounded,
                color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

class _AppBarBtn extends StatelessWidget {
  final IconData icon;
  final int badge;
  final bool active;
  final VoidCallback? onTap;
  const _AppBarBtn(
      {required this.icon, this.badge = 0, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF6C47FF).withOpacity(0.2)
                  : const Color(0xFF13131F),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active
                    ? const Color(0xFF6C47FF).withOpacity(0.5)
                    : const Color(0xFF1E1E30),
                width: 0.8,
              ),
            ),
            child: Icon(icon,
                color: active
                    ? const Color(0xFF8B6FFF)
                    : const Color(0xFFF5F3FF),
                size: 19),
          ),
          if (badge > 0)
            Positioned(
              top: -3,
              right: -3,
              child: Container(
                width: 17,
                height: 17,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF4F7B),
                ),
                child: Center(
                  child: Text('$badge',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SEARCH BAR
// ─────────────────────────────────────────────────────────────
class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF13131F),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFF6C47FF).withOpacity(0.4), width: 1),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search_rounded,
                  color: Color(0xFF6C47FF), size: 18),
              const SizedBox(width: 10),
              const Expanded(
                child: TextField(
                  autofocus: true,
                  style: TextStyle(
                      color: Color(0xFFF5F3FF),
                      fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search films, directors, talent...',
                    hintStyle: TextStyle(
                        color: Color(0xFF5A577A), fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C47FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Search',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  TAB BAR
// ─────────────────────────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController controller;
  final List<String> tabs;
  const _TabBarDelegate({required this.controller, required this.tabs});

  @override
  double get minExtent => 50;
  @override
  double get maxExtent => 50;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF080810),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF1E1E30),
            width: 0.5,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF5A577A),
        labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.2),
        unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 13),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(color: Color(0xFF6C47FF), width: 2.5),
          borderRadius: BorderRadius.circular(2),
          insets: const EdgeInsets.symmetric(horizontal: 8),
        ),
        tabs: tabs.map((t) => Tab(text: t, height: 48)).toList(),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate old) => false;
}

// ─────────────────────────────────────────────────────────────
//  STORIES SECTION
// ─────────────────────────────────────────────────────────────
class _StoriesSection extends StatelessWidget {
  final List<_Story> stories;
  const _StoriesSection({required this.stories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            children: [
              const Text('Opportunities',
                  style: TextStyle(
                      color: Color(0xFFF5F3FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('See all',
                    style: TextStyle(
                        color: Color(0xFF8B6FFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        // Horizontal scroll
        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: const BouncingScrollPhysics(),
            itemCount: stories.length + 1,
            itemBuilder: (ctx, i) {
              if (i == 0) return _AddStoryBtn();
              return _StoryAvatar(story: stories[i - 1], index: i - 1);
            },
          ),
        ),
        // ── Opportunity Cards (horizontal) ─────────────────
        SizedBox(
          height: 158,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            physics: const BouncingScrollPhysics(),
            itemCount: stories.length,
            itemBuilder: (ctx, i) => _OpportunityCard(
              story: stories[i],
              index: i,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddStoryBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C47FF), Color(0xFFFF4F7B)],
                  ),
                  border: Border.all(
                      color: const Color(0xFF080810), width: 2),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 22),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6C47FF),
                  // ignore: unnecessary_new
                ),
                child: const Icon(Icons.add_rounded,
                    color: Colors.white, size: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoryAvatar extends StatefulWidget {
  final _Story story;
  final int index;
  const _StoryAvatar({required this.story, required this.index});

  @override
  State<_StoryAvatar> createState() => _StoryAvatarState();
}

class _StoryAvatarState extends State<_StoryAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween<double>(begin: 1.0, end: 0.9)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _ctrl.forward().then((_) => _ctrl.reverse());
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [widget.story.accent, widget.story.accentDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
                color: const Color(0xFF080810), width: 2.5),
            boxShadow: [
              BoxShadow(
                color: widget.story.accent.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(widget.story.icon,
              color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _OpportunityCard extends StatefulWidget {
  final _Story story;
  final int index;
  const _OpportunityCard({required this.story, required this.index});

  @override
  State<_OpportunityCard> createState() => _OpportunityCardState();
}

class _OpportunityCardState extends State<_OpportunityCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(
            begin: const Offset(0.15, 0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: () => HapticFeedback.lightImpact(),
          child: Container(
            width: 210,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  widget.story.accent.withOpacity(0.85),
                  widget.story.accentDark.withOpacity(0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.story.accent.withOpacity(0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative circle
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge + icon row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(widget.story.badge,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8)),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(widget.story.icon,
                                color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(widget.story.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              height: 1.2)),
                      const SizedBox(height: 4),
                      Text(widget.story.subtitle,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 11)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 0.8),
                              ),
                              child: const Center(
                                child: Text('Apply Now',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700)),
                              ),
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  TRENDING BANNER
// ─────────────────────────────────────────────────────────────
class _TrendingBanner extends StatelessWidget {
  final AnimationController shimmerCtrl;
  const _TrendingBanner({required this.shimmerCtrl});

  @override
  Widget build(BuildContext context) {
    final trends = ['#IndieFilm', '#Sundance2025', '#MAMI', '#CastingCall'];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB830).withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFFFB830).withOpacity(0.2), width: 0.8),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: Color(0xFFFFB830), size: 16),
          const SizedBox(width: 8),
          const Text('Trending:',
              style: TextStyle(
                  color: Color(0xFFFFB830),
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: trends
                    .map((t) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(t,
                              style: const TextStyle(
                                  color: Color(0xFFF5F3FF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  POST COMPOSER
// ─────────────────────────────────────────────────────────────
class _PostComposer extends StatelessWidget {
  static const _card = Color(0xFF13131F);
  static const _accent = Color(0xFF6C47FF);
  static const _rose = Color(0xFFFF4F7B);
  static const _teal = Color(0xFF00D4AA);
  static const _gold = Color(0xFFFFB830);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E1E30), width: 0.8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C47FF), Color(0xFFFF4F7B)],
                  ),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0F1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF1E1E30), width: 0.8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Share your film journey...',
                          style: TextStyle(
                              color: Color(0xFF5A577A),
                              fontSize: 13.5)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              _ComposerAction(
                  icon: Icons.video_camera_back_rounded,
                  label: 'Video',
                  color: _rose),
              _ComposerAction(
                  icon: Icons.image_rounded,
                  label: 'Photo',
                  color: _teal),
              _ComposerAction(
                  icon: Icons.article_rounded,
                  label: 'Script',
                  color: _gold),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C47FF), Color(0xFF8B4FE0)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('Post',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComposerAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ComposerAction(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FEED HEADER
// ─────────────────────────────────────────────────────────────
class _FeedHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 20,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C47FF), Color(0xFFFF4F7B)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          const Text('Latest in Film',
              style: TextStyle(
                  color: Color(0xFFF5F3FF),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2)),
          const Spacer(),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF13131F),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFF1E1E30), width: 0.8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tune_rounded,
                      color: Color(0xFF9895B5), size: 14),
                  const SizedBox(width: 4),
                  const Text('Filter',
                      style: TextStyle(
                          color: Color(0xFF9895B5),
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ANIMATED POST CARD
// ─────────────────────────────────────────────────────────────
class _AnimatedPostCard extends StatefulWidget {
  final _Post post;
  final int index;
  final VoidCallback onLike;
  final VoidCallback onBookmark;
  final VoidCallback onFollow;

  const _AnimatedPostCard({
    super.key,
    required this.post,
    required this.index,
    required this.onLike,
    required this.onBookmark,
    required this.onFollow,
  });

  @override
  State<_AnimatedPostCard> createState() => _AnimatedPostCardState();
}

class _AnimatedPostCardState extends State<_AnimatedPostCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: (widget.index % 6) * 90), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: _PostCard(
          post: widget.post,
          onLike: widget.onLike,
          onBookmark: widget.onBookmark,
          onFollow: widget.onFollow,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  POST CARD
// ─────────────────────────────────────────────────────────────
class _PostCard extends StatelessWidget {
  static const _card = Color(0xFF13131F);
  static const _border = Color(0xFF1E1E30);
  static const _accent = Color(0xFF6C47FF);
  static const _textPrimary = Color(0xFFF5F3FF);
  static const _textSecondary = Color(0xFF9895B5);
  static const _textMuted = Color(0xFF5A577A);
  static const _rose = Color(0xFFFF4F7B);
  static const _gold = Color(0xFFFFB830);

  final _Post post;
  final VoidCallback onLike;
  final VoidCallback onBookmark;
  final VoidCallback onFollow;

  const _PostCard({
    required this.post,
    required this.onLike,
    required this.onBookmark,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with ring
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: post.isFilmmaker
                            ? LinearGradient(
                                colors: [post.avatarColor, _rose],
                              )
                            : null,
                        color: post.isFilmmaker ? null : _border,
                      ),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: post.avatarColor,
                          border: Border.all(
                              color: _card, width: 2),
                        ),
                        child: Center(
                          child: Text(post.userName[0],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20)),
                        ),
                      ),
                    ),
                    if (post.isVerified)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _accent,
                            border: Border.all(
                                color: _card, width: 1.5),
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 10),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                // Name + meta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(post.userName,
                                style: const TextStyle(
                                    color: _textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                                overflow: TextOverflow.ellipsis),
                          ),
                          if (post.isFilmmaker) ...{
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: _accent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('Filmmaker',
                                  style: TextStyle(
                                      color: Color(0xFF8B6FFF),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700)),
                            ),
                          },
                          if (post.isSponsored) ...{
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: _gold.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('Sponsored',
                                  style: TextStyle(
                                      color: Color(0xFFFFB830),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700)),
                            ),
                          },
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(post.handle,
                              style: const TextStyle(
                                  color: _textMuted, fontSize: 11.5)),
                          const Text(' · ',
                              style: TextStyle(
                                  color: _textMuted, fontSize: 11.5)),
                          Text(post.timeAgo,
                              style: const TextStyle(
                                  color: _textMuted, fontSize: 11.5)),
                          if (post.genre != null) ...{
                            const Text(' · ',
                                style: TextStyle(
                                    color: _textMuted, fontSize: 11.5)),
                            Text(post.genre!,
                                style: const TextStyle(
                                    color: Color(0xFF8B6FFF),
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600)),
                          },
                        ],
                      ),
                    ],
                  ),
                ),
                // Follow + more
                Row(
                  children: [
                    if (!post.following)
                      GestureDetector(
                        onTap: onFollow,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C47FF), Color(0xFF8B4FE0)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Follow',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: onFollow,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: _border,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Following',
                              style: TextStyle(
                                  color: _textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    const SizedBox(width: 6),
                    const Icon(Icons.more_vert_rounded,
                        color: _textMuted, size: 18),
                  ],
                ),
              ],
            ),
          ),

          // ── Content ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Text(post.content,
                style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 13.5,
                    height: 1.55)),
          ),

          // ── Tags ────────────────────────────────────────
          if (post.tags.isNotEmpty) ...{
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: post.tags
                    .map((t) => Text(t,
                        style: const TextStyle(
                            color: Color(0xFF8B6FFF),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600)))
                    .toList(),
              ),
            ),
          },

          // ── Image ───────────────────────────────────────
          if (post.imagePlaceholderLabel != null) ...{
            const SizedBox(height: 12),
            _FilmImageCard(
              label: post.imagePlaceholderLabel!,
              accent: post.avatarColor,
            ),
          },

          // ── Stats bar ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Row(
              children: [
                Icon(Icons.visibility_outlined,
                    color: _textMuted, size: 13),
                const SizedBox(width: 4),
                Text(_fmtCount(post.views),
                    style: const TextStyle(
                        color: _textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(width: 14),
                // Liked avatars mockup
                SizedBox(
                  width: 40,
                  height: 18,
                  child: Stack(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Positioned(
                          left: i * 12.0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: [_rose, _accent, _gold][i],
                              border: Border.all(
                                  color: _card, width: 1.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text('${_fmtCount(post.likeCount)} liked this',
                    style: const TextStyle(
                        color: _textMuted,
                        fontSize: 11)),
              ],
            ),
          ),

          // ── Divider ─────────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            height: 0.5,
            color: _border,
          ),

          // ── Actions ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Row(
              children: [
                _ActionBtn(
                  icon: post.liked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  label: _fmtCount(post.likeCount),
                  color: post.liked ? _rose : _textSecondary,
                  activeColor: _rose,
                  onTap: onLike,
                ),
                _ActionBtn(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: _fmtCount(post.comments),
                  color: _textSecondary,
                  activeColor: _accent,
                  onTap: () {},
                ),
                _ActionBtn(
                  icon: Icons.send_outlined,
                  label: _fmtCount(post.shares),
                  color: _textSecondary,
                  activeColor: _teal,
                  onTap: () {},
                ),
                const Spacer(),
                _ActionBtn(
                  icon: post.bookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  label: '',
                  color: post.bookmarked ? _gold : _textSecondary,
                  activeColor: _gold,
                  onTap: onBookmark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _teal = Color(0xFF00D4AA);

  String _fmtCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

// ─────────────────────────────────────────────────────────────
//  FILM IMAGE CARD
// ─────────────────────────────────────────────────────────────
class _FilmImageCard extends StatefulWidget {
  final String label;
  final Color accent;
  const _FilmImageCard({required this.label, required this.accent});

  @override
  State<_FilmImageCard> createState() => _FilmImageCardState();
}

class _FilmImageCardState extends State<_FilmImageCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _playing = !_playing);
        HapticFeedback.lightImpact();
        _ctrl.forward().then((_) => _ctrl.reverse());
      },
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          height: 220,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF0D0D1A),
            border: Border.all(
                color: const Color(0xFF1E1E30), width: 0.8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Film strip top
                _FilmStrip(accent: widget.accent),
                // Main content area
                Positioned(
                  top: 28,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.accent.withOpacity(0.12),
                          const Color(0xFF080810),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Film grain
                        CustomPaint(
                          painter: _GrainPainter(),
                          size: const Size(double.infinity, double.infinity),
                        ),
                        // Play button
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _playing ? 56 : 64,
                          height: _playing ? 56 : 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _playing
                                ? widget.accent
                                : widget.accent.withOpacity(0.2),
                            border: Border.all(
                              color: widget.accent.withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            _playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        // Label bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(
                                14, 30, 14, 14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.label,
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                        height: 1.3),
                                  ),
                                ),
                                // Duration badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius:
                                        BorderRadius.circular(6),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 0.8),
                                  ),
                                  child: const Text('2:34',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Top right: fullscreen btn
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.fullscreen_rounded,
                                color: Colors.white70, size: 16),
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
      ),
    );
  }
}

class _FilmStrip extends StatelessWidget {
  final Color accent;
  const _FilmStrip({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      color: const Color(0xFF0A0A14),
      child: Row(
        children: List.generate(
          24,
          (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 2, vertical: 5),
              decoration: BoxDecoration(
                color: i % 3 == 0
                    ? accent.withOpacity(0.4)
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  final _rng = Random(99);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 0.8;
    for (int i = 0; i < 120; i++) {
      final x = _rng.nextDouble() * size.width;
      final y = _rng.nextDouble() * size.height;
      paint.color = Colors.white.withOpacity(_rng.nextDouble() * 0.04);
      canvas.drawCircle(Offset(x, y), 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────
//  ACTION BUTTON
// ─────────────────────────────────────────────────────────────
class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color activeColor;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.activeColor,
    required this.onTap,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 140));
    _scale = Tween<double>(begin: 1.0, end: 0.75)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.color, size: 21),
              if (widget.label.isNotEmpty) ...{
                const SizedBox(width: 5),
                Text(widget.label,
                    style: TextStyle(
                        color: widget.color,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
              },
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SKELETON LOADER
// ─────────────────────────────────────────────────────────────
class _SkeletonLoader extends StatelessWidget {
  final AnimationController ctrl;
  const _SkeletonLoader({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final shimmer = LinearGradient(
          begin: Alignment(-1 + ctrl.value * 3, 0),
          end: Alignment(1 + ctrl.value * 3, 0),
          colors: const [
            Color(0xFF13131F),
            Color(0xFF1E1E30),
            Color(0xFF13131F),
          ],
        );

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF13131F),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF1E1E30), width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Bone(width: 52, height: 52, radius: 26, shimmer: shimmer),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bone(width: 130, height: 13, radius: 6, shimmer: shimmer),
                      const SizedBox(height: 6),
                      _Bone(width: 90, height: 10, radius: 5, shimmer: shimmer),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _Bone(width: double.infinity, height: 11, radius: 5, shimmer: shimmer),
              const SizedBox(height: 6),
              _Bone(width: double.infinity, height: 11, radius: 5, shimmer: shimmer),
              const SizedBox(height: 6),
              _Bone(width: 200, height: 11, radius: 5, shimmer: shimmer),
              const SizedBox(height: 14),
              _Bone(width: double.infinity, height: 180, radius: 14, shimmer: shimmer),
            ],
          ),
        );
      },
    );
  }
}

class _Bone extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Gradient shimmer;
  const _Bone(
      {required this.width,
      required this.height,
      required this.radius,
      required this.shimmer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: shimmer,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}