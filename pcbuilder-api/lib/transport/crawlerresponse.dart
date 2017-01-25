import 'package:dartson/dartson.dart';
import '../domain/crawler.dart';

@Entity()
class CrawlerResponse {
  List<Crawler> crawlers;
}