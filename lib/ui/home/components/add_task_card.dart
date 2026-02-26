import 'package:flutter/material.dart';
import 'package:schedule_generator_ai/models/task.dart';

class AddTaskCard extends StatefulWidget { 
  final Function(Task) onAddTask; // buat nampung function yang di pass dari home screen untuk nambahin task ke list
  const AddTaskCard({super.key, required this.onAddTask});

  @override
  State<AddTaskCard> createState() => _AddTaskCardState();
}

class _AddTaskCardState extends State<AddTaskCard> {
  // isian yang wajib di isi sama user
  final taskController = TextEditingController(); // buat nyimpen value task karena nanti di parse ke string
  final durationController = TextEditingController(); // buat nyimpen value dadi string karena nanti di parse ke int
  final deadlineController = TextEditingController(); // buat nyimpen value dadi string karena nanti di parse ke datetime
  String? priority;

  @override
  // pastiin controller nya di dispose setelah selesai biar gak memory leak
  // ini buat ngilangin cache yang ada di ui 
  void dispose() {
    // ini ilangin cache satu satu
    taskController.dispose();
    durationController.dispose();
    deadlineController.dispose();
    // buat ngilangin total cache yang di pake sama controller setelah selesai di pake
    // kenapa pakai super lagi? karena takut ada cache yang ketinggalan
    super.dispose();
  }

  // ini function buat ngecek kalo semua inputan udah di isi sama user, baru kita bisa submit task nya, kalo ada yang kosong ya gak bisa submit
  void _submit() {
    // ini buat mastiin value nya ga kosong, dan untuk prioritynya beda sendiri karena dia dropdown jadi beda cara ngecek nya
    if (taskController.text.isNotEmpty && durationController.text.isNotEmpty && deadlineController.text.isNotEmpty && priority != null) {
      widget.onAddTask(Task(
        name: taskController.text, 
        priority: priority!, 
        duration: int.tryParse(durationController.text) ?? 5, 
        deadline: deadlineController.text
        ));

        // ini buat ngebersiin cache nya, tapi buat tombol submitnya. kalo yang sebelumnya buat ui
        taskController.clear();
        durationController.clear();
        deadlineController.clear();
        setState(() => priority = null); // buat reset dropdown nya setelah submit
    }
  }

 @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.playlist_add_check_circle_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  'Add Task',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            // TEXT INPUT ACTION (KALO BISA BIKIN INI JADI COMPONENT LAIN BIAR GAK NULIS ULANG KODE YANG SAMA) (KALO BISA BIKIN VALIDASI JUGA BIAR USER GAK SALAH INPUT)
            // ini buat bikin jarak antara judul sama inputan
            SizedBox(height: 12),
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.task),
              ),
              // ini buat bikin tombol next di keyboard biar user bisa langsung ke inputan selanjutnya tanpa harus tap
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12),
            TextField(
              controller: durationController,
              decoration: InputDecoration(
                labelText: 'Duration (minutes)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer),
              ),
              // ini buat bikin tombol next di keyboard biar user bisa langsung ke inputan selanjutnya tanpa harus tap
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12),
            TextField(
              controller: deadlineController,
              decoration: InputDecoration(
                labelText: 'Deadline (YYYY-MM-DD)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              // ini buat bikin tombol done di keyboard biar user (langsung ketutup) bisa langsung submit setelah ngisi deadline tanpa harus tap tombol submit
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 12),
            // <String> biar spesfik value buat string
            DropdownButtonFormField<String>(
              initialValue: priority,
               decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.priority_high),
              ),
              items: const ['High', 'Medium', 'Low']
                  .map((values) => DropdownMenuItem(
                    value: values,
                    child: Text(values),
                  ))
                  .toList(),
                  // karena ada perubahan state yang terjadi di dropdown (value), jadi kita harus pake setState biar ui nya bisa update sesuai dengan value yang dipilih
              onChanged: (value) => setState(() => priority = value), // buat ngeset value yang dipilih ke variable priority
            ),
            SizedBox(height: 16),
            // ini buat tombol submitnya, kalo di tap bakal manggil function _submit yang udah kita buat tadi
            FilledButton(
              onPressed: _submit, 
              child: Text('Add Task'),
            )
          ],
        ),
      ),
    );
  }
}