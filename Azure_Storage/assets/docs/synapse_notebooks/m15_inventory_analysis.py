# Synapse Spark (PySpark) - Inventory analysis starter
# Replace <account> and <container> accordingly; ensure MSI or linked service is configured.
from pyspark.sql.functions import col, count, sum as _sum

account = dbutils.widgets.get("account") if "dbutils" in globals() else "<account>"
container = dbutils.widgets.get("container") if "dbutils" in globals() else "inventory"

path = f"abfss://{container}@{account}.dfs.core.windows.net/"
df = spark.read.format("parquet").load(path)

print("Total blobs:", df.count())
df.groupBy("AccessTier").agg(count("*").alias("count"), _sum(col("Content-Length")).alias("bytes")).show()
