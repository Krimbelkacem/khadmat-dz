import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khadmatdz/services/clientService.dart';

class AddProposal extends StatefulWidget {
  const AddProposal({Key? key}) : super(key: key);

  @override
  _AddProposalScreenState createState() => _AddProposalScreenState();
}

class _AddProposalScreenState extends State<AddProposal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timelineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  File? _image;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Proposal'),
        backgroundColor: Colors.white,
      ),
      body: _isLoading ? _buildLoading() : _buildForm(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitProposal,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Post', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Updated _buildForm method
  Widget _buildForm() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'Enter the title for your proposal',
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _timelineController,
            decoration: InputDecoration(
              labelText: 'Timeline',
              hintText: 'Enter the timeline for your proposal',
              prefixIcon: Icon(Icons.calendar_today),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _budgetController,
            decoration: InputDecoration(
              labelText: 'Budget',
              hintText: 'Enter the budget for your proposal',
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Enter a description for your proposal',
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: null,
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.image),
                onPressed: _pickImage,
              ),
              if (_image != null) ...[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                  },
                ),
              ],
            ],
          ),
          SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    if (kIsWeb) {
      // Use Image.network for web
      return Image.network(_image!.path, fit: BoxFit.cover);
    } else {
      // Use Image.file for other platforms
      return Image.file(_image!, fit: BoxFit.cover);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  Future<void> _submitProposal() async {
    setState(() {
      _isLoading = true;
    });

    String title = _titleController.text;
    String timeline = _timelineController.text;
    String description = _descriptionController.text;
    String budget = _budgetController.text;

    try {
      // Validate inputs
      if (title.isEmpty || timeline.isEmpty || description.isEmpty || budget.isEmpty || _image == null) {
        throw Exception("Please fill in all fields and select an image.");
      }

      // Create an instance of ClientService
      ClientService clientService = ClientService();

      // Call addProposal method on the instance
      await clientService.addProposal('66012ac933e14f22abbbffa5', title, description, budget, timeline, _image!);

      // Clear fields
      _titleController.clear();
      _timelineController.clear();
      _descriptionController.clear();
      _budgetController.clear();
      setState(() {
        _image = null;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Proposal submitted successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }


  // Implementation of _submitProposal method...

    setState(() {
      _isLoading = false;
    });
  }
}
