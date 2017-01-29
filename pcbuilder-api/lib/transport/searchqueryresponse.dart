import 'package:dartson/dartson.dart';
import '../domain/searchquery.dart';

@Entity()
class SearchQueryResponse {
  List<SearchQuery> searches=[];
  int page=1;
  int pageCount=0;
}
