// lib/screens/document_preview_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';

class DocumentPreviewScreen extends StatelessWidget {
  final Map<String, File?> documents;
  final String userType; // citizen, police, fire, rescue, traffic
  final String userName;

  const DocumentPreviewScreen({
    super.key,
    required this.documents,
    required this.userType,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out null documents
    final Map<String, File> validDocuments = {};
    documents.forEach((key, value) {
      if (value != null) {
        validDocuments[key] = value!;
      }
    });

      _debugLog("Screen Opened");
  _debugLog("User Type: $userType");
  _debugLog("User Name: $userName");
  _debugLog("Raw Documents: ${documents.keys.toList()}");
_debugLog("Raw Documents Count: ${documents.length}");

documents.forEach((key, value) {
  _debugLog("DOC KEY => $key");

  if (value != null) {
    _debugLog("📁 FILE PATH => ${value.path}");
    _debugLog("📦 FILE SIZE => ${value.lengthSync()} bytes");
  } else {
    _debugLog("❌ FILE NULL for => $key");
  }
});
    return Scaffold(
      appBar: AppBar(
        title: Text('$userType Documents'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: validDocuments.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Header info
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.deepPurple.shade50,
                  child: Row(
                    children: [
                      const Icon(Icons.upload_file, color: Colors.deepPurple),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Documents: ${validDocuments.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'User: $userName',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Documents list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: validDocuments.length,
                    itemBuilder: (context, index) {
                      String docName = validDocuments.keys.elementAt(index);
                      File docFile = validDocuments[docName]!;
                      return _buildDocumentCard(docName, docFile, context);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No Documents Uploaded',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Upload documents during registration',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(String docName, File docFile, BuildContext context) {
    // Format document name for display
    String displayName = _formatDocumentName(docName);
    String fileSize = _formatFileSize(docFile.lengthSync());
    String fileExtension = docFile.path.split('.').last.toUpperCase();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showDocumentDetail(context, docName, docFile);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getIconColor(docName).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getFileIcon(docName),
                  color: _getIconColor(docName),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              
              // Document info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            fileExtension,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          fileSize,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      docFile.path.split('/').last,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Action buttons
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.blue),
                    onPressed: () => _showDocumentDetail(context, docName, docFile),
                    tooltip: 'Preview',
                  ),
                 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocumentDetail(BuildContext context, String docName, File docFile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _formatDocumentName(docName),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Image preview
                Expanded(
                  child: InteractiveViewer(
                    child: Image.file(
                      docFile,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Cannot preview this file',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Action buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.close,
                        label: 'Close',
                        color: Colors.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                    
                      _buildActionButton(
                        icon: Icons.info,
                        label: 'Details',
                        color: Colors.blue,
                        onPressed: () => _showFileDetails(context, docFile, docName),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: 30),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }

  void _showFileDetails(BuildContext context, File file, String docName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_formatDocumentName(docName)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('File Name', file.path.split('/').last),
            _buildDetailRow('File Size', _formatFileSize(file.lengthSync())),
            _buildDetailRow('File Type', file.path.split('.').last.toUpperCase()),
            _buildDetailRow('Full Path', file.path),
            _buildDetailRow('Last Modified', file.lastModifiedSync().toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
          const Divider(),
        ],
      ),
    );
  }

  // void _shareDocument(File file) async {
  //   // You can implement share functionality using share_plus package
  //   // For now, just show a message
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Sharing: ${file.path.split('/').last}'),
  //       action: SnackBarAction(
  //         label: 'OK',
  //         onPressed: () {},
  //       ),
  //     ),
  //   );
  // }

  String _formatDocumentName(String docName) {
    Map<String, String> nameMap = {
      'profilePhoto': 'Profile Photo',
      'scannedCNIC': 'Scanned CNIC',
      'policeIDCardFront': 'Police ID Card (Front)',
      'policeIDCardBack': 'Police ID Card (Back)',
      'fireIDCardFront': 'Fire Brigade ID Card (Front)',
      'fireIDCardBack': 'Fire Brigade ID Card (Back)',
      'rescueIDCardFront': 'Rescue ID Card (Front)',
      'rescueIDCardBack': 'Rescue ID Card (Back)',
      'trafficPoliceIDCardFront': 'Traffic Police ID Card (Front)',
      'trafficPoliceIDCardBack': 'Traffic Police ID Card (Back)',
      'appointmentLetter': 'Appointment Letter',
      'recentPhotograph': 'Recent Photograph',
    };
    
    return nameMap[docName] ?? docName;
  }

  IconData _getFileIcon(String docName) {
    if (docName.contains('IDCard') || docName.contains('CNIC')) {
      return Icons.credit_card;
    } else if (docName.contains('photograph') || docName.contains('Photo')) {
      return Icons.camera_alt;
    } else if (docName.contains('appointment') || docName.contains('Letter')) {
      return Icons.description;
    }
    return Icons.file_present;
  }

  Color _getIconColor(String docName) {
    if (docName.contains('IDCard') || docName.contains('CNIC')) {
      return Colors.purple;
    } else if (docName.contains('photograph') || docName.contains('Photo')) {
      return Colors.orange;
    } else if (docName.contains('appointment') || docName.contains('Letter')) {
      return Colors.blue;
    }
    return Colors.green;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Tap on any document to preview it'),
            SizedBox(height: 8),
            Text('• Use share button to share documents'),
            SizedBox(height: 8),
            Text('• Swipe up to see full image preview'),
            SizedBox(height: 8),
            Text('• Documents are stored locally in app cache'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
  
void _debugLog(String message) {
  debugPrint("🧪 DOCUMENT_PREVIEW => $message");
}
}