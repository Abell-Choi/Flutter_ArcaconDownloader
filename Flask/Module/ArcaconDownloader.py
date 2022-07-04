import urllib
import requests
from bs4 import BeautifulSoup
from moviepy.editor import *
class ArcaconUtility():
    def __init__ (self):
        self.contentUrl = 'https://arca.live/e/'

    def findCodeForContent(self, strConCode:str=''):
        return self.__findCodeForContent(strConCode=strConCode)

    def __findCodeForContent(self, strConCode:str = None):
        if strConCode == None: return self.__resultType('err', 'strConCode is None')
        strConCode = self.__convertUrlToCode(strUrl = strConCode)['value']
        r = self.__getRequestsData(self.contentUrl +strConCode)
        if r['res'] == 404: return self.__resultType('err', 'no Data')
        if r['res'] != 'ok' : return r
        r = BeautifulSoup(r['value'].content , "html.parser")
        contentTag = 'body > div.root-container > div.content-wrapper.clearfix > article > div > div.article-wrapper > div.article-head > div.title-row > div:nth-child(1)'
        
        return self.__resultType('ok', r.select_one(contentTag).get_text())

    def getContentDataUrls(self, strConCode:str=None):
        return self.__getContentDataUrls(strConCode= strConCode)

    def __getContentDataUrls(self, strConCode):
        strConCode = self.__convertUrlToCode(strUrl=strConCode)['value']
        if (res:=self.__findCodeForContent(strConCode= strConCode))['res'] == 'err': return res

        strImgTag = 'body > div.root-container > div.content-wrapper.clearfix > article > div > div.article-wrapper > div.article-body > div > img'
        strVideoTag = 'body > div.root-container > div.content-wrapper.clearfix > article > div > div.article-wrapper > div.article-body > div > video'
        r = self.__getRequestsData(self.contentUrl +strConCode)
        bs = BeautifulSoup(r['value'].content, 'html.parser')
        lstUrl = []
        for i in bs.select(strImgTag) + bs.select(strVideoTag):
            try:
                if i['src'][-3:] == 'mp4':
                    lstUrl.append('https:' +i['src'][:-3] +'gif')
                    continue
                lstUrl.append('https:' +i['src'])
            except:
                if i ['data-src'][-3:] == 'mp4':
                    lstUrl.append('https:' +i['data-src'][:-3] +'gif')
                    continue
                lstUrl.append('https:' +i['data-src'])

        return self.__resultType('ok', lstUrl)

    def getGifData(self, strUrl:str=None):
        return self.__getGifData(strUrl)

    def __getGifData(self, strUrl:str=None):
        if strUrl == None or not type(strUrl) is str:
            return self.__resultType('err', 'strUrl must be String')

        objReqData = self.__getRequestsData(strUrl)
        print(objReqData)
        if objReqData['res'] != 404:
            return self.__resultType('err', '200')
        

        strUrl = strUrl[:-3] +'mp4'
        objReqData = self.__getRequestsData(strUrl)
        f = open('./convertFiles/convert.mp4', 'wb')
        f.write(objReqData['value'].content)
        f.close()
        VideoFileClip('./convertFiles/convert.mp4').speedx(1).write_gif('./convertFiles/out.gif')
        return self.__resultType('ok', './convertFiles/out.gif')
    
    def convertUrlToCode(self, strUrl:str=None):
        return self.__convertUrlToCode(strUrl= strUrl)

    def __convertUrlToCode(self, strUrl:str=None):
        if strUrl == None : return self.__resultType('err', 'no Url in data')
        if type(strUrl) is int : return self.__resultType('ok', str(strUrl))
        if strUrl.isdigit() : return self.__resultType('ok', strUrl)
        if not '/e/' in strUrl : return self.__resultType('err', "can't convert url to code\nNo /e/ in {0}".format(strUrl))
        strUrl = strUrl.split('/e/')[1]
        if strUrl.split('?')[0].isdigit() == False : return self.__resultType('err', 'some convert err -> \n{0}'.format(strUrl))
        return self.__resultType('ok', strUrl.split('?')[0])

    def __getRequestsData(self, strUrl:str = ''):
        try:
            r = requests.get(strUrl)
        except Exception as e:
            return self.__resultType('err', 'requests err -> {0}'.format(e))

        if r.status_code != 200:
            return self.__resultType(r.status_code, 'not 200 code -> {0}'.format(r.status_code))
        
        return self.__resultType('ok', r)

    def __resultType(self, strRes, objValue):
        return { 'res' : strRes, 'value' : objValue, 'type' : str(type(objValue)) } 
