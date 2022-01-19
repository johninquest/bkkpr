import 'package:flutter/material.dart';
import 'package:ldgr/filters/filter_data.dart';
import 'package:ldgr/filters/filter_logic.dart';
import 'package:ldgr/pages/records/expense_detail.dart';
import 'package:ldgr/services/formatter.dart';
import 'package:ldgr/services/router.dart';
import 'package:ldgr/shared/widgets.dart';
import 'package:ldgr/styles/style.dart';

class SearchPage extends StatefulWidget {
  final List searchData;
  const SearchPage({Key? key, required this.searchData}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _day;
  String? _month;
  String? _year;
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<Object>>? _dayList = FilterData().dayList();
    List<DropdownMenuItem<Object>>? _monthList = FilterData().monthList();
    List<DropdownMenuItem<Object>>? _yearList = FilterData().yearList();
    final _daybookRecords = FilterService()
        .byDate(widget.searchData, _day ?? '', _month ?? '', _year ?? '');
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter, search, etc'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: 'DD',
                            labelStyle: TextStyle(fontSize: 12.0)),
                        items: _dayList,
                        validator: (val) => val == null ? 'DD?' : null,
                        onChanged: (val) {
                          setState(() {
                            _day = val as String?;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: 'MM',
                            labelStyle: TextStyle(fontSize: 12.0)),
                        items: _monthList,
                        validator: (val) => val == null ? 'MM?' : null,
                        onChanged: (val) => setState(() {
                          _month = val as String?;
                        }),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: 'YYYY',
                            labelStyle: TextStyle(fontSize: 12.0)),
                        items: _yearList,
                        validator: (val) => val == null ? 'YYYY?' : null,
                        onChanged: (val) => setState(() {
                          _year = val as String?;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: buildTable(_daybookRecords),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTable(List fsCollection) {
    if (fsCollection.length < 1) {
      return Container(
        margin: EdgeInsets.only(top: 50.0),
        child: Center(
          child: EmptyTable(),
        ),
      );
    } else {
      final allColumns = [
        'Date',
        'Cost area',
        'Item name',
        'Price',
      ];
      return DataTable(
        // sortAscending: isAscending,
        // sortColumnIndex: sortColumnIndex,
        columnSpacing: 20.0,
        horizontalMargin: 0.0,
        showCheckboxColumn: false,
        columns: getColumns(allColumns),
        rows: getRows(fsCollection),
      );
    }
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(
              column,
              style: ListTitleStyle,
            ),
            // onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List rows) => rows
      .map(
        (e) => DataRow(
          color: MaterialStateProperty.all(Colors.transparent),
          selected: false,
          onSelectChanged: (val) {
            if (val == true) {
              return PageRouter()
                  .navigateToPage(ItemDetailPage(rowData: e), context);
            }
          },
          cells: [
            DataCell(Text(
                DateTimeFormatter().isoToUiDate(e['picked_date']) ?? '',
                style: TableItemStyle,
                textAlign: TextAlign.left)),
            DataCell(Text(
              Formatter().dbToUiValue(e['cost_area']) ?? '',
              style: TableItemStyle,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            )),
            DataCell(ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.20,
              ),
              child: Text(
                e['item_name'] ?? '',
                style: TableItemStyle,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            )),
            DataCell(Text(e['price'] ?? '',
                style: StyleHandler().paymentStatus(e['payment_status']),
                textAlign: TextAlign.right)),
          ],
        ),
      )
      .toList();
}
