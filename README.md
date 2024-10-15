## INTRODUCTION
The dbt models in this projects run on a postgres image. The project also make us of a pgadmin image where we are more flexible in creating our transformations.
We have a medallion-like data architecture that follows the following structure:

![data_architecture](https://github.com/user-attachments/assets/9ac67c82-4989-49a9-aff0-6272231a4858)

1) The provided raw data will be ingested in postgres using a python script.
2) They then will be stored incrementally in data lake layer. Here we will have our raw historical data.
3) Models in the staging layer are not materialized. They are ephemeral. In this layer, we will only be doing small transformations like casting and renaming.
4) In Datawarehouse layer, we will have our clean dimension and fact tables. This is where we are building the main logic of our business requirements like joins and aggregations.
5) Lastly in the Datamart layer, we will have tables that feed the potential dashboards.

Each layer will have 4 folders. **Calls, costs, customers, revenues**

Each model in the datalake will start with the prefix **dl** as dbt documentation suggests. The same applies to other layers and they go like **stg, dwh, dm**.

This architecture will provide us a great deal of modularity and cleanliness. We will be easily guided through the models thanks to the folder structure and consistent naming convention.


## WARM UP

```bash
# Clone the repository
https://github.com/Murataydinunimi/dbt_gostudent.git

# Navigate into the project directory
cd dbt_gostudent
```
To avoid dependency problems, we need to run dbt in a separated environment for which we are going to create a virtual env.

```bash
#install virtualenv
pip install virtualenv

#Create the virtualenv
virtualenv venv

#Activate virtualenv
venv\Scripts\activate
```
We now need to install dbt and its specific connector with postgres.

```bash
pip install dbt-postgres==1.8.0
```


**For other libraries and their versions refer to the requirements.txt file**.

At this point, if we would want to create a dbt project from scratch, we would run **dbt init** and choose our respective connector.
However, a fully configured dbt project is already provided in this repo.

We have two files to configure in dbt. The first one is **profiles.yml** and the other is **project.yml**. The **profiles.yml** stores the connection details and credentials required to connect to different database systems or environments when running dbt commands.

![{812B5421-219A-44F0-844C-5BCE480AD15F}](https://github.com/user-attachments/assets/358704ee-95f0-462d-9e5a-7738e0d93c8c)

We have two profiles;  **dev** and **prod**. What we are basically saying here is that we would like to connect to the postgres with two different profiles named **dev** and **prod**. As later will be shown, there is a postgres container listening to us at port 5432 
with user, password and dbname as specified.

Then we have **project.yml** file which is our global configuration file for this project. It is project level config file where we have project specific configs that apply to the entire project.
This is how it looks like;
![{4EB5FEE1-1DA2-4B53-A5A4-7A79E1239110}](https://github.com/user-attachments/assets/a383f990-52df-479b-ae4a-6a18b91e2b71)

01_dl means the configurations for the models that are under 01_dl folder. They are materialized as incremental. They have **data_lake** and **dl** as tags, so we can run all of them using these shortcuts.
**full_refresh** is false because we never want to lose our historical data. All the models of this folder will be materialized under the **data_lake** schema (e.g., **db_name.data_lake.model_name**)

As said before, our dbt models will be running inside a postgres container and we will have another container, pgadmin, for interacting with our data in a more flexible way. Since we have more than one container, using docker-compose becomes highly useful.
It is a tool that simplifies defining and running multi-container Docker applications. When you create services with docker-compose, there is a common network created which further simplifies the data transfer between the services.
This is how a **docker-compose.yml** file looks like ;

![{F2C5DC8B-AAB6-410E-A081-5C3C4771E4FD}](https://github.com/user-attachments/assets/0886964a-15fd-4623-b0a5-c8f485f50471)

Under the services keyword, we specify the images that we would like pull and build our containers over. We specify the ports where the containers will be listening to us along with the passwords, users etc.



## HOW TO RUN THE PROJECT ?

Once the repo is cloned, we are ready to pull our images and build the containers.

```bash
#Run the docker compose
docker compose up -d
```
When the containers are ready, the postgre container will be initialized with the **sql_commands.sql** file that we have under the init folder. 
This sql file basically creates the tables for the raw layer.

Once the tables are created, we are ready to ingest the raw data into the tables using a python script **load_data.py** that is found in root directory. Notice that raw data are under the **data** folder.

```bash
#Load the tables
python load_data.py
```
We can now go to pgadmin in  **http://localhost:8888/**. To do it, you need to create a new server. Give a name to the server and enter the connection details as 

![{5BA8FA3F-AC89-4D2B-B133-BCE416D969E4}](https://github.com/user-attachments/assets/cf27c1c7-f8bb-4c39-bf6f-22858513ec03)

where password is **postgres** as well.

![{3A50678D-8E9A-438B-A6E3-469A406062FD}](https://github.com/user-attachments/assets/c98148f8-d1be-4fa1-94e2-8363937c36fa)

Our tables are now available in raw schema waiting for our dbt transformations to be applied!


```bash
#cd into dbt directory
cd gostudent_dbt

#set a user name to integrate into your development environment name
#mine
set user=murat

```
Run the dbt models

```bash
#run dbt models
dbt run --profiles-dir .
```

![{B80B3471-BD9A-4867-BD35-1E3B6EB6F55C}](https://github.com/user-attachments/assets/56315ff6-af88-4227-8df3-445fa3f7e2be)

All of our models are successfully created. Notice that our naming convention is different for each layer. It is specifically 

**environment_name_user_schema_name_table_name**. Example --> **dev_murat_data_warehouse.dim_calls_range_mapping** or **dev_murat_data_mart.dm_ser_per_source**

## UNDERSTAND THE DATA TRANSFORMATIONS

Here is our beautiful dbt lineage graph showing how our transformations move around.
Click on it to see better.

![{00228C92-F5D2-4BB6-8F88-C7D75ADF932F}](https://github.com/user-attachments/assets/f4b07e32-3cfe-474b-af51-9e2765c2d2d0)

**We have 45 transformations done in dbt included the ephemeral models!!** 

**Since all the datalakes creation follow the same pattern, we are using a macro get_datalake_model for not DRY**

![{CFFD4C09-5F42-4AF0-B128-50F6BD373C99}](https://github.com/user-attachments/assets/54a994ad-c13a-4f7b-8ca8-6eaad7ee1740)


For each dataset provided in the raw, we have a datalake, staging and datawarehouse. We have 7 datamarts.

![{8EA31FBD-60B9-4034-B1F9-8C6EADEF079D}](https://github.com/user-attachments/assets/999aaf68-1227-4a7d-878c-dffdf65b074d)

And they answer some business questions like

1) dm_cac_per_period shows the **customer acquisition cost** for each period available in the data like **2022-11,2022-12** etc.
2) dm_cac_per_source (higher granularity) shows the **customer acquisition cost** for each marketing source, **Google, Meta, Other**, and period
3) dm_ser_per_period shows the **sales efficiency ratio** for each period.
4) dm_ser_per_source (higher granularity) shows the **sales efficiency ratio** per each source and period
5) dm_lead_conversion_per_period shows the **lead conversion** per period.
6) dm_lead_conversion_per_source (higher granularity) shows the **lead conversion** per period and source.
7) dm_calls_conversion shows some KPIs on how calls usings **>30 minutes succesful call and call attempts** info affect the lead conversion.

Given all these datamarts, we can answer;
1) Which market has the lowest **cac** ? --> For all the periods, it is **other**.
2) What is the lowest **cac** value period ? --> 2023-01.
3) What is the most sales effective channel ( **Sales Efficency Ratio**) ? --> For all the periods, it is **other**
4) What is the highest **ser** value period ? --> 2023-02.
5) How profitable is this investment ? The **ser** for almost all the periods is over 3 which is sign of an extremely good sales. Also, the **cac** is for almost all the periods with the exception of 2022-11 has way lower values than the average **customer lifetime value**. **THIS INVESTMENT IS GREAT!**
6) When we got the highest lead conversion ? --> 2023-01.
7) Which channel provided the highest lead conversion ? --> For all the periods, it is **google**
8) Do call attempts and number of successful conversations having more than 30min affect the leads ? Absolutely, but it is more like polynomial pattern.
9) How would you assess the development of the quality of leads in terms of likelihood of becoming a customer ? I would train the callers in terms of call_attempts, having successful conversations longer than 30min, and that they being from a known city. Message length did not seem to be important for me.


I now would like to show you how specifically a given dm is created. Insıde the dbt project, run


```bash
#Create dbt docs
dbt docs generate

#Serve the docs
dbt docs serve
```
This will create a localhost webserver where you can interact visually with your dbt models and documentation. Here is a piece of our lineage graph filtered for **dm_ser_per_source** model.


![{F26B8BA1-4486-4590-8421-61B30607DFCA}](https://github.com/user-attachments/assets/877febf3-1f8b-4527-8c37-04364fc36359)


As you can see, for each raw data provided we have a table.


![{9252C60E-5145-48D6-BF0B-A29FE85927C1}](https://github.com/user-attachments/assets/bfa8c6f5-5147-4720-ad25-bd2538fc503f)


I used the raw layer as sources. Sources are abstractions on top of our input tables. Unlike seeds, they are already ingested in dwh.
Since we are doing a small project with small datasets, our data could be seen as seeds too but we assume that they arrive in huge amounts at pre-scheduled intervals, so they are **sources**.


Then for each row, we have an incremental datalake.

![{0F122EB3-3016-43D8-8A6E-ECCEF1BB10AF}](https://github.com/user-attachments/assets/ae74f11e-66dd-4564-8711-aac4dd1e4c57)

Then for each dl model, we have a stg model with small transformations.

![{071B8E75-D7FF-46F0-A985-8645AA77A94A}](https://github.com/user-attachments/assets/faf63bb1-acc0-4440-8467-4029c3510149)


For each stg, we have a dwh model.

![{0355C1CA-AD17-43F7-BB49-06758AD4B202}](https://github.com/user-attachments/assets/d7c43e17-8815-471a-95cb-dac32758680b)


Notice in the **lineage graph** that **dim_clv**, **dim_lead**, **dim_customers** all together feed **fct_revenues_per_source** which then together with **fct_mkt_source_per_source** feed the dm report.


## HOW CI/CD WORK?


Since we understood how the projects works, how it is structured, how our transformations are done,  we can now move to the next stage where we continuously integrate our new models and deploy them.

I used **github actions** to do it. It is in **.github\workflows\dbt_cicd.yml**.

We have a pipeline that triggered on a **push** to dev or **pull request** to dev.

The actions work in the following order
**FIRST STEP**
  1) start pulling the same postgres image we used locally.
  2)  Install the python dependencies that we use locally.
  3)  Run the sql initialization scripts to create the tables in postgres.
  4)  Load tables with python.
  5)  Run dbt debug
  6)  Run dbt models
  7)  Run dbt test

**SECOND STEP**

If only the previous step is concluded successfully, we have a merge to the master branch from dev. Our new code is merged to the master.

**THIRD STEP***

If only the previous step is concluded successfully, we can run our production dbt code.

  1) Create the postgres container.
  2) Install python dependencies.
  3) Run initialization script.
  4) Load Tables.
  5) Run dbt build ( both run and test

## HOW IT WORKS?   BONUS QUESTION


```bash
#Create a feature branch
git checkout -b feature/my_cicd
```

Do your modifications.

```bash
#Add the changes to staging.
git add .

#commit changes
git commit -m "my modifications"

#push the changes

git push origin feature/my_cicd
```

Now go to github and create a PR to the dev. When you merge the PR, the actions will get triggered.

![{76B6D57F-A538-4585-BA26-B175257B7437}](https://github.com/user-attachments/assets/0c843c5f-9ed5-4c82-ae43-45392efa3d12)


Our code is nicely integrated, pipeline is triggered and completed successfully. Notice that tables created in dev and prod have different prefixes. They start with **dev** if they are in dev, **prod** otherwise.


## EXPLAIN DATA AND ML PIPELINE DIAGRAMS. BONUS QUESTION 2.

The diagrams I drew can be found in the **architectures** folder. 

1) **High level data pipeline**

![{5875F762-E704-4606-B56B-2A19B00553C3}](https://github.com/user-attachments/assets/8f3bbe78-54c1-4d01-8cce-db5c2257ac64)

Our sources arrive at different formats and ingested in the datalake. Using Apache airflow we ingested them in postgres.  Then again using other Apache transformation dags, we run dbt models. 
The resulting models are re-uploaded to the postgres. The transformations can then be used for BI consumption in Apache superset(preset) which is open source, synchronized and nicely integrated with dbt

2) **Draw an Architecture Daigram for Deploying a ML model via API**

There are many ways to deploy a ML model with API. I studided many of them and thought that the one that google docs suggest might be a robust one.

   ![{DAECC69A-28D1-4CAF-9311-1B17B5B34ED1}](https://github.com/user-attachments/assets/cd855679-0fd3-4841-8ecb-c31db0ace941)

We have a feature db which is a centralized repo  that stores, manages, and serves machine learning features for consistent use in model training and real-time predictions, typically created and maintained by data scientists and engineers.
In our case, it has an api through which it provides data.
In the **dev** environment,
1) the data analyst get the data from feature db in an offline mode in batches and do data analysis.
2) We then do iterative model experimentation like trying different algorithms, models, data, different hyperparameters etc.
3) When things look promising, we push our code to the source repository. Here **Continuous Integration** start and packages our pipeline 
4) We deploy the model to the prod.
5) We again get the data from feature db, we do a series of steps like data validation, preparation, model training etc.
6) We put the trained model in model registery and deploy it through **REST API**.
7) When there is a post/predict request to the REST API, it gets the data in real time from feature db, does whatever the model needs to do and responds back to the client.

Thank you!
   









