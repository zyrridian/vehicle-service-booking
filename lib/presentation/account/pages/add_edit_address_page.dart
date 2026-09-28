import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/address_entity.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';

class AddEditAddressPage extends StatefulWidget {
  final AddressEntity? addressToEdit;
  const AddEditAddressPage({super.key, this.addressToEdit});

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _addressController;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.addressToEdit?.label ?? '');
    _addressController = TextEditingController(text: widget.addressToEdit?.fullAddress ?? '');
    _isDefault = widget.addressToEdit?.isDefault ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.addressToEdit != null;
    return Scaffold(
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
        title: Text(isEditing ? 'Edit Address' : 'Add New Address', style: const TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEditing ? 'Address updated!' : 'Address added!')));
            Navigator.of(context).pop();
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildTextField(label: 'Label (e.g. Home, Office)', controller: _labelController),
                const SizedBox(height: 20),
                _buildTextField(label: 'Full Address', controller: _addressController, maxLines: 3),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Set as Default Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)),
                    Switch(
                      value: _isDefault,
                      activeColor: AppColors.brand,
                      onChanged: (val) {
                        setState(() {
                          _isDefault = val;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final address = AddressEntity(
                          id: isEditing ? widget.addressToEdit!.id : '',
                          label: _labelController.text,
                          fullAddress: _addressController.text,
                          isDefault: _isDefault,
                        );
                        if (isEditing) {
                          context.read<AccountBloc>().add(UpdateAddressRequested(address));
                        } else {
                          context.read<AccountBloc>().add(AddAddressRequested(address));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: state.isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(isEditing ? 'Save Changes' : 'Add Address', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.6))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 15, color: AppColors.ink),
          validator: (val) => val == null || val.trim().isEmpty ? 'Required field' : null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: AppColors.surface,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.brand, width: 2)),
          ),
        ),
      ],
    );
  }
}
