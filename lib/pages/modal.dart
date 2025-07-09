import 'package:flutter/material.dart';

class Modal extends StatelessWidget {
  final bool show;
  final Function(bool) setShow;
  final bool closeWhenClickBackground;
  final Widget child;

  const Modal({
    Key? key,
    required this.show,
    required this.setShow,
    this.closeWhenClickBackground = true,
    required this.child,
  }) : super(key: key);

  void _onClickBackground() {
    if (closeWhenClickBackground) {
      setShow(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Modal background overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: _onClickBackground,
            child: AnimatedOpacity(
              opacity: show ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ),

        // Modal container
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: show ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent tap from bubbling to background
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Alternative implementation using showDialog for better Flutter patterns
class ModalHelper {
  static Future<T?> showModal<T>({
    required BuildContext context,
    required Widget child,
    bool closeWhenClickBackground = true,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible && closeWhenClickBackground,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: closeWhenClickBackground
                ? () => Navigator.of(context).pop()
                : null,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: GestureDetector(
                  onTap: () {}, // Prevent tap from bubbling
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom Modal Widget with more Flutter-like API
class CustomModal extends StatefulWidget {
  final bool isVisible;
  final Function(bool) onVisibilityChanged;
  final bool closeWhenClickBackground;
  final Widget child;
  final Duration animationDuration;
  final Color? barrierColor;

  const CustomModal({
    Key? key,
    required this.isVisible,
    required this.onVisibilityChanged,
    this.closeWhenClickBackground = true,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 200),
    this.barrierColor,
  }) : super(key: key);

  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CustomModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleBackgroundTap() {
    if (widget.closeWhenClickBackground) {
      widget.onVisibilityChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible && _animationController.isDismissed) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Background overlay
            Positioned.fill(
              child: GestureDetector(
                onTap: _handleBackgroundTap,
                child: Container(
                  color: (widget.barrierColor ?? Colors.black.withOpacity(0.5))
                      .withOpacity(_opacityAnimation.value * 0.5),
                ),
              ),
            ),

            // Modal content
            Positioned.fill(
              child: Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: GestureDetector(
                      onTap: () {}, // Prevent tap propagation
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}