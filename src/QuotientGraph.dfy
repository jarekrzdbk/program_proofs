module QuotientGraph {

  import opened Common

  method ConstructLQG(atoms: seq<Atom>, bonds: seq<Bond>) returns (V: set<Vertex>, E: set<Edge>)
    requires |atoms| > 0
    requires forall b :: b in bonds ==> b.a in atoms && b.b in atoms
    ensures forall e1,e2 | e1 in E && e2 in E && e1 != e2 ::
      !(e1.u == e2.v && e1.v == e2.u && e1.shift == Negate(e2.shift))
    ensures forall i | 0 <= i < |atoms| :: Id(atoms[i]) in V
    ensures V == AllNodeIds(atoms)
  {
    var allNodeIds := AllNodeIds(atoms);
    var visited : set<Vertex> := allNodeIds;
    var edges : set<Edge> := {};

    var atomIdx := 0;
    while atomIdx < |atoms|
      decreases |atoms| - atomIdx
      invariant forall e1,e2 | e1 in edges && e2 in edges && e1 != e2 ::
        !(e1.u == e2.v && e1.v == e2.u && e1.shift == Negate(e2.shift))
    {
      var currentAtom := atoms[atomIdx];
      atomIdx := atomIdx + 1;
      var currentNodeId := Id(currentAtom);

      var bondIdx := 0;
      while bondIdx < |bonds|
        decreases |bonds| - bondIdx
        invariant forall e1,e2 | e1 in edges && e2 in edges && e1 != e2 ::
          !(e1.u == e2.v && e1.v == e2.u && e1.shift == Negate(e2.shift))
      {
        var bond := bonds[bondIdx];
        bondIdx := bondIdx + 1;

        if bond.a == currentAtom {
          var neighborNodeId := Id(bond.b);
          var shift := Subtract(bond.b.translation, bond.a.translation);
          var edge := Edge(currentNodeId, neighborNodeId, shift);
          var invEdge := Edge(neighborNodeId, currentNodeId, Negate(shift));

          if edge !in edges && invEdge !in edges {
            edges := edges + {edge};
          }
        } else if bond.b == currentAtom {
          var neighborNodeId := Id(bond.a);
          var shift := Subtract(bond.a.translation, bond.b.translation);
          var edge := Edge(currentNodeId, neighborNodeId, shift);
          var invEdge := Edge(neighborNodeId, currentNodeId, Negate(shift));

          if edge !in edges && invEdge !in edges {
            edges := edges + {edge};
          }
        }
      }
    }

    V := visited;
    E := edges;
  }

  function BaseAtom(v: Vertex): Atom       { Atom(v.atomLabel, v.sym, Translation(0,0,0)) }
  function ShiftedAtom(e: Edge): Atom      { Atom(e.v.atomLabel, e.v.sym, e.shift) }
  function BaseAtoms(V: set<Vertex>): set<Atom> {
      set v | v in V :: BaseAtom(v)
  }
  function TranslatedAtoms(E: set<Edge>): set<Atom> {
      set e | e in E && e.shift != Translation(0,0,0) :: ShiftedAtom(e)
  }

  method ReconstructMolecule(V: set<Vertex>, E: set<Edge>)
         returns (atoms: set<Atom>, bonds: set<Bond>)
    requires forall e | e in E :: e.u in V && e.v in V
    ensures atoms == BaseAtoms(V) + TranslatedAtoms(E)
    ensures BaseAtoms(V) * TranslatedAtoms(E) == {}
    ensures |atoms| == |BaseAtoms(V)| + |TranslatedAtoms(E)|
  {
    var base       := BaseAtoms(V);
    var translated := TranslatedAtoms(E);
    atoms := base + translated;

    bonds := set e | e in E :: Bond(BaseAtom(e.u), ShiftedAtom(e));

    assert base * translated == {};
  }
}
