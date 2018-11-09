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
    public partial class detailPage : System.Web.UI.Page
    {
        private FastcatCommunicator logger = new FastcatCommunicator("10.0.1.90", "8050", "www");

        protected void Page_Load(object sender, EventArgs e)
        {
            String Keyword = Request["keyword"];        // 검색키워드, 검색키워드가 없다면 아무 값도 들어가지 않습니다. (필수는 아닙니다.)
            String clickId = Request["clickId"];        // 클릭문서 아이디, 어떠한 문서를 클릭했는지 정보를 기록합니다.
            String clickType = Request["clickType"];    // 클릭문서 타입, Attibute설정에 입력해 둔 클릭타입 ID를 사용합니다. 
                                                        // (Configuration > ATTRIBUTE SETTING > Click Type Attributes에 추가한 Click ID 중 하나의 값이 들어가면 됩니다.)
            logger.sendClickData(Keyword, clickId, clickType);
        }

        /* 클릭통계데이터 쿼리를 리턴한다. 쿼리 보여주기 용으로 만들어 둔 함수이기 때문에 안 쓰셔도 됩니다. */
        protected String getClickDataQuery()
        {
            return logger.getClickDataQuery();
        }
    }
}