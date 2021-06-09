# Tea Subscription Service

### Endpoints

HTTP verbs  | Path                                       | Use
----------- | ------------------------------------------ |-------------------------------------------
POST        | /api/v1/customer_subscription              | Subscribe a customer to a tea subscription 
PATCH/PUT   | /api/v1/customer_subscription/:id          | Cancel a customer's tea subscription 
GET         | /api/v1/customer_subscription/:customer_id | See all a customer's subscriptions

##### Subscribe a Customer to a Tea Subscription

- POST `http://localhost:3000/api/v1/customer_subscription`, 
body:
```
json 
{
  "customer_id": "1",
  "subscription_id": "1",
}
```
response: 
```
{
    "data": {
        "id": "1",
        "type": "customer_subscription",
        "attributes": {
            "id": "1",
            "customer_id": "1"
            "subscription_id": "1"
        }
    }
}
```


##### Cancel a Customer's Tea Subscription 

##### See All a Customer's Subscriptions

### Database Schema 
![db_schema](https://user-images.githubusercontent.com/69491049/121395380-99fb2e80-c90f-11eb-85ef-89c7599bb4fa.png)

