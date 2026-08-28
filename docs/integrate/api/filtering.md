# Filtering Queries

Many of Keystone's API endpoints are designed to return a list of records (e.g., `/users/teams/`).
By default, these endpoints paginate all records available to the current user.
Query parameters provide a mechanism to refine the returned records according to user defined filters.

Query parameters with a preceding underscore (`_limit`, `_offset`, `_order`, `_search`) are used to perform high level
data operations, including pagination, sorting, and searching.
Parameters without an underscore are used to apply filters on individual record fields, allowing users to construct
complex, data driven queries.

## Paginating Responses

Keystone uses limit/offset style pagination.

```
.../endpoint/?_limit=100&_offset=400
```

Both pagination arguments are optional and default to the values below.
To prevent excessive request sizes, the API enforces an upper limit of 1,000 records per response.

| Query Argument | Default Value      |
|----------------|--------------------|
| `_limit`       | `100`              |
| `_offset`      | `0` (First record) |

## Ordering Responses

The `_order` parameter is used to sort records by one or more fields.

```
.../endpoint/?_order=field1
.../endpoint/?_order=field1,field2
```

To sort in descending order, a hyphen is prefixed to the field name.
In the following example, `field1` is sorted in ascending order followed by `field2` in descending order.

```bash
.../endpoint/?_order=field1,-field2
```

## Searching Records

The `_search` parameter provides support for semantic text searching.
When provided, the API will compare the search value against each record's text fields and return any case-insensitive
partial matches.

```bash
.../endpoint/?_search=user%20search%20input
```

## Filtering Records

Query parameters allow users to filter records by the record content.
In the following example, returned records are limited to those where the `example` field equals `100`:

```
.../endpoint?example=100
```

More advanced filtering is achieved by adding filter expressions.
Query filters are specified using a double underscore (`__`) followed by a filter expression.
In the following example the API will return records where the `example` field is greater than `50` but less than `150`:

```
.../endpoint?example__gt=50&example__lt=150
```

The available filter expressions depend on a field's data type and are summarized in the tables below.

### General Filters

The following filters are available for all data types.

| Filter   | Description                                                         | Example               |
|----------|---------------------------------------------------------------------|-----------------------|
| (none)   | Filter where the field matches a value exactly                      | `field=value`         |
| `not_eq` | Filter where the field does not match a value exactly               | `field__not_eq=value` |
| `in`     | Filter where the field is in a comma-separated list of values       | `field__in=1,2,3`     |
| `not_in` | Filter where the field is *not* in a comma-separated list of values | `field__not_in=1,2,3` |
| `isnull` | Filter where the field is None                                      | `field__isnull=true`  |

### Numeric Filters

The following filters are available for numerical data such as floats and integers.

| Filter | Description                                                        | Example          |
|--------|--------------------------------------------------------------------|------------------|
| `lt`   | Filter where the field is less than the given value                | `field__lt=100`  |
| `lte`  | Filter where the field is less than or equal to the given value    | `field__lte=100` |
| `gt`   | Filter where the field is greater than the given value             | `field__gt=100`  |
| `gte`  | Filter where the field is greater than or equal to the given value | `field__gte=100` |

### String Filters

The following filters are available for text and character values.

| Filter           | Description                                                 | Example                         |
|------------------|-------------------------------------------------------------|---------------------------------|
| `contains`       | Filter where the field contains the given text              | `field__contains=subtext`       |
| `not_contains`   | Filter where the field does *not* contain the given text    | `field__not_contains=subtext`   |
| `startswith`     | Filter where the field starts with the given text           | `field__startswith=subtext`     |
| `not_startswith` | Filter where the field does *not* start with the given text | `field__not_startswith=subtext` |
| `endswith`       | Filter where the field ends with the given text             | `field__endswith=subtext`       |
| `not_endswith`   | Filter where the field does *not* end with the given text   | `field__not_endswith=subtext`   |

### Date Filters

The following filters are available for date and datetime values in ISO-8601 format.

| Filter     | Description                                                       | Example                 |
|------------|-------------------------------------------------------------------|-------------------------|
| `year`     | Whether the date value matches the given year                     | `field__year=2022`      |
| `month`    | Whether the date value matches the given month                    | `field__month=12`       |
| `day`      | Whether the date value matches the given day                      | `field__day=25`         |
| `week`     | Whether the date value falls on the given week of the month       | `field__week=52`        |
| `week_day` | Whether the date value falls on the given day of the week         | `field__week_day=1`     |
| `lt`       | Filter where the field is less than the given date                | `field__lt=2020-01-22`  |
| `lte`      | Filter where the field is less than or equal to the given date    | `field__lte=2020-01-22` |
| `gt`       | Filter where the field is greater than the given date             | `field__gt=2020-01-22`  |
| `gte`      | Filter where the field is greater than or equal to the given date | `field__gte=2020-01-22` |

### Time Filters

The following filters are available for time and datetime values in ISO-8601 format.

| Filter   | Description                                                       | Example               |
|----------|-------------------------------------------------------------------|-----------------------|
| `hour`   | Whether the time value matches the given hour                     | `field__hour=8`       |
| `minute` | Whether the time value matches the given minute                   | `field__minute=30`    |
| `second` | Whether the time value matches the given second                   | `field__second=45`    |
| `lt`     | Filter where the field is less than the given time                | `field__lt=19:20:15`  |
| `lte`    | Filter where the field is less than or equal to the given time    | `field__lte=19:20:15` |
| `gt`     | Filter where the field is greater than the given time             | `field__gt=19:20:15`  |
| `gte`    | Filter where the field is greater than or equal to the given time | `field__gte=19:20:15` |
