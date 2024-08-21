import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:http/http.dart' as http;
import 'package:majan_road/auth/authService.dart';
import 'package:majan_road/auth/forgetPassword.dart';
import 'package:majan_road/auth/signupPage.dart';

class SignIn extends StatefulWidget {
  final Function(Locale) changeLanguage;

  const SignIn({Key? key, required this.changeLanguage}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late TextEditingController _inputController;
  Icon _prefixIcon = const Icon(
    Icons.email,
    color: Color(0xff55A5A4),
  );
  String _selectedLanguage = 'en'; // Default language is English
  bool _obscurePassword = true;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    // _inputController.addListener(_updatePrefixIcon);
  }

  // void _updatePrefixIcon() {
  //   setState(() {
  //     _prefixIcon = _inputController.text.contains('@')
  //         ? const Icon(Icons.email)
  //         : const Icon(Icons.phone);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Center(
            child: Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        // actions: [
        //   // Language Dropdown
        //   Padding(
        //     padding: const EdgeInsets.only(left: 10.0),
        //     child: Row(
        //       children: [
        //         Container(
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(10.0),
        //             border: Border.all(
        //               color: Color(0xff55A5A4), // Customize the border color
        //             ),
        //           ),
        //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //           child: DropdownButton(
        //             underline: Container(),
        //             icon: const Icon(Icons.language),
        //             value: _selectedLanguage,
        //             items: const [
        //               DropdownMenuItem(
        //                 value: 'en',
        //                 child: Text('English'),
        //               ),
        //               DropdownMenuItem(
        //                 value: 'fr',
        //                 child: Text('Français'),
        //               ),
        //               DropdownMenuItem(
        //                 value: 'ar',
        //                 child: Text('عربي'),
        //               ),
        //             ],
        //             onChanged: (val) {
        //               setState(() {
        //                 _selectedLanguage = val.toString();
        //               });
        //               widget.changeLanguage(
        //                   Locale(_selectedLanguage)); // Handle language change
        //             },
        //           ),
        //         ),
        //         const SizedBox(
        //           width: 16.0, // Adjust the width as needed
        //         ),
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.0, // Adjust the height as needed
                child: Image.asset('assets/images/majanMobile.png'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  // Email or Mobile Number Input
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: _selectedLanguage == 'ar'
                          ? 'أدخل بريدك الإلكتروني أو رقم هاتفك المحمول'
                          : _selectedLanguage == 'fr'
                              ? 'Entrez votre e-mail ou votre numéro de téléphone portable'
                              : 'Enter your Email or mobile number',
                      prefixIcon: _prefixIcon,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                  ),

                  const SizedBox(height: 20.0),
                  // Password Input
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: _selectedLanguage == 'ar'
                          ? 'أدخل كلمة المرور الخاصة بك'
                          : _selectedLanguage == 'fr'
                              ? 'Entrez votre mot de passe'
                              : 'Enter your password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xff55A5A4),
                      ),
                      suffixIcon: IconButton(
                        color: Color(0xff55A5A4),
                        icon: _obscurePassword
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPassword(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forget Password?',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Login Button and Sign Up Text
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // Extract email and password from text fields
                            String email = _emailController.text;
                            String password = _passwordController.text;

                            // Make API request
                            await AuthService.login(context, email, password,
                                widget.changeLanguage);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xff55A5A4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                _selectedLanguage == 'ar'
                                    ? 'تسجيل الدخول'
                                    : _selectedLanguage == 'fr'
                                        ? 'Se connecter'
                                        : 'Login',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(
                                  changeLanguage: widget.changeLanguage,
                                ),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 16),
                              children: [
                                TextSpan(
                                  text: _selectedLanguage == 'ar'
                                      ? 'ليس لديك حساب؟ '
                                      : _selectedLanguage == 'fr'
                                          ? 'Vous n\'avez pas de compte? '
                                          : 'Don\'t have an account? ',
                                ),
                                TextSpan(
                                  text: _selectedLanguage == 'ar'
                                      ? 'انضم'
                                      : _selectedLanguage == 'fr'
                                          ? 'S\'inscrire'
                                          : 'Sign Up',
                                  style: const TextStyle(
                                    color: Color(0xff55A5A4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Text(
                        //   _selectedLanguage == 'ar'
                        //       ? 'أو'
                        //       : _selectedLanguage == 'fr'
                        //           ? 'Ou'
                        //           : 'Or',
                        //   style: const TextStyle(
                        //     color: Colors.grey,
                        //     fontSize: 16,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 20.0),
                  // // Social Login Buttons
                  // Center(
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {},
                  //         child: Container(
                  //           width: MediaQuery.of(context).size.width - 130,
                  //           height: MediaQuery.of(context).size.height / 16,
                  //           decoration: BoxDecoration(
                  //             color: const Color(0xff55A5A4),
                  //             borderRadius: BorderRadius.circular(15),
                  //           ),
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               const Icon(Bootstrap.google),
                  //               const SizedBox(width: 10),
                  //               Text(
                  //                 _selectedLanguage == 'ar'
                  //                     ? 'المتابعة مع جوجل'
                  //                     : _selectedLanguage == 'fr'
                  //                         ? 'Continuer avec Google'
                  //                         : 'Continue with Google',
                  //                 style: const TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(height: 20.0),
                  //       GestureDetector(
                  //         onTap: () {},
                  //         child: Container(
                  //           width: MediaQuery.of(context).size.width - 130,
                  //           height: MediaQuery.of(context).size.height / 16,
                  //           decoration: BoxDecoration(
                  //             color: const Color(0xff55A5A4),
                  //             borderRadius: BorderRadius.circular(15),
                  //           ),
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               const Icon(Icons.facebook, size: 28),
                  //               const SizedBox(width: 10),
                  //               Text(
                  //                 _selectedLanguage == 'ar'
                  //                     ? 'المتابعة مع فيسبوك'
                  //                     : _selectedLanguage == 'fr'
                  //                         ? 'Continuer avec Facebook'
                  //                         : 'Continue with Facebook',
                  //                 style: const TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 20.0),
                  // // Continue as Guest Button
                  // Center(
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       _selectedLanguage == 'ar'
                  //           ? 'المتابعة كزائر'
                  //           : _selectedLanguage == 'fr'
                  //               ? 'Continuer en tant qu\'invité'
                  //               : 'Continue as Guest',
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
