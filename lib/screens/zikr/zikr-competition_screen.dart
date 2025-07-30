import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serag_app/bloc/zikrs/zikr_competition_bloc.dart';
import 'package:serag_app/bloc/zikrs/zikr_competition_event.dart';
import 'package:serag_app/bloc/zikrs/zikr_competition_state.dart';
import 'package:serag_app/models/zikr_competition.dart';
import 'package:serag_app/screens/zikr/create_competition_dialog.dart';
import 'package:serag_app/services/zikr_competition_service.dart';

class ZikrCompetitionScreen extends StatelessWidget {
  const ZikrCompetitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ZikrCompetitionBloc(ZikrCompetitionService())..add(LoadZikrCompetition()),
      child: const ZikrCompetitionView(),
    );
  }
}

class ZikrCompetitionView extends StatelessWidget {
  const ZikrCompetitionView({super.key});

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CreateCompetitionDialog(
        onCreate: (title, target) {
          context.read<ZikrCompetitionBloc>().add(CreateZikrCompetition(title, target));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFF9F5F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/floral.png', width: 50, height: 50),
            const SizedBox(height: 20),
            const Text(
              'تم إنجاز الجلسة بنجاح!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff5C3B13),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD6B287),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('تم', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ZikrCompetitionBloc, ZikrCompetitionState>(
      listener: (context, state) {
        if (state is ZikrInitial) {
          _showCreateDialog(context);
        } else if (state is ZikrError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ZikrCompleted) {
          _showCompletionDialog(context);
        }
      },
      builder: (context, state) {
        if (state is ZikrLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xff5C3B13))),
          );
        }

        if (state is ZikrLoaded) {
          return _buildScaffold(context, state.competition);
        }

        return const Scaffold(
          body: Center(child: Text('لا توجد مسابقة حالية')),
        );
      },
    );
  }

  Widget _buildScaffold(BuildContext context, ZikrCompetition comp) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF9F5F0), Color(0xFFEBCDA5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildInfoBoxes(comp),
              const SizedBox(height: 20),
              _buildZikrTextBox(comp.zikrText),
              const SizedBox(height: 30),
              Expanded(child: _buildCounter(context)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBoxes(ZikrCompetition comp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildInfoBox("الهدف", comp.targetCount.toString()),
          const SizedBox(width: 15),
          _buildInfoBox("المكتمل", comp.completedCount.toString()),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      width: 140,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFC79E6F),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff5C3B13), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildZikrTextBox(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5C3B13),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 28, color: Color(0xFFF9F5F0), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCounter(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => context.read<ZikrCompetitionBloc>().add(IncrementCount()),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/side1.png', width: 300, height: 300),
            Image.asset('assets/images/side2.png', width: 250, height: 250),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/side3.png', width: 150, height: 150),
                const Text("انقر", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5C3B13))),
              ],
            ),
            _buildRadialText('33', -90, 120),
            _buildRadialText('100', -180, 120),
            _buildRadialText('500', 45, 120),
          ],
        ),
      ),
    );
  }

  Widget _buildRadialText(String text, double angleDegrees, double radius) {
    final angleRadians = angleDegrees * (math.pi / 180);
    return Positioned(
      left: 150 + radius * math.cos(angleRadians) - 20,
      top: 150 + radius * math.sin(angleRadians) - 10,
      child: Transform.rotate(
        angle: angleRadians + math.pi / 2,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xff5C3B13)),
        ),
      ),
    );
  }
}
