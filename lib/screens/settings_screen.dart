import 'package:flutter/material.dart';

import '../models/look_pack.dart';
import '../services/look.dart';
import '../services/store.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController goal;
  late final TextEditingController height;
  late final TextEditingController stride;
  late final TextEditingController weight;

  @override
  void initState() {
    super.initState();
    final s = Store.instance;
    goal = TextEditingController(text: '${s.goal}');
    height = TextEditingController(text: '${s.heightCm}');
    stride = TextEditingController(text: '${s.strideCm}');
    weight = TextEditingController(text: '${s.weightKg}');
  }

  @override
  void dispose() {
    goal.dispose();
    height.dispose();
    stride.dispose();
    weight.dispose();
    super.dispose();
  }

  void _save() {
    final s = Store.instance;
    final parsedGoal = int.tryParse(goal.text);
    if (parsedGoal != null && parsedGoal < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal must be at least 100')),
      );
      return;
    }
    if (parsedGoal != null) {
      s.goal = parsedGoal;
    }
    s.heightCm = int.tryParse(height.text) ?? s.heightCm;
    s.strideCm = int.tryParse(stride.text) ?? s.strideCm;
    s.weightKg = int.tryParse(weight.text) ?? s.weightKg;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = Look.instance.pack;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: p.bg,
        foregroundColor: p.ink,
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save', style: TextStyle(color: p.accent)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          _field('Daily goal (steps)', goal, p),
          _field('Height (cm)', height, p),
          _field('Stride (cm)', stride, p),
          _field('Weight (kg) — for kcal estimate only', weight, p),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: p.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Quiet Steps is not a medical device. It does not diagnose, treat, cure or prevent any condition.\n\n'
              'Steps come from the phone sensor. Distance and calories are estimates from the numbers you type here.\n\n'
              'Nothing is uploaded. There is no account. GPS is not used.',
              style: TextStyle(color: p.muted, height: 1.45, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c, LookPack p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        style: TextStyle(color: p.ink),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: p.muted),
          filled: true,
          fillColor: p.card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
