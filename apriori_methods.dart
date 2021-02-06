import 'utilities.dart';

List<dynamic> itemset_1(var I, Map<dynamic, dynamic> D, var minsupp) {
  var prev = [];
  for (var i in I) {
    var supp = 0; // support
    var item = <dynamic>{};
    for (var d in D.values) {
      if (isInList(d, i)) {
        supp++;
      }
    }
    if (supp >= minsupp) {
      item.add(i);
      prev.add(item);
    }
  }
  return prev;
}

List<dynamic> candidate_generation(List D) {
  var result = [];
  if (D.length == 1) {
    return null;
  }
  for (var i = 0; i < D.length; i++) {
    for (var j = i + 1; j < D.length; j++) {
      var elem = <dynamic>{};
      for (var chaine in D[i]) {
        elem.add(chaine);
      }
      for (var chaine in D[j]) {
        elem.add(chaine);
      }
      if (elem.length != D[i].length + 1) {
        continue;
      }
      if (result.contains(elem)) {
        continue;
      } else {
        result.add(elem);
      }
    }
  }
  return result;
}

List<dynamic> validate_candidate(
    var candidate, Map<dynamic, dynamic> D, var minsuppq) {
  var result = [];
  for (var i in candidate) {
    var supp = 0; // support
    for (var d in D.values) {
      if (isInListSet(d, i)) {
        supp++;
      }
    }
    if (isInListSet(result, i)) {
      continue;
    } else {
      if (supp >= minsuppq) {
        result.add(i);
      }
    }
  }
  return result;
}

List<dynamic> apriori_reel(var I, Map<dynamic, dynamic> D, var minsupp) {
  var result = [];
  print('Calcul des 1-itemsets fréquents ...');
  var L1 = itemset_1(I, D, minsupp);
  print('L1 calculé.');
  for (var chaine in L1) {
    result.add(chaine);
  }
  var L = L1;
  var i = 2;
  do {
    print('Génération des candidats ...');
    var C = candidate_generation(L);
    print('Ck$i calculé.');
    if (C == null || C.isEmpty) {
      break;
    }
    L.clear();
    print('Validation des candidats ...');
    L = validate_candidate(C, D, minsupp);
    print('Validation terminée.');
    if (L.isNotEmpty) {
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
