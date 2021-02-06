import 'apriori_methods.dart';
import 'utilities.dart';
import 'package:collection/collection.dart';

Map<dynamic, dynamic> Ck_init(Map<dynamic, dynamic> D) {
  print('Génération du premier Ckbar ...');
  var result = {};
  for (var e in D.entries) {
    var new_inv = e.key;
    var new_des = [];
    for (var s in e.value) {
      var elem = <dynamic>{};
      elem.add(s);
      new_des.add(elem);
    }
    result[new_inv] = new_des;
  }
  return result;
}

List<dynamic> itemset_1_TID(List items, Map<dynamic, dynamic> D, int sup) {
  var result = [];
  Function eq = const SetEquality().equals;
  for (var i in items) {
    var cpt = 0;
    for (var d in D.values) {
      for (var j = 0; j < d.length; j++) {
        if (eq(i, d[j])) {
          cpt += 1;
          break;
        }
      }
    }
    if (cpt >= sup) {
      result.add(i);
    }
  }
  return result;
}

List<dynamic> decompose_set(var S) {
  var result = [];
  for (var s in S) {
    var elem = <dynamic>{};
    elem.add(s);
    result.add(elem);
  }
  var temp = [];
  for (var r in result) {
    temp.add(r);
  }
  while (temp[0].length < S.length - 1) {
    var C = candidate_generation(temp);
    temp = C;
  }
  result.clear();
  for (var l in temp) {
    result.add(l);
  }
  return result;
}

Map<dynamic, dynamic> CkBar_generator(
    Map<dynamic, dynamic> D, List<dynamic> CANDIDATE) {
  var result = {};
  for (var d in D.entries) {
    var elem = [];
    for (var s in CANDIDATE) {
      var temp = decompose_set(s);
      if (containsAllSets(d.value, temp)) {
        elem.add(s);
      }
    }
    if (elem == null) {
      continue;
    } else {
      result[d.key] = elem;
    }
  }
  return result;
}

List<dynamic> candidate_validation_TID(
    List<dynamic> C, Map<dynamic, dynamic> datas, int suppmin) {
  var result = [];
  Function eq = const SetEquality().equals;
  for (var i in C) {
    var supp = 0.0; // support
    for (var d in datas.values) {
      for (var j = 0; j < d.length; j++) {
        if (eq(i, d[j])) {
          supp += 1;
          break;
        }
      }
    }
    if (supp >= suppmin) {
      result.add(i);
    }
  }
  return result;
}

List<dynamic> apriori_TID(
    List<dynamic> I, Map<dynamic, dynamic> D, int minsup) {
  var result = [];
  var Ck_bar1 = Ck_init(D);
  print('Calcul des 1-itemsets fréquents ...');
  var L1 = itemset_1_TID(I, Ck_bar1, minsup);
  print('L1 calculé.');
  for (var chaine in L1) {
    result.add(chaine);
  }
  var L = [];
  var Ckbar = {};
  for (var e in Ck_bar1.entries) {
    Ckbar[e.key] = e.value;
  }
  for (var l in L1) {
    L.add(l);
  }
  var i = 2;
  do {
    print('Génération de Ck$i ...');
    var C = candidate_generation(L);
    print('Génération terminée.');
    if (C == null) {
      break;
    }
    print('Génération de Ckbar$i ...');
    Ckbar = CkBar_generator(Ckbar, C);
    print('Ckbar$i a été générée avec succès.');
    L.clear();
    print('Validations des candidats ...');
    L = candidate_validation_TID(C, Ckbar, minsup);
    print('L$i calculé.');
    if (L.isEmpty) {
      break;
    } else {
      for (var q in L) {
        if (contains_set(result, q)) {
          continue;
        } else {
          result.add(q);
        }
      }
    }
    i += 1;
  } while (L.isNotEmpty);
  return result;
}
