import 'package:flutter/material.dart';

class Loading {
  static OverlayEntry? _overlayEntry;
  static late AnimationController _controller;

  static void show(
    BuildContext context, {
    String text = "加载中...",
    bool cancelable = false,
    String positive = "",
    String negative = "",
    VoidCallback? onPositive,
    VoidCallback? onNegative,
  }) {
    if (_overlayEntry != null) return;

    _controller = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );

    final Animation<double> scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    final Animation<double> fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        List<Widget> actions = [];
        if (positive.isNotEmpty && onPositive != null) {
          actions.add(
            TextButton(
              onPressed: () {
                hide();
                onPositive();
              },
              child: Text(positive),
            ),
          );
        }
        if (negative.isNotEmpty && onNegative != null) {
          actions.add(
            TextButton(
              onPressed: () {
                hide();
                onNegative();
              },
              child: Text(negative),
            ),
          );
        }

        return GestureDetector(
          onTap: cancelable ? () => hide() : null,
          child: Material(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: FadeTransition(
                opacity: fadeAnim,
                child: ScaleTransition(
                  scale: scaleAnim,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    padding: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: buildDialogContent(text, context, actions),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
    _controller.forward(); // 播放进入动画
  }

  static Column buildDialogContent(String text, BuildContext context, List<Widget> actions) {
    return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              text,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      if (actions.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: actions,
                        ),
                      ],
                    ],
                  );
  }

  static void hide() async {
    if (_overlayEntry != null) {
      await _controller.reverse(); // 播放退出动画
      _overlayEntry?.remove();
      _overlayEntry = null;
      _controller.dispose();
    }
  }
}
