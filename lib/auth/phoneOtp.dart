import 'package:flutter/material.dart';
import 'dart:async';

class MobileOtp extends StatefulWidget {
  const MobileOtp({Key? key}) : super(key: key);

  @override
  State<MobileOtp> createState() => _MobileOtpState();
}

class _MobileOtpState extends State<MobileOtp> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  late Timer _timer;
  int _start = 60;

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Verification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset(
              width: MediaQuery.of(context).size.height / 2.6,
              height: MediaQuery.of(context).size.height / 2.6,
              'assets/images/otp.png',
            ),
            const Text(
              'Enter code',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const Text(
              'An 4 digit code has been sent to you',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: MediaQuery.of(context).size.width / 7,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        _focusNodes[index + 1].requestFocus();
                      }
                    },
                    decoration: const InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width - 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xffF69523),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _start == 0
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        _start = 60;
                        _startTimer();
                      });
                      // Implement logic to resend OTP here
                    },
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Text(
                    'Resend OTP ($_start)',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MobileOtp(),
  ));
}
