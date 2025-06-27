module Test_Construct {

  import opened Common
  import opened QuotientGraph

  lemma TestCaseNodeIdProperties(atoms: seq<Atom>)
    requires |atoms| == 4
    requires atoms[0] == Atom("B",1, Translation(0,0,0))
    requires atoms[1] == Atom("N",2, Translation(0,0,0))
    requires atoms[2] == Atom("N",2, Translation(1,0,0))
    requires atoms[3] == Atom("N",2, Translation(1,1,0))
    ensures AllNodeIds(atoms) == {Vertex("B", 1), Vertex("N", 2)}
    ensures |AllNodeIds(atoms)| == 2
  {
    assert AllNodeIds(atoms) == {Vertex("B", 1), Vertex("N", 2)} by {
      assert Id(atoms[0]) == Vertex("B", 1);
      assert Id(atoms[1]) == Vertex("N", 2);
      assert Id(atoms[2]) == Vertex("N", 2);
      assert Id(atoms[3]) == Vertex("N", 2);
    }
  }

  method count_vertices(xs: set<Vertex>) returns (z:int) {
    var count := 0;
    var c := xs;
    while c != {}
    decreases c
    invariant c <= xs
    {
        var x :| x in c;
        print "Test ", count, " vertex ", x, "\n";
        c := c - {x};
        count := count + 1;
    }
    return count;
  }

  method count_edges(edges: set<Edge>) returns (z:int) {
    var count := 0;
    var c := edges;
    while c != {}
    decreases c
    invariant c <= edges
    {
        var x :| x in c;
        print "Test ", count, " edge ", x, "\n";
        c := c - {x};
        count := count + 1;
    }
    return count;
  }

  method Main()
  {
    var B0 := Atom("B",1, Translation(0,0,0));
    var N00 := Atom("N",2, Translation(0,0,0));
    var N10 := Atom("N",2, Translation(1,0,0));
    var N11 := Atom("N",2, Translation(1,1,0));

    var atoms := [B0, N00, N10, N11];
    var bonds := [Bond(B0,N00), Bond(B0,N10), Bond(B0,N11)];

    var V, E := ConstructLQG(atoms, bonds);

    print "Results:\n";
    print "|V| = ", |V|, " unique vertices\n";
    print "|E| = ", |E|, " edges\n";

    TestCaseNodeIdProperties(atoms);
    assert |V| == 2;
    assert Vertex("B", 1) in V;
    assert Vertex("N", 2) in V;

    var vertex_count := count_vertices(V);
    print "Vertex count: ", vertex_count, "\n";
    var edges_count := count_edges(E);
    print "Edges count: ", edges_count, "\n";
  }
}
