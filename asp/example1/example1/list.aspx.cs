using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using FastcatSearch_ASP_001.Fastcat;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace FastcatSearch_ASP_001
{
    public partial class list : System.Web.UI.Page
    {
        private FastcatCommunicator logger = new FastcatCommunicator("10.0.1.90", "8050", "www");
        protected JArray realtimePopularList = null;
        protected JArray yesterdayPopularList = null;
        protected JArray lastweekPopularList = null;
        protected JArray relateList = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            realtimePopularList = logger.takeJSONResult("rt");                          // 실시간 인기 검색어
            yesterdayPopularList = logger.takeJSONResult("popular", "_root", "D", "1"); // 어제의 인기 검색어
            lastweekPopularList = logger.takeJSONResult("popular", "_root", "W", "1");  // 지난 주의 인기 검색어
            relateList = logger.takeJSONResult("relate", "LOUIS");                      // 연관검색어, 연관된 검색단어를 보여줄 검색어를 두 번째 파라미터에 넣어주시면 됩니다.
        }
    }
}