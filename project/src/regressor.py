%pyspark
from pyspark.sql.types import (StructField, StringType,
                               IntegerType, StructType)
from pyspark.ml.feature import VectorAssembler
from pyspark.ml import Pipeline
from pyspark.ml.regression import RandomForestRegressor
from pyspark.ml.regression import GBTRegressor
from pyspark.ml.feature import VectorIndexer
from pyspark.ml.evaluation import RegressionEvaluator

data_schema  = [StructField('_c0', IntegerType(), True),
               StructField('0', IntegerType(), True),
               StructField('1', IntegerType(), True),
               StructField('2', IntegerType(), True),
               StructField('3', IntegerType(), True),
               StructField('4', StringType(), True),
               StructField('5', IntegerType(), True),
               StructField('6', IntegerType(), True)]
final_struc = StructType(fields = data_schema)

df = spark.read.csv("s3://rtbdaccessbysparkzeppelin/clean_input.csv", header=True, schema=final_struc)
df = df.withColumnRenamed('_c0', 'index') \
        .withColumnRenamed('0', 'station') \
        .withColumnRenamed('1', 'day_of_week') \
        .withColumnRenamed('2', 'time_of_day') \
        .withColumnRenamed('3', 'net_flow') \
        .withColumnRenamed('4', 'date') \
        .withColumnRenamed('5', 'num_of_incid') \
        .withColumnRenamed('6', 'incid_in_effect')

assembler = VectorAssembler(inputCols = ['station', 'day_of_week',
                            'time_of_day', 'num_of_incid',
                            'incid_in_effect'],
                            outputCol = 'features')
output = assembler.transform(df)
final_data = output.select('features', 'net_flow')

featureIndexer = VectorIndexer(inputCol="features",
                               outputCol="indexedFeatures",
                               maxCategories=7).fit(final_data)


(train_data, test_data) = final_data.randomSplit([0.8, 0.2])
rf = RandomForestRegressor(featuresCol = 'indexedFeatures',
                           labelCol="net_flow",
                           seed=23330)


pipeline = Pipeline(stages=[featureIndexer, rf])
rf_model = pipeline.fit(train_data)

pred_in = rf_model.transform(train_data)
pred_out = rf_model.transform(test_data)
evaluator = RegressionEvaluator(labelCol="net_flow",
                                predictionCol="prediction",
                                metricName="r2")
r2_in = evaluator.evaluate(pred_in)
r2_out = evaluator.evaluate(pred_out)

print(" In sample R2 {} \n Out of sample R2 {}".format(r2_in, r2_out))
#  In sample R2 0.111944545697
#  Out of sample R2 0.110338890963
