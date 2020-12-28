# TCP To Blackhole Performance Test

This test measures the raw internal performance of the subject by configuring it to
simply discard incoming data. Most subject include a "blackhole" or "null" output
for this purposes.

## Design

1. Each subjects is configured to receive data over TCP and discard it.
2. The TCP producer is a separate instance to help ensure performance is not tainted.
3. Each subject is started and ran for 60 seconds.
4. [Performance data][performance_data] is collected and persisted to S3 for analysis.

## Results

```
$ bin/compare -t tcp_to_blackhole_performance

| Metric          | fluentbit | fluentd   | logstash  | vector    |
|:----------------|:----------|:----------|:----------|:----------|
| IO Thrpt (avg)  | 64.4MiB/s | 27.7MiB/s | 40.6MiB/s | 86MiB/s W |
| CPU sys (max)   | 4         | 3.5 W     | 6.1       | 6.5       |
| CPU usr (max)   | 53.2      | 50.8 W    | 91.5      | 96.5      |
| Load 1m (avg)   | 0.5 W     | 0.8       | 1.8       | 1.7       |
| Mem used (max)  | 614.8MiB  | 294MiB    | 742.5MiB  | 181MiB W  |
| Disk read (sum) | 9MiB      | 2.6MiB W  | 2.6MiB    | 2.6MiB    |
| Disk writ (sum) | 14.8MiB   | 13.7MiB   | 11.6MiB   | 11MiB W   |
| Net recv (sum)  | 3.9gib    | 1.7gib    | 2.4gib    | 5.1gib W  |
| Net send (sum)  | 7.9MiB    | 5.7MiB    | 2.6MiB    | 9MiB      |
| TCP estab (avg) | 663       | 664       | 665       | 664       |
| TCP sync (avg)  | 0         | 0         | 0         | 0         |
| TCP close (avg) | 1         | 2         | 7         | 4         |
-------------------------------------------------------------------------------------------------------------
W = winner
fluentbit = 1.1.0
fluentd = 3.3.0-1
logstash = 7.0.1
vector = 0.2.0-6-g434bed8
```

## Try It

```bash
bin/test -t tcp_to_blackhole_performance
```

## Resources

* [Setup][setup]
* [Usage][usage]
* [Development][development]
* [How it works][how_it_works]
* [Vector docs][docs]
* [Vector repo][repo]
* [Vector website][website]


[development]: /README.md#development
[docs]: https://docs.vector.dev
[how_it_works]: /README.md#how-it-works
[performance_data]: /README.md#performance-data
[repo]: https://github.com/timberio/vector
[setup]: /README.md#setup
[usage]: /README.md#usage
[website]: https://vector.dev
