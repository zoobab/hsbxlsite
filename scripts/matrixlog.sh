curl "https://hackerspaces.be/_matrix/client/r0/rooms/!mnQLxCDhwmKozNmuIB:hackerspaces.be/send/m.room.message?access_token=MDAxZGxvY2F0aW9uIGhhY2tlcnNwYWNlcy5iZQowMDEzaWRlbnRpZmllciBrZXkKMDAxMGNpZCBnZW4gPSAxCjAwMmFjaWQgdXNlcl9pZCA9IEBnaXRsYWI6aGFja2Vyc3BhY2VzLmJlCjAwMTZjaWQgdHlwZSA9IGFjY2VzcwowMDIxY2lkIG5vbmNlID0geXgrNUJZK211aWk0dnN5dQowMDJmc2lnbmF0dXJlIOEs7nsIv4K9Fj1mhcnGjkbwxHn-Y13vSlNz6kcVGKYjCg" -X POST -H 'Content-Type: application/json' -d '{"msgtype":"m.text", "body":"'"$CI_BUILD_REF"'" }'