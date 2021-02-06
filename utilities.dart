import 'package:collection/collection.dart';

List<dynamic> setItems(var D) {
  var I = [];
  for (var d in D.values) {
    for (var r in d) {
      if (I.contains(r)) {
        continue;
      } else {
        I.add(r);
      }
    }
  }
  return I;
}

List<dynamic> setTransac(var Rows) {
  var t = [];
  for (var i = 1; i < Rows.length; i++) {
    if (Rows[i][0].runtimeType == String) {
      continue;
    }
    if (Rows[i][2].runtimeType != String || Rows[i][2] == null) {
      continue;
    } else {
      var l = [];
      l.add(Rows[i][0]);
      l.add(Rows[i][2]);
      t.add(l);
    }
  }
  return t;
}

Map<dynamic, dynamic> setDatas(var transac) {
  print('Génération de la base de données transactionnelle ...');
  var M = {};
  var curr = transac[0][0];
  var cpt = 0;
  while (cpt < transac.length) {
    var itemset = [];
    while (transac[cpt][0] == curr) {
      itemset.add(transac[cpt][1]);
      cpt++;
      if (cpt == transac.length - 1) {
        break;
      }
    }
    M[curr] = itemset;
    if (cpt == transac.length - 1) {
      break;
    }
    curr = transac[cpt][0];
  }
  return M;
}

List<dynamic> setItemsTID(var D) {
  var I = [];
  for (var d in D) {
    var elem = <dynamic>{};
    elem.add(d);
    I.add(elem);
  }
  return I;
}

bool isInList(List L, var o) {
  for (var l in L) {
    if (l == o) {
      return true;
    }
  }
  return false;
}

bool isInListSet(List L, Set o) {
  var i = 0;
  for (var ch in o) {
    if (isInList(L, ch) == false) {
      return false;
    } else {
      i += 1;
    }
  }
  if (i == o.length) {
    return true;
  } else {
    return false;
  }
}

bool containsAllSets(List<dynamic> L, List<dynamic> T) {
  Function eq = const SetEquality().equals;
  var cpt = 0;
  for (var s in T) {
    for (var i = 0; i < L.length; i++) {
      if (eq(s, L[i])) {
        cpt += 1;
        break;
      }
    }
  }
  if (cpt == T.length) {
    return true;
  } else {
    return false;
  }
}

bool contains_set(var L, var S) {
  if (L.isEmpty) {
    return false;
  } else {
    Function Eq = const SetEquality().equals;
    for (var i = 0; i < L.length; i++) {
      if (Eq(L[i], S)) {
        return true;
      }
    }
    return false;
  }
}
