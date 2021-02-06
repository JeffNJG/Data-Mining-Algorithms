import 'package:excel/excel.dart'; // excel dependency for manipulating xlsx files with dart
import 'dart:io'; // input / output dependency

// apriori, aprioriTID and setm modules
import 'apriori_methods.dart';
import 'tid_methods.dart';
import 'setm.dart';
import 'utilities.dart';

// main function
void main(List<String> arguments) {
  print('Extraction des données ...');
  var file = './testdata.xlsx';
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);
  var datas = {}; // transactions
  var transac = []; // invoice-item association
  var I = []; // Items
  for (var table in excel.tables.keys) {
    var Rows = excel.tables[table].rows; // contain all the rows of the sheet
    transac = setTransac(Rows);
  }
  datas = setDatas(transac);
  I = setItems(datas);
  var II = setItemsTID(I);
  var choice;
  print('Il y a ${datas.length} transactions.');
  print('');
  print('************************ MENU ************************');
  print('1. Apriori');
  print('2. Apriori TID');
  print('3. SETM');
  do {
    try {
      print("Entrez le numéro de l'algorithme que vous désirez exécuter : ");
      choice = int.parse(stdin.readLineSync());
      break;
    } on FormatException {
      print("Entrez une valeur entière s'il vous plaît.");
    }
  } while (true);
  switch (choice) {
    case 1:
      {
        var supp;
        do {
          try {
            print('Choisissez le support minimum :');
            supp = int.parse(stdin.readLineSync());
            break;
          } on FormatException {
            print("Entrez une valeur entière s'il vous plaît.");
          }
        } while (true);
        print("Exécution de l'algorithme Apriori, patientez !");
        var freq = apriori_reel(I, datas, supp);
        print('Les itemsets fréquents trouvés sont : ');
        for (var elem in freq) {
          print(' ==> $elem');
        }
        print('Il y a ${freq.length} itemsets fréquents.');
        break;
      }
    case 2:
      {
        var supp;
        do {
          try {
            print('Choisissez le support minimum :');
            supp = int.parse(stdin.readLineSync());
            break;
          } on FormatException {
            print("Entrez une valeur entière s'il vous plaît.");
          }
        } while (true);
        print("Exécution de l'algorithme Apriori TID, patientez !");
        var freq = apriori_TID(II, datas, supp);
        print('Les itemsets fréquents trouvés sont : ');
        for (var elem in freq) {
          print('  ==> $elem');
        }
        print('Il y a ${freq.length} itemsets fréquents.');
        break;
      }
    case 3:
      {
        var supp;
        do {
          try {
            print('Choisissez le support minimum :');
            supp = int.parse(stdin.readLineSync());
            break;
          } on FormatException {
            print("Entrez une valeur entière s'il vous plaît.");
          }
        } while (true);
        print("Exécution de l'algorithme SETM, patientez !");
        var freq = SETM(I, datas, supp);
        print('Les itemsets fréquents trouvés sont : ');
        for (var elem in freq) {
          print('  ==> $elem');
        }
        print('Il y a ${freq.length} itemsets fréquents.');
        break;
      }
    default:
      {
        print('Not allowed value');
      }
  }
}
