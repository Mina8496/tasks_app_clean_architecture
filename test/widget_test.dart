import 'package:flutter_test/flutter_test.dart';

import 'package:tasks_app_clean_architecture/main.dart';

void main() {
  testWidgets('app starts and shows the tasks home page', (tester) async {
    await tester.pumpWidget(const TasksApp());
    await tester.pump();

    expect(find.text('New Tasks'), findsOneWidget);
  });
}
