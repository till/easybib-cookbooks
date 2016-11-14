Data wrappers to access node data in a consistent way in chef11 and chef12

We currently access things like `node[deploy]` and `node[opsworks]` direct. This will change with chef12, so lets move all this into a wrapper to mitigate the overall impact.
