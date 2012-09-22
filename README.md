![Gremlin](https://github.com/tinkerpop/gremlin/raw/master/doc/images/gremlin-logo.png)

[Gremlin](http://gremlin.tinkerpop.com) is a domain specific language for traversing property graphs. This language has application in the areas of graph query, analysis, and manipulation. See the [Getting Started](https://github.com/tinkerpop/gremlin/wiki/Getting-Started) Gremlin wiki page for downloading and installing Gremlin.

Gremlin is an open source project maintained by [TinkerPop](http://tinkerpop.com).  Please join the Gremlin users group at http://groups.google.com/group/gremlin-users for all TinkerPop related discussions.

Unless otherwise noted, all samples are derived from the TinkerPop "toy" graph generated with: 

```text
gremlin> g = TinkerGraphFactory.createTinkerGraph()
```

This produces a hardcoded representation of the graph diagrammed [here](http://github.com/tinkerpop/blueprints/wiki/Property-Graph-Model).  

The documentation and samples presented here attempt to stay current with the most current and stable release of Gremlin (currently 2.1.0).  Please note that this is not the *official* Gremlin documentation.  The official documentation resides in the Gremlin [wiki](https://github.com/tinkerpop/gremlin/wiki).  


## Transform

Transform steps take an object and emit a transformation of it.

### _

Identity turns an arbitrary object into a "pipeline".

```text
gremlin> x = [1,2,3]
==>1
==>2
==>3
gremlin> x._().transform{it+1}
==>2
==>3
==>4
gremlin> x = g.E.has('weight', T.gt, 0.5f).toList()
==>e[10][4-created->5]
==>e[8][1-knows->4]
gremlin> x.inV
==>[StartPipe, InPipe]
==>[StartPipe, InPipe]
gremlin> x._().inV
==>v[5]
==>v[4]
```

### both

Get both adjacent vertices of the vertex, the in and the out.

```text
gremlin> v.both
==>v[1]
==>v[5]
==>v[3]
gremlin> v.both('knows')
==>v[1]
gremlin> v.both('knows', 'created')
==>v[1]
==>v[5]
==>v[3]
```

### bothE

Get both incoming and outgoing edges of the vertex.

```text
gremlin> v.bothE
==>e[8][1-knows->4]
==>e[10][4-created->5]
==>e[11][4-created->3]
gremlin> v.bothE('knows')
==>e[8][1-knows->4]
gremlin> v.bothE('knows', 'created')
==>e[8][1-knows->4]
==>e[10][4-created->5]
==>e[11][4-created->3]
```

### bothV

Get both incoming and outgoing vertices of the edge.

```text
gremlin> e = g.e(12)
==>e[12][6-created->3]
gremlin> e.outV
==>v[6]
gremlin> e.inV
==>v[3]
gremlin> e.bothV
==>v[6]
==>v[3]
```

### cap

Gets the side-effect of the pipe prior.  In other words, it emits the value of the previous step and not the values that flow through it.

```text
gremlin> g.V('lang', 'java').in('created').name.groupCount
==>marko
==>josh
==>peter
==>josh
gremlin> g.V('lang', 'java').in('created').name.groupCount.cap
==>{marko=1, peter=1, josh=2}
```

### E

The edge iterator for the graph.  Utilize this to iterate through all the edges in the graph.  Use with care on large graphs.

```text
gremlin> g.E
==>e[10][4-created->5]
==>e[7][1-knows->2]
==>e[9][1-created->3]
==>e[8][1-knows->4]
==>e[11][4-created->3]
==>e[12][6-created->3]
gremlin> g.E.weight
==>1.0
==>0.5
==>0.4
==>1.0
==>0.4
==>0.2
```

### gather

Collect all objects up to that step and process with the provided closure.

```text
gremlin> g.v(1).out
==>v[2]
==>v[4]
==>v[3]
gremlin> g.v(1).out.gather
==>[v[2], v[4], v[3]]
```

#### See Also

* [scatter](#transform/scatter)

### id

Gets the unique identifier of the element.  

```text
gremlin> v = g.V("name", "marko").next()
==>v[1]
gremlin> v.id
==>1
gremlin> g.v(1).id
==>1
```

### in

Gets the adjacent vertices to the vertex.

```text
gremlin> v = g.v(4)
==>v[4]
gremlin> v.inE.outV
==>v[1]
gremlin> v.in
==>v[1]
gremlin> v = g.v(3)
==>v[3]
gremlin> v.in("created")
==>v[1]
==>v[4]
==>v[6]
gremlin> v.inE("created").outV
==>v[1]
==>v[4]
==>v[6]
```

### inE

Gets the incoming edges of the vertex.

```text
gremlin> v = g.v(4)
==>v[4]
gremlin> v.inE.outV
==>v[1]
gremlin> v.in
==>v[1]
gremlin> v = g.v(3)
==>v[3]
gremlin> v.in("created")
==>v[1]
==>v[4]
==>v[6]
gremlin> v.inE("created").outV
==>v[1]
==>v[4]
==>v[6]
```

### inV

Get both incoming head vertex of the edge.

```text
gremlin> e = g.e(12)
==>e[12][6-created->3]
gremlin> e.outV
==>v[6]
gremlin> e.inV
==>v[3]
gremlin> e.bothV
==>v[6]
==>v[3]
```

### key

Get the property value of an element.  The property value can be obtained by simply appending the name to the end of the element or by referencing it as a Groovy map element with square brackets.  For best performance, drop down to the Blueprints API and use `getProperty(key)`.

```text
gremlin> v = g.v(3)
==>v[3]
gremlin> v.name
==>lop
gremlin> v['name']
==>lop
gremlin> x = 'name'
==>name
gremlin> v[x]
==>lop
gremlin> v.getProperty('name')
==>lop
```

### label

Gets the label of an edge.

```text
gremlin> g.v(6).outE.label
==>created
gremlin> g.v(1).outE.filter{it.label=='created'}
==>e[9][1-created->3]

// a more efficient approach to use of label
gremlin> g.v(1).outE.has('label','created')
==>e[9][1-created->3]
```

### map

Gets the property map of the graph element.

```text
gremlin> g.v(1).map
==>{name=marko, age=29}
gremlin> g.v(1).map()
==>name=marko
==>age=29
```

### memoize

Remembers a particular mapping from input to output.  Long or expensive expressions with no side effects can use this step to remember a mapping, which helps reduce load when previously processed objects are passed into it.

For situations where memoization may consume large amounts of RAM, consider using an embedded key-value store like [JDBM](http://code.google.com/p/jdbm2/) or some other persistent Map implementation.

```text
gremlin> g.V.out.out.memoize(1).name
==>ripple
==>lop
gremlin> g.V.out.as('here').out.memoize('here').name
==>ripple
==>lop
gremlin> m = [:]
gremlin> g.V.out.out.memoize(1,m).name
==>ripple
==>lop
```

### order

Order the items in the stream according to the closure if provided.  If no closure is provided, then a default sort order is used.

```text
gremlin> g.V.name.order
==>josh
==>lop
==>marko
==>peter
==>ripple
==>vadas
gremlin>  g.V.name.order{it.b <=> it.a}
==>vadas
==>ripple
==>peter
==>marko
==>lop
==>josh
gremlin> g.V.order{it.b.name <=> it.a.name}.out('knows')
==>v[2]
==>v[4]
```

### out

Gets the out adjacent vertices to the vertex.

```text
gremlin> v = g.v(1)
==>v[1]
gremlin> v.outE.inV
==>v[2]
==>v[4]
==>v[3]
gremlin> v.out
==>v[2]
==>v[4]
==>v[3]
gremlin> v.outE('knows').inV
==>v[2]
==>v[4]
gremlin> v.out('knows')
==>v[2]
==>v[4]
```

### outE

Gets the outgoing edges to the vertex.

```text
gremlin> v.outE.inV
==>v[2]
==>v[4]
==>v[3]
gremlin> v.out
==>v[2]
==>v[4]
==>v[3]
gremlin> v.outE('knows').inV
==>v[2]
==>v[4]
gremlin> v.out('knows')
==>v[2]
==>v[4]
```

### outV

Get both outgoing tail vertex of the edge.

```text
gremlin> e = g.e(12)
==>e[12][6-created->3]
gremlin> e.outV
==>v[6]
gremlin> e.inV
==>v[3]
gremlin> e.bothV
==>v[6]
==>v[3]
```

### path

Gets the path through the pipeline up to this point, where closures are post-processing for each object in the path.  If the path step is provided closures then, in a round robin fashion, the closures are evaluated over each object of the path and that post-processed path is returned.

```text
gremlin> g.v(1).out.path
==>[v[1], v[2]]
==>[v[1], v[4]]
==>[v[1], v[3]]
gremlin> g.v(1).out.path{it.id}
==>[1, 2]
==>[1, 4]
==>[1, 3]
gremlin> g.v(1).out.path{it.id}{it.name}
==>[1, vadas]
==>[1, josh]
==>[1, lop]
gremlin> g.v(1).outE.inV.name.path
==>[v[1], e[7][1-knows->2], v[2], vadas]
==>[v[1], e[8][1-knows->4], v[4], josh]
==>[v[1], e[9][1-created->3], v[3], lop]
```

### scatter

Unroll all objects in the iterable at that step. Gather/Scatter is good for breadth-first traversals where the gather closure filters out unwanted elements at the current radius.

```text
gremlin> g.v(1).out
==>v[2]
==>v[4]
==>v[3]
gremlin> g.v(1).out.gather{it[1..2]}
==>[v[4], v[3]]
gremlin> g.v(1).out.gather{it[1..2]}.scatter
==>v[4]
==>v[3]
```

### select

Select the named steps to emit after select with post-processing closures.

```text
gremlin> g.v(1).as('x').out('knows').as('y').select
==>[x:v[1], y:v[2]]
==>[x:v[1], y:v[4]]
gremlin> g.v(1).as('x').out('knows').as('y').select(["y"])
==>[y:v[2]]
==>[y:v[4]]
gremlin> g.v(1).as('x').out('knows').as('y').select(["y"]){it.name}
==>[y:vadas]
==>[y:josh]
gremlin>  g.v(1).as('x').out('knows').as('y').select{it.id}{it.name}
==>[x:1, y:vadas]
==>[x:1, y:josh]
```

### transform

Transform emits the result of a closure.

```text
gremlin> g.E.has('weight', T.gt, 0.5f).outV.map
==>32
==>29
gremlin> g.E.has('weight', T.gt, 0.5f).outV.age.transform{it+2}
==>34
==>31
```

### V

The vertex iterator for the graph.  Utilize this to iterate through all the vertices in the graph.  Use with care on large graphs unless used in combination with a key index lookup.

```text
gremlin> g.V
==>v[3]
==>v[2]
==>v[1]
==>v[6]
==>v[5]
==>v[4]
gremlin> g.V("name", "marko")
==>v[1]
gremlin> g.V("name", "marko").name
==>marko
```

#### See Also

* [gather](#transform/gather)

## Filter

Filter steps decide whether to allow an object to pass to the next step or not.

### [i]

A index filter that emits the particular indexed object.

```text
gremlin> g.V[0].name
==>lop
```

### [i..j]

A range filter that emits the objects within a range.

```text
gremlin> g.V[0..2].name
==>lop
==>vadas
==>marko
gremlin> g.V[0..<2].name
==>lop
==>vadas
```

### and

Takes a collection of pipes and emits incoming objects that are true for all of the pipes.

```text
gremlin> g.v(1).outE.and(_().has('weight', T.gt, 0.4f), _().has('weight', T.lt, 0.8f))
==>e[7][1-knows->2]
```

### back

Go back to the results from n-steps ago or go back to the results of a named step.

```text
gremlin> g.V.out('knows').has('age', T.gt, 30).back(2).age
==>29
gremlin> g.V.as('x').outE('knows').inV.has('age', T.gt, 30).back('x').age
==>29
```

### filter

Decide whether to allow an object to pass.  Return true from the closure to allow an object to pass.

```text
gremlin> g.V.filter{it.age > 29}.name
==>peter
==>josh
```

### has

Allows an element if it has a particular property.  Utilizes several options for comparisons on through `T`:

* T.gt - greater than 
* T.gte - greater than or equal to
* T.eq - equal to
* T.neq - not equal to
* T.lte - less than or equal to
* T.lt - less than

```text
gremlin> g.V.has("name", "marko").name
==>marko
gremlin> g.v(1).outE.has("weight", T.gte, 0.5f).weight
==>0.5
==>1.0
gremlin> g.V.has("age", null).name
==>lop
==>ripple
```

#### See Also

* [hasNot](#filter/hasNot)

### hasNot

Allows an element if it does not have a particular property.  Utilizes several options for comparisons on through `T`:

* T.gt - greater than 
* T.gte - greater than or equal to
* T.eq - equal to
* T.neq - not equal to
* T.lte - less than or equal to
* T.lt - less than

```text
gremlin> g.v(1).outE.hasNot("weight", T.eq, 0.5f).weight
==>1.0
==>0.4
gremlin> g.V.hasNot("age", null).name
==>vadas
==>marko
==>peter
==>josh
```

#### See Also

* [has](#filter/has)

### or

Takes a collection of pipes and emits incoming objects that are true for any of the pipes.

```text
gremlin> g.v(1).outE.or(_().has('id', T.eq, "9"), _().has('weight', T.lt, 0.6f))
==>e[7][1-knows->2]
==>e[9][1-created->3]
```

## Side Effect

Side Effect steps pass the object, but yield some kind of side effect while doing so.

### aggregate

Emits input, but adds input in collection, where provided closure processes input prior to insertion (greedy). In being "greedy", 'aggregate' will exhaust all the items that come to it from previous steps before emitting the next element.

```text
gremlin> x = []
gremlin> g.v(1).out.aggregate(x).next()
==>v[2]
gremlin> x
==>v[2]
==>v[4]
==>v[3]
```

#### See Also

* [store](#side-effect/store)
* [fill](#methods/fill)

### store

Emits input, but adds input to collection, where provided closure processes input prior to insertion (lazy).  In being "lazy", 'store' will keep element as they are being requested.

```text
gremlin> x = []
gremlin> g.v(1).out.store(x).next()
==>v[2]
gremlin> x
==>v[2]
```

#### See Also

* [aggregate](#side-effect//aggregate)
* [fill](#methods/fill)

## Branch

Branch steps decide which step to take.

## Methods

Methods represent functions that make it faster and easier to work with [Blueprints](http://blueprints.tinkerpop.com) and [Pipes](http://pipes.tinkerpop.com) APIs.  It is important to keep in mind that the full [Java API](http://download.oracle.com/javase/6/docs/api/) and [Groovy API](http://groovy.codehaus.org/groovy-jdk) are accessible from Gremlin.

### fill

Takes all the results in the pipeline and puts them into the provided collection.

```text
gremlin> m = []
gremlin> g.v(1).out.fill(m)
==>v[2]
==>v[4]
==>v[3]
gremlin> m
==>v[2]
==>v[4]
==>v[3]
```

#### See Also

* [aggregate](#side-effect/aggregate)
* [store](#side-effect/store)
