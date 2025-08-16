import 'package:flutter/material.dart';
import 'dart:async';

class UploadModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String) onFileSelected;

  const UploadModal({
    Key? key,
    required this.onClose,
    required this.onFileSelected,
  }) : super(key: key);

  @override
  State<UploadModal> createState() => _UploadModalState();
}

class _UploadModalState extends State<UploadModal> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _selectedFileName;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                onTap: widget.onClose,
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
            width: double.infinity,
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
                  child: Stack(
                    children: [
                      // Folder base
                      Positioned(
                        left: 0,
                        top: 9,
                        child: Container(
                          width: 42,
                          height: 33,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2BA1F3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      // Folder tab
                      Positioned(
                        left: 0,
                        top: 3,
                        child: Container(
                          width: 22,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF09E24),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      // Arrow
                      const Positioned(
                        left: 15,
                        top: 20,
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: Color(0xFFECBB2D),
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Browse Button
                ElevatedButton(
                  onPressed: _selectFile,
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
                    _isUploading = false;
                    _uploadProgress = 0.0;
                  });
                  widget.onClose();
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
            width: double.infinity,
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
                          Text(
                            'Uploading ${_selectedFileName ?? "document"}...',
                            style: const TextStyle(
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
                        GestureDetector(
                          onTap: _pauseUpload,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.pause_circle,
                              color: Color(0xFF2BA1F3),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: _cancelUpload,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.cancel,
                              color: Color(0xFFEA493C),
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Progress Bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xFFE1E1E2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _uploadProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFF2BA1F3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Uploading Button (Disabled)
          Container(
            width: double.infinity,
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

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: const Color(0xFF2BA1F3),
      ),
      child: ElevatedButton(
        onPressed: () {
          widget.onClose();
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

  void _selectFile() async {
    // Simulate file selection
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _selectedFileName = 'document.pdf';
      _isUploading = true;
    });
    
    widget.onFileSelected(_selectedFileName!);
    _simulateUpload();
  }

  void _simulateUpload() {
    const duration = Duration(milliseconds: 100);
    Timer.periodic(duration, (timer) {
      setState(() {
        _uploadProgress += 0.02;
        if (_uploadProgress >= 0.65) { // Stop at 65% as shown in design
          timer.cancel();
          _uploadProgress = 0.65;
        }
      });
    });
  }

  void _pauseUpload() {
    // Handle pause upload
  }

  void _cancelUpload() {
    setState(() {
      _isUploading = false;
      _uploadProgress = 0.0;
      _selectedFileName = null;
    });
  }
}