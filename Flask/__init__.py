from operator import methodcaller
from unittest import result
from flask import Flask, jsonify, request, json, request_tearing_down, redirect
import json
import requests
from Module.ArcaconDownloader import ArcaconUtility

app = Flask(__name__)

# result type
def _resultType(strRes, objValue):
    return {
        'res' : strRes,
        'value' : objValue,
        'type' : str(type(objValue))
    }



# 아카콘 존재 여부 확인
# POST strData
@app.route('/api/v1/findArcaconContents', methods=['POST'])
def findArcaconContents():
    objPostData = request.values.to_dict()
    if not 'strData' in objPostData.keys():
        return json.dumps(_resultType('err', 'no strData in POST data'), ensure_ascii=False)
    
    if not type(objPostData['strData']) is str:
        return json.dumps(_resultType('err', 'strData must be String type'), ensure_ascii=False)
    
    obj = ArcaconUtility()
    return json.dumps(obj.findCodeForContent(objPostData['strData']), ensure_ascii=False)

@app.route('/api/v1/getArcaconContents', methods=['POST'])
def getArcaconContents():
    objPostData = request.values.to_dict()
    if not 'strData' in objPostData.keys():
        return json.dumps(_resultType('err', 'no strData in POST data'), ensure_ascii=False)

    if not type(objPostData['strData']) is str:
        return json.dumps(_resultType('err', 'strData must be String type'), ensure_ascii=False)
    
    obj = ArcaconUtility()
    return json.dumps(obj.getContentDataUrls(objPostData['strData']), ensure_ascii=False)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)