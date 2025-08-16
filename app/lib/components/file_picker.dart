import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum PickerOptions {
  takePhoto,
  takeVideo,
  imageGallery,
  videoGallery,
  // file,
}

class FilePickerInputWrapper extends StatefulWidget {
  final Widget child;
  final bool enableCrop;
  final void Function(File) onSelect;
  final List<PickerOptions> options;

  const FilePickerInputWrapper({
    super.key,
    required this.child,
    required this.options,
    this.enableCrop = false,
    required this.onSelect,
  });

  @override
  State<FilePickerInputWrapper> createState() => _FilePickerInputWrapperState();
}

class _FilePickerInputWrapperState extends State<FilePickerInputWrapper> {
  late final ImagePicker imagePicker;

  @override
  void initState() {
    imagePicker = ImagePicker();
    super.initState();
  }

  void handlePickerOptionSelection(PickerOptions option) {
    try {
      switch (option) {
        case PickerOptions.takePhoto:
          {
            uploadImageFromGalleryOrCamera(option);
          }
        case PickerOptions.imageGallery:
          {
            uploadImageFromGalleryOrCamera(option);
          }
        case PickerOptions.takeVideo:
          {
            uploadVideoFromGalleryOrCamera(option);
          }
        case PickerOptions.videoGallery:
          {
            uploadVideoFromGalleryOrCamera(option);
          }
        // case PickerOptions.file: {
        //   selectDocument();
        // }
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Failed to upload image/video file!"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      );
    }
  }

  void uploadImageFromGalleryOrCamera(PickerOptions option) async {
    XFile? file = await imagePicker.pickImage(
      source: option == PickerOptions.takePhoto
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (file != null) {
      widget.onSelect(File(file.path));
    }
  }

  void uploadVideoFromGalleryOrCamera(PickerOptions option) async {
    XFile? file = await imagePicker.pickVideo(
      source: option == PickerOptions.takeVideo
          ? ImageSource.camera
          : ImageSource.gallery,
      maxDuration: const Duration(seconds: 20),
    );
    if (file != null) {
      widget.onSelect(File(file.path));
    }
  }

  // selectDocument() async {
  //   final result = await file_picker.FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     File file = File(result.files.single.path!);
  //     widget.onSelect(file);
  //   }
  // }

  void _showOptions(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: _buildCupertinoActions(context),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildMaterialOptions(context),
            ),
          );
        },
      );
    }
  }

  List<Widget> _buildMaterialOptions(BuildContext context) {
    return widget.options.map((option) {
      return ListTile(
        title: Row(
          children: [
            Icon(getOptionIcon(option)),
            const SizedBox(width: 10),
            Text(getOptionText(context, option)),
          ],
        ),
        onTap: () {
          handlePickerOptionSelection(option);
          Navigator.pop(context);
        },
      );
    }).toList();
  }

  List<Widget> _buildCupertinoActions(BuildContext context) {
    return widget.options.map((option) {
      return CupertinoActionSheetAction(
        onPressed: () {
          handlePickerOptionSelection(option);
          Navigator.pop(context);
        },
        child: Text(
          getOptionText(context, option),
          style: const TextStyle(color: Colors.blue),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showOptions(context);
      },
      child: widget.child,
    );
  }
}

String getOptionText(BuildContext context, PickerOptions option) =>
    switch (option) {
      // PickerOptions.takePhoto => context.l10n.takePhoto,
      // PickerOptions.imageGallery => context.l10n.chooseFromGallery,
      // PickerOptions.takeVideo => context.l10n.takeVideo,
      // PickerOptions.videoGallery => context.l10n.chooseFromVideos,
      // PickerOptions.file => context.l10n.selectDocument,
      PickerOptions.takePhoto => 'Take Photo',
      PickerOptions.imageGallery => 'Choose from Gallery',
      PickerOptions.takeVideo => 'Take Video',
      PickerOptions.videoGallery => 'Choose from Videos',
      // PickerOptions.file => 'Select Document',
    };

IconData getOptionIcon(PickerOptions option) => switch (option) {
      PickerOptions.takePhoto => Icons.camera_alt,
      PickerOptions.imageGallery => Icons.photo,
      PickerOptions.takeVideo => Icons.videocam,
      PickerOptions.videoGallery => Icons.video_library,
      // PickerOptions.file => Icons.folder,
    };
