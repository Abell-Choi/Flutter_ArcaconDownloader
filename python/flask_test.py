import requests

req = requests.post(
    'http://127.0.0.1:8080/getArcaconInformation',
    data={
        'strTargetLink' : 'https://arca.live/e/23647?target=title&keyword=%EB%B8%94%EB%A3%A8%EC%95%84%EC%B9%B4%EC%9D%B4%EB%B8%8C%20%EC%95%84%EB%A3%A8%20%EC%A7%AD%EC%B0%BD%EA%B3%A0%20(%EC%B6%94%EA%B0%80%EC%A4%91)&p=1'
    }
)

req2 = requests.post(
    'http://127.0.0.1:8080/convertMP4ToGIF',
    data={
        'strTargetLink' : 'https://ac2-p2.namu.la/ef/ef4ebe64e6bda25c84c878a4caf6cc65b108262f43b9dd45a09fc7f22dda1e9f.mp4'
    }
)
print(req2.text)