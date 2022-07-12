from moviepy.editor import *
import uuid
import requests
import os
class MediaManager:
    def __init__(self, strMp4Url):
        self.strFileUid = uuid.uuid4()
        self.targetUrl = strMp4Url

        pass
    
    def getTargetLink(self):
        return self.strFileUid

    def mp4ToGif(self):
        req = requests.get(self.targetUrl).content
        f = open('./image_temp/{0}.mp4'.format(self.strFileUid), 'wb')
        f.write(req)
        f.close()
        VideoFileClip('./image_temp/{0}.mp4'.format(self.strFileUid)).speedx(1).write_gif('./image_temp/{0}.gif'.format(self.strFileUid))
        os.remove('./image_temp/{0}.mp4'.format(self.strFileUid))

        return '{0}.gif'.format(self.strFileUid)
#VideoFileClip('mov.mp4').speedx(4).write_gif('out.gif') // 4배속도로 gif 생성