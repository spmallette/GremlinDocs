gremlin-docs
============

Gremlin is a domain specific language for traversing property graphs. Gremlin makes use of Pipes to perform complex graph traversals. This language has application in the areas of graph query, analysis, and manipulation. Connectors, provided by Blueprints, exist for the following graph management systems:

Unless otherwise noted, all samples are derived from the TinkerPop "toy" graph generated with:

```groovy
gremlin> g = TinkerGraphFactory.createTinkerGraph()
```

This produces a hardcoded representation of the graph diagrammed [here](https://github.com/tinkerpop/blueprints/wiki/Property-Graph-Model).

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

## Side Effect

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

### store

Emits input, but adds input to collection, where provided closure processes input prior to insertion (lazy).  In being "lazy", 'store' will keep element as they are being requested.

```groovy
gremlin> x = []
gremlin> g.v(1).out.store(x).next()
==>v[2]
gremlin> x
==>v[2]
```

## Branch

## Methods

### fill

Takes all the results in the pipeline and puts them into the provided collection.
