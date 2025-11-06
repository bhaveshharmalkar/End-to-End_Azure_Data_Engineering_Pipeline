### Steps to performed this project

1. Create overview diagram using drawio.
2. Create Azure account and resource group in it as `ecomm-live`.
3. Download dataset from [kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
4. Create a git repo.
5. Create sql and nosql database on filess.io
6. Create new notebook in google colab and upload `olist_order_payments_dataset.csv`. Then run `Data_Ingestion.ipynb` file.
7. Create Data Factory as `olist-ecomm-project-data-factory`.
8. Create pipeline as `data_ingestion_pipeline`
9. Copy Data single file from `HTTPS` github
10. Create storage account service as `olist1storageaccount`. Create directory as `bronze`, `silver`, `gold`.
11. Create Linked service as `http_github_linked_service` from Manage in Data Factory.
12. Create Linked service as `sql_github_linked_service` from Manage in Data Factory.
13. Create pipeline as `github_data_from_linked_service` and after that in relative url click on dynamic content and create new parameter as `csv_relative_url`.
14. Create sink as `csv_from_linked_service_to_sink` and file path to `bronze` storageaccount. After created then in file name click on dynamic content and create parameter as `file_name`. 
15. Create `ForEach` from Iteration & Conditionals
16. Create file called `loop_content.txt` with variable set for fetching and storing data.
17. Then go to `ForEach` setting tick `sequencial`.
18. Click on outside of the canvas and create new parameter as `for_each_input` set type as `Array` and paste `loop_content` text in Default value.
19. Click on `ForEach` go to settings then in Items click on Add dynamic content then select `for_each_input` click ok.
20. Click on `Edit` icon in `ForEach`. Then create `Copy data` from Move & Transform as `copy_data_inside_foreach` and in Source Dataset set as `github_data_from_linked_service` and in Sink Dataset as `csv_from_linked_service_to_sink`.
21. Now go to Source in the value of `csv_relative_url` click on dynamic content then select `ForEach` and in field set as `@item().csv_relative_url`. Then go to sink in the value of `file_name` click on dynamic content then select `ForEach` and in field set as `@item().file_name`.
22. Create copy data as `data_from_sql` and in Source Dataset click + search for sql and set name as `sql_data_from_filess` and set Linked service. 
23. Then go to Sink click + click ADLS Gen 2 -> Delimited Text set name and create new linked service as `ADLS_to_csv_from_sql` click create in file folder set as `bronze` and file name `olist_order_payments_dataset.csv`.
24. Click and validate and debug.
25. Create `Lookup` from General as `lookup_for_github_foreach` then upload our `loop_content.json` on github and from source dataset of lookup create new http -> json and add raw url of json file.
26. Go to `ForEach` -> Settings in items value click on dynamic content then click on `lookup_for_github_foreach` on then add value keyword like `@activity('lookup_for_github_foreach').output.value`.
27. Click on validate then debug.
28. Create Azure Databricks as `olist-ecomm-databricks`. Then go to resource -> Launch workspace and create basic recommended compute.

### Now we want to give permission to databricks to access the ADLS for that follow below steps
29. After that go to azure and search for `App Registrations` and name as `olist-app-reg-databricks-adls` and create it. We can see Application, Object and Directory ID.
30. Go to `Manage` -> `Certificates & Secrets` -> `New client Secret` name as `databricks-client-sec` and Add. We have `Value` secret as `cpE8Q~Rw0uSalRBrK~mAFfmO2KrrWMHAdruugb6C`
31. Then add python code that present in file file.py in newly created notebook in databricks and fill value such as application, directory id and storage account name and client secret value as service_credential_key.
32. Then go to storage account created early as `olist1storageaccount` then container > then created container as `olistcontainer` > Access Control > Add role assignment > Search for `Storage Blob Data Contributor` > Next > Tick on User,group or service principle then click on select members after that search for `olist-app-registration-databricks-adls` > Select.
29. After that create New notebook.

databricks-scope

```
spark.conf.set("fs.azure.account.auth.type.olist1storageaccount.dfs.core.windows.net", "OAuth")
spark.conf.set("fs.azure.account.oauth.provider.type.olist1storageaccount.dfs.core.windows.net", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id.olist1storageaccount.dfs.core.windows.net", "141a66f1-3d25-4714-a85e-d8d96052e4c5")
spark.conf.set("fs.azure.account.oauth2.client.secret.olist1storageaccount.dfs.core.windows.net", "cpE8Q~Rw0uSalRBrK~mAFfmO2KrrWMHAdruugb6C")
spark.conf.set("fs.azure.account.oauth2.client.endpoint.olist1storageaccount.dfs.core.windows.net", "https://login.microsoftonline.com/f902b2b3-c305-46c9-a89a-366a5f7266c1/oauth2/token")
```