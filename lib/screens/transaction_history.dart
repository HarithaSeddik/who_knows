import 'package:flutter/material.dart';
import 'package:who_knows/config/constants.dart';
import 'package:who_knows/screens/pickup_layout.dart';

class TransactionHistory extends StatelessWidget {
  final TableRow rowSpacer = TableRow(children: [
    SizedBox(
      height: 10,
    ),
    SizedBox(
      height: 10,
    ),
    SizedBox(
      height: 10,
    )
  ]);
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Container(
          margin: EdgeInsets.only(top: 70, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 15),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey[500],
                        blurRadius: 1.0, // soften the shadow
                        spreadRadius: 0.5, //extend the shadow
                        offset: Offset(
                          2.0, // Move to right 10  horizontally
                          1.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ], shape: BoxShape.circle, color: Colors.white),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:
                            Icon(Icons.arrow_back, color: appTheme, size: 25)),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(15),
                        shape: BoxShape.rectangle,
                      ),
                      child: FlatButton.icon(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        onPressed: () {},
                        color: Colors.orange[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        icon: const Icon(Icons.monetization_on,
                            color: appTextColor),
                        label: Text("124",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )),
                        textColor: appTextColor,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                        "How do you want to use\nyour WhoKnows account balance?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 10),
                    Container(
                      width: 220,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(30),
                        shape: BoxShape.rectangle,
                      ),
                      child: FlatButton.icon(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        onPressed: () {},
                        color: Colors.lightBlue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        icon: const Icon(Icons.account_balance_wallet,
                            color: appTextColor),
                        label: Text("Spend on WhoKnows",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            )),
                        textColor: appTextColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 220,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(30),
                        shape: BoxShape.rectangle,
                      ),
                      child: FlatButton.icon(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        onPressed: () {},
                        color: Colors.lightBlue[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        icon: const Icon(Icons.account_balance,
                            color: appTextColor),
                        label: Text("Transfer to Bank Account",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            )),
                        textColor: appTextColor,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("History",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(height: 5),
                    Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                    SizedBox(height: 5),
                    Table(
                      border: TableBorder.all(
                          color: Colors.black26,
                          width: 1,
                          style: BorderStyle.none),
                      children: [
                        TableRow(children: [
                          TableCell(
                            child: Center(child: Text('user_a')),
                          ),
                          TableCell(
                            child: Center(child: Text('07/06/2020')),
                          ),
                          TableCell(
                            child: Center(child: Text('98 \$')),
                          ),
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                            child: Center(child: Text('tester_b')),
                          ),
                          TableCell(
                            child: Center(child: Text('17/06/2020')),
                          ),
                          TableCell(
                            child: Center(child: Text('67 \$')),
                          ),
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                            child: Center(child: Text('jakeww')),
                          ),
                          TableCell(
                            child: Center(child: Text('08/06/2020')),
                          ),
                          TableCell(
                            child: Center(child: Text('51 \$')),
                          ),
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                            child: Center(child: Text('mickey91')),
                          ),
                          TableCell(
                            child: Center(child: Text('21/05/2020')),
                          ),
                          TableCell(
                            child: Center(child: Text('91 \$')),
                          ),
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                            child: Center(child: Text('amy77')),
                          ),
                          TableCell(
                            child: Center(child: Text('09/04/2020')),
                          ),
                          TableCell(
                            child: Center(child: Text('12 \$')),
                          ),
                        ]),
                        rowSpacer,
                        TableRow(children: [
                          TableCell(
                            child: Center(child: Text('john623')),
                          ),
                          TableCell(
                            child: Center(child: Text('26/03/2020')),
                          ),
                          TableCell(
                            child: Center(child: Text('44 \$')),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
