import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:majan_road/auth/authService.dart';
import 'package:majan_road/auth/loginPage.dart';
import 'package:country_picker/country_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/services.dart'; // Import the services package for input formatters

class SignUp extends StatefulWidget {
  final Function(Locale) changeLanguage;

  const SignUp({Key? key, required this.changeLanguage}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _selectedLanguage = 'en'; // Default language is English
  bool _obscurePassword = true;
  bool _acceptedPolicy = false; // Track if the policy is accepted
  File? _profileImage;
  String _selectedCountry = 'Select Country';
  String _phoneNumber = '';

  // Controller variables for text fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // Validation variables
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSymbol = false;
  bool hasMinLength = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      hasUppercase = value.contains(RegExp(r'[A-Z]'));
      hasLowercase = value.contains(RegExp(r'[a-z]'));
      hasNumber = value.contains(RegExp(r'[0-9]'));
      hasSymbol = value.contains(RegExp(r'[!@#\$&*~]'));
      hasMinLength = value.length > 8;
    });
  }

  void _showPasswordErrorSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
          'Password must contain an uppercase letter, lowercase letter, number, symbol, and be more than 8 characters.'),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 100.0,
                child: Image.asset('assets/images/majanMobile.png'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    _selectedLanguage == 'ar'
                        ? 'البريد الإلكتروني'
                        : _selectedLanguage == 'fr'
                            ? 'e-mail'
                            : 'Email',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'email@gmail.com',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xff55A5A4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    style:
                        TextStyle(color: Colors.black), // Ensures text is black
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    _selectedLanguage == 'ar'
                        ? 'الاسم'
                        : _selectedLanguage == 'fr'
                            ? 'Name'
                            : 'Nom',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'full name',
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xff55A5A4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    style:
                        TextStyle(color: Colors.black), // Ensures text is black
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    _selectedLanguage == 'ar'
                        ? 'رقم الهاتف'
                        : _selectedLanguage == 'fr'
                            ? 'Numero de telephone'
                            : 'Phone number',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Color(0xff55A5A4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    initialCountryCode: 'US',
                    onChanged: (phone) {
                      setState(() {
                        _phoneNumber = phone.completeNumber;
                      });
                    },
                    style:
                        TextStyle(color: Colors.black), // Ensures text is black
                    keyboardType: TextInputType.number, // Ensure only numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Ensure only digits
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    _selectedLanguage == 'ar'
                        ? 'الدولة'
                        : _selectedLanguage == 'fr'
                            ? 'Pays'
                            : 'Country',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode:
                            false, // optional. Shows phone code before the country name.
                        onSelect: (Country country) {
                          setState(() {
                            _selectedCountry = country.name;
                          });
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCountry,
                            style: TextStyle(
                                color: Colors.black), // Ensures text is black
                          ),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    _selectedLanguage == 'ar'
                        ? 'المدينة'
                        : _selectedLanguage == 'fr'
                            ? 'Ville'
                            : 'City',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelText: 'city',
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: Color(0xff55A5A4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    style:
                        TextStyle(color: Colors.black), // Ensures text is black
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    _selectedLanguage == 'ar'
                        ? 'كلمة المرور'
                        : _selectedLanguage == 'fr'
                            ? 'Mot de passe'
                            : 'Password',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: '********',
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
                    onChanged: _validatePassword,
                  ),
                  const SizedBox(height: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            hasUppercase ? Icons.check : Icons.close,
                            color: hasUppercase ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Contains uppercase letter',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            hasLowercase ? Icons.check : Icons.close,
                            color: hasLowercase ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Contains lowercase letter',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            hasNumber ? Icons.check : Icons.close,
                            color: hasNumber ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Contains number',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            hasSymbol ? Icons.check : Icons.close,
                            color: hasSymbol ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Contains symbol',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            hasMinLength ? Icons.check : Icons.close,
                            color: hasMinLength ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'More than 8 characters',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    _selectedLanguage == 'ar'
                        ? 'تأكيد كلمة المرور'
                        : _selectedLanguage == 'fr'
                            ? 'Confirmez le mot de passe'
                            : 'Confirm password',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: passwordConfirmationController,
                    decoration: InputDecoration(
                      labelText: '********',
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
                    style:
                        TextStyle(color: Colors.black), // Ensures text is black
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedPolicy,
                        activeColor:
                            Color(0xff55A5A4), // Set the fill color here
                        onChanged: (newValue) {
                          setState(() {
                            _acceptedPolicy = newValue!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          _selectedLanguage == 'ar'
                              ? 'فهمت الشروط والسياسة.'
                              : _selectedLanguage == 'fr'
                                  ? 'J\'ai compris les termes et la politique.'
                                  : 'I understood the terms & policy.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    _selectedLanguage == 'ar'
                        ? 'صورة الملف الشخصي'
                        : _selectedLanguage == 'fr'
                            ? 'Photo de profil'
                            : 'Profile Picture',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _profileImage == null
                        ? Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(_profileImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (hasUppercase &&
                                hasLowercase &&
                                hasNumber &&
                                hasSymbol &&
                                hasMinLength) {
                              AuthService.signUp(
                                context,
                                email: emailController.text,
                                password: passwordController.text,
                                passwordConfirmation:
                                    passwordConfirmationController.text,
                                name: nameController.text,
                                phoneNumber: _phoneNumber,
                                country: _selectedCountry,
                                city: cityController.text,
                                conditions: _acceptedPolicy ? 1 : 0,
                                picture: _profileImage,
                              );
                            } else {
                              _showPasswordErrorSnackbar(context);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xffF69523),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                _selectedLanguage == 'ar'
                                    ? 'تسجيل'
                                    : _selectedLanguage == 'fr'
                                        ? 'S\'inscrire'
                                        : 'Sign Up',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignIn(
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
                                      ? 'لديك حساب؟ '
                                      : _selectedLanguage == 'fr'
                                          ? 'Vous avez deja un compte? '
                                          : 'Already have an account? ',
                                ),
                                TextSpan(
                                  text: _selectedLanguage == 'ar'
                                      ? 'انضم'
                                      : _selectedLanguage == 'fr'
                                          ? 'Se connecter'
                                          : 'Sign In',
                                  style:
                                      const TextStyle(color: Color(0xffF69523)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
