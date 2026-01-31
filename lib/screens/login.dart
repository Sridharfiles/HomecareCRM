import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homecarecrm/screens/home.dart';
import 'package:homecarecrm/screens/signup.dart';
import 'package:homecarecrm/service/google_signin_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Text editing controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Google Sign-In service
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Email/Password Login
  Future<void> _handleEmailLogin() async {
    // Validate inputs
    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter your password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        _showSuccessSnackBar('Login successful!');
        // Navigate to HomePage since user is already authenticated
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later';
          break;
        default:
          errorMessage = e.message ?? 'An error occurred';
      }
      
      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Google Sign In - Matching signup screen implementation
  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) {
      print('🔴 Already loading, ignoring click');
      return;
    }

    print('🔵 Setting loading state to true');
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔵 Starting Google Sign-In...');
      print('🔵 Calling _googleSignInService.signInWithGoogle()...');
      
      final UserCredential? userCredential = await _googleSignInService.signInWithGoogle();
      
      print('🔵 ===== SIGN-IN METHOD RETURNED =====');
      print('🔵 UserCredential is null: ${userCredential == null}');
      
      if (userCredential != null) {
        print('🔵 UserCredential is NOT NULL!');
        print('🔵 User is null: ${userCredential.user == null}');
        
        if (userCredential.user != null) {
          print('🔵 User email: ${userCredential.user?.email}');
          print('🔵 User displayName: ${userCredential.user?.displayName}');
          print('🔵 User uid: ${userCredential.user?.uid}');
        }
      } else {
        print('🔴 UserCredential is NULL!');
      }

      print('🔵 Checking if widget is mounted: $mounted');
      if (!mounted) {
        print('🔴 Widget not mounted, aborting navigation');
        return;
      }

      if (userCredential != null && userCredential.user != null) {
        print('🔵 ✅ SUCCESS! User is authenticated!');
        print('🔵 Preparing to navigate to HomePage...');
        
        // Small delay to ensure state is updated
        await Future.delayed(const Duration(milliseconds: 200));
        
        print('🔵 Checking mounted again: $mounted');
        if (!mounted) {
          print('🔴 Widget unmounted during delay, aborting');
          return;
        }
        
        print('🔵 Calling Navigator.pushReplacement...');
        
        // Navigate to HomePage
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            print('🔵 Building HomePage widget...');
            return const HomePage();
          }),
        );
        
        print('🔵 ✅ Navigation completed successfully!');
      } else {
        print('🔴 Cannot navigate - UserCredential or user is null');
        print('🔴 userCredential != null: ${userCredential != null}');
        if (userCredential != null) {
          print('🔴 userCredential.user != null: ${userCredential.user != null}');
        }
      }
    } on Exception catch (e) {
      print('🔴 ===== EXCEPTION CAUGHT =====');
      print('🔴 Exception: $e');
      print('🔴 Exception type: ${e.runtimeType}');
      print('🔴 Exception string: ${e.toString()}');
      
      if (!mounted) {
        print('🔴 Widget not mounted in exception handler');
        return;
      }
      
      // Check if it's a cancellation exception
      String errorString = e.toString();
      if (errorString.contains('canceled') || 
          errorString.contains('cancelled') ||
          errorString.contains('sign_in_canceled') ||
          errorString.contains('activity is cancelled by the user')) {
        print('🔵 User cancelled sign-in - no error shown');
        // User cancelled - silently ignore
      } else {
        // Show error only for actual failures
        print('🔴 Real error - showing message to user');
        _showErrorSnackBar('Google sign-in failed. Please try again.');
      }
    } catch (e) {
      print('🔴 ===== UNEXPECTED ERROR =====');
      print('🔴 Unexpected error: $e');
      print('🔴 Error type: ${e.runtimeType}');
      
      if (!mounted) return;
      _showErrorSnackBar('Google sign-in failed. Please try again.');
    } finally {
      print('🔵 In finally block');
      if (mounted) {
        print('🔵 Setting loading state to false');
        setState(() {
          _isLoading = false;
        });
        print('🔵 Loading state updated');
      } else {
        print('🔴 Widget not mounted in finally block');
      }
    }
  }

  // Facebook Sign In (placeholder)
  Future<void> _handleFacebookSignIn() async {
    _showErrorSnackBar('Facebook sign-in coming soon!');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D6EFD),
                Color(0xFF1E88E5),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Title at the top
                const Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'HomeCare CRM',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Animated Login Card
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 2),
                              const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0D6EFD),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Email field
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0D6EFD), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Password field
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0D6EFD), width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                              ),
                              // Forgot password
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // TODO: Implement forgot password functionality
                                      _showErrorSnackBar('Forgot password feature coming soon!');
                                    },
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        color: Color(0xFF0D6EFD),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleEmailLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D6EFD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'or continue with',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Social Login Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 56,
                                      child: OutlinedButton.icon(
                                        onPressed: _isLoading ? null : _handleFacebookSignIn,
                                        icon: Image.asset(
                                          'assets/logo/Facebook.png',
                                          height: 24,
                                          width: 24,
                                        ),
                                        label: const Text(
                                          'Facebook',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.grey),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          backgroundColor: Colors.grey[100],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: SizedBox(
                                      height: 56,
                                      child: OutlinedButton.icon(
                                        onPressed: _isLoading ? null : _handleGoogleSignIn,
                                        icon: Image.asset(
                                          'assets/logo/Google.png',
                                          height: 24,
                                          width: 24,
                                        ),
                                        label: const Text(
                                          'Google',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.grey),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          backgroundColor: Colors.grey[100],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Sign up text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Signup(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Color(0xFF0D6EFD),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
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