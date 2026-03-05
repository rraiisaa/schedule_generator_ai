import 'package:flutter/material.dart';
import 'package:schedule_generator_ai/models/task.dart';

class AddTaskListSection extends StatefulWidget {
  final List<Task> tasks; // buat nampung list task yang di pass dari home screen, biar kita bisa nampilin list task yang udah di tambah sama user
  final Function(int) onDelete; // buat nampung function yang di pass dari home screen untuk nambahin task ke list

  const AddTaskListSection({super.key, required this.tasks, required this.onDelete});

  @override
  State<AddTaskListSection> createState() => _AddTaskListSectionState();
}

class _AddTaskListSectionState extends State<AddTaskListSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        // 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.view_list_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text('Task List',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            if (widget.tasks.isEmpty) 
              _buildEmptyState(context) // ini buat nampilin empty state kalo list task nya masih kosong, biar user tau kalo belum ada task yang di tambah
            else 
              _buildList(context), // ini buat nampilin list task yang di tambah sama user, nanti kita bakal parse list task ini ke widget TaskCard buat nampilin detail task nya
          ],
        )
      ),
    );
  }

// ini buat nampilin empty state kalo list task nya masih kosong, biar user tau kalo belum ada task yang di tambah
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 42, color: Colors.grey),
            SizedBox(height: 8),
            Text('No tasks added yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        )
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return SizedBox(
      height: 260,
      // buat nyimpen list task yang di tambah sama user, nanti kita bakal parse list task ini ke widget TaskCard buat nampilin detail task nya
      child: ListView.separated( // untuk menyajikan data menjadi sebuah list
        itemCount: widget.tasks.length, // panggil widget karena kita mau akses list task yang di pass dari home screen
        // _ = private parameter yang dimiliki anonimus function, karena kita gak butuh parameter itu, jadi kita pake _ buat ngilangin parameter yang gak kepake
        separatorBuilder: (_, _) => SizedBox(height: 8), // ini ga ada di listview builder, fungsinya buat ngasih jarak antar item di list
        itemBuilder: (context, index) {
         final task = widget.tasks[index]; // buat nampung task yang lagi di iterasi, nanti kita bakal parse task ini ke widget TaskCard buat nampilin detail task nya

         // ini buat nampilin detail task nya, kita panggil widget TaskCard yang udah kita buat sebelumnya, terus kita parse task yang lagi di iterasi ke widget TaskCard buat nampilin detail task nya
          return ListTile(
            tileColor: Theme.of(context).colorScheme.surfaceContainerHighest, // buat ngasih warna background ke setiap item di list, biar lebih enak diliat
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // buat ngasih border radius ke setiap item di list, biar lebih enak diliat
            leading: CircleAvatar(
              radius: 14,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              // ini buat nampilin huruf pertama dari nama task nya, biar user bisa tau task apa yang lagi di iterasi, terus kita parse huruf pertama dari nama task nya ke widget Text buat nampilin detail task nya
              child: Text(
               '${index + 1}', // karena index mulainya dari 0, jadi kita tambahin 1 biar mulai dari 1
               style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer,
               fontSize: 12, 
               fontWeight: FontWeight.bold), 
               ),
            ),
            // ini leading, fungsinya itu buat nampilin component di sebelah kiri
            title: Text(task.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)), // buat nampilin nama task nya, terus kita parse nama task nya ke widget Text buat nampilin detail task nya
            subtitle: 
            Text(
              '${task.priority} | ${task.duration} mins | Deadline: ${task.deadline}', style: TextStyle(fontSize: 12, color: Colors.grey)), // buat nampilin detail task nya, terus kita parse detail task nya ke widget Text buat nampilin detail task nya
              // ini trailing, fungsinya itu buat nampilin component di sebelah kanan, kita pake icon delete buat ngasih tau user kalo item di list ini bisa di tap, nanti kita bakal buat function buat hapus task nya
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, size: 12, color: Colors.grey),
                onPressed: () => widget.onDelete(index),
              ), // ini buat nampilin icon panah di sebelah kanan, biar user bisa tau kalo item di list ini bisa di tap
          );
        },
      ),
    );
  }
}