import 'package:flutter/material.dart';
import 'package:ldgr/db/sp_helper.dart';
import 'package:ldgr/firebase/firestore.dart';
import 'package:ldgr/pages/records/entrylist.dart';
import 'package:ldgr/services/date_time_helper.dart';
import 'package:ldgr/services/formatter.dart';
import 'package:ldgr/services/preprocessor.dart';
import 'package:ldgr/services/router.dart';
import 'package:ldgr/shared/snackbar_messages.dart';
import 'package:ldgr/styles/colors.dart';
import 'package:ldgr/shared/lists.dart';
import 'package:uuid/uuid.dart';

class InputExpenditurePage extends StatelessWidget {
  // const InputExpenditure({ Key? key })//  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Enter expense'),
          centerTitle: true,
          backgroundColor: myRed,
        ),
        body: Center(
          child: ExpenditureForm(),
        ));
  }
}

class ExpenditureForm extends StatefulWidget {
  const ExpenditureForm({Key? key}) : super(key: key);

  @override
  _ExpenditureFormState createState() => _ExpenditureFormState();
}

class _ExpenditureFormState extends State<ExpenditureForm> {
  final _expenseFormKey = GlobalKey<FormState>();
  TextEditingController _itemCategory = TextEditingController();
  TextEditingController _itemName = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _pickedDate = TextEditingController();
  TextEditingController _quantity = TextEditingController();

  String? _costArea;
  String? _unit;
  String? _paymentMethod;
  String? _paymentStatus;
  String? _currentUser;

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _pickedDate.text = DateTimeFormatter().toDateString(picked);
        print(_pickedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferencesHelper()
        .readData('currentUserData')
        .then((value) => _currentUser = DataParser().strToMap(value)['name']);
    return Form(
      key: _expenseFormKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.95, 
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _pickedDate,
                  enabled: true,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Date'),
                  onTap: () => _selectDate(context),
/*                   validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter item category!';
                    }
                  }, */
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.95, 
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Cost area'),
                  items: MyItemList().costAreaList,
                  validator: (val) =>
                      val == null ? 'Please select cost area!' : null,
                  onChanged: (val) => setState(() {
                    _costArea = val as String?;
                  }),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _itemCategory,
                  decoration: InputDecoration(labelText: 'Item category'),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
/*                   validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter item category!';
                    }
                  }, */
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _itemName,
                  decoration: InputDecoration(labelText: 'Item name'),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter item name!';
                    }
                  },
                )),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    margin: EdgeInsets.only(right: 10.0),
                    padding: EdgeInsets.only(left: 20.0),
                    child: TextFormField(
                      controller: _quantity,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
/*                       validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter quantity!';
                        }
                      }, */
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0),
                    padding: EdgeInsets.only(right: 20.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(labelText: 'Unit'),
                      items: MyItemList().unitList,
                      /* validator: (val) =>
                          val == null ? 'Please select unit!' : null, */
                      onChanged: (val) => setState(() {
                        _unit = val as String?;
                      }),
                    ),
                  )
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _price,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter price!';
                    }
                  },
                )),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                                    Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    margin: EdgeInsets.only(right: 10.0),
                    padding: EdgeInsets.only(left: 15.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(labelText: 'Payment status'),
                      items: MyItemList().paymentStatusList,
                      validator: (val) =>
                          val == null ? 'Please select payment status!' : null,
                      onChanged: (val) => setState(() {
                        _paymentStatus = val as String?;
                      }),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    margin: EdgeInsets.only(left: 10.0),
                    padding: EdgeInsets.only(right: 15.0),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(labelText: 'Payment method'),
                      items: MyItemList().paymentMethodList,
                      /* validator: (val) =>
                          val == null ? 'Please select payment method' : null, */
                      onChanged: (val) => setState(() {
                        _paymentMethod = val as String?;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('CANCEL'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      String _tsToString =
                          DateTimeHelper().timestampForDB(DateTime.now());
                      String _uuid = Uuid().v1();
                      Map<String, dynamic> _fsPayload = {
                        'account': 'expense',
                        'cost_area': _costArea ?? '',
                        'item_category': _itemCategory.text,
                        'item_name': _itemName.text,
                        'price': _price.text,
                        'quantity': _quantity.text,
                        'unit': _unit ?? '',
                        'payment_method': _paymentMethod ?? '', 
                        'payment_status': _paymentStatus ?? '',
                        'picked_date': '$selectedDate',
                        'created_at': _tsToString,
                        'last_update_at': '',
                        'doc_id': _uuid,
                        'entered_by': _currentUser ?? '',
                      };
                      if (_expenseFormKey.currentState!.validate()) {
                        FirestoreService()
                            .addDocumentWithId(_uuid, _fsPayload)
                            .then((val) {
                          // print('Added id => ${val.id}');
                          if (val == 'add-success') {
                            SnackBarMessage().saveSuccess(context);
                            PageRouter()
                                .navigateToPage(EntryListPage(), context);
                          } else if (val == 'permission-denied') {
                            String eMessage = 'Permission denied';
                            return SnackBarMessage()
                                .customErrorMessage(eMessage, context);
                          } else {
                            return SnackBarMessage()
                                .generalErrorMessage(context);
                          }
                        });
                      }
                    },
                    child: Text('SAVE'),
                    style: ElevatedButton.styleFrom(primary: myRed),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

setExpenseItemList(String category) {
  if (category == 'bar') {
    return MyItemList().barItemList;
  }
  if (category == 'kitchen') {
    return MyItemList().kitchenItemList;
  }
  if (category == 'operating_costs') {
    return MyItemList().operatingCostsItemList;
  }
  if (category == 'toilet') {
    return MyItemList().toiletItemList;
  }
  if (category == 'others') {
    return MyItemList().othersItemList;
  } else {
    return MyItemList().emptyList;
  }
}
