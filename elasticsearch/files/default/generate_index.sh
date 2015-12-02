### 日次で実行するスクリプト
### /home/ec2-user/generate_index.sh
month=`date -d '1 day' +%Y%m`
date=`date -d '1 day' +%Y%m%d`
curl -XPOST "http://localhost:9200/adrequest-${date}"
curl -X POST 'http://localhost:9200/_aliases' -d "{
     \"actions\" : [{
         \"add\" : {
            \"alias\": \"alias_adrequest-${month}\",
            \"index\": \"adrequest-${date}\"
         },
         \"add\" : {
            \"alias\": \"alias_adrequest-${date}\",
            \"index\": \"adrequest-${date}\"
         }
     }
 ]}"

