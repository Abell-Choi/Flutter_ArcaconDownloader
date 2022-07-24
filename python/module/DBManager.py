import pymysql

class DBManager:
    def __init__( 
        self, 
        strURL : str, 
        nport : int,
        strDBName : str ,
        strID : str,
        strPW : str
    ):
        self.strURL = strURL
        self.strDBName = strDBName
        self.nPort = nport
        self.strID = strID
        self.strPW = strPW
        dbConn = self.__connectingDB()
        if dbConn['res'] == 'err':
            print(dbConn)
            self.db = None
            return
        self.db = dbConn['value']

    def __connRefresh (self):
        connRes = self.__connectingDB()
        if connRes['res'] == 'err':
            self.db = None
            return self.__resultType('err',' connERR -> {0}'.format(connRes['value']))

        self.db = connRes['value']
        return self.__resultType("ok", 'connection refreshed')

    def findCacheData(self, strUrl : str):
        if self.db == None:
            connRes = self.__connRefresh()
            if connRes['res'] == 'err':
                return connRes

        
        sql = 'SELECT {0} FROM {1} WHERE gif_url = "{2}"'.format('*', 'gif_cache_table', strUrl)
        try:
            cur = self.db.cursor()
            cur.execute(sql)
        except Exception as e:
            print(e)
            return False
        resData = cur.fetchall()
        cur.close()
        if len(resData) <= 0:
            return self.__resultType("no", 'no Data')
        
        return self.__resultType('ok', resData[0]['cached_url'])

    def insertCacheData(self, strUrl : str, strCachePath : str):
        if self.db == None:
            if self.__connRefresh()['res'] == 'err':
                return self.__connRefresh()

        sql = 'INSERT INTO gif_cache_table (gif_url, cached_url, update_date) VALUES ("{0}","{1}", NOW())'.format(strUrl, strCachePath)

        cur = self.db.cursor()
        try:
           cur.execute(sql)
        except Exception as e:
            return self.__resultType('err', 'execute err -> {0}'.format(e))
        
        cur.close()
            
        return self.__resultType('ok', 'insert ok -> {0} // {1}'.format(strUrl, strCachePath))
    
    def delectCachedData(self, strCachedPath:str):
        if self.db == None:
            if self.__connectingDB()['res'] == 'err':
                return self.__connRefresh()
        
        sql = 'DELETE FROM `gif_cache_table` WHERE gif_url="{0}"'.format(strCachedPath)

        cur = self.db.cursor()
        try:
            cur.execute(sql)
        except Exception as e:
            return self.__resultType('err', 'execute Err -> {0}'.format(e))
        
        return self.__resultType('ok', '{0} is deleted'.format(strCachedPath))

    def __connectingDB(self):
        try:
            db = pymysql.connect(
                host= self.strURL,
                db= self.strDBName,
                user= self.strID,
                passwd= self.strPW,
                port= self.nPort,
                cursorclass= pymysql.cursors.DictCursor,
                autocommit= True
            )
        except Exception as e:
            return self.__resultType('err', 'conn err -> {0}'.format(e))
        
        return self.__resultType('ok', db)

    def __resultType(self, res, value):
        return {
            'res' : res,
            'value' : value,
            'type' : str(type(value))
        }