import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:serag_app/bloc/khetma/khetma_bloc.dart';
import 'package:serag_app/bloc/khetma/khetma_event.dart';
import 'package:serag_app/bloc/khetma/khetma_state.dart';
import 'package:serag_app/models/khetma.dart';
import 'package:serag_app/screens/add_khetma.dart';
import 'package:serag_app/screens/khetma_details_screen.dart';
import 'package:serag_app/services/khetma_service.dart';

class KhetmaPublicScreen extends StatelessWidget {
  const KhetmaPublicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KhetmaBloc(KhetmaService())..add(FetchKhetmas(isPublic: true)),
      child: const _KhetmaPublicView(),
    );
  }
}

class _KhetmaPublicView extends StatelessWidget {
  const _KhetmaPublicView({super.key});

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
                  child: BlocBuilder<KhetmaBloc, KhetmaState>(
                    builder: (context, state) {
                      if (state is KhetmaLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is KhetmaError) {
                        return Center(child: Text(state.message));
                      } else if (state is KhetmaEmpty) {
                        return const Center(child: Text('لا توجد ختمات عامة بعد'));
                      } else if (state is KhetmaLoaded) {
                        final khatmas = state.khatmas;

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: khatmas.length,
                          itemBuilder: (context, index) {
                            final khatma = khatmas[index];
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => PrivateKhetmaDetailsScreen(khatma: khatma),
                                );
                              },
                              child: _buildKhetmaCard(khatma, index),
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
                  builder: (_) => AddKhetma(
                    isPublic: true,
                    onAdded: () {
                      context.read<KhetmaBloc>().add(FetchKhetmas(isPublic: true));
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
              'الختمات العامة',
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

  Widget _buildKhetmaCard(Khetma khatma, int index) {
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
                    khatma.name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/star.png',
                      width: 90,
                      height: 89,
                    ),
                    Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 1,
              color: const Color(0xFF6B3E26),
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('تاريخ الانتهاء', style: TextStyle(fontSize: 15, color: Colors.black)),
                Image.asset('assets/images/floralll.png', width: 50, height: 28),
                const Text('تاريخ البدء', style: TextStyle(fontSize: 15, color: Colors.black)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.yMd().format(khatma.endDate), style: const TextStyle(fontSize: 12, color: Color(0xffB99470))),
                Text(DateFormat.yMd().format(khatma.startDate), style: const TextStyle(fontSize: 12, color: Color(0xffB99470))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
