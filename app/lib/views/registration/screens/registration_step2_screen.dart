import 'package:flutter/material.dart';
import 'dart:async';

class RegistrationStep2Screen extends StatefulWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onBack;
  
  const RegistrationStep2Screen({Key? key, this.onContinue, this.onBack}) : super(key: key);

  @override
  State<RegistrationStep2Screen> createState() => _RegistrationStep2ScreenState();
}

class _RegistrationStep2ScreenState extends State<RegistrationStep2Screen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  String? _selectedGender;
  bool _showUploadModal = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                _buildHeader(),
                
                // Divider
                Container(
                  height: 1,
                  color: const Color(0xFFDDEAFE),
                ),
                
                // Progress Indicator
                _buildProgressIndicator(),
                
                // Form Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        
                        // Age Field
                        _buildInputField(
                          label: 'Age',
                          controller: _ageController,
                          hintText: 'Enter your age',
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Gender Dropdown
                        _buildGenderDropdown(),
                        
                        const SizedBox(height: 30),
                        
                        // NIC Field
                        _buildInputField(
                          label: 'National Identity Card Number (NIC)',
                          controller: _nicController,
                          hintText: 'Enter your NIC number',
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Upload Image Field
                        _buildUploadField(),
                        
                        const Spacer(),
                        
                        // Continue Button
                        _buildContinueButton(),
                        
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Upload Modal
            if (_showUploadModal) _buildUploadModal(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Call the onBack callback if provided, otherwise pop
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFDDEAFE), width: 0.8),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF1F7BBB),
                size: 20,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Basic Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1D21),
                fontFamily: 'Noto Sans',
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Step 1 - Completed
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2BA1F3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x2604147C),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
          
          // Line 1
          Container(
            width: 49,
            height: 2,
            color: const Color(0xFF2BA1F3),
          ),
          
          // Step 2 - Active
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2BA1F3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          // Line 2
          Container(
            width: 49,
            height: 2,
            color: const Color(0xFFCACACA),
          ),
          
          // Step 3 - Inactive
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFCACACA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1C1D21),
            fontFamily: 'Noto Sans',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFDDEAFE)),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1C1D21),
              fontFamily: 'Noto Sans',
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Color(0xFF838383),
                fontWeight: FontWeight.w300,
                fontFamily: 'Noto Sans',
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 23, vertical: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1C1D21),
            fontFamily: 'Noto Sans',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFDDEAFE)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 23),
                child: Text(
                  'Choose your gender',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF838383),
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Noto Sans',
                  ),
                ),
              ),
              icon: const Padding(
                padding: EdgeInsets.only(right: 23),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF135686),
                  size: 24,
                ),
              ),
              isExpanded: true,
              items: ['Male', 'Female', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Text(value),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload an Image Of Your NIC',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1C1D21),
            fontFamily: 'Noto Sans',
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _showUploadModal = true;
            });
          },
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFDDEAFE)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 23),
              child: Row(
                children: [
                  Text(
                    'Click here to upload',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF838383),
                      fontWeight: FontWeight.w300,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.file_upload_outlined,
                    color: Color(0xFF135686),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: 373,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: const Color(0xFF2BA1F3),
      ),
      child: ElevatedButton(
        onPressed: () {
          // Call the onContinue callback
          widget.onContinue?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2BA1F3),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontFamily: 'Noto Sans',
          ),
        ),
      ),
    );
  }

  Widget _buildUploadModal() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.24),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 391,
            decoration: const BoxDecoration(
              color: Color(0xFFFAFDFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: _isUploading ? _buildUploadProgress() : _buildUploadContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upload Document',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1D21),
                  fontFamily: 'DM Sans',
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showUploadModal = false;
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFDDEAFE), width: 0.6),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF1C1D21),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'You can upload a file',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontFamily: 'Noto Sans',
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Upload Area
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF1F7BBB),
                style: BorderStyle.solid,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Upload Icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2BA1F3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.file_upload,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Browse Button
                ElevatedButton(
                  onPressed: () async {
                    // Simulate file picking - in real app you would use file_picker package
                    setState(() {
                      _isUploading = true;
                    });
                    _simulateUpload();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2BA1F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                      side: const BorderSide(color: Color(0xFF838383), width: 0.6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  ),
                  child: const Text(
                    'Browse files',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF515356),
                      fontFamily: 'Noto Sans',
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Continue Button
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildUploadProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upload Document',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1D21),
                  fontFamily: 'DM Sans',
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showUploadModal = false;
                    _isUploading = false;
                    _uploadProgress = 0.0;
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFDDEAFE), width: 0.6),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF1C1D21),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Don\'t close or Refresh',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontFamily: 'Noto Sans',
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Upload Progress Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFDDEAFE)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Uploading...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF1C1D21),
                              fontFamily: 'Noto Sans',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${(_uploadProgress * 100).toInt()}% • 30 seconds remaining',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF515356),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.pause_circle, color: Color(0xFF2BA1F3), size: 24),
                        const SizedBox(width: 4),
                        const Icon(Icons.cancel, color: Color(0xFFEA493C), size: 24),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Progress Bar
                LinearProgressIndicator(
                  value: _uploadProgress,
                  backgroundColor: const Color(0xFFE1E1E2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2BA1F3)),
                  minHeight: 8,
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Uploading Button (Disabled)
          Container(
            width: 375,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: const Color(0xFF838383),
            ),
            child: const Center(
              child: Text(
                'Uploading...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFE1E1E2),
                  fontFamily: 'Noto Sans',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _simulateUpload() {
    const duration = Duration(milliseconds: 100);
    Timer.periodic(duration, (timer) {
      setState(() {
        _uploadProgress += 0.02;
        if (_uploadProgress >= 1.0) {
          timer.cancel();
          _uploadProgress = 1.0;
        }
      });
    });
  }
}

