![Gremlin](https://github.com/tinkerpop/gremlin/raw/master/doc/images/gremlin-logo.png)

[Gremlin](http://gremlin.tinkerpop.com) is a domain specific language for traversing property graphs. This language has application in the areas of graph query, analysis, and manipulation. See the [Getting Started](https://github.com/tinkerpop/gremlin/wiki/Getting-Started) Gremlin wiki page for downloading and installing Gremlin.

Gremlin is an open source project maintained by [TinkerPop](http://tinkerpop.com).  Please join the Gremlin users group at http://groups.google.com/group/gremlin-users for all TinkerPop related discussions.

Unless otherwise noted, all samples are derived from the TinkerPop "toy" graph generated with:

```groovy
gremlin> g = TinkerGraphFactory.createTinkerGraph()
```

This produces a hardcoded representation of the graph diagrammed [here](http://github.com/tinkerpop/blueprints/wiki/Property-Graph-Model).

## Transform

Transform steps take an object and emit a transformation of it.

### gather

Collect all objects up to that step and process with the provided closure.

```groovy
gremlin> g.v(1).out
==>v[2]
==>v[4]
==>v[3]
gremlin> g.v(1).out.gather
==>[v[2], v[4], v[3]]
```

### scatter

Unroll all objects in the iterable at that step. Gather/Scatter is good for breadth-first traversals where the gather closure filters out unwanted elements at the current radius.

```groovy
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

## Filter

Filter steps decide whether to allow an object to pass to the next step or not.

## Side Effect

Side Effect steps pass the object, but yield some kind of side effect while doing so.

### aggregate

Emits input, but adds input in collection, where provided closure processes input prior to insertion (greedy). In being "greedy", 'aggregate' will exhaust all the items that come to it from previous steps before emitting the next element.

```groovy
gremlin> x = []
gremlin> g.v(1).out.aggregate(x).next()
==>v[2]
gremlin> x
==>v[2]
==>v[4]
==>v[3]
```

#### See Also

* [store](#store)
* [fill](#fill)

### store

Emits input, but adds input to collection, where provided closure processes input prior to insertion (lazy).  In being "lazy", 'store' will keep element as they are being requested.

```groovy
gremlin> x = []
gremlin> g.v(1).out.store(x).next()
==>v[2]
gremlin> x
==>v[2]
```

#### See Also

* [aggregate](#aggregate)
* [fill](#fill)

## Branch

Branch steps decide which step to take.

## Methods

Methods represent functions that make it faster and easier to work with [Blueprints](http://blueprints.tinkerpop.com) and [Pipes](http://pipes.tinkerpop.com) APIs.  It is important to keep in mind that the full [Java API](http://download.oracle.com/javase/6/docs/api/) and [Groovy API](http://groovy.codehaus.org/groovy-jdk) are accessible from Gremlin.

### fill

Takes all the results in the pipeline and puts them into the provided collection.

```groovy
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

* [aggregate](#aggregate)
* [store](#store)
