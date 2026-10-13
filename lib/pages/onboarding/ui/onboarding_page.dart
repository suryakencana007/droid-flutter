import 'package:droid/features/complete_onboarding/index.dart';
import 'package:droid/shared/config/index.dart';
import 'package:droid/shared/l10n/index.dart';
import 'package:droid/shared/ui/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

typedef _Slide = ({IconData icon, String title, String body});

List<_Slide> _slides(AppLocalizations l10n) => [
  (
    icon: FLucideIcons.layers,
    title: l10n.onboarding1Title,
    body: l10n.onboarding1Body,
  ),
  (
    icon: FLucideIcons.palette,
    title: l10n.onboarding2Title,
    body: l10n.onboarding2Body,
  ),
  (
    icon: FLucideIcons.rocket,
    title: l10n.onboarding3Title,
    body: l10n.onboarding3Body,
  ),
];

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  var _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingDoneProvider.notifier).complete();
    if (mounted) context.go(AppRoutes.signIn);
  }

  void _next() => _controller.nextPage(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
  );

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final slides = _slides(l10n);
    final isLast = _index == slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: FButton(
                  variant: FButtonVariant.ghost,
                  onPress: isLast ? null : _finish,
                  child: Text(l10n.onboardingSkip),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: theme.colors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            slide.icon,
                            size: 56,
                            color: theme.colors.primary,
                          ),
                        ),
                        const Gap(AppSpacing.xl),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: theme.typography.display.xl2.copyWith(
                            color: theme.colors.foreground,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                        const Gap(AppSpacing.sm),
                        Text(
                          slide.body,
                          textAlign: TextAlign.center,
                          style: theme.typography.body.md.copyWith(
                            color: theme.colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _Dots(count: slides.length, index: _index),
                  const Gap(AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: FButton(
                      onPress: isLast ? _finish : _next,
                      child: Text(
                        isLast ? l10n.onboardingStart : l10n.onboardingNext,
                      ),
                    ),
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

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            width: i == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index ? colors.primary : colors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
