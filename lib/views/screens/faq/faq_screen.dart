// Copyright 2021-2022, Markus Näther <naem@hs-furtwangen.de>

import 'package:flutter/material.dart';
import 'package:fancai_client/views/widgets/navigation/sidebar_navigation.dart';
import 'package:fancai_client/views/widgets/general/accordion.dart';

class InfocardsScreen extends StatelessWidget {
  const InfocardsScreen({Key? key}) : super(key: key);
  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  final _loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      drawer: const SidebarNavigation(),
      body: Accordion(
        maxOpenSections: 3,
        headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        children: [
          AccordionSection(
            isOpen: true,
            leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
            header: Text('Introduction', style: _headerStyle),
            content: Text(_loremIpsum, style: _contentStyle),
            contentHorizontalPadding: 20,
            contentBorderWidth: 1,
          ),
          AccordionSection(
            isOpen: false,
            leftIcon: const Icon(Icons.compare_rounded, color: Colors.white),
            header: Text('About Us', style: _headerStyle),
            contentBorderColor: const Color(0xffffffff),
            content: Row(
              children: [
                const Icon(Icons.compare_rounded,
                    size: 120, color: Colors.orangeAccent),
                Flexible(
                    flex: 1, child: Text(_loremIpsum, style: _contentStyle)),
              ],
            ),
          ),
          AccordionSection(
            isOpen: false,
            leftIcon: const Icon(Icons.food_bank, color: Colors.white),
            header: Text('Company Info', style: _headerStyle),
            content: DataTable(
              sortAscending: true,
              sortColumnIndex: 1,
              dataRowHeight: 40,
              showBottomBorder: false,
              columns: [
                DataColumn(
                    label: Text('ID', style: _contentStyleHeader),
                    numeric: true),
                DataColumn(
                    label: Text('Description', style: _contentStyleHeader)),
                DataColumn(
                    label: Text('Price', style: _contentStyleHeader),
                    numeric: true),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('1',
                        style: _contentStyle, textAlign: TextAlign.right)),
                    DataCell(Text('Fancy Product', style: _contentStyle)),
                    DataCell(Text(r'$ 199.99',
                        style: _contentStyle, textAlign: TextAlign.right))
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('2',
                        style: _contentStyle, textAlign: TextAlign.right)),
                    DataCell(Text('Another Product', style: _contentStyle)),
                    DataCell(Text(r'$ 79.00',
                        style: _contentStyle, textAlign: TextAlign.right))
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('3',
                        style: _contentStyle, textAlign: TextAlign.right)),
                    DataCell(Text('Really Cool Stuff', style: _contentStyle)),
                    DataCell(Text(r'$ 9.99',
                        style: _contentStyle, textAlign: TextAlign.right))
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('4',
                        style: _contentStyle, textAlign: TextAlign.right)),
                    DataCell(
                        Text('Last Product goes here', style: _contentStyle)),
                    DataCell(Text(r'$ 19.99',
                        style: _contentStyle, textAlign: TextAlign.right))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
