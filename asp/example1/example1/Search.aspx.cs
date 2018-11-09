/*
 * 날짜 : 2015-07-20
 * 작성자 : 패스트캣 사원 전제현
 * 내용 : 로그분석기 연동 ASP.NET(C#) 예제
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using FastcatSearch_ASP_001.Fastcat;

namespace FastcatSearch_ASP_001
{
    public partial class Search : System.Web.UI.Page
    {
        private FastcatCommunicator logger = new FastcatCommunicator("10.0.1.90", "8050", "www");

        protected void Page_Load(object sender, EventArgs e)
        {
            /* 기본 */
            String categoryId = ""; // categoryId 값, Site하위 카테고리 ID

            /* 검색유입 경로 */
            String searchService = "totalSearch";

            /* 검색회수 통계, 인기키워드, 연관키워드 */
            String Keyword = Request["searchKeyword"];  // (*필수) 입력된 키워드, 현재 검색한 키워드를 넣어주세요.
            String prev = Request["prevKeyword"];       // (*필수) 이전 키워드, 현재 검색 키워드 이전에 검색하신 키워드를 넣어주세요.
            String restime = "3";                       // (*필수) 검색엔진 응답시간, 검색 후 받아오는 json 객체에 들어있는 응답시간 restime 값을 숫자 부분만 넣어주세요.

            /* 비율통계 */
            String category = Request["category"];      // 타입별 분류 입력, 카테고리 이름을 전달한다.
            String page = Request["page"];              // 현재 페이지의 번호, 바로 검색했을 경우에는 1, 페이지 이동 시에는 해당 페이지 번호가 들어가야 한다.
            String sort = Request["sort"];              // 정렬구분, 검색옵션 변경 시 정렬값을 전달한다.
            String service = Request["service"];        // 서비스 구분 (통합검색인지, 그 밖에 상세검색인지 전달용)
            String age = Request["age"];                // 연령대 구분, 로그인 사용자일 경우 연령대의 구분을 위해 전달한다.
            String gender = Request["gender"];          // 성별구분, 로그인 사용자일 경우 성별의 구분을 위해 전달한다.

            logger.sendUrl(categoryId, searchService, Keyword, prev, restime, category, page, sort, service, age, gender);
        }

        /* 검색 쿼리를 리턴한다. 쿼리 보여주기 용으로 만들어 둔 함수이기 때문에 안 쓰셔도 됩니다. */
        protected String getQuery()
        {
            return logger.getQuery();
        }

        /* 검색 키워드를 리턴한다. */
        protected String getKeyword()
        {
            return Request["searchKeyword"];
        }
    }
}