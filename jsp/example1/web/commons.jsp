<%@page import="
				org.json.*,
				java.io.*,
				java.net.*,
				java.text.SimpleDateFormat,
				java.util.Date,
				java.util.regex.Pattern" %>
<%!

    /**
     * 검색 기능 중 핵심 기능들을 모아놓은 라이브러리.
     * 구형 WAS 를 사용하거나 운영중 리셋이 불가능한 고객 클라이언트를 위해 JSP로 작성됨.
     * 라이브러리 의존성이 크지 않아 다양한 클라이언트에 붙일 수 있다.
     * ( org.json 라이브러리 필요 )
     **/

    private static final String HOST_SEARCH_ENGINE = "10.0.1.202:8090";
    private static final String HOST_ANALYTICS_ENGINE = "10.0.1.202:8050";

    public String getStr(HttpServletRequest request, String str, String defaultStr) {
        String value = request.getParameter(str);
        if (value == null) {
            return defaultStr;
        }
        try {
            value = new String(value.getBytes("ISO-8859-1"), "utf8");
        } catch (UnsupportedEncodingException e) {
        }
        return value;
    }

    public String e(String str) {
        try {
            return URLEncoder.encode(str, "utf8");
        } catch (UnsupportedEncodingException e) {
        }
        return "";
    }

    public String d(String str) {
        try {
            return URLDecoder.decode(str, "utf8");
        } catch (UnsupportedEncodingException e) {
        }
        return "";
    }

    public int parseInt(Object str, int def) {
        int ret = 0;
        try {
            if (str != null) {
                ret = Integer.parseInt(str.toString());
            } else {
                ret = def;
            }
        } catch (Exception e) {
        }
        return ret;
    }

    public String subQuery(String query, String subQuery, String mode) {
        if (query == null || "".equals(query)) {
            query = subQuery;
        } else {
            query = "{" + query + "}" + mode + "{" + subQuery + "}";
        }
        return query;
    }

    public JSONObject searchData(String collectionName, String fieldList,String searchFieldList, String searchStr, int start, int length) {
        //List는 ,로 구분
        searchStr = searchStr.replaceAll("\\&", "\\\\&");
        String cn = collectionName;
        String fl = fieldList;
        String sn = "" + start;
        String ln = "" + length;
        String searchField1 = "P_NAME1";
        String searchField2 = "P_NAME2";
        String se = "{"+searchField1+":ALL(" + searchStr + "):100}OR{"+searchField2+":ALL(" + searchStr+ "):10}";

        String urlStr = "cn=" + e(cn) +
                "&ht=" + "&sn=" + e(sn) + "&ln=" + e(ln) +
                "&fl=" + e(fl) + "&se=" + e(se) + "&timeout=999";

        urlStr = "http://" + HOST_SEARCH_ENGINE + "/service/search.json?" + urlStr;
        return communicateSearchEngine(urlStr);
    }

    public JSONObject searchAutoCompleteData(String collectionName, String fieldList, String searchStr, int start, int length) {

        String cn = collectionName;
        String fl = fieldList;
        String sn = "" + start;
        String ln = "" + length;
        String searchField1 = "KEYWORD";
        String searchField2 = "SEARCH";
        String se = "{"+searchField1+":ALL(" + e(searchStr) + "):100}OR{"+searchField2+":ALL(" + e(searchStr) + "):10}";

        String urlStr = "cn=" + e(cn) +
                "&ht=" + "&sn=" + e(sn) + "&ln=" + e(ln) +
                "&fl=" + e(fl) + "&se=" + se + "&timeout=999";
        urlStr = "http://" + HOST_SEARCH_ENGINE + "/service/search.json?" + urlStr;

        return communicateSearchEngine(urlStr);
    }

    public JSONObject communicateSearchEngine(String urlStr) {
        URL url = null;
        HttpURLConnection con = null;
        InputStream is = null;
        BufferedReader br = null;
        JSONObject ret = null;

        try {
            url = new URL(urlStr);
            con = (HttpURLConnection) url.openConnection();
            is = con.getInputStream();
            br = new BufferedReader(new InputStreamReader(is, "utf-8"));

            StringBuilder sbuilder = new StringBuilder();

            for (String rline = null; (rline = br.readLine()) != null; ) {
                sbuilder.append(rline).append("\n");
            }

            ret = new JSONObject(sbuilder.toString());

        } catch (JSONException e) {
            throw new RuntimeException(e);
        } catch (MalformedURLException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            if (br != null) try {
                br.close();
            } catch (IOException e) {
            }
            if (is != null) try {
                is.close();
            } catch (IOException e) {
            }
            if (con != null) {
                con.disconnect();
            }
        }

        return ret;
    }

    public void sendSearchData(String _siteId, String _categoryId,String _searchService, String _keyword, String _prev, String _resptime, String _category, String _pageValue, String _sort, String _service, String _login, String _age, String _gender) {
        //List는 ,로 구분
        _keyword = _keyword.replaceAll("\\&", "\\\\&");
        _prev = _prev.replaceAll("\\&", "\\\\&");
        String siteId = _siteId;
        String categoryId = _categoryId;
        String searchService =_searchService;
        String keyword =_keyword;
        String prev =_prev;
        String resptime=_resptime;
        String category=_category;
        String pageValue=_pageValue;
        String sort=_sort;
        String service=_service;
        String login=_login;
        String age=_age;
        String gender=_gender;

        if(prev.equals(keyword)){
            prev="";
        }

        String urlStr = "&siteId=" + e(siteId) +
                "&categoryId="+categoryId + "&searchService=" + e(searchService) +"&keyword="+e(keyword)+ "&prev=" + e(prev) +"&resptime="+resptime+"&category="+category+"&page="+pageValue+"&sort="+sort+"&age="+age+"&service="+service+"&login="+login+"&gender="+gender;
        urlStr = "http://" + HOST_ANALYTICS_ENGINE + "/service/keyword/hit/post?type=search" + urlStr;

        communicateAnalyticsEngine(urlStr);
    }
    public void communicateAnalyticsEngine(String urlStr) {
        URL url = null;
        HttpURLConnection con = null;
        InputStream is = null;

        try {
            url = new URL(urlStr);
            con = (HttpURLConnection) url.openConnection();
            is = con.getInputStream();

        } catch (MalformedURLException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            if (is != null) try {
                is.close();
            } catch (IOException e) {
            }
            if (con != null) {
                con.disconnect();
            }
        }
    }

    public JSONObject getPopularKeyword(String siteId, String categoryId) {
        //List는 ,로 구분
        siteId = siteId.replaceAll("\\&", "\\\\&");
        String si = siteId;
        String ci = categoryId;
        String urlStr = "siteId=" + si+"&categoryId="+ci;

        urlStr = "http://" + HOST_ANALYTICS_ENGINE + "/service/keyword/popular/rt.json?" + "type=search&"+urlStr;

        return communicateSearchEngine(urlStr);
    }
    public Date parseDate(String data) {
        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyyMMddHHmmssS");
        SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
        Pattern ptn = Pattern.compile("[- /\\:.,]");

        if (data == null) {
            return null;
        }

        data = ptn.matcher(data).replaceAll("");
        for (int strlen = data.length(); strlen < 18; strlen++) {
            data += "0";
        }
        try {
            return ((SimpleDateFormat) inputFormat.clone()).parse(data);
        } catch (Exception e) {
            return new Date(0);
        }
    }

    public String formatDate(long date, int type) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
        String str = "";
        try {
            str = sdf.format(new java.util.Date(date));
        } catch (Exception e) {
        }
        if (type == 1) {
            str = str + " 00:00:00";
        } else if (type == 2) {
            str = str + " 23:59:59";
        } else if (type == 3) {
            str = str + "000000";
        } else if (type == 4) {
            str = str + "235959";
        }
        return str;
    }

    private static class PageNavigator {

        //-----------------------------------필드--------------------------------------
        /**전체레코드에대한 갯수를 저장*/
        private int totalRecord;
        /**전체페이지에대한 갯수를 저장*/
        private int totalPage;
        /**한화면에 표현 가능한 줄의 갯수*/
        private int rowsOfScreen;
        /**한화면에 표현 가능한 내비게이터갯수*/
        private int pagesOfScreen;

        //----------------------------------생성자-------------------------------------
        public PageNavigator(int rowsOfScreen, int pagesOfScreen) {
            this.rowsOfScreen = rowsOfScreen;
            this.pagesOfScreen = pagesOfScreen;
        }

        //----------------------------------메서드-------------------------------------
        public void setTotal(int totalRecord) {
            this.totalRecord = totalRecord;
            //전체 레코드를 화면단위로 나누어 페이지 갯수 계산
            this.totalPage = (int) Math.round((double) totalRecord / rowsOfScreen + .4);
        }

        public int getTotalRecord() {
            return totalRecord;
        }

        public int getTotalPage() {
            return totalPage;
        }

        public int currentPage(int rowNumber) {
            return (int) Math.floor((rowNumber + rowsOfScreen) / rowsOfScreen);
        }

        public int[] getRowMargine(int pageNumber) {
            int st = totalRecord, ed = totalRecord - rowsOfScreen;
            int[] ret = {st, ed};
            st = pageNumber * rowsOfScreen;
            if (st > totalRecord) st = totalRecord;
            if (totalRecord > rowsOfScreen) {
                ed = st - rowsOfScreen;
                if (ed < 0) {
                    st = rowsOfScreen;
                    ed = 0;
                }
            } else {
                st = totalRecord;
                ed = 0;
            }
            ret[0] = st;
            ret[1] = ed;
            return ret;
        }

        public int endRow(int pageNumber) {
            return getRowMargine(pageNumber)[0];
        }

        public int startRow(int pageNumber) {
            return getRowMargine(pageNumber)[1];
        }

        public int getRows() {
            return this.rowsOfScreen;
        }

        /**
         * 내비게이션 바는 처음에 1페이지부터 시작하며 점점 오른쪽으로 갈수록
         * 위치에 맞추어 시작위치가 증가한다. 즉
         * ◀[1][2] 3 [4][5]▶   여기서 4번을 클릭하면
         * ◀[2][3] 4 [5][6]▶   이렇게
         * 이런식으로 현제 페이지가 3에서 4로 증가될 때 맨 앞의 내비게이션
         * 숫자가 같이 증가하게 된다
         */
        public int[] getPageMargine(int pageNumber) {
            int st = 1, ed = pagesOfScreen;
            int[] ret = {st, ed};
            int halfLine = (int) Math.floor(this.pagesOfScreen / 2);
            //시작페이지는 현제페이지에서 표현가능한 페이지수의 반값을 뺀위치이다
            st = pageNumber - halfLine;
            //시작페이지값이 1보다 작은 경우 1부터 시작함
            if (st < 1) {
                st = 1;
            }
            //전체페이지가 표현가능한페이지보다 많은경우
            if (totalPage > pagesOfScreen) {
                ed = st + pagesOfScreen - 1;
                //마지막값이 전체페이지를 넘어가면 시작값은 전체페이지에서
                //표현가능한 페이지갯수를 뺀만큼으로 조정된다.
                if (ed > totalPage) {
                    st = totalPage - pagesOfScreen + 1;
                    ed = totalPage;
                }
            } else {
                //전체페이지가 표현가능한 페이지보다 작으므로 1페이지부터 시작
                st = 1;
                ed = totalPage;
            }
            if (ed == 0) {
                ed = 1;
            }
            ret[0] = st;
            ret[1] = ed;
            return ret;
        }

        public int startPage(int pageNumber) {
            return getPageMargine(pageNumber)[0];
        }

        public int endPage(int pageNumber) {
            return getPageMargine(pageNumber)[1];
        }

        public int nextPage(int pageNumber, int offset) {
            return nextPage(pageNumber + offset);
        }

        public int nextPage(int pageNumber) {
            int ret = pageNumber + 1;
            if (ret > totalPage) ret = totalPage;
            if (ret < 1) ret = 1;
            return ret;
        }

        public int prevPage(int pageNumber, int offset) {
            return prevPage(pageNumber - offset);
        }

        public int prevPage(int pageNumber) {
            int ret = pageNumber - 1;
            if (ret > totalPage) ret = totalPage;
            if (ret < 1) ret = 1;
            return ret;
        }

        public boolean hasNextPage(int pageNumber, int offset) {
            return hasNextPage(pageNumber + offset);
        }

        public boolean hasNextPage(int pageNumber) {
            return pageNumber < totalPage;
        }

        public boolean hasPrevPage(int pageNumber, int offset) {
            return hasPrevPage(pageNumber - offset);
        }

        public boolean hasPrevPage(int pageNumber) {
            return pageNumber > 1;
        }
    }

%>
