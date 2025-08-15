# Synapse Spark (PySpark) - ADLS ACL demo
# Assumes filesystem 'research' exists and MSI is permitted.
from pyspark.sql import SparkSession

account = dbutils.widgets.get("account") if "dbutils" in globals() else "<account>"
fs = dbutils.widgets.get("fs") if "dbutils" in globals() else "research"

base = f"abfss://{fs}@{account}.dfs.core.windows.net/"
spark.range(0, 100).toDF("n").write.mode("overwrite").parquet(base + "cohorts/2025q1/sample.parquet")
df = spark.read.parquet(base + "cohorts/2025q1/sample.parquet")
df.show(5)
