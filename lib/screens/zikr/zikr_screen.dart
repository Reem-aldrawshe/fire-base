import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:serag_app/bloc/zikrs/zikr/zikr_bloc.dart';
import 'package:serag_app/bloc/zikrs/zikr/zikr_event.dart';
import 'package:serag_app/bloc/zikrs/zikr/zikr_state.dart';
import 'package:serag_app/models/zikr.dart';
import 'package:serag_app/services/zikr_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_zikr_bottom_sheet.dart';

class ZikrSessionScreen extends StatelessWidget {
  const ZikrSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ZikrBloc(ZikrService())..add(FetchZikrs()),
      child: const _ZikrSessionView(),
    );
  }
}

class _ZikrSessionView extends StatelessWidget {
  const _ZikrSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildHeader(context),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<ZikrBloc, ZikrState>(
                    builder: (context, state) {
                      if (state is ZikrLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ZikrError) {
                        return Center(child: Text(state.message));
                      } else if (state is ZikrEmpty) {
                        return const Center(child: Text('لا توجد أذكار مضافة بعد'));
                      } else if (state is ZikrLoaded) {
                        final zikrs = state.zikrs;
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: zikrs.length,
                          itemBuilder: (context, index) {
                            final zikr = zikrs[index];
                            return GestureDetector(
                              onTap: () => _handleZikrCardTap(context, zikr),
                              child: _buildZikrCard(zikr, index),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: MediaQuery.of(context).size.width / 2 - 24,
            child: GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AddZikrBottomSheet(
                    onAdded: () {
                      context.read<ZikrBloc>().add(FetchZikrs());
                    },
                  ),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B3E26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffFBCB8F), Color(0xffFBCB8F), Color(0xffD97654), Color(0xff2C1D22)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Color(0xff372527)),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/floral.png', width: 24, height: 24),
            const SizedBox(width: 8),
            const Text(
              'جلسة ذكر',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 30,
                color: Color(0xff5C3B13),
              ),
            ),
            const SizedBox(width: 8),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.1416),
              child: Image.asset('assets/images/floral.png', width: 24, height: 24),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildZikrCard(Zikr zikr, int index) {
    return Card(
      color: const Color(0xffFFF8C7),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    zikr.name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/images/star.png', width: 90, height: 89),
                    Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(height: 1, color: const Color(0xFF6B3E26), margin: const EdgeInsets.symmetric(vertical: 8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('تاريخ الانتهاء', style: TextStyle(fontSize: 15, color: Colors.black)),
                Image(image: AssetImage('assets/images/floralll.png'), width: 50, height: 28),
                Text('تاريخ البدء', style: TextStyle(fontSize: 15, color: Colors.black)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.yMd().format(zikr.endDate), style: const TextStyle(fontSize: 12, color: Color(0xffB99470))),
                Text(DateFormat.yMd().format(zikr.startDate), style: const TextStyle(fontSize: 12, color: Color(0xffB99470))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(' المفروض:', style: TextStyle(fontSize: 15, color: Colors.black)),

                const Text(' المنجز:', style: TextStyle(fontSize: 15, color: Colors.black)),
                //Text('${zikr.completedCount}', style: const TextStyle(fontSize: 15, color: Color(0xffB99470))),
                //const Text(' المفروض:', style: TextStyle(fontSize: 15, color: Colors.black)),
                //Text('${zikr.targetCount}', style: const TextStyle(fontSize: 15, color: Color(0xffB99470))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${zikr.targetCount}', style: const TextStyle(fontSize: 15, color: Color(0xffB99470))),
                Text('${zikr.completedCount}', style: const TextStyle(fontSize: 15, color: Color(0xffB99470))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('العدد اليومي المستهدف: ', style: TextStyle(fontSize: 15, color: Colors.black)),
                Text('${zikr.dailyTarget}', style: const TextStyle(fontSize: 15, color: Color(0xffB99470))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleZikrCardTap(BuildContext context, Zikr zikr) async {
    final DateTime today = DateTime.now();
    final isWithinRange = !today.isBefore(zikr.startDate) && !today.isAfter(zikr.endDate);

    if (!isWithinRange) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('هذا الذكر خارج المدة المحددة.')),
      );
      return;
    }

    final newCompletedCount = zikr.completedCount + zikr.dailyTarget;
    final updatedCompletedCount = newCompletedCount > zikr.targetCount
        ? zikr.targetCount
        : newCompletedCount;

    if (zikr.id != null) {
      context.read<ZikrBloc>().add(UpdateZikrCount(zikr.id!, updatedCompletedCount));
    }

    final message = '''
السلام عليكم 🌸
📿 ذكر اليوم: ${zikr.name}
🔢 عدد الأذكار لليوم: ${zikr.dailyTarget}
✅ المنجز حتى الآن: $updatedCompletedCount من ${zikr.targetCount}
''';

    final whatsappUrl = Uri.parse("https://wa.me/?text=${Uri.encodeFull(message)}");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح واتساب. تأكد من تثبيته.')),
      );
    }
  }
}
