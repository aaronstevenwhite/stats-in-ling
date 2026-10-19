# Nettle linguistic-diversity input

The table used for the Poisson-rate lesson comes from Nettle (1999) through
Bodo Winter's [course-data repository](https://github.com/bodowinter/applied_statistics_book_data/blob/master/nettle_1999_climate.csv).
It contains 74 country rows with language counts, log-base-ten population and
area, and mean growing season.

The repository does not state a data license. Thus the preparation script writes
an ignored local copy rather than redistributing the source or its derivative:

```bash
Rscript scripts/data-grounding/prepare_nettle.R
```

The script pins the source checksum, checks the schema and support, and adds the
natural-log area required by a log-link offset. This conversion prevents the
base-ten `Area` column from being inserted unaltered as a Poisson offset.
