using CommandLine;

namespace FastAndQueryous;

public static class Program
{
    private static HashSet<string> _supportedDatabaseTypes = new HashSet<string> { "mongodb", "mssql", "postgres" };
    
    public class Options
    {
        [Option('c', "connectionString", Required = true, HelpText = "Connection string")]
        public string ConnectionString { get; set; }
        
        [Option('d', "databaseName", Required = false, HelpText = "Database name")]
        public string DatabaseName { get; set; }
        
        [Option('i', "iterations", Required = true, HelpText = "Number of iterations")]
        public int Iterations { get; set; }
        
        [Option('b', "benchmarkConfig", Required = true, HelpText = "Benchmark configuration file")]
        public string BenchmarkConfig { get; set; }
    }
    private static DatabaseBenchmark CreateBenchmark(string connectionString, string? databaseName, string databaseType)
    {
        return databaseType.ToLower() switch
        {
            "mongodb" => new MongoDbBenchmark(connectionString, databaseName),
            "mssql" => new MssqlBenchmark(connectionString),
            "postgres" => new PostgresBenchmark(connectionString),
            _ => throw new ArgumentException($"Database type '{databaseType}' is not supported.")
        };
    }
    public static async Task Main(string[] args)
    {
        Parser.Default.ParseArguments<Options>(args).WithParsed(
            options =>
            {
                // Load the benchmark configuration
                var config = BenchmarkConfig.FromFile(options.BenchmarkConfig);
                
                // Validate the database type
                if (!_supportedDatabaseTypes.Contains(config.DatabaseType.ToLower()))
                {
                    Console.WriteLine($"Database type '{config.DatabaseType}' is not supported.");
                    return;
                }
                
                // Create a new benchmark
                var benchmark = CreateBenchmark(options.ConnectionString, options.DatabaseName, config.DatabaseType);
                
                // Measure the performance of each query
                BenchmarkResult[] results = benchmark.MeasureQuerySuitePerformanceAsync(config.NameQueryPairs, options.Iterations).Result;
                
                // Print the results
                benchmark.ShowResults(results);
            }
        );
    }
}