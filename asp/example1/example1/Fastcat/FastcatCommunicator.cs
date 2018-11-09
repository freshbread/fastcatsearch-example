/*
 * 날짜 : 2015-07-20
 * 작성자 : 패스트캣 사원 전제현
 * 내용 : 로그분석기 연동 ASP.NET(C#) 예제
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Net;
using System.Text;

namespace FastcatSearch_ASP_001.Fastcat
{
    public class FastcatCommunicator
    {
        private String baseAddr;
        private String basePort;
        private String baseSiteID;
        private String query;     // 쿼리를 보여드리기 위해 만들어 둔 변수입니다. 실제 사용하실 때는 안 쓰셔도 됩니다.
        private String clickDataQuery;     // 쿼리를 보여드리기 위해 만들어 둔 변수입니다. 실제 사용하실 때는 안 쓰셔도 됩니다.

        /* 아이피 또는 주소, 포트번호, 사이트ID를 받아온다. 디폴트는 localhost:8050과 사이트 아이디 www이다. */
        public FastcatCommunicator(String getAddr = "10.0.1.90", String getPort = "8050", String getSideID = "www")
        {
            this.baseAddr = getAddr;        // IP Address or Address
            this.basePort = getPort;        // Port
            this.baseSiteID = getSideID;    // Site ID
        }

        // 쿼리를 보여드리기 위해 만들어 둔 함수입니다. 실제 사용하실 때는 안 쓰셔도 됩니다.
        public String getQuery()
        {
            if (this.query == null)
                this.query = "no Query.";
            return this.query;
        }

        public String getClickDataQuery()
        {
            if (this.clickDataQuery == null)
                this.clickDataQuery = "no Query.";
            return this.clickDataQuery;
        }

        /* 검색 후 검색결과가 나올 시 로그를 보낸다. 입력 순서는 (검색 키워드, 이전 검색 키워드, 카테고리 ID, 서비스 구분, 정렬 구분, 현재 페이지, 반응시간) 으로 입력한다.  */
        public String sendUrl(String getCategoryid, String getSearchService, String getKeyword, String getPrevKeyword, String getRestime, String getCategory, String getPage, String getSort, String getService, String getAge, String getGender)
        {
            String paramStr = "";   // 로그분석기 서버로 보낼 파라미터 값들

            /* 검색유입 경로 */
            String searchService = getSearchService;

            /* 기본 */
            String keyword;         // (*필수) 입력된 키워드
            String prevKeyword;     // (*필수) 이전 키워드
            String resptime;        // (*필수) 반응시간, 검색 후 반응시간 값을 가져온다.

            /* 여기서부터는 비율통계 값입니다. 통계를 원하지 않는 값은 해당 값을 넣지 않아도 상관없습니다. */
            String prmCategory;     // 타입별 분류 입력, 카테고리 이름을 전달한다.
            String prmPage;         // 현재 페이지의 번호, 바로 검색했을 경우에는 1, 페이지 이동 시에는 해당 페이지 번호가 들어가야 한다.
            String prmSort;         // 정렬구분, 검색옵션 변경 시 정렬값을 전달한다.
            String prmService;      // 서비스 구분 (통합검색인지, 그 밖에 상세검색인지 전달용)
            //String prmLogin;      // 로그인 구분 여부, 로그인을 했는지 하지 않았는지의 경우를 입력한다. !로그인 여부는 넣지 말아달라고 하셔서 뺍니다.
            String prmAge;          // 연령대 구분, 로그인 사용자일 경우 연령대의 구분을 위해 전달한다.
            String prmGender;       // 성별구분, 로그인 사용자일 경우 성별의 구분을 위해 전달한다.

            keyword = getKeyword;
            prevKeyword = getPrevKeyword;
            resptime = getRestime;

            prmCategory = getCategory;
            prmPage = getPage;
            prmSort = getSort;
            prmService = getService;
            //prmLogin = "로그인"; 로그인 여부는 넣지 말아달라고 하셔서 뺍니다.
            prmAge = getAge;
            prmGender = getGender;
            
            /* Uri 파라미터 작성 */
            paramStr += "type=search&siteId=" + this.baseSiteID + "&categoryId=" + getCategoryid + "&keyword=" + keyword + "&prev=" + prevKeyword;
            paramStr += "&resptime=" + resptime + "&page=" + prmPage + "&sort=" + prmSort + "&service=" + prmService;
            //paramStr += "&age=" + prmAge + "&login=" + prmLogin + "&gender=" + prmGender + "&category=" + prmCategory; // 로그인 여부는 넣지 말아달라고 하셔서 뺍니다.
            paramStr += "&age=" + prmAge + "&login=&gender=" + prmGender + "&category=" + prmCategory;

            this.query = "http://" + this.baseAddr + ":" + this.basePort + "/service/keyword/hit/post?" + paramStr; // 쿼리를 보여드리기 위해 만들어 둔 변수입니다. 실제 사용하실 때는 안 쓰셔도 됩니다.

            /* 검색 로그 전송 */
            return Request_Analytics(this.query);
        }

        /* 제품 상세 페이지로 접근할 시 로그분석기에 검색통계데이터를 보낸다. */
        public String sendClickData(String getKeyword, String getClickId, String getClickType)
        {
            String paramStr = "";   // 로그분석기 서버로 보낼 파라미터 값들

            String keyword;
            String clickId;
            String clickType;

            keyword = getKeyword;
            clickId = getClickId;
            clickType = getClickType;

            paramStr += "siteId=" + this.baseSiteID + "&keyword=" + getKeyword + "&clickId=" + getClickId + "&clickType=" + getClickType;

            this.clickDataQuery = "http://" + this.baseAddr + ":" + this.basePort + "/service/ctr/click/post?" + paramStr;

            return Request_Analytics(this.clickDataQuery);
        }

        /* 로그분석기에 검색 로그를 전송하는 함수 (sendUrl, sendClickUrl 함수에서 사용합니다.) */
        private String Request_Analytics(String getUrl)
        {
            string result = null;
            string url = getUrl;

            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                Stream stream = response.GetResponseStream();
                StreamReader reader = new StreamReader(stream);
                result = reader.ReadToEnd();
                stream.Close();
                response.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

            if (result.Equals("{}"))
            {
                return "true";
            }
            else
            {
                return "true";
            }
        }

        /* 검색서버에 요청하여 받아온 값을 JArray 객체에 넣어 반환한다. */
        public JArray takeJSONResult(String getType, String getParam1 = "_root", String getParam2 = "", String getParam3 = "")
        {
            String takeResult;
            String[] output = new String[100];
            JObject obj;

            if(getType == "rt") /* 실시간 인기 검색어 */
            {
                takeResult = RequestJSON("/service/keyword/popular/rt.json", "siteId=" + this.baseSiteID + "&categoryId=" + getParam1);
            }
            else if (getType == "popular") /* 날짜별 인기 검색어 */
            {
                takeResult = RequestJSON("/service/keyword/popular.json", "siteId=" + this.baseSiteID + "&categoryId=" + getParam1 + "&timeType=" + getParam2 + "&interval=" + getParam3);
            }
            else if (getType == "relate") /* 연관검색어 인기 검색어 */
            {
                takeResult = RequestJSON("/service/keyword/relate.json", "siteId=" + this.baseSiteID + "&keyword=" + getParam1);
            }
            else /* 첫 번째 파라미터를 위의 3개의 값이 아닌 다른 값을 넣으시면 실시간 인기 검색어를 불러옵니다. */
            {
                takeResult = RequestJSON("/service/keyword/popular/rt.json", "siteId=" + this.baseSiteID + "&categoryId=" + getParam1);
            }

            obj = JObject.Parse(takeResult);

            if (getType == "relate")
            {
                return JArray.Parse(obj["relate"].ToString());
            }
            else
            {
                return JArray.Parse(obj["list"].ToString());
            }
        }

        /* 검색서버에 값을 요청하고 받아온다. */
        private String RequestJSON(String getUrlPath, String getParam)
        {
            String result = null;
            String urlPath = getUrlPath;
            String jsonParameter = getParam;
            String url = "http://" + this.baseAddr + ":" + this.basePort + getUrlPath + "?" + jsonParameter;

            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                Stream stream = response.GetResponseStream();
                StreamReader reader = new StreamReader(stream);
                result = reader.ReadToEnd();
                stream.Close();
                response.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }

            return result;
        }
    }
}