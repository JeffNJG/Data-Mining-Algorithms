import 'apriori_methods.dart';
import 'tid_methods.dart';
import 'package:collection/collection.dart';
import 'utilities.dart';

Map<dynamic, dynamic> Lk_init(Map<dynamic, dynamic> D, List<dynamic> L) {
  print('Génération du premier LkBar ...');
  var result = {};
  Function eq = const SetEquality().equals;
  for (var e in D.entries) {
    for (var s in L) {
      for (var i = 0; i < e.value.length; i++) {
        if (eq(e.value[i], s)) {
          if (result.keys.contains(e.key)) {
            result[e.key].add(s);
          } else {
            var elem = [];
            elem.add(s);
            result[e.key] = elem;
          }
        }
      }
    }
  }
  return result;
}

Map<dynamic, dynamic> Ckbar_generatorSETM(Map<dynamic, dynamic> Lk) {
  var result = {};
  for (var e in Lk.entries) {
    var Ck = candidate_generation(e.value);
    if (Ck == null) {
      continue;
    } else {
      result[e.key] = Ck;
    }
  }
  return result;
}

List<dynamic> extract_ck(Map<dynamic, dynamic> Ckbar) {
  var result = [];
  for (var v in Ckbar.values) {
    for (var e in v) {
      if (contains_set(result, e)) {
        continue;
      } else {
        result.add(e);
      }
    }
  }
  return result;
}

Map<dynamic, dynamic> LkBar_generator(
    List<dynamic> Ck, Map<dynamic, dynamic> Ckbar, int supp) {
  var result = {};
  for (var elem in Ck) {
    var sup = 0;
    for (var q in Ckbar.values) {
      if (contains_set(q, elem)) {
        sup += 1;
      }
    }

    if (sup >= supp) {
      for (var e in Ckbar.entries) {
        if (contains_set(e.value, elem)) {
          if (result.keys.contains(e.key)) {
            result[e.key].add(elem);
          } else {
            var list = [];
            list.add(elem);
            result[e.key] = list;
          }
        }
      }
    }
  }
  return result;
}

List<dynamic> LkSETM(Map<dynamic, dynamic> LkBar) {
  var result = [];
  for (var s in LkBar.values) {
    for (var elem in s) {
      if (contains_set(result, elem)) {
        continue;
      } else {
        result.add(elem);
      }
    }
  }
  return result;
}

List<dynamic> SETM(List<dynamic> I, Map<dynamic, dynamic> D, int minsup) {
  var result = [];
  print('Calcul des 1-itemsets fréquents ...');
  var L1 = itemset_1(I, D, minsup);
  print('L1 calculé.');
  var Ck_bar1 = Ck_init(D);
  var Lk_bar1 = Lk_init(Ck_bar1, L1);
  for (var chaine in L1) {
    result.add(chaine);
  }
  var L = [];
  var Ck = [];
  var Ckbar = {};
  var Lkbar = {};
  for (var e in Ck_bar1.entries) {
    Ckbar[e.key] = e.value;
  }
  for (var e in Lk_bar1.entries) {
    Lkbar[e.key] = e.value;
  }
  for (var l in L1) {
    L.add(l);
  }
  var i = 2;
  do {
    print('Génération de Ckbar$i ...');
    Ckbar = Ckbar_generatorSETM(Lkbar);
    print('Ckbar$i a été générée avec succès.');
    Lkbar.clear();
    print('Extraction des candidats ...');
    Ck = extract_ck(Ckbar);
    print('Extraction terminée.');
    print('Génération de Lkbar$i ...');
    Lkbar = LkBar_generator(Ck, Ckbar, minsup);
    print('Il reste ${Lkbar.length} transactions intéressantes.');
    L.clear();
    print('Extraction de Lk$i ...');
    L = LkSETM(Lkbar);
    print('Extraction terminée.');
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
      i += 1;
    }
  } while (L.isNotEmpty);
  return result;
}
