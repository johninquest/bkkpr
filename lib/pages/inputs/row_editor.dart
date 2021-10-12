import 'package:flutter/material.dart';
import 'package:tba/data/models.dart';
import 'package:tba/services/date_time_helper.dart';
import 'package:tba/styles/colors.dart';
import 'package:tba/shared/lists.dart';
import 'package:tba/shared/snackbar_messages.dart';
import 'package:tba/data/sqlite_helper.dart';
import 'package:tba/services/router.dart';
import 'package:tba/services/preprocessor.dart';
import 'package:tba/pages/records/all.dart';
import 'package:intl/intl.dart';
import 'package:tba/services/formatter.dart';

class RowEditorPage extends StatelessWidget {
  final Record rowData;
  const RowEditorPage({Key? key, required this.rowData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: setPageTitle(rowData.category),
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: setPageTitleBackgroundColor(rowData.category),
        ),
        body: Container(
          child: Center(
            child: RowEditorForm(initialFormData: rowData),
            /* child: Text(
                '${rowData.id}, ${rowData.createdAt}, ${rowData.category}, ${rowData.source}, ${rowData.amount}'), */
          ),
        ));
  }
}

setPageTitle(String? recordCategory) {
  if (recordCategory != null && recordCategory != '') {
    if (recordCategory == 'expenditure') {
      return Text('Edit expenditure');
    }
    if (recordCategory == 'income') {
      return Text('Edit income');
    }
  } else
    return Text('Nada');
}

setPageTitleBackgroundColor(String? recordCategory) {
  if (recordCategory != null && recordCategory != '') {
    if (recordCategory == 'expenditure') {
      return myRed;
    }
    if (recordCategory == 'income') {
      return myGreen;
    }
  } else
    return myBlue;
}

class RowEditorForm extends StatefulWidget {
  final Record initialFormData;
  const RowEditorForm({Key? key, required this.initialFormData})
      : super(key: key);

  @override
  _RowEditorFormState createState() => _RowEditorFormState();
}

class _RowEditorFormState extends State<RowEditorForm> {
  final _rowEditorFormKey = GlobalKey<FormState>();

  TextEditingController _amount = TextEditingController();
  TextEditingController _createdDateTime = TextEditingController();
  int? _rowId;
  String? _category;
  String? _source;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 1, 1),
        lastDate: DateTime(2101, 12, 31));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _createdDateTime.text = formatDisplayedDate('$picked');
      });
  }

  @override
  void initState() {
    super.initState();
    final data = widget.initialFormData;
    setState(() {
      _rowId = data.id;
      _amount.text = Formatter().toNoDecimal(data.amount);
      _category = data.category;
      _createdDateTime.text = formatDisplayedDate(data.createdAt);
      _source = data.source;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _rowEditorFormKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextFormField(
                controller: _createdDateTime,
                enabled: true,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                ),
                onTap: () => _selectDate(context),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: DropdownButtonFormField(
                  value: _source,
                  decoration:
                      InputDecoration(labelText: 'Reason for expenditure'),
                  items: assignSourceList(_category),
                  validator: (val) => val == null
                      ? 'Please select reason for expenditure!'
                      : null,
                  onChanged: (val) => setState(() {
                    _source = val as String?;
                  }),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _amount,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter amount!';
                    }
                  },
                  /* validator: (val) =>
                      val!.isEmpty ? 'Please enter an amount!' : null,
                  onChanged: (val) => setState(() {
                    expenditureAmount = val;
                  }), */
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('CANCEL'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_rowEditorFormKey.currentState!.validate()) {
                        String editDate = DateTimeHelper()
                            .toDbDateTimeFormat(_createdDateTime.text);
                        String editSource = _source!;
                        String editAmount =
                            InputHandler().moneyCheck(_amount.text);
                        int editRowId = _rowId!;
                        SQLiteDatabaseHelper()
                            .updateRow(
                                editDate, editSource, editAmount, editRowId)
                            .then((value) {
                          if (value != null) {
                            SnackBarMessage().changeSuccess(context);
                            PageRouter().navigateToPage(AllRecords(), context);
                          }
                        });
                      }
                    },
                    child: Text('SAVE'),
                    style: ElevatedButton.styleFrom(
                        primary: setSaveButtonColor(_category)
                        /* primary: myBlue */
                        ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      SQLiteDatabaseHelper().deleteRow(_rowId!).then((value) {
                        if (value != null) {
                          SnackBarMessage().deleteSuccess(context);
                          PageRouter().navigateToPage(AllRecords(), context);
                        }
                      });
                    },
                    child: Text('DELETE'),
                    style: ElevatedButton.styleFrom(
                      primary: myLightRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

assignSourceList(String? editCategory) {
  if (editCategory == 'expenditure') {
    return MyItemList().expenditureList;
  }
  if (editCategory == 'income') {
    return MyItemList().incomeList;
  } else {
    return null;
  }
}

setSaveButtonColor(String? editCategory) {
  if (editCategory == 'expenditure') {
    return myRed;
  }
  if (editCategory == 'income') {
    return myGreen;
  }
}

formatDisplayedDate(String dt) {
  if (DateTime.tryParse(dt) != null && dt != '') {
    DateTime parsedDatTime = DateTime.parse(dt);
    DateFormat cmrDateFormat = DateFormat('dd/MM/yyyy');
    String toCmrDateFormat = cmrDateFormat.format(parsedDatTime);
    return toCmrDateFormat;
  } else {
    return '--/--/----';
  }
}
