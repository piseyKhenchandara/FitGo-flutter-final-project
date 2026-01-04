import 'dart:io';

import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/service/user_setup_service.dart';
import 'package:fit_go/service/validation_service.dart';
import 'package:fit_go/widgets/appbar.dart';
import 'package:fit_go/widgets/back_next_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  File? _profileImage;
  Uint8List? _webImage;
  
  final ImagePicker _picker = ImagePicker();
  final _formkey = GlobalKey<FormState>();

  @override 
  void initState() {
    super.initState();

    if (userSetupController.name != null) {
      _nameController.text = userSetupController.name!;
    }
    if (userSetupController.age != null) {
      _ageController.text = userSetupController.age.toString();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
          });
        } else {
          setState(() {
            _profileImage = File(pickedFile.path);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _showImageSourceOptions() {
    final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
    if (isMobile) {
      showModalBottomSheet(
        context: context, 
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        }
      );
    } else {
      _pickImage(ImageSource.gallery);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[300],
        child: Column(  
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: Appbar(),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    Form(
                      key: _formkey, 
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(40),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'User Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),

                            const SizedBox(height: 40),

                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                              validator: ValidationService.validateName,
                            ),
                            
                            const SizedBox(height: 20),

                            TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Age',
                              ),
                              validator: ValidationService.validateAge,
                            ),
                            
                            const SizedBox(height: 20),

                            if (_profileImage != null || _webImage != null)
                              Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: kIsWeb 
                                        ? Image.memory(_webImage!, fit: BoxFit.cover) 
                                        : Image.file(_profileImage!, fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _profileImage = null;
                                          _webImage = null;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            else
                              GestureDetector(
                                onTap: _showImageSourceOptions,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Add Profile Picture',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    BackNextButton(
                      go_next: true,
                      nextRoute: '/setup/gender',
                      onNext: () {
                        
                        if (_formkey.currentState!.validate()) {
                          
                          UserService.saveUserInfo(
                            _nameController.text,
                            _ageController.text,
                          );
                          UserService.saveProfileImage(_profileImage, _webImage);

                          return true;
                        
                        }
                        return false;

                        
                       
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}