import 'package:flutter/material.dart';
import 'package:schedule_generator_ai/models/task.dart';
import 'package:schedule_generator_ai/services/gemini_service.dart';
import 'package:schedule_generator_ai/ui/home/components/add_task_card.dart';
import 'package:schedule_generator_ai/ui/home/components/schedule_result_card.dart';
import 'package:schedule_generator_ai/ui/home/components/task_list_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  final List<Task> tasks = []; // buat nampung hasil inputan task yang di input sama user
  String scheduleResult =''; // buat wadah hasil generate schedule yang dihasilkan gemini
  final GeminiService geminiService = GeminiService();

  // function utama buat generate jadwal harian berdasarkan task yang sudah di input
  Future<void>_generateSchedule() async {
    setState(() => isLoading = true);
    try {
      // pastiin proses async nya selesai dulu baru hasilnya bisa di tampilkan
      // await di taro di dalam variable schedule biar hasilnya bisa di tampilin setelah proses async selesai
      final schedule = await geminiService.generateSchedule(tasks);
      setState(() => scheduleResult = schedule);
    } catch (e) {
      setState(() => scheduleResult = e.toString());
    }
    // pastiin proses loading nya selesai setelah hasilnya di tampilkan
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Generator'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildHeader(),
          AddTaskCard(onAddTask: (task) => setState(() => tasks.add(task))),
          SizedBox(height: 16),
          AddTaskListSection(
            tasks: tasks,
            // ignore: collection_methods_unrelated_type
            onDelete: (index) => setState(() => tasks.removeAt(index)),
          ),
          SizedBox(height: 16),
          _buildGenerateButton(),
          SizedBox(height: 16),
          ScheduleResultCard(schedule: scheduleResult)
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Icon(
              Icons.auto_awesome_mosaic_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "plan your day faster",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700
                  ),
                ),
                Text(
                  "Add task and generate",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant
                  ),
                )
              ],
            ),
          ),
          Chip(label:Text('${tasks.length} task'))
        ],
      ),
    );
  }
  Widget _buildGenerateButton() {
    return FilledButton.icon(
      onPressed: (isLoading || tasks.isEmpty) ? null : _generateSchedule,
      // size loading indicator nya di sesuaikan dengan ukuran icon biar pas
      icon: isLoading ? SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      ) : Icon(Icons.auto_awesome_rounded),
      label: Text(isLoading ? 'Generating...' : 'Generate Schedule'),
      );
  }
}