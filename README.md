gremlin-docs
============

Gremlin Documentation and Samples

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
gremlin> g.v(1).out.gather{it[1..2]}
==>[v[4], v[3]]
```

## Filter

## Side Effect

## Branch

## Methods

