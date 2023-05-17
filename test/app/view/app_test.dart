import 'package:flutter_news/app/app.dart';
import 'package:flutter_news/features/news_feed/presentation/pages/feeds_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders NewsFeedPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(FeedsPage), findsOneWidget);
    });
  });
}
