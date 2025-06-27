module Common {


  datatype Translation = Translation(x: int, y: int, z: int)
  datatype Atom   = Atom(atomLabel: string, sym: int, translation: Translation)

  datatype Vertex = Vertex(atomLabel: string, sym: int)
  datatype Bond = Bond(a: Atom, b: Atom)
  datatype Edge = Edge(u: Vertex, v: Vertex, shift: Translation)

  function Id(a: Atom): Vertex { Vertex(a.atomLabel, a.sym) }

  function AllNodeIds(atoms: seq<Atom>): set<Vertex> {
    set i | 0 <= i < |atoms| :: Id(atoms[i])
  }

  function Add  (u: Translation, v: Translation): Translation { Translation(u.x+v.x, u.y+v.y, u.z+v.z) }
  function Subtract (u: Translation, v: Translation): Translation { Translation(u.x-v.x, u.y-v.y, u.z-v.z) }
  function Negate (u: Translation): Translation { Translation(-u.x, -u.y, -u.z) }

  lemma IdentityVector()
    ensures forall v: Translation :: Add(v, Translation(0,0,0)) == v && Add(Translation(0,0,0),v) == v
  { }

  lemma InverseVector(v: Translation)
    ensures Add(v, Negate(v)) == Translation(0,0,0) && Add(Negate(v), v) == Translation(0,0,0)
  { }

  lemma AssociativeVector(u: Translation, v: Translation, w: Translation)
    ensures Add(u, Add(v, w)) == Add(Add(u, v), w)
  { }
}
