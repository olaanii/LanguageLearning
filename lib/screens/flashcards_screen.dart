import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_theme.dart';
import '../constants/dummy_data.dart';
import '../models/models.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isFlipped = false;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeOutBack),
    );

    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_swipeController);
  }

  @override
  void dispose() {
    _flipController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    _isFlipped = !_isFlipped;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final limit = 100.0;
    final swipeVelocity = 500.0;

    if (_dragOffset.dx > limit || velocity > swipeVelocity) {
      _animateSwipe(1);
    } else if (_dragOffset.dx < -limit || velocity < -swipeVelocity) {
      _animateSwipe(-1);
    } else {
      // Snap back
      setState(() {
        _dragOffset = Offset.zero;
      });
    }
  }

  void _animateSwipe(int direction) {
    _swipeAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(direction * 400.0, _dragOffset.dy), // Swipe off-screen
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));

    _swipeController.forward(from: 0).then((_) {
      if (_currentIndex < DummyData.flashcards.length - 1) {
        setState(() {
          _currentIndex++;
          _dragOffset = Offset.zero;
          _isFlipped = false;
          _swipeController.reset();
          _flipController.reset();
        });
      } else {
        // Finished
        context.go('/quiz');
      }
    });
  }

  void _playAudio(String text) {
    // In actual implementation, utilize flutter_tts
    // For now, print out mapping logic
    debugPrint('Playing audio for: $text');
  }

  @override
  Widget build(BuildContext context) {
    final flashcards = DummyData.flashcards;
    if (_currentIndex >= flashcards.length) return const SizedBox();
    final card = flashcards[_currentIndex];

    // Compute Math transforms equivalent to the framer motion values
    double rotateAngle =
        (_dragOffset.dx / MediaQuery.of(context).size.width) * 30 * (pi / 180);
    double weakOpacity = (_dragOffset.dx < -50)
        ? min((-_dragOffset.dx - 50) / 100, 1.0)
        : 0;
    double greatOpacity = (_dragOffset.dx > 50)
        ? min((_dragOffset.dx - 50) / 100, 1.0)
        : 0;

    return Scaffold(
      backgroundColor: AppColors.brandDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/lessons'),
                    child: Container(
                      width: 48,
                      height: 48,
                      // ignore: deprecated_member_use
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.chevronLeft,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const Text(
                    'Review Words',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    // ignore: deprecated_member_use
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${flashcards.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Canvas
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _flipController,
                    _swipeController,
                  ]),
                  builder: (context, child) {
                    final currentOffset = _swipeController.isAnimating
                        ? _swipeAnimation.value
                        : _dragOffset;
                    final currentRot = _swipeController.isAnimating
                        ? 0.0
                        : rotateAngle;

                    // 3D Transform wrapper
                    final transform = Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..setTranslationRaw(
                        currentOffset.dx,
                        currentOffset.dy,
                        0.0,
                      )
                      ..rotateZ(currentRot);
                    return GestureDetector(
                      onPanUpdate: _handleDragUpdate,
                      onPanEnd: _handleDragEnd,
                      onTap: _toggleFlip,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: transform,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // 3D Flippable Card
                            SizedBox(
                              width: 320,
                              height: 426, // Roughly 3/4 aspect ratio
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(_flipAnimation.value),
                                child:
                                    _isFlipped || _flipAnimation.value > pi / 2
                                    // Back of card
                                    ? Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..rotateY(pi),
                                        child: _CardBack(
                                          card: card,
                                          onPlay: () => _playAudio(card.back),
                                        ),
                                      )
                                    // Front of card
                                    : _CardFront(card: card),
                              ),
                            ),

                            // Weak Badge
                            if (weakOpacity > 0)
                              Positioned(
                                top: 32,
                                right: 32,
                                child: Transform.rotate(
                                  angle: 12 * (pi / 180),
                                  child: Opacity(
                                    opacity: weakOpacity,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        // ignore: deprecated_member_use
                                        color: Colors.white.withOpacity(0.9),
                                        border: Border.all(
                                          color: const Color(0xFFFF4747),
                                          width: 4,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'WEAK',
                                        style: TextStyle(
                                          color: Color(0xFFFF4747),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // Great Badge
                            if (greatOpacity > 0)
                              Positioned(
                                top: 32,
                                left: 32,
                                child: Transform.rotate(
                                  angle: -12 * (pi / 180),
                                  child: Opacity(
                                    opacity: greatOpacity,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        // ignore: deprecated_member_use
                                        color: Colors.white.withOpacity(0.9),
                                        border: Border.all(
                                          color: AppColors.brandYellow,
                                          width: 4,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'GREAT',
                                        style: TextStyle(
                                          color: AppColors.brandYellow,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Footer hint
            const Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: Text(
                'Swipe left for Weak, right for Great!',
                style: TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  final Flashcard card;
  const _CardFront({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            card.front,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.brandDark,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          const Text(
            'TAP TO FLIP',
            style: TextStyle(
              color: AppColors.brandTextLight,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final Flashcard card;
  final VoidCallback onPlay;

  const _CardBack({required this.card, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.brandOrange,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            card.back,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.brandDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // ignore: deprecated_member_use
          Text(
            '[${card.pronunciation}]',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              // ignore: deprecated_member_use
              color: AppColors.brandDark.withOpacity(0.6),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              onPlay();
            },
            child: Container(
              width: 56,
              height: 56,
              // ignore: deprecated_member_use
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: const Icon(
                LucideIcons.volume2,
                size: 28,
                color: AppColors.brandDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
