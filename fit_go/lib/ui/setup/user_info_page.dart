import 'dart:io';

import 'package:fit_go/widgets/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  Uint8List? _webImage; // new
  
  final ImagePicker _picker = ImagePicker();


  Future<void> _pickImage(ImageSource source) async {
    try{
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if(pickedFile !=null) {
        if(kIsWeb) {

          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
          });
        }
        else{
          setState(() {
            _profileImage = File(pickedFile.path);
          });
        }
      }
    }
    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eror picking image : $e')),
      );
    }
  }

  void _showImageSourceOptions() {

    final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
    if(isMobile) {
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
            ) 
            );
        }
      );
    }
    else{
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
      body: Center(
        
        child: Container(
          color: Colors.blue[300],
          child: Column(  
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
                
                child: Appbar(),
              ),

              const SizedBox(height: 10),

              Container(
                
                
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color : Colors.white,
                  ),
                  child : Column(
                  children: [

                    const Text(
                        'User Information',
                        style: TextStyle(
                          
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                    ),

                    SizedBox(height: 40,),

                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'name',
                        
                      ),
                    ),
                    
                    SizedBox(height: 20,),

                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'age',
                      ),
                    ),
                    
                    SizedBox(height: 20,),


                    const SizedBox(height: 10,),

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
                                  ? Image.memory(_webImage!, fit : BoxFit.cover) : Image.file(_profileImage!, fit: BoxFit.cover,)
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
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

            const SizedBox(height: 40),
            ]
            
      ),
        ),
      ),
    );
  }
}