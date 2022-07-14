import requests
from bs4 import BeautifulSoup

class ArcaconManager:
    def __init__(self, strTargetUrl):
        self.strTargetUrl:str = strTargetUrl
        self.lstEmoticonUrl:list = []
        self.lstEmoticonDataID:list = []
        self.strTitle:str = ''
        self.strMaker:str = ''
        self.strEmoticonTitleImg:str = ''
        self.strDateTime:str = ''
        self.isComplite = False
        self.__importArcaconData()
        pass

    def isValidData(self):
        return self.isComplite
    
    def getAllData(self):
        if not self.isComplite:
            return self.__resultType('err', 'not complite constructing data')
        
        return self.__resultType(
            'ok',
            {
                'title' : self.strTitle,
                'title-img' : self.strEmoticonTitleImg,
                'maker' : self.strMaker,
                'datetime' : self.strDateTime,
                'conList' : self.lstEmoticonUrl,
                'conData-Id' : self.lstEmoticonDataID,
                'conDataId' : None
            }
        )
    
    def getTitle(self):
        if not self.isComplite:
            return self.__resultType('err', 'not complite constructing data')
        return self.__resultType('ok', self.strTitle)

    def getTitleImage(self):
        if not self.isComplite:
            return self.__resultType('err', 'not complite constructing data')
        return self.__resultType('ok', self.strEmoticonTitleImg)
    
    def getMaker(self):
        if not self.isComplite:
            return self.__resultType('err', 'not complite constructing data')
        return self.__resultType('ok', self.strMaker)
    
    def getUploadTime(self):
        if not self.isComplite:
            return self.__resultType('err', 'not complite constructing data')
        return self.__resultType('ok', self.getUploadTime)

    def getContentList(self):
        if not self.isComplite:
            return self.__resultType('err', 'not complite constructing data')
        return self.__resultType('ok', self.lstEmoticonUrl)

    def __importArcaconData(self):
        self.isComplite = False
        req = self.__getContent(self.strTargetUrl)
        if req['res'] == 'err': return req
        bs = BeautifulSoup(req['value'].content, 'html.parser')
        if len(bs.select('.emoticons-wrapper')) == 0:
            return self.__resultType('no', 'no Arcacon Url')
        self.strTitle = bs.select('*.title-row > *.title')[0].text
        self.strMaker = bs.select('.member-info')[0].text
        self.strDateTime = bs.select('time')[0].text
        #print(bs.select('.emoticons-wrapper')[0].select('*.emoticon'))
        for i in bs.select('.emoticons-wrapper')[0].select('*.emoticon'):
            self.lstEmoticonDataID.append(i['data-id'])
            try:
                self.lstEmoticonUrl.append('https:' +i['src'])
            except:
                self.lstEmoticonUrl.append('https:' +i['data-src'])

        self.isComplite = True
        self.strEmoticonTitleImg = self.getContentTitle()['value']

    def getContentTitle(self):
        ''' 
        strUrl에 아카콘 링크주소를 넣으면\n
        자동적으로 해당 아카콘의 메인이미지를 return 할 것 입니다.     
        '''
        if not self.isComplite:
            return self.__resultType('err', 'is not compliling data')
        
        self.strTitle = self.strTitle[1:-1]
        print(self.strTitle)
        strTargetUrl = 'https://arca.live/e/?target=title&keyword={0}'.format(self.strTitle)
        req = self.__getContent(strTargetUrl)
        if req['res'] == 'err':
            return req
        
        bs = BeautifulSoup(req['value'].content, 'html.parser')
        selector = 'body > div.root-container > div.content-wrapper.clearfix > article > div > div > div.emoticon-list > a > div > img'
        bs = 'https:' +bs.select(selector)[0]['src']
        return self.__resultType('ok', bs)


    def __getContent(self, strUrl):
        try:
            req = requests.get(strUrl)
        except Exception as e:
            return self.__resultType('err', 'conn err -> {0}'.format(e))
        
        return self.__resultType('ok', req)
        
    def __typeError(self, strValue:str, type:type):
        return self.__resultType('err', '{0} must be {1} type'.format(strValue, str(type)))
   
    def __notArcaconData(self, strUrl:str):
        return self.__resultType('err', '{0} is not arcacon url')

    def __resultType(self, strRes:str, objValue:any):
        return {
            'res' : strRes,
            'value' : objValue,
            'type' : str(type(objValue))
        }

