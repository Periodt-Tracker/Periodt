import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:periodt/core/settings/models.dart';
import 'package:periodt/core/settings/notifier.dart';
import 'package:periodt/core/theme/app.dart';
import 'package:periodt/core/theme/base/text.dart';
import 'package:pinput/pinput.dart';
import 'package:slide_action/slide_action.dart';

class PinSetupScreen extends HookConsumerWidget {
  const PinSetupScreen({super.key});

  Future _showConfirmationDialog(
    BuildContext context,
    String pin,
    WidgetRef ref,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Are you sure?",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Make sure you know your pin. If you forget it, you won't be able to access Periodt again. Slide the slider below to confirm your order.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // The SlideAction Widget
            SlideAction(
              stretchThumb: true,
              trackBuilder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey[200],
                  ),
                  child: const Center(
                    child: Text(
                      "Slide to confirm",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                );
              },
              thumbBuilder: (context, state) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: PeriodtTheme.period.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: state.isPerformingAction
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : const Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 64,
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                );
              },
              action: () async {
                final storage = FlutterSecureStorage();
                final hashed = BCrypt.hashpw(pin, BCrypt.gensalt());

                await storage.write(key: "periodt-pin", value: hashed);

                final notifier = ref.read(settingsNotifier.notifier);
                notifier.updateSecuritySettings(
                  (s) => s.copyWith(method: SecurityMethod.pin),
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = GoRouter.of(context);

    final firstPin = useState<String?>(null);
    final incorrect = useState<bool>(false);

    final pinController = useTextEditingController();
    final focusNode = useFocusNode();

    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, const []);

    const length = 4;
    const borderColor = Color.fromRGBO(114, 178, 238, 1);
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.outfit(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    void clear() => Future.delayed(const Duration(milliseconds: 100), () {
      pinController.clear();
      focusNode.requestFocus();
    });

    Future processPin(String pin, WidgetRef ref) async {
      if (firstPin.value == null) {
        // if we had a latent error wipe it
        incorrect.value = false;
        firstPin.value = pin;

        clear();
      } else if (pin != firstPin.value) {
        incorrect.value = true;
        firstPin.value = null;

        clear();
      } else {
        await _showConfirmationDialog(context, pin, ref);

        if (navigator.canPop()) {
          navigator.pop();
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (firstPin.value == null) {
              navigator.pop();
              return;
            }

            firstPin.value = null;
            incorrect.value = false;

            clear();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                firstPin.value == null ? "Set a Pin" : "Confirm Your Pin",
                style: TextStyle(
                  fontSize: PeriodtText.xxl,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 68,
                child: Pinput(
                  length: length,
                  focusNode: focusNode,
                  controller: pinController,
                  defaultPinTheme: defaultPinTheme,
                  obscureText: true,
                  onCompleted: (pin) => processPin(pin, ref),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    height: 68,
                    width: 64,
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: borderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: errorColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              if (incorrect.value) ...[
                const Text(
                  "The pins did not match, please try again",
                  style: TextStyle(color: Colors.red),
                ),
              ],
              const Text(
                "Set a unique pin just for periodt. You will be asked for this every time you open the app, this can be disabled or updated at any time in settings.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: PeriodtText.base),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
