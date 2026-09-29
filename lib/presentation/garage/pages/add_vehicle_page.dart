import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/garage_vehicle_entity.dart';
import '../bloc/garage_bloc.dart';

class AddVehiclePage extends StatefulWidget {
  final GarageVehicleEntity? vehicleToEdit;
  const AddVehiclePage({super.key, this.vehicleToEdit});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedVehicleType;
  
  late final TextEditingController _nameController;
  late final TextEditingController _plateController;
  late final TextEditingController _expiryController;
  late final TextEditingController _mileageController;
  late final TextEditingController _capacityController;
  late final TextEditingController _yearController;

  final List<String> _vehicleTypes = ['Scooter / Matic', 'Manual / Bebek', 'Sport'];
  
  final ImagePicker _picker = ImagePicker();
  List<String> _existingImages = [];
  List<File> _newImages = [];

  @override
  void initState() {
    super.initState();
    final v = widget.vehicleToEdit;
    _nameController = TextEditingController(text: v?.name);
    _plateController = TextEditingController(text: v?.plate);
    _expiryController = TextEditingController(text: v?.expiry);
    _mileageController = TextEditingController(text: v?.mileage);
    _capacityController = TextEditingController(text: v?.capacity);
    _yearController = TextEditingController(text: v?.year);
    
    if (v != null) {
      _existingImages = List.from(v.imageUrls);
      if (_vehicleTypes.contains(v.type)) {
        _selectedVehicleType = v.type;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _plateController.dispose();
    _expiryController.dispose();
    _mileageController.dispose();
    _capacityController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _newImages.addAll(images.map((img) => File(img.path)));
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GarageBloc, GarageState>(
      listener: (context, state) {
        if (state.addSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle added successfully!')),
          );
          Navigator.of(context).pop();
        } else if (state.editSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle updated successfully!')),
          );
          Navigator.of(context).pop();
        } else if (state.errorMessage != null && !state.isSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft, color: AppColors.ink),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.vehicleToEdit != null ? 'Edit Vehicle' : 'Add Vehicle', style: const TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            children: [
              _buildImagePicker(),
              const SizedBox(height: 24),
              _buildTextField(hint: 'Vehicle Model', controller: _nameController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(flex: 3, child: _buildTextField(hint: 'License Plate', controller: _plateController)),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: _buildTextField(hint: 'Expiry (MM/YY)', controller: _expiryController)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(hint: 'Current Mileage (km)', keyboardType: TextInputType.number, controller: _mileageController),
              const SizedBox(height: 16),
              _buildDropdownField(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField(hint: 'Engine Capacity (cc)', keyboardType: TextInputType.number, controller: _capacityController)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField(hint: 'Year', keyboardType: TextInputType.number, controller: _yearController)),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: BlocBuilder<GarageBloc, GarageState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final List<String> finalImages = [
                                  ..._existingImages,
                                  ..._newImages.map((f) => f.path)
                                ];

                                final vehicle = GarageVehicleEntity(
                                  id: widget.vehicleToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                                  name: _nameController.text,
                                  plate: _plateController.text,
                                  expiry: _expiryController.text,
                                  mileage: _mileageController.text,
                                  type: _selectedVehicleType ?? '',
                                  capacity: _capacityController.text,
                                  year: _yearController.text,
                                  nextService: widget.vehicleToEdit?.nextService ?? 'Not scheduled',
                                  status: widget.vehicleToEdit?.status ?? 'Good',
                                  imageUrls: finalImages.isNotEmpty ? finalImages : ['https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=300&q=80'],
                                );
                                if (widget.vehicleToEdit != null) {
                                  context.read<GarageBloc>().add(EditVehicleEvent(vehicle));
                                } else {
                                  context.read<GarageBloc>().add(AddVehicleEvent(vehicle));
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                          : Text(widget.vehicleToEdit != null ? 'Save Changes' : 'Save Vehicle', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vehicle Images', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.7))),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.ink.withValues(alpha: 0.1)),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.camera, color: AppColors.brand, size: 32),
                  ),
                ),
              ),
              ...List.generate(_existingImages.length, (index) {
                final imgUrl = _existingImages[index];
                final imageProvider = imgUrl.startsWith('http') ? NetworkImage(imgUrl) : FileImage(File(imgUrl)) as ImageProvider;
                return _buildImageThumbnail(imageProvider, () => _removeExistingImage(index));
              }),
              ...List.generate(_newImages.length, (index) {
                return _buildImageThumbnail(FileImage(_newImages[index]), () => _removeNewImage(index));
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageThumbnail(ImageProvider imageProvider, VoidCallback onRemove) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.x, color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hint, TextInputType? keyboardType, required TextEditingController controller, bool isOptional = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => !isOptional && (value == null || value.isEmpty) ? 'Required field' : null,
      style: const TextStyle(fontSize: 15, color: AppColors.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.ink.withValues(alpha: 0.4), fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: AppColors.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.brand, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedVehicleType,
      icon: Icon(LucideIcons.chevronDown, color: AppColors.ink.withValues(alpha: 0.5), size: 20),
      validator: (value) => value == null ? 'Please select a type' : null,
      hint: Text('Vehicle Type', style: TextStyle(color: AppColors.ink.withValues(alpha: 0.4), fontSize: 15)),
      style: const TextStyle(fontSize: 15, color: AppColors.ink),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: AppColors.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.brand, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
      items: _vehicleTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _selectedVehicleType = val;
        });
      },
    );
  }
}
