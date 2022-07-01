from flask import Flask, jsonify, request, json, request_tearing_down, redirect
import json
import requests

app = Flask(__name__)

# result type
def _resultType(strRes, objValue):
    return {
        'res' : strRes,
        'value' : objValue,
        'type' : str(type(objValue))
    }


# 트위치 # 스트리머 목록 받아오기
@app.route('/api/v1/getArcaconContents', methods=['POST'])
def getCachedStreammerList():
    objPostData = request.values.to_dict()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
    #ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    #ssl_context.load_cert_chain(certfile='server.crt', keyfile='server.key', password='PURURU966a#@!')
    #app.run(host='0.0.0.0', port=8080, debug=True)