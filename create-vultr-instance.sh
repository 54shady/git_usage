#!/usr/bin/env bash
export VULTR_API_KEY='CF4BWYKTTEDOJHIEFCAQJB57VCWJPZWRXCEA'
curl "https://api.vultr.com/v2/instances" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "region" : "icn",
    "plan" : "vc2-1c-1gb",
    "label" : "Example Instance",
    "os_id" : 477,
    "backups" : "disabled",
    "hostname": "gptvpn",
	"sshkey_id":["c3096c8a-9a34-47b6-8a4b-10e5567c2259"],
	"script_id": "35887d27-d58a-47a8-9176-57bf5a951706",
    "tags": [
      "a tag",
      "another"
    ]
  }'


# list sshkeys
#curl "https://api.vultr.com/v2/ssh-keys"   -X GET   -H "Authorization: Bearer ${VULTR_API_KEY}"

# list instance
#curl "https://api.vultr.com/v2/instances" -X GET   -H "Authorization: Bearer ${VULTR_API_KEY}"

# delete instance
#curl "https://api.vultr.com/v2/instances/f6e6a1b8-1cba-4082-a6b0-cc6153e0683a" \
#	  -X DELETE \
#	-H "Authorization: Bearer ${VULTR_API_KEY}"


# list startup script
#curl "https://api.vultr.com/v2/startup-scripts" \
#	-X GET  -H "Authorization: Bearer ${VULTR_API_KEY}"


#curl "https://api.vultr.com/v2/startup-scripts/{startup-id}" -X GET -H "Authorization: Bearer ${VULTR_API_KEY}"
