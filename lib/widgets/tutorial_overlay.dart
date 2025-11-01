import 'package:flutter/material.dart';

class TutorialStep {
  final String title;
  final String description;
  final GlobalKey targetKey;
  final Alignment alignment;
  final EdgeInsets? padding;

  TutorialStep({
    required this.title,
    required this.description,
    required this.targetKey,
    this.alignment = Alignment.bottomCenter,
    this.padding,
  });
}

class TutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const TutorialOverlay({
    super.key,
    required this.steps,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int _currentStep = 0;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverlay();
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    if (_currentStep >= widget.steps.length) {
      widget.onComplete();
      return;
    }

    _removeOverlay();

    final step = widget.steps[_currentStep];
    final renderBox = step.targetKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      // If widget not found, skip to next or complete
      if (_currentStep < widget.steps.length - 1) {
        _currentStep++;
        WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlay());
      } else {
        widget.onComplete();
      }
      return;
    }

    final targetPosition = renderBox.localToGlobal(Offset.zero);
    final targetSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _TutorialOverlayContent(
        step: step,
        targetPosition: targetPosition,
        targetSize: targetSize,
        currentStep: _currentStep,
        totalSteps: widget.steps.length,
        onNext: _nextStep,
        onSkip: _skip,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlay());
    } else {
      _removeOverlay();
      widget.onComplete();
    }
  }

  void _skip() {
    _removeOverlay();
    widget.onSkip();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _TutorialOverlayContent extends StatelessWidget {
  final TutorialStep step;
  final Offset targetPosition;
  final Size targetSize;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _TutorialOverlayContent({
    required this.step,
    required this.targetPosition,
    required this.targetSize,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          // Dimmed background with hole
          CustomPaint(
            size: Size(screenSize.width, screenSize.height),
            painter: _HolePainter(
              holeRect: Rect.fromLTWH(
                targetPosition.dx - 8,
                targetPosition.dy - 8,
                targetSize.width + 16,
                targetSize.height + 16,
              ),
            ),
          ),

          // Tutorial card
          Positioned(
            left: 16,
            right: 16,
            top: _calculateCardTop(screenSize.height),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: (currentStep + 1) / totalSteps,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF2196F3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${currentStep + 1}/$totalSteps',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      step.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: onSkip,
                          child: const Text(
                            'Skip Tutorial',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            currentStep < totalSteps - 1 ? 'Next' : 'Got it!',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Pointing arrow
          Positioned(
            left: targetPosition.dx + targetSize.width / 2 - 15,
            top: targetPosition.dy + targetSize.height + 8,
            child: CustomPaint(
              size: const Size(30, 20),
              painter: _ArrowPainter(),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateCardTop(double screenHeight) {
    final targetBottom = targetPosition.dy + targetSize.height;

    // If there's enough space below the target, place card below
    if (screenHeight - targetBottom > 300) {
      return targetBottom + 40;
    }

    // Otherwise place above
    if (targetPosition.dy > 300) {
      return targetPosition.dy - 280;
    }

    // Default to center
    return screenHeight / 2 - 150;
  }
}

class _HolePainter extends CustomPainter {
  final Rect holeRect;

  _HolePainter({required this.holeRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(holeRect, const Radius.circular(8)));

    final combinedPath = Path.combine(PathOperation.difference, path, holePath);
    canvas.drawPath(combinedPath, paint);

    // Draw border around hole
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(holeRect, const Radius.circular(8)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

