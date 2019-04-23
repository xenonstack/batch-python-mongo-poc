from pymongo import MongoClient
client = MongoClient()
db = client['my_db']
collection = db.my_counter
current_count = 0
try:
    find = collection.find_one({"type": "counter"})
    current_count = int(find.get('count'))
    update = collection.update_one({"count": current_count, "type": "counter"},{
      '$set': {
        'count': current_count + 1
      }
    }, upsert=True)
except Exception as e:
    print(e)
    update = collection.insert_one({"count": 1, "type": "counter"})
find = collection.find_one({"type": "counter"})
print(find.get('count'))
