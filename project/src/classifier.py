%pyspark
from pyspark.sql.types import (StructField, StringType,
                               IntegerType, StructType)
from pyspark.ml.feature import VectorAssembler
from pyspark.ml import Pipeline
from pyspark.ml.classification import RandomForestClassifier
from pyspark.ml.classification import GBTClassifier
from pyspark.ml.feature import StringIndexer, VectorIndexer
from pyspark.ml.evaluation import BinaryClassificationEvaluator
from pyspark.ml.evaluation import MulticlassClassificationEvaluator as MCeva

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

assembler = VectorAssembler(inputCols = ['day_of_week',
                            'time_of_day', 'net_flow'],
                            outputCol = 'features')
output = assembler.transform(df)
final_data = output.select('features', 'incid_in_effect')

featureIndexer = VectorIndexer(inputCol="features",
                               outputCol="indexedFeatures",
                               maxCategories=7).fit(final_data)

(train_data, test_data) = final_data.randomSplit([0.7, 0.3])

gb = GBTClassifier(labelCol = 'incid_in_effect',
                  featuresCol="indexedFeatures",
                  maxIter=10)

gb_pipeline = Pipeline(stages=[featureIndexer, gb])
gb_model = gb_pipeline.fit(train_data)
gb_pred = gb_model.transform(test_data)

eval_acc = MCeva(labelCol='incid_in_effect', metricName='accuracy')
eval_pre = MCeva(labelCol='incid_in_effect', metricName='weightedPrecision')
eval_rec = MCeva(labelCol='incid_in_effect', metricName='weightedRecall')
eval_f1 = MCeva(labelCol='incid_in_effect', metricName='f1')

gb_acc = eval_acc.evaluate(gb_pred)
gb_pre = eval_pre.evaluate(gb_pred)
gb_rec = eval_rec.evaluate(gb_pred)
gb_f1 = eval_f1.evaluate(gb_pred)

print("Gradient Boosting")
print("Accuracy {} \nPrecision {} \nRecall {} \nF1 {}".format(gb_acc, gb_pre, gb_rec, gb_f1))
# Gradient Boosting
# Accuracy 0.994977538549
# Precision 0.989980302216
# Recall 0.994977538549
# F1 0.992472629979

rf = RandomForestClassifier(featuresCol = 'indexedFeatures',
                          labelCol="incid_in_effect",
                          seed=100)

rf_pipeline = Pipeline(stages=[featureIndexer, rf])
rf_model = rf_pipeline.fit(train_data)
rf_pred = rf_model.transform(test_data)

eval_acc = MCeva(labelCol='incid_in_effect', metricName='accuracy')
eval_pre = MCeva(labelCol='incid_in_effect', metricName='weightedPrecision')
eval_rec = MCeva(labelCol='incid_in_effect', metricName='weightedRecall')
eval_f1 = MCeva(labelCol='incid_in_effect', metricName='f1')

rf_acc = eval_acc.evaluate(rf_pred)
rf_pre = eval_pre.evaluate(rf_pred)
rf_rec = eval_rec.evaluate(rf_pred)
rf_f1 = eval_f1.evaluate(rf_pred)

print("Random Forest")
print("Accuracy {} \nPrecision {} \nRecall {} \nF1 {}".format(rf_acc, rf_pre, rf_rec, rf_f1))
# Accuracy 0.995295698925
# Precision 0.990613528298
# Recall 0.995295698925
# F1 0.992949094043
