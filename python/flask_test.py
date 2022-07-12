import requests

req = requests.post(
    'http://127.0.0.1:8080/convertMP4ToGIF',
    data={
        'strTargetLink' : 'https://ac2-p2.namu.la/ef/ef4ebe64e6bda25c84c878a4caf6cc65b108262f43b9dd45a09fc7f22dda1e9f.mp4'
    }
)

f = open('./a.gif', 'wb')
f.write(req.content)
f.close()