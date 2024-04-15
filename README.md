# Fast & Queryous - A "benchmarking tool"

Fast and Queryous is a benchmarking tool that allows you to compare the "performance" of different queries on a given
database. It is designed to be used with .NET.

Following is an example of the output of the tool:

```
+----------------------------------+----------+----------+----------+----------+----------+----------+-----------------+
| Name                             | Avg (ms) | Min (ms) | Max (ms) | 10% (ms) | 50% (ms) | 90% (ms) | QPS (queries/s) |
+----------------------------------+----------+----------+----------+----------+----------+----------+-----------------+
| Find Post by Id                  |     0.35 |     0.22 |    48.88 |     0.24 |     0.26 |     0.34 |        2,884.96 |
| Post Summary                     |     1.17 |     0.99 |    11.01 |     1.04 |     1.11 |     1.30 |          857.15 |
| Post Comments with Reactions     |     0.24 |     0.18 |     1.14 |     0.21 |     0.23 |     0.29 |        4,143.77 |
| Recent Posts with most Reactions |     1.08 |     0.82 |     3.05 |     0.87 |     1.10 |     1.22 |          928.65 |
+----------------------------------+----------+----------+----------+----------+----------+----------+-----------------+
```

## How to use it?

In the root directory there are following examples of the benchmark config files:

- `benchmark.mongodb.config.json`
- `benchmark.mssql.config.json`
- `benchmark.postgres.config.json`

And the directory `queries` contains the example queries for each database engine.

### Configuration

The tool uses JSON config files to define the database engine and the queries to be executed in the benchmark. The 
following is an example of a JSON config file:

```json
{
  "Name": "User Comment Query",
  "DatabaseType": "Postgres",
  "Queries": [
    {
      "Name": "Find Post by Id",
      "Query": "queries/find_post_by_id.postgres.sql"
    },
    {
      "Name": "Post Summary",
      "Query": "queries/post_summary.postgres.sql"
    },
    {
      "Name": "Post Comments with Reactions",
      "Query": "queries/post_comments_with_reactions.postgres.sql"
    },
    {
      "Name": "Recent Posts with Most Reactions",
      "Query": "queries/recent_posts_with_most_reactions.postgres.sql"
    }
  ]
}
```

Following is a list of the supported database engines:

- `Postgres`
- `MongoDB`
- `MSSQL`

The queries are defined in separate files to avoid the need to escape special characters in the JSON file. The queries
are defined in the following format:

```sql
SELECT * FROM Posts WHERE PostId = 22
```

Or in the case of using MongoDB as the database engine:

```json
{
  "find": "posts",
  "filter": {
    "_id": "6616840f5a60fa6e12f9528e"
  }
}
```

### Running the tool

```bash
dotnet run --project FastAndQueryous --connectionString "mongodb://localhost:27017" --databaseName blog --iterations 1000 --benchmarkConfig benchmarkConfig.mongodb.config.json
```

Following is a list of the available options:

- `connectionString`: The connection string to the database.
- `databaseName`: The name of the database (optional, only required for MongoDB).
- `iterations`: The number of iterations to run the benchmark for each query.
- `benchmarkConfig`: The path to the benchmark config file.
