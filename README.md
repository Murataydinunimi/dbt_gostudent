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

#Run the docker compose
docker compose up -d

