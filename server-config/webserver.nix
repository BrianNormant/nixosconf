{pkgs, config, ...}:
{
	services.nginx = {
		enable = true;
	};

	age.secrets.desectoken = {
		file = ./secrets/desecio.age;
		owner = "root";
		group = "root";
	};

	systemd.services.setlocalip = {
		enable = true;
		Unit = {
			Description = "Set the ip for the dns webserver";
		};
		Service = {
			Type = "oneshot";
			ExecStart = ''
#!env zsh

set -euo pipefail

DESEC_TOKEN=`cat ${config.age.secrets.desectoken.path}`

DOMAIN=ggkbrian.com

IP=`curl -s4 ifconfig.me`

echo "Current public IP: $IP"

# 2. Update the record via deSec REST API
RESPONSE=$(curl -s -w "\n%{http_code}" -X PATCH \
  "https://desec.io/api/v1/domains/$${DOMAIN}/rrsets/@/A/" \
  -H "Authorization: Token $${DESEC_TOKEN}" \
  -H "Content-Type: application/json" \
  -d @- <<EOF
{
  "subname": "",
  "type": "A",
  "ttl": 3600,
  "records": ["$${IP}"]
}
EOF
)

# Extract HTTP status code and response body
HTTP_STATUS=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_STATUS" -eq 200 ]]; then
  echo "Successfully updated $DOMAIN @ A to $IP"
else
  echo "Error updating record (HTTP $HTTP_STATUS):" >&2
  echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
  exit 1
fi

sleep 1

RESPONSE=$(curl -s -w "\n%{http_code}" -X PATCH \
  "https://desec.io/api/v1/domains/$${DOMAIN}/rrsets/ollama/A/" \
  -H "Authorization: Token $${DESEC_TOKEN}" \
  -H "Content-Type: application/json" \
  -d @- <<EOF
{
  "subname": "ollama",
  "type": "A",
  "ttl": 3600,
  "records": ["$${IP}"]
}
EOF
)


HTTP_STATUS=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_STATUS" -eq 200 ]]; then
  echo "Successfully updated $DOMAIN ollama A to $IP"
else
  echo "Error updating record (HTTP $HTTP_STATUS):" >&2
  echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
  exit 1
fi

sleep 1

RESPONSE=$(curl -s -w "\n%{http_code}" -X PATCH \
  "https://desec.io/api/v1/domains/$${DOMAIN}/rrsets/chatbot/A/" \
  -H "Authorization: Token $${DESEC_TOKEN}" \
  -H "Content-Type: application/json" \
  -d @- <<EOF
{
  "subname": "chatbot",
  "type": "A",
  "ttl": 3600,
  "records": ["$${IP}"]
}
EOF
)


HTTP_STATUS=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_STATUS" -eq 200 ]]; then
  echo "Successfully updated $DOMAIN chatbot A to $IP"
else
  echo "Error updating record (HTTP $HTTP_STATUS):" >&2
  echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
  exit 1
fi
				'';
		};
		Timer = {
			OnCalendar = "*-*-*-*:*:00";
			Unit = {
				Description = "Timer for my service";
			};
		};
	};

}
