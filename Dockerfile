FROM node:12-alpine as node

RUN npm install -g lighthouse

FROM alpine:latest

ENV HOSTS_HOME="https://www.douglas.de,https://www.douglas.at"
ENV HOSTS_PRODUCT="https://www.douglas.ch/de/p/hugo-boss-boss-bottled-eau-de-toilette/1010209304,https://www.douglas.de/Sale-Top-Angebote-Hugo-Boss-Boss-Bottled_product_258400.html"
ENV HOSTS_SEARCH="https://www.douglas.ch/de/search?q=lippenstift:relevance:price:20+-+49.90+CHF:classificationClassName:Lippenstift,https://www.douglas.de/search.html?filterClassifications=Lippenstift&filterPrice=20+-+50&query=lippenstift"
ENV HOSTS_BRAND="https://www.douglas.ch/de/b/hugo-boss/b0102,https://www.douglas.de/Hugo-Boss/index_b0102.html"
ENV INFLUX_HOST=influx-local
ENV INFLUX_PORT=8080

COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
    && echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
    && apk add --no-cache \
    chromium~=79.0 \
    curl \
    jq \
    nodejs \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk%

CMD IFS=","; for host in $HOSTS_HOME; do \
        echo ""; \
        echo "$host - Desktop"; \
        echo "$host - Desktop"; \
        /usr/bin/node /usr/local/lib/node_modules/lighthouse/lighthouse-cli/index.js \
            https://douglas.de --no-enable-error-reporting \
            --chrome-flags="--headless --no-sandbox" --only-categories="performance" --emulated-form-factor="desktop" --max-wait-for-load=“1000” --output json --quiet > response.json;\
            echo -n "performance,url=$(echo $host |sed 's/=/\\=/g'),device=desktop,category=home " > data; \
            echo -n "performance-score=" >> data; \
            val=$(cat response.json | jq -r '[.categories.performance][].score'); echo -n $val >> data; \
            echo -n ",first-contentful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-contentful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",first-meaningful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-meaningful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",time-to-interactive=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "interactive")).numericValue'); echo -n $val >> data; \
            echo -n ",first-cpu-idle=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-cpu-idle")).numericValue'); echo -n $val >> data; \
            echo -n ",max-potential-first-input-delay=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "max-potential-fid")).numericValue'); echo -n $val >> data; \
            cat data; \
            curl -i -XPOST "http://$INFLUX_HOST:$INFLUX_PORT/write?db=lighthouse" --data-binary @data; \
        echo ""; \
        echo "$host - Mobile"; \
        echo "$host - Mobile"; \
        /usr/bin/node /usr/local/lib/node_modules/lighthouse/lighthouse-cli/index.js \
            $host --no-enable-error-reporting \
            --chrome-flags="--headless --no-sandbox" --only-categories="performance" --emulated-form-factor="mobile" --max-wait-for-load=“1000” --output json --quiet > response.json;\
            echo -n "performance,url=$(echo $host |sed 's/=/\\=/g'),device=mobile,category=home " > data; \
            echo -n "performance-score=" >> data; \
            val=$(cat response.json | jq -r '[.categories.performance][].score'); echo -n $val >> data; \
            echo -n ",first-contentful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-contentful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",first-meaningful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-meaningful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",time-to-interactive=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "interactive")).numericValue'); echo -n $val >> data; \
            echo -n ",first-cpu-idle=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-cpu-idle")).numericValue'); echo -n $val >> data; \
            echo -n ",max-potential-first-input-delay=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "max-potential-fid")).numericValue'); echo -n $val >> data; \
            cat data; \
            curl -i -XPOST "http://$INFLUX_HOST:$INFLUX_PORT/write?db=lighthouse" --data-binary @data; \
     done; \
     for host in $HOSTS_PRODUCT; do \
        echo ""; \
        echo "$host - Desktop"; \
        echo "$host - Desktop"; \
        /usr/bin/node /usr/local/lib/node_modules/lighthouse/lighthouse-cli/index.js \
            $host --no-enable-error-reporting \
            --chrome-flags="--headless --no-sandbox" --only-categories="performance" --emulated-form-factor="desktop" --max-wait-for-load=“1000” --output json --quiet > response.json;\
            echo -n "performance,url=$(echo $host |sed 's/=/\\=/g'),device=desktop,category=product " > data; \
            echo -n "performance-score=" >> data; \
            val=$(cat response.json | jq -r '[.categories.performance][].score'); echo -n $val >> data; \
            echo -n ",first-contentful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-contentful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",first-meaningful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-meaningful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",time-to-interactive=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "interactive")).numericValue'); echo -n $val >> data; \
            echo -n ",first-cpu-idle=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-cpu-idle")).numericValue'); echo -n $val >> data; \
            echo -n ",max-potential-first-input-delay=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "max-potential-fid")).numericValue'); echo -n $val >> data; \
            cat data; \
            curl -i -XPOST "http://$INFLUX_HOST:$INFLUX_PORT/write?db=lighthouse" --data-binary @data; \
        echo ""; \
        echo "$host - Mobile"; \
        echo "$host - Mobile"; \
        /usr/bin/node /usr/local/lib/node_modules/lighthouse/lighthouse-cli/index.js \
            $host --no-enable-error-reporting \
            --chrome-flags="--headless --no-sandbox" --only-categories="performance" --emulated-form-factor="mobile" --max-wait-for-load=“1000” --output json --quiet > response.json;\
            echo -n "performance,url=$(echo $host |sed 's/=/\\=/g'),device=mobile,category=product " > data; \
            echo -n "performance-score=" >> data; \
            val=$(cat response.json | jq -r '[.categories.performance][].score'); echo -n $val >> data; \
            echo -n ",first-contentful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-contentful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",first-meaningful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-meaningful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",time-to-interactive=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "interactive")).numericValue'); echo -n $val >> data; \
            echo -n ",first-cpu-idle=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-cpu-idle")).numericValue'); echo -n $val >> data; \
            echo -n ",max-potential-first-input-delay=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "max-potential-fid")).numericValue'); echo -n $val >> data; \
            cat data; \
            curl -i -XPOST "http://$INFLUX_HOST:$INFLUX_PORT/write?db=lighthouse" --data-binary @data; \
     done; \
     for host in $HOSTS_SEARCH; do \
        echo ""; \
        echo "$host - Desktop"; \
        echo "$host - Desktop"; \
        /usr/bin/node /usr/local/lib/node_modules/lighthouse/lighthouse-cli/index.js \
            $host --no-enable-error-reporting \
            --chrome-flags="--headless --no-sandbox" --only-categories="performance" --emulated-form-factor="desktop" --max-wait-for-load=“1000” --output json --quiet > response.json;\
            echo -n "performance,url=$(echo $host |sed 's/=/\\=/g'),device=desktop,category=search " > data; \
            echo -n "performance-score=" >> data; \
            val=$(cat response.json | jq -r '[.categories.performance][].score'); echo -n $val >> data; \
            echo -n ",first-contentful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-contentful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",first-meaningful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-meaningful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",time-to-interactive=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "interactive")).numericValue'); echo -n $val >> data; \
            echo -n ",first-cpu-idle=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-cpu-idle")).numericValue'); echo -n $val >> data; \
            echo -n ",max-potential-first-input-delay=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "max-potential-fid")).numericValue'); echo -n $val >> data; \
            cat data; \
            curl -i -XPOST "http://$INFLUX_HOST:$INFLUX_PORT/write?db=lighthouse" --data-binary @data; \
        echo ""; \
        echo "$host - Mobile"; \
        echo "$host - Mobile"; \
        /usr/bin/node /usr/local/lib/node_modules/lighthouse/lighthouse-cli/index.js \
            $host --no-enable-error-reporting \
            --chrome-flags="--headless --no-sandbox" --only-categories="performance" --emulated-form-factor="mobile" --max-wait-for-load=“1000” --output json --quiet > response.json;\
            echo -n "performance,url=$(echo $host |sed 's/=/\\=/g'),device=mobile,category=search " > data; \
            echo -n "performance-score=" >> data; \
            val=$(cat response.json | jq -r '[.categories.performance][].score'); echo -n $val >> data; \
            echo -n ",first-contentful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-contentful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",first-meaningful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-meaningful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",time-to-interactive=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "interactive")).numericValue'); echo -n $val >> data; \
            echo -n ",first-cpu-idle=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-cpu-idle")).numericValue'); echo -n $val >> data; \
            echo -n ",max-potential-first-input-delay=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "max-potential-fid")).numericValue'); echo -n $val >> data; \
            cat data; \
            curl -i -XPOST "http://$INFLUX_HOST:$INFLUX_PORT/write?db=lighthouse" --data-binary @data; \
     done; \
     for host in $HOSTS_BRAND; do \
        echo ""; \
        echo "$host - Desktop"; \
        echo "$host - Desktop"; \
        /usr/bin/node /usr/local/lib/node_modules/lighthouse/lighthouse-cli/index.js \
            $host --no-enable-error-reporting \
            --chrome-flags="--headless --no-sandbox" --only-categories="performance" --emulated-form-factor="desktop" --max-wait-for-load=“1000” --output json --quiet > response.json;\
            echo -n "performance,url=$(echo $host |sed 's/=/\\=/g'),device=desktop,category=brand " > data; \
            echo -n "performance-score=" >> data; \
            val=$(cat response.json | jq -r '[.categories.performance][].score'); echo -n $val >> data; \
            echo -n ",first-contentful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-contentful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",first-meaningful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-meaningful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",time-to-interactive=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "interactive")).numericValue'); echo -n $val >> data; \
            echo -n ",first-cpu-idle=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-cpu-idle")).numericValue'); echo -n $val >> data; \
            echo -n ",max-potential-first-input-delay=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "max-potential-fid")).numericValue'); echo -n $val >> data; \
            cat data; \
            curl -i -XPOST "http://$INFLUX_HOST:$INFLUX_PORT/write?db=lighthouse" --data-binary @data; \
        echo ""; \
        echo "$host - Mobile"; \
        echo "$host - Mobile"; \
        /usr/bin/node /usr/local/lib/node_modules/lighthouse/lighthouse-cli/index.js \
            $host --no-enable-error-reporting \
            --chrome-flags="--headless --no-sandbox" --only-categories="performance" --emulated-form-factor="mobile" --max-wait-for-load=“1000” --output json --quiet > response.json;\
            echo -n "performance,url=$(echo $host |sed 's/=/\\=/g'),device=mobile,category=brand " > data; \
            echo -n "performance-score=" >> data; \
            val=$(cat response.json | jq -r '[.categories.performance][].score'); echo -n $val >> data; \
            echo -n ",first-contentful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-contentful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",first-meaningful-paint=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-meaningful-paint")).numericValue'); echo -n $val >> data; \
            echo -n ",time-to-interactive=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "interactive")).numericValue'); echo -n $val >> data; \
            echo -n ",first-cpu-idle=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "first-cpu-idle")).numericValue'); echo -n $val >> data; \
            echo -n ",max-potential-first-input-delay=" >> data; \
            val=$(cat response.json | jq -r '(.audits[] | select(.id == "max-potential-fid")).numericValue'); echo -n $val >> data; \
            cat data; \
            curl -i -XPOST "http://$INFLUX_HOST:$INFLUX_PORT/write?db=lighthouse" --data-binary @data; \
     done


# performance,url=https://douglas.de performance-score=0.13,first-contentful-paint=3,first-meaningful-paint=3,time-to-interactive=3,first-cpu-idle=3,max-potential-first-input-delay=3
# weather,location=us-midwest temperature=82 1465839830100400200
#   |    -------------------- --------------  |
#   |             |             |             |
#   |             |             |             |
# +-----------+--------+-+---------+-+---------+
# |measurement|,tag_set| |field_set| |timestamp|
# +-----------+--------+-+---------+-+---------+
