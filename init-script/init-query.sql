CREATE DATABASE hikaru_ojima;
USE hikaru_ojima;

CREATE TABLE IF NOT EXISTS `hikaru_ojima`.`regex_test` (
    ip          STRING,
    member_id   STRING,
    time        STRING,
    request     STRING,
    url         STRING,
    status      STRING,
    size        STRING,
    referer     STRING,
    agent       STRING,
    x_analytics_user STRING,
    x_analytics_page STRING
)
PARTITIONED BY (dt STRING, domain STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe'
WITH SERDEPROPERTIES
(
    "input.regex" = '^([0-9\\.]+) - (-|[0-9]+) \\[[0-9]{2}/[a-zA-Z]+/[0-9]{4}:([0-9]{2}:[0-9]{2}:[0-9]{2})[^\\]]+\\] "([A-Z]+) ([^"]+) .*" ([0-9]+) ([0-9]+) "([^"]+)" "([^"]+)" ?(-|[^ ]+)? ?(-|[^ ]+)?$',
    "output.format.string" = "%1$s %2$s %3$s %4$s %5$s %6$s %7$s %8$s %9$s %10$s"
)
STORED AS TEXTFILE;

--S3にファイルを置く
--s3://analysistest/mikiokato/access_log

ALTER TABLE regex_test ADD PARTITION (dt='2014-11-09', domain='sakura_mixi_main') LOCATION 's3://analysistest/mikiokato/access_log/';

