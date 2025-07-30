import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../bloc/khetma_details/khetma_details_bloc.dart';
import '../../bloc/khetma_details/khetma_details_event.dart';
import '../../bloc/khetma_details/khetma_details_state.dart';
import '../../models/khetma.dart';

class PrivateKhetmaDetailsScreen extends StatelessWidget {
  final Khetma khatma;

  const PrivateKhetmaDetailsScreen({super.key, required this.khatma});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return BlocProvider(
      create: (_) => KhetmaDetailsBloc(client, khatma)..add(LoadReservedParts()),
      child: _PrivateKhetmaDetailsView(),
    );
  }
}

class _PrivateKhetmaDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDEBD0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'الختمة',
          style: TextStyle(
            color: Colors.brown,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<KhetmaDetailsBloc, KhetmaDetailsState>(
        builder: (context, state) {
          if (state is KhetmaLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is KhetmaError) {
            return Center(child: Text(state.message));
          }

          if (state is KhetmaFinished) {
            return Center(child: Text(state.message));
          }

          List<int> reservedParts = [];
          Khetma? khatma;

          if (state is KhetmaLoaded) {
            reservedParts = state.reservedParts;
            khatma = state.khatma;
          }

          if (khatma == null) {
            return const Center(child: Text('لا توجد بيانات الختمة'));
          }

          final totalParts = 30;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        khatma.intention,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'ID: ${khatma.id}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: totalParts,
                    itemBuilder: (context, index) {
                      final part = index + 1;
                      final isSelected = reservedParts.contains(part);

                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xffC7B7A3)
                              : const Color(0xffF7E1A1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$part',
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5C3B13),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      // جرب غير قيمة offset لتجربة يوم مختلف
                      context.read<KhetmaDetailsBloc>().add(RemindAndMarkToday(offset: 2));
                    },
                    child: const Text(
                      'تذكير ومشاركة',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
