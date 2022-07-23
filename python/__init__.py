import mimetypes
from flask import Flask, redirect, request, send_file, url_for
from module.ArcaManager import ArcaconManager
from module.mediaConverter import MediaManager
import json

app = Flask(__name__)

# Utility
def __resultType(strRes:str='err', objValue:all='err'):
    return {
        'res' : strRes,
        'value' : objValue,
        'type' : str(type(objValue))
    }

@app.route('/', methods=['POST'])
def root():
    objPostData = request.values.to_dict()
    if not 'strKey' in objPostData.keys() : return json.dumps(__resultType('err', 'need strKey'), ensure_ascii=False, indent=4)
    return json.dumps(__resultType('ok', objPostData['strKey']), ensure_ascii=False, indent=4)

@app.route('/getArcaconInformation', methods=['POST'])
def getArcaconInformation():
    objPostData = request.values.to_dict()
    if not 'strTargetLink' in objPostData.keys(): return json.dumps(__resultType('err', 'strTargetLink must input post data'), ensure_ascii=False)
    obj = ArcaconManager(objPostData['strTargetLink'])
    if obj.isValidData() == False: return json.dumps(__resultType('err', 'not valid data'))
    return json.dumps(obj.getAllData(), ensure_ascii=False, indent=4)

@app.route('/convertMP4ToGIF', methods=['POST'])
def convertMP4toGIF():
    objPostData = request.values.to_dict()
    if not 'strTargetLink' in objPostData.keys(): return json.dumps(__resultType('err', 'strTargetLink must input post data'), ensure_ascii=False)
    converter = MediaManager(objPostData['strTargetLink'])
    strTargetUrl = converter.mp4ToGif()
    if strTargetUrl == None:
        return json.dumps(__resultType('err', 'some err in working'), ensure_ascii=False)
    return json.dumps(__resultType('ok', '/file/redirect/{0}'.format(strTargetUrl)), ensure_ascii=False, indent=4)
    # return imageRedirection('{0}'.format(strTargetUrl))

@app.route('/file/redirect/<filename>')
def imageRedirection(filename):
    return send_file(
        'image_temp/{0}'.format(filename , mimetypes='image/gif')
    ) 

@app.route('/')
def root_page():
    return json.dumps(
        {
            'res' : 'ok',
            'value' : 'API server is running'
        }
    )

app.run(host='0.0.0.0', port=8080, debug=True)