// lib/features/group/screens/payment_flow_screen.dart

import 'package:amal_tracker/features/group/models/group_mode.dart';
import 'package:amal_tracker/features/group/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _C {
  static const pageBg = Color(0xFFF4F6F1);
  static const cardBg = Color(0xFFFFFFFF);
  static const darkGreen = Color(0xFF0E3D22);
  static const midGreen = Color(0xFF1B7045);
  static const gold = Color(0xFFD4A843);
  static const green = Color(0xFF16A34A);
  static const greenLight = Color(0xFFE8F5EE);
  static const amber = Color(0xFFFF6B35);
  static const amberLight = Color(0xFFFFF3E0);
  static const red = Color(0xFFEF4444);
  static const silver = Color(0xFF8B92A8);
  static const textPrimary = Color(0xFF0A1A0F);
  static const textSecondary = Color(0xFF6B7C6E);
  static const textHint = Color(0xFFABBAAE);
  static const border = Color(0xFFE4EAE4);
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT FLOW — 3 steps: Method → Form → Pending
// ─────────────────────────────────────────────────────────────────────────────

class PaymentFlowScreen extends ConsumerStatefulWidget {
  final SubscriptionPlan plan;
  final String duration;
  final int price;

  const PaymentFlowScreen({
    super.key,
    required this.plan,
    required this.duration,
    required this.price,
  });

  @override
  ConsumerState<PaymentFlowScreen> createState() => _PaymentFlowScreenState();
}

class _PaymentFlowScreenState extends ConsumerState<PaymentFlowScreen> {
  int _step = 0; // 0=method, 1=form, 2=pending

  PaymentMethod _selectedMethod = PaymentMethod.bkash;

  // Form controllers
  final _txnCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  DateTime? _transferTime;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _txnCtrl.dispose();
    _mobileCtrl.dispose();
    _bankNameCtrl.dispose();
    super.dispose();
  }

  String get _durationBn =>
      widget.duration == 'yearly' ? 'বার্ষিক (৩৬৫ দিন)' : 'মাসিক (৩০ দিন)';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(paymentSubmitProvider.notifier);
    final ok = await notifier.submit(
      plan: widget.plan,
      duration: widget.duration,
      method: _selectedMethod.value,
      transactionId: _txnCtrl.text,
      mobileLast4:
          _selectedMethod != PaymentMethod.bank ? _mobileCtrl.text : null,
      bankName:
          _selectedMethod == PaymentMethod.bank ? _bankNameCtrl.text : null,
      transferTime: _transferTime?.toIso8601String(),
    );

    if (ok && mounted) {
      setState(() => _step = 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentSubmitProvider);
    final methodsAsync = ref.watch(paymentMethodsProvider);

    return Scaffold(
      backgroundColor: _C.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            _TopBar(
              step: _step,
              onBack: _step == 0
                  ? () => Navigator.pop(context)
                  : _step == 1
                      ? () => setState(() => _step = 0)
                      : null,
            ),

            // Step indicator
            if (_step < 2) _StepIndicator(current: _step),

            Expanded(
              child: AnimatedSwitcher(
                duration: 220.ms,
                child: _step == 0
                    ? _MethodStep(
                        key: const ValueKey(0),
                        plan: widget.plan,
                        price: widget.price,
                        duration: _durationBn,
                        selectedMethod: _selectedMethod,
                        methodsAsync: methodsAsync,
                        onMethod: (m) => setState(() => _selectedMethod = m),
                        onNext: () => setState(() => _step = 1),
                      )
                    : _step == 1
                        ? _FormStep(
                            key: const ValueKey(1),
                            formKey: _formKey,
                            plan: widget.plan,
                            price: widget.price,
                            duration: _durationBn,
                            method: _selectedMethod,
                            txnCtrl: _txnCtrl,
                            mobileCtrl: _mobileCtrl,
                            bankNameCtrl: _bankNameCtrl,
                            transferTime: _transferTime,
                            onTransferTime: (dt) =>
                                setState(() => _transferTime = dt),
                            isLoading: paymentState.isLoading,
                            error: paymentState.error,
                            errorCode: paymentState.errorCode,
                            onSubmit: _submit,
                          )
                        : _PendingStep(
                            key: const ValueKey(2),
                            plan: widget.plan,
                            price: widget.price,
                            duration: _durationBn,
                            method: _selectedMethod,
                            txnId: _txnCtrl.text.toUpperCase(),
                            result: ref.read(paymentSubmitProvider).result,
                            onDone: () =>
                                Navigator.popUntil(context, (r) => r.isFirst),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 0 — METHOD SELECTION
// ─────────────────────────────────────────────────────────────────────────────

class _MethodStep extends StatelessWidget {
  final SubscriptionPlan plan;
  final int price;
  final String duration;
  final PaymentMethod selectedMethod;
  final AsyncValue<Map<String, dynamic>> methodsAsync;
  final ValueChanged<PaymentMethod> onMethod;
  final VoidCallback onNext;

  const _MethodStep({
    super.key,
    required this.plan,
    required this.price,
    required this.duration,
    required this.selectedMethod,
    required this.methodsAsync,
    required this.onMethod,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan summary
          _PlanSummaryCard(plan: plan, price: price, duration: duration),
          const SizedBox(height: 20),

          const Text(
            'পেমেন্ট পদ্ধতি বেছে নিন',
            style: TextStyle(
                color: _C.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 10),

          // Method cards
          ...PaymentMethod.values.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: methodsAsync.when(
                loading: () => _MethodCard(
                  method: m,
                  number: '...',
                  instruction: '',
                  isSelected: selectedMethod == m,
                  onTap: () => onMethod(m),
                ),
                error: (_, __) => _MethodCard(
                  method: m,
                  number: '',
                  instruction: '',
                  isSelected: selectedMethod == m,
                  onTap: () => onMethod(m),
                ),
                data: (methods) {
                  final key = m.value;
                  final info = methods[key] as Map? ?? {};
                  final number = m == PaymentMethod.bank
                      ? info['accountNumber'] ?? ''
                      : info['number'] ?? '';
                  return _MethodCard(
                    method: m,
                    number: number,
                    instruction: info['instruction'] ?? '',
                    isSelected: selectedMethod == m,
                    onTap: () => onMethod(m),
                    bankInfo: m == PaymentMethod.bank ? info : null,
                  );
                },
              ),
            ),
          ),

          // Instruction box
          methodsAsync.when(
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
            data: (methods) {
              final key = selectedMethod.value;
              final info = methods[key] as Map? ?? {};
              final instruction = info['instruction'] ?? '';
              final number = selectedMethod == PaymentMethod.bank
                  ? info['accountNumber'] ?? ''
                  : info['number'] ?? '';
              if (instruction.isEmpty) return const SizedBox();
              return _InstructionBox(
                method: selectedMethod,
                number: number,
                instruction: instruction,
                price: price,
                bankInfo: selectedMethod == PaymentMethod.bank ? info : null,
              );
            },
          ),

          const SizedBox(height: 20),

          _PrimaryBtn(
            label: 'পেমেন্ট করেছি, পরবর্তী ধাপ',
            icon: Icons.arrow_forward_rounded,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final PaymentMethod method;
  final String number;
  final String instruction;
  final bool isSelected;
  final VoidCallback onTap;
  final Map? bankInfo;

  const _MethodCard({
    required this.method,
    required this.number,
    required this.instruction,
    required this.isSelected,
    required this.onTap,
    this.bankInfo,
  });

  Color get _iconBg {
    switch (method) {
      case PaymentMethod.bkash:
        return const Color(0xFFE2136E).withOpacity(0.1);
      case PaymentMethod.nagad:
        return const Color(0xFFF4811F).withOpacity(0.1);
      case PaymentMethod.bank:
        return _C.greenLight;
    }
  }

  Color get _iconColor {
    switch (method) {
      case PaymentMethod.bkash:
        return const Color(0xFFE2136E);
      case PaymentMethod.nagad:
        return const Color(0xFFF4811F);
      case PaymentMethod.bank:
        return _C.midGreen;
    }
  }

  String get _iconLabel {
    switch (method) {
      case PaymentMethod.bkash:
        return 'bK';
      case PaymentMethod.nagad:
        return 'Ng';
      case PaymentMethod.bank:
        return '🏦';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 160.ms,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _C.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? _C.darkGreen : _C.border,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _iconLabel,
                  style: TextStyle(
                    color: _iconColor,
                    fontWeight: FontWeight.w800,
                    fontSize: method == PaymentMethod.bank ? 18 : 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.displayName,
                    style: const TextStyle(
                      color: _C.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (number.isNotEmpty)
                    Text(
                      number,
                      style: const TextStyle(
                          color: _C.textSecondary, fontSize: 12),
                    ),
                ],
              ),
            ),
            // Radio
            AnimatedContainer(
              duration: 160.ms,
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _C.darkGreen : _C.border,
                  width: isSelected ? 5 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionBox extends StatelessWidget {
  final PaymentMethod method;
  final String number;
  final String instruction;
  final int price;
  final Map? bankInfo;

  const _InstructionBox({
    required this.method,
    required this.number,
    required this.instruction,
    required this.price,
    this.bankInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBDD7F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline_rounded,
                  color: Color(0xFF2563EB), size: 16),
              SizedBox(width: 6),
              Text(
                'নির্দেশনা',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (method != PaymentMethod.bank) ...[
            _InstrRow('নম্বরে পাঠান', number),
            _InstrRow('পরিমাণ', '৳$price'),
            _InstrRow('পদ্ধতি', instruction),
          ] else ...[
            _InstrRow('Bank', bankInfo?['bankName'] ?? ''),
            _InstrRow('Account Name', bankInfo?['accountName'] ?? ''),
            _InstrRow('Account No', bankInfo?['accountNumber'] ?? ''),
            _InstrRow('পরিমাণ', '৳$price'),
            _InstrRow('পদ্ধতি', instruction),
          ],
        ],
      ),
    ).animate(delay: 50.ms).fadeIn(duration: 200.ms);
  }
}

class _InstrRow extends StatelessWidget {
  final String label;
  final String value;
  const _InstrRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: value.isNotEmpty
                  ? () {
                      Clipboard.setData(ClipboardData(text: value));
                    }
                  : null,
              child: Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF1E3A5F),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                  if (value.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.copy_rounded,
                        size: 11, color: Color(0xFF94A3B8)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 1 — TRANSACTION FORM
// ─────────────────────────────────────────────────────────────────────────────

class _FormStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final SubscriptionPlan plan;
  final int price;
  final String duration;
  final PaymentMethod method;
  final TextEditingController txnCtrl;
  final TextEditingController mobileCtrl;
  final TextEditingController bankNameCtrl;
  final DateTime? transferTime;
  final ValueChanged<DateTime> onTransferTime;
  final bool isLoading;
  final String? error;
  final String? errorCode;
  final VoidCallback onSubmit;

  const _FormStep({
    super.key,
    required this.formKey,
    required this.plan,
    required this.price,
    required this.duration,
    required this.method,
    required this.txnCtrl,
    required this.mobileCtrl,
    required this.bankNameCtrl,
    required this.transferTime,
    required this.onTransferTime,
    required this.isLoading,
    this.error,
    this.errorCode,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PlanSummaryCard(plan: plan, price: price, duration: duration),
            const SizedBox(height: 20),

            // Error banner
            if (error != null) ...[
              _ErrorBanner(
                  message: error!,
                  isDuplicate: errorCode == 'DUPLICATE_TRANSACTION'),
              const SizedBox(height: 12),
            ],

            // Transaction ID
            _FormField(
              label: 'Transaction ID *',
              hint: 'যেমন: 8K9J2L4MNP',
              controller: txnCtrl,
              textCapitalization: TextCapitalization.characters,
              keyboardType: TextInputType.text,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Transaction ID দিন';
                }
                if (v.trim().length < 5) {
                  return 'সঠিক Transaction ID দিন';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Mobile last 4 (bKash/Nagad)
            if (method != PaymentMethod.bank) ...[
              _FormField(
                label: 'প্রেরকের মোবাইলের শেষ ৪ সংখ্যা *',
                hint: 'যেমন: 4521',
                controller: mobileCtrl,
                keyboardType: TextInputType.number,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'শেষ ৪ সংখ্যা দিন';
                  if (v.length != 4) return '৪টি সংখ্যা দিন';
                  return null;
                },
              ),
              const SizedBox(height: 12),
            ],

            // Bank specific fields
            if (method == PaymentMethod.bank) ...[
              _FormField(
                label: 'আপনার Bank এর নাম *',
                hint: 'যেমন: Dutch-Bangla Bank',
                controller: bankNameCtrl,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Bank এর নাম দিন';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Transfer time picker
              _TransferTimePicker(
                selectedTime: transferTime,
                onChanged: onTransferTime,
              ),
              const SizedBox(height: 12),
            ],

            // Payment method display (read only)
            _ReadOnlyField(
              label: 'পেমেন্ট পদ্ধতি',
              value: method.displayName,
            ),
            const SizedBox(height: 6),
            _ReadOnlyField(
              label: 'প্ল্যান',
              value: '${plan.badge} ${plan.nameBn} — ৳$price ($duration)',
            ),

            const SizedBox(height: 16),

            // Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _C.greenLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.green.withOpacity(0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline_rounded,
                      color: _C.midGreen, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Submit এর পরে ২৪ ঘন্টার মধ্যে confirm করা হবে। Confirm হলে notification পাবেন।',
                      style: TextStyle(
                          color: _C.midGreen, fontSize: 11, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _PrimaryBtn(
              label: 'Submit করুন',
              icon: Icons.send_rounded,
              onTap: onSubmit,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _C.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(
              color: _C.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: _C.textHint, fontSize: 13),
            counterText: '',
            filled: true,
            fillColor: _C.cardBg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _C.border, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _C.border, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _C.darkGreen, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _C.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  const _ReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(color: _C.textHint, fontSize: 11)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  color: _C.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransferTimePicker extends StatelessWidget {
  final DateTime? selectedTime;
  final ValueChanged<DateTime> onChanged;

  const _TransferTimePicker(
      {required this.selectedTime, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transfer এর আনুমানিক সময় *',
          style: TextStyle(
            color: _C.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 3)),
              lastDate: DateTime.now(),
              builder: (ctx, child) => Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(primary: _C.darkGreen),
                ),
                child: child!,
              ),
            );
            if (date == null || !context.mounted) return;
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time == null) return;
            onChanged(DateTime(
                date.year, date.month, date.day, time.hour, time.minute));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: _C.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedTime != null ? _C.darkGreen : _C.border,
                width: selectedTime != null ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: selectedTime != null ? _C.darkGreen : _C.textHint,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  selectedTime != null
                      ? '${selectedTime!.day}/${selectedTime!.month}/${selectedTime!.year}  ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                      : 'তারিখ ও সময় বেছে নিন',
                  style: TextStyle(
                    color: selectedTime != null ? _C.textPrimary : _C.textHint,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final bool isDuplicate;

  const _ErrorBanner({required this.message, this.isDuplicate = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.red.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: _C.red, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style:
                      const TextStyle(color: _C.red, fontSize: 12, height: 1.4),
                ),
                if (isDuplicate)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'এই Transaction ID আগে ব্যবহার হয়েছে। সঠিক ID দিন।',
                      style: TextStyle(
                          color: _C.red,
                          fontSize: 11,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STEP 2 — PENDING CONFIRMATION
// ─────────────────────────────────────────────────────────────────────────────

class _PendingStep extends StatelessWidget {
  final SubscriptionPlan plan;
  final int price;
  final String duration;
  final PaymentMethod method;
  final String txnId;
  final Map<String, dynamic>? result;
  final VoidCallback onDone;

  const _PendingStep({
    super.key,
    required this.plan,
    required this.price,
    required this.duration,
    required this.method,
    required this.txnId,
    this.result,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        children: [
          // Success icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _C.greenLight,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.schedule_rounded,
                color: _C.midGreen, size: 36),
          )
              .animate()
              .scale(
                  begin: const Offset(0.5, 0.5),
                  duration: 400.ms,
                  curve: Curves.elasticOut)
              .fadeIn(),

          const SizedBox(height: 16),

          const Text(
            'অপেক্ষায় আছে',
            style: TextStyle(
              color: _C.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 8),

          const Text(
            'আপনার transaction যাচাই করা হচ্ছে।\n২৪ ঘন্টার মধ্যে জানানো হবে।',
            style:
                TextStyle(color: _C.textSecondary, fontSize: 13, height: 1.5),
            textAlign: TextAlign.center,
          ).animate(delay: 150.ms).fadeIn(),

          const SizedBox(height: 24),

          // Summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _C.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _C.border),
            ),
            child: Column(
              children: [
                _SummaryRow('প্ল্যান', '${plan.badge} ${plan.nameBn}'),
                const Divider(height: 16, color: _C.border),
                _SummaryRow('Transaction ID', txnId),
                const Divider(height: 16, color: _C.border),
                _SummaryRow('পেমেন্ট', '৳$price — ${method.displayName}'),
                const Divider(height: 16, color: _C.border),
                _SummaryRow('মেয়াদ', duration),
                const Divider(height: 16, color: _C.border),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('অবস্থা',
                        style:
                            TextStyle(color: _C.textSecondary, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _C.amberLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'যাচাই চলছে ⏳',
                        style: TextStyle(
                          color: _C.amber,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.05),

          const SizedBox(height: 20),

          // Timeline
          _Timeline().animate(delay: 300.ms).fadeIn(),

          const SizedBox(height: 24),

          // Done button
          GestureDetector(
            onTap: onDone,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _C.darkGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'হোমে ফিরে যান',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: 350.ms).fadeIn().slideY(begin: 0.05),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: _C.textSecondary, fontSize: 12)),
        Text(value,
            style: const TextStyle(
                color: _C.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final steps = [
      (true, 'Transaction submit', 'সম্পন্ন হয়েছে'),
      (false, 'Admin যাচাই', '২৪ ঘন্টার মধ্যে'),
      (false, 'Subscription সক্রিয়', 'Confirm হলে notification আসবে'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'পরবর্তী ধাপ',
            style: TextStyle(
              color: _C.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((e) {
            final i = e.key;
            final s = e.value;
            final isDone = s.$1;
            final isLast = i == steps.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isDone ? _C.green : _C.border,
                          shape: BoxShape.circle,
                        ),
                        child: isDone
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 8)
                            : null,
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 1.5,
                            color: _C.border,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.$2,
                            style: TextStyle(
                              color: isDone ? _C.textPrimary : _C.textSecondary,
                              fontWeight:
                                  isDone ? FontWeight.w600 : FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            s.$3,
                            style: const TextStyle(
                                color: _C.textHint, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int step;
  final VoidCallback? onBack;

  const _TopBar({required this.step, this.onBack});

  String get _title {
    switch (step) {
      case 0:
        return 'পেমেন্ট পদ্ধতি';
      case 1:
        return 'Transaction যাচাই';
      default:
        return 'অনুরোধ পাঠানো হয়েছে';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: _C.cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.border),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: _C.textSecondary, size: 18),
              ),
            ),
          Text(
            _title,
            style: const TextStyle(
              color: _C.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int current;
  const _StepIndicator({required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Row(
        children: List.generate(2, (i) {
          final isActive = i <= current;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 1 ? 6 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? _C.darkGreen : _C.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PlanSummaryCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final int price;
  final String duration;

  const _PlanSummaryCard({
    required this.plan,
    required this.price,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
      ),
      child: Row(
        children: [
          Text(plan.badge, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${plan.nameBn} প্ল্যান',
                  style: const TextStyle(
                    color: _C.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  duration,
                  style: const TextStyle(color: _C.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            '৳$price',
            style: const TextStyle(
              color: _C.darkGreen,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _PrimaryBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: 160.ms,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isLoading ? _C.darkGreen.withOpacity(0.7) : _C.darkGreen,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            else ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
