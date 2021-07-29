#!/bin/bash -x

RUN_TIME_SECONDS=30

echo "GET http://localhost:8080/productpage" | vegeta attack -rate 10/1s -duration=${RUN_TIME_SECONDS}s | vegeta encode > stats.json

vegeta report stats.json

vegeta plot stats.json > plot.html
