module Test_Reconstruct {

  import opened Common
  import opened QuotientGraph

  method Main()
  {
    var vB  := Vertex("B", 1);
    var vN  := Vertex("N", 2);
    var V : set<Vertex> := { vB, vN };

    var E : set<Edge> := {
      Edge(vB, vN, Translation(0,0,0)),
      Edge(vB, vN, Translation(1,0,0)),
      Edge(vB, vN, Translation(1,1,0))
    };

    var atoms, bonds := ReconstructMolecule(V, E);

    assert BaseAtoms(V) ==
    { Atom("B",1,Translation(0,0,0)),
      Atom("N",2,Translation(0,0,0)) };

    assert TranslatedAtoms(E) ==
    { Atom("N",2,Translation(1,0,0)),
      Atom("N",2,Translation(1,1,0)) };

    assert |atoms| == 4;
    assert Atom("B",1,Translation(0,0,0)) in atoms;
    assert Atom("N",2,Translation(0,0,0)) in atoms;
    assert Atom("N",2,Translation(1,0,0)) in atoms;
    assert Atom("N",2,Translation(1,1,0)) in atoms;

    print "Reconstruct:  #atoms=", |atoms|, "  #bonds=", |bonds|, "\n";
  }
}
