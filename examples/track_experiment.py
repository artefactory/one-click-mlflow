import os
import mlflow
import mlflow_config


# Log a parameter (key-value pair)
mlflow.log_param("bar", 42)

# Log a metric; metrics can be updated throughout the run
for k in range(6):
    mlflow.log_metric("foo", 2**k)
