set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040100 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,59821147419987601273));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2011.02.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,64083);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/authentication_type/plasti_auth_cdu_edu_au
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 59826725171557382866 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'AUTHENTICATION TYPE'
 ,p_name => 'PLASTI_AUTH.CDU.EDU.AU'
 ,p_display_name => 'Plasti-Auth'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'function sample_template return varchar2 is'||unistr('\000a')||
'begin'||unistr('\000a')||
'return'||unistr('\000a')||
'''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">''||chr(10)||'||unistr('\000a')||
'''<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">''||chr(10)||'||unistr('\000a')||
'''<head>''||chr(10)||'||unistr('\000a')||
'''  <meta http-equiv="Content-Type" content="text/html; ch'||
'arset=utf-8"/>''||chr(10)||'||unistr('\000a')||
'''  <title>External Link Confirmation</title>''||chr(10)||'||unistr('\000a')||
'''  <style>''||chr(10)||'||unistr('\000a')||
'''  body{background:#EEE;margin:0; padding:0;}''||chr(10)||'||unistr('\000a')||
'''  h1{color:#444; font-size:32px; font-family:arial; text-align:center; margin:20px}''||chr(10)||'||unistr('\000a')||
'''  h2{font-size:24px; font-family:arial; padding:20px 20px 0 20px; margin-bottom:5px}''||chr(10)||'||unistr('\000a')||
'''  .subheading{font-style:italic; margin'||
'-bottom:5px}''||chr(10)||'||unistr('\000a')||
'''  .content-box{''||chr(10)||'||unistr('\000a')||
'''    margin: 10px auto 0px auto;''||chr(10)||'||unistr('\000a')||
'''    border:1px solid #BBB;''||chr(10)||'||unistr('\000a')||
'''    border-radius: 5px;''||chr(10)||'||unistr('\000a')||
'''    width:880px;''||chr(10)||'||unistr('\000a')||
'''    background:#FFF;''||chr(10)||'||unistr('\000a')||
'''    position:relative;''||chr(10)||'||unistr('\000a')||
'''    font-size:14px;''||chr(10)||'||unistr('\000a')||
'''    font-family:arial, sans-serif;''||chr(10)||'||unistr('\000a')||
'''    padding:0px 20px 70px 20px;}''||chr(10)'||
'||'||unistr('\000a')||
'''  .content-box img{padding:40px;position:relative;float:left}''||chr(10)||'||unistr('\000a')||
'''  .confirmation {padding:20px 0}''||chr(10)||'||unistr('\000a')||
'''  .button-box {position:absolute;float:right;margin:10px 60px; padding:10px;bottom:0;right:0}''||chr(10)||'||unistr('\000a')||
'''  .footer {margin:10px 0; text-align:center;}''||chr(10)||'||unistr('\000a')||
'''  .footer *{font-size:11px; font-family:arial; color:#888; text-align: center;}''||chr(10)||'||unistr('\000a')||
'''  .footer a{colo'||
'r:#222;}''||chr(10)||'||unistr('\000a')||
'''  a.button {''||chr(10)||'||unistr('\000a')||
'''    background-image: linear-gradient(bottom, #888 0%, #CCC 100%);''||chr(10)||'||unistr('\000a')||
'''    background-image: -o-linear-gradient(bottom, #888 0%, #CCC 100%);''||chr(10)||'||unistr('\000a')||
'''    background-image: -moz-linear-gradient(bottom, #888 0%, #CCC 100%);''||chr(10)||'||unistr('\000a')||
'''    background-image: -webkit-linear-gradient(bottom, #888 0%, #CCC 100%);''||chr(10)||'||unistr('\000a')||
'''    background-i'||
'mage: -ms-linear-gradient(bottom, #888 0%, #CCC 100%);''||chr(10)||'||unistr('\000a')||
'''    background-color: #CCC;''||chr(10)||'||unistr('\000a')||
'''    color:#333;''||chr(10)||'||unistr('\000a')||
'''    line-height:24px;''||chr(10)||'||unistr('\000a')||
'''    height:24px;''||chr(10)||'||unistr('\000a')||
'''    padding:5px 10px;''||chr(10)||'||unistr('\000a')||
'''    border-right:1px solid #777;''||chr(10)||'||unistr('\000a')||
'''    border-bottom:1px solid #777;''||chr(10)||'||unistr('\000a')||
'''    text-decoration:none;''||chr(10)||'||unistr('\000a')||
'''    border-radius: 2px;''||chr('||
'10)||'||unistr('\000a')||
'''    font-weight:bold;''||chr(10)||'||unistr('\000a')||
'''    margin-right:10px;''||chr(10)||'||unistr('\000a')||
'''    }''||chr(10)||'||unistr('\000a')||
'''  a.button:hover {''||chr(10)||'||unistr('\000a')||
'''    border:none;''||chr(10)||'||unistr('\000a')||
'''    border-top:1px solid #777;''||chr(10)||'||unistr('\000a')||
'''    border-left:1px solid #777;''||chr(10)||'||unistr('\000a')||
'''    background-image: linear-gradient(top, #888 0%, #CCC 100%);''||chr(10)||'||unistr('\000a')||
'''    background-image: -o-linear-gradient(top, #888 0%, #CCC 100%);''||chr(10'||
')||'||unistr('\000a')||
'''    background-image: -moz-linear-gradient(top, #888 0%, #CCC 100%);''||chr(10)||'||unistr('\000a')||
'''    background-image: -webkit-linear-gradient(top, #888 0%, #CCC 100%);''||chr(10)||'||unistr('\000a')||
'''    background-image: -ms-linear-gradient(top, #888 0%, #CCC 100%);''||chr(10)||'||unistr('\000a')||
'''    background-color: #AAA;''||chr(10)||'||unistr('\000a')||
'''    color:#DDD;''||chr(10)||'||unistr('\000a')||
'''    }''||chr(10)||'||unistr('\000a')||
'''  </style>''||chr(10)||'||unistr('\000a')||
'''</head>''||chr(10)||'||unistr('\000a')||
'''<body>''||chr('||
'10)||'||unistr('\000a')||
'''  <h1>#PLUGIN.APP_NAME#</h1>''||chr(10)||'||unistr('\000a')||
'''  <div class="content-box">''||chr(10)||'||unistr('\000a')||
'''    <img height="64" width="64" src="&IMAGE_PREFIX.eba/img/eba_warning_icons.png"><h2>External Link Confirmation</h2>''||chr(10)||'||unistr('\000a')||
'''    <span class="subheading">This link is attempting to join your existing session. Only continue if the source of the link is trusted.</span><br/>''||chr(10)||'||unistr('\000a')||
'''    <div class="co'||
'nfirmation">#PLUGIN.CONTENT#</div>''||chr(10)||'||unistr('\000a')||
'''    <div class="button-box"><p><a class="button" href="#PLUGIN.REDIRECT_URL#">''||chr(10)||'||unistr('\000a')||
'''      <span>Link Source Trusted</span></a>&nbsp;<a class="button" href="about:blank">''||chr(10)||'||unistr('\000a')||
'''      <span>Cancel</span></a></p>''||chr(10)||'||unistr('\000a')||
'''    </div>''||chr(10)||'||unistr('\000a')||
'''  </div>''||chr(10)||'||unistr('\000a')||
''' <div class="footer">''||chr(10)||'||unistr('\000a')||
'''   <span>Lorem ipsum footer dolor'||
': consectetur adipiscing elit. <a href="about:blank">Lorum Ispsum Linksum&APP_USER.</a></span>''||chr(10)||'||unistr('\000a')||
''' </div>''||chr(10)||'||unistr('\000a')||
'''</body>''||chr(10)||'||unistr('\000a')||
'''</html>''||chr(10);'||unistr('\000a')||
'end;'||unistr('\000a')||
''||unistr('\000a')||
'function session_recycler ('||unistr('\000a')||
'  p_authentication in apex_plugin.t_authentication,'||unistr('\000a')||
'  p_plugin         in apex_plugin.t_plugin,'||unistr('\000a')||
'  p_is_public_page in boolean )'||unistr('\000a')||
'  return apex_plugin.t_authentication_sentry_result'||unistr('\000a')||
'is'||unistr('\000a')||
'  l_session_re'||
'cycle   varchar2(1) := p_authentication.attribute_02;'||unistr('\000a')||
'  l_whitelist         varchar2(32767) := p_authentication.attribute_03;'||unistr('\000a')||
'  l_confirmation      varchar2(32767) := p_authentication.attribute_04;'||unistr('\000a')||
'  l_cookie_session_id number;'||unistr('\000a')||
'  l_user              APEX_WORKSPACE_SESSIONS.USER_NAME%TYPE;'||unistr('\000a')||
'  l_result            apex_plugin.t_authentication_sentry_result;'||unistr('\000a')||
'  l_valid             boolean;'||unistr('\000a')||
'  l_query_str'||
'ing      varchar2(32767) := null;'||unistr('\000a')||
'  l_app               varchar2(30)    := null;'||unistr('\000a')||
'  l_page              varchar2(30)    := null;'||unistr('\000a')||
'  l_session           varchar2(256)   := null;'||unistr('\000a')||
'  l_tail              varchar2(32767) := null;'||unistr('\000a')||
'  l_footer            clob;'||unistr('\000a')||
'  l_app_name          varchar2(32767) := null;'||unistr('\000a')||
'  l_notification_page varchar2(32767) := null;'||unistr('\000a')||
'  l_debug_log         varchar2(32767) := null;'||unistr('\000a')||
'  '||unistr('\000a')||
'  proc'||
'edure dbg(p_str in varchar2) is'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    l_debug_log := l_debug_log || p_str || chr(10);'||unistr('\000a')||
'    apex_application.debug(''plasti-auth.session_recycler: '' || p_str);'||unistr('\000a')||
'  end dbg;'||unistr('\000a')||
'  '||unistr('\000a')||
'  function is_recycle_permitted(p_session_recycle varchar2,'||unistr('\000a')||
'                                p_page_whitelist  varchar2,'||unistr('\000a')||
'                                p_page_id         number) return boolean is'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    -- Returns true'||
' if permitted to recycle sessions on this page'||unistr('\000a')||
'    if p_page_id IS NULL or p_page_whitelist is null THEN RETURN'||unistr('\000a')||
'      FALSE; --Sanity check'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'    -- Regex will match when exact page number occurs in a comma separated list'||unistr('\000a')||
'    return (p_session_recycle = ''Y'' and'||unistr('\000a')||
'            regexp_like(p_page_whitelist,''(^|,)''||p_page_id||''(,|$)''));'||unistr('\000a')||
'  end is_recycle_permitted;'||unistr('\000a')||
'  '||unistr('\000a')||
'  function is_recycle_can'||
'didate(session_id varchar2) return boolean is'||unistr('\000a')||
'  begin'||unistr('\000a')||
'    -- Returns true if the cookie session appears a safe alternative'||unistr('\000a')||
'    if session_id is null then'||unistr('\000a')||
'      return false;'||unistr('\000a')||
'    elsif :SESSION is null then'||unistr('\000a')||
'      return true;'||unistr('\000a')||
'    elsif :SESSION != session_id then'||unistr('\000a')||
'      return true;'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'    return false;'||unistr('\000a')||
'  end is_recycle_candidate;'||unistr('\000a')||
'begin'||unistr('\000a')||
'  -- Public page check'||unistr('\000a')||
'  if p_is_public_page = true th'||
'en'||unistr('\000a')||
'    l_result.is_valid := true;'||unistr('\000a')||
'    dbg(''public page - sentry succeeded'');'||unistr('\000a')||
'    -- TODO: this will essentially nuke our old session, is this a problem?'||unistr('\000a')||
'    -- Could make this behaviour configurable.'||unistr('\000a')||
'    return l_result;'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  -- Check authenticated session'||unistr('\000a')||
'  l_result.is_valid := (apex_custom_auth.is_session_valid and'||unistr('\000a')||
'                        nvl(:APP_USER,''nobody'') != ''nobody'');'||unistr('\000a')||
''||unistr('\000a')||
'  if (l_re'||
'sult.is_valid = false and'||unistr('\000a')||
'      is_recycle_permitted(l_session_recycle, l_whitelist, :APP_PAGE_ID)) then'||unistr('\000a')||
'    dbg(''user unauthenticated - session recycle permitted on page #''||:APP_PAGE_ID);'||unistr('\000a')||
''||unistr('\000a')||
'    l_cookie_session_id := APEX_CUSTOM_AUTH.GET_SESSION_ID_FROM_COOKIE;'||unistr('\000a')||
''||unistr('\000a')||
'    if is_recycle_candidate(l_cookie_session_id) then'||unistr('\000a')||
'      -- Validate cookie session and get username'||unistr('\000a')||
'      begin'||unistr('\000a')||
'        select user_'||
'name'||unistr('\000a')||
'          into l_user'||unistr('\000a')||
'          from APEX_WORKSPACE_SESSIONS'||unistr('\000a')||
'         where nvl(user_name,''nobody'') != ''nobody'''||unistr('\000a')||
'           and apex_session_id = l_cookie_session_id;'||unistr('\000a')||
'        l_result.is_valid := true;'||unistr('\000a')||
'      exception when NO_DATA_FOUND then'||unistr('\000a')||
'        l_result.is_valid := false;'||unistr('\000a')||
'        dbg(''cookie session invalid - sentry failed'');'||unistr('\000a')||
'      end;'||unistr('\000a')||
''||unistr('\000a')||
'      if l_result.is_valid then'||unistr('\000a')||
'        dbg(''recycl'||
'ing session from cookie'');'||unistr('\000a')||
''||unistr('\000a')||
'        if l_confirmation is null then'||unistr('\000a')||
'          -- Recycle session'||unistr('\000a')||
'          APEX_CUSTOM_AUTH.DEFINE_USER_SESSION ('||unistr('\000a')||
'            p_user       => l_user,'||unistr('\000a')||
'            p_session_id => l_cookie_session_id);'||unistr('\000a')||
'            '||unistr('\000a')||
'          -- Clear REQUEST to reduce risk of DML via external links'||unistr('\000a')||
'          APEX_APPLICATION.G_REQUEST := NULL; '||unistr('\000a')||
'        else'||unistr('\000a')||
'          -- Display confirm'||
'ation page with a link to the requested page'||unistr('\000a')||
'          dbg(''user must confirm this action - rendering confirmation page and halting apex'');'||unistr('\000a')||
''||unistr('\000a')||
'          -- Undocumented functions that apparently break apart the query string...'||unistr('\000a')||
'          l_query_string := WWV_FLOW_UTILITIES.URL_DECODE2(OWA_UTIL.GET_CGI_ENV(''QUERY_STRING''));'||unistr('\000a')||
'          WWV_FLOW_UTILITIES.PARSE_QUERY_STRING(l_query_string,l_app,l_page,l'||
'_session,l_tail); '||unistr('\000a')||
''||unistr('\000a')||
'          -- Clear REQUEST to reduce risk of DML via external links'||unistr('\000a')||
'          -- Regex will match all character that are not ":" from the begining of the string'||unistr('\000a')||
'          -- so the regexp_replace essentially clears the REQUEST section of the URL'||unistr('\000a')||
'          l_tail := regexp_replace(l_tail,''^[^:]+'');'||unistr('\000a')||
''||unistr('\000a')||
'          -- Find the app name for template substitutions'||unistr('\000a')||
'          select appli'||
'cation_name into l_app_name'||unistr('\000a')||
'          from apex_applications where application_id = :app_id;'||unistr('\000a')||
''||unistr('\000a')||
'          l_notification_page := sample_template;'||unistr('\000a')||
'          l_notification_page := REPLACE(l_notification_page, ''#PLUGIN.APP_NAME#'', l_app_name);'||unistr('\000a')||
'          l_notification_page := REPLACE(l_notification_page, ''#PLUGIN.CONTENT#'', l_confirmation);'||unistr('\000a')||
'          l_notification_page := REPLACE(l_notification_page,'||
' ''#PLUGIN.REDIRECT_URL#'', ''f?p=''||:APP_ID||'':''||l_page||'':''||l_cookie_session_id||'':''||l_tail);'||unistr('\000a')||
''||unistr('\000a')||
'          --Redirect to the old session (via confirmation page)'||unistr('\000a')||
'          htp.init;'||unistr('\000a')||
'          --owa_util.redirect_url(''f?p=''||:APP_ID||'':''||l_page||'':''||l_cookie_session_id||'':''||l_tail);'||unistr('\000a')||
'          htp.p(l_notification_page);'||unistr('\000a')||
'          '||unistr('\000a')||
'          --TODO: Debug log here seems pretty redundand as it all '||
'gets logged in APEX anyway'||unistr('\000a')||
'          htp.p(''<!-- Debug Log'');'||unistr('\000a')||
'          htp.p(l_debug_log);'||unistr('\000a')||
'          htp.p(''-->'');'||unistr('\000a')||
'          apex_application.g_unrecoverable_error := true;'||unistr('\000a')||
'        end if;'||unistr('\000a')||
'      end if;'||unistr('\000a')||
'    else'||unistr('\000a')||
'      l_result.is_valid := false; -- Nothing to recycle'||unistr('\000a')||
'      dbg(''no session to recycle - sentry failed'');'||unistr('\000a')||
'    end if;'||unistr('\000a')||
'  else'||unistr('\000a')||
'    dbg(''session either valid or recycling not permitted'');'||unistr('\000a')||
''||
'    --TODO: Results be self evident, don''t know if it''s even worth logging this'||unistr('\000a')||
'  end if;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_result;'||unistr('\000a')||
'end session_recycler;'||unistr('\000a')||
''||unistr('\000a')||
'function dynamic_authentication ('||unistr('\000a')||
'  p_authentication in apex_plugin.t_authentication,'||unistr('\000a')||
'  p_plugin         in apex_plugin.t_plugin,'||unistr('\000a')||
'  p_password       in varchar2 )'||unistr('\000a')||
'  return apex_plugin.t_authentication_auth_result'||unistr('\000a')||
'is'||unistr('\000a')||
'  l_auth_func   varchar2(255) := p_authentication.a'||
'ttribute_01;'||unistr('\000a')||
'  l_auth_return integer;'||unistr('\000a')||
'  l_dynsql      VARCHAR2(32767);'||unistr('\000a')||
'  l_username    varchar2(255) := p_authentication.username;'||unistr('\000a')||
'  l_result      apex_plugin.t_authentication_auth_result;'||unistr('\000a')||
'  plsql_exception  exception;'||unistr('\000a')||
'  pragma        exception_init(plsql_exception,-6550);'||unistr('\000a')||
'begin'||unistr('\000a')||
'  l_dynsql :=  ''declare'||unistr('\000a')||
'                  l_result boolean;''||'||unistr('\000a')||
'                  p_authentication.plsql_code||'''||unistr('\000a')||
'        '||
'        begin'||unistr('\000a')||
'                  l_result := ''||dbms_assert.qualified_sql_name(l_auth_func)||''(:1, :2);'||unistr('\000a')||
'                     :3 := sys.diutil.bool_to_int(l_result);'||unistr('\000a')||
'                end;'';'||unistr('\000a')||
'  execute immediate l_dynsql using in l_username, in p_password, out l_auth_return;'||unistr('\000a')||
''||unistr('\000a')||
'  l_result.is_authenticated := sys.diutil.int_to_bool(l_auth_return);'||unistr('\000a')||
'  return l_result;'||unistr('\000a')||
'exception'||unistr('\000a')||
'  when plsql_exception then'||unistr('\000a')||
' '||
'   raise_application_error( -20001,'||unistr('\000a')||
'      ''Authentication Plugin: authentication function must be of the format ''||'||unistr('\000a')||
'      ''"Function_Name(p_username varchar2, p_password varchar2) return boolean"'');'||unistr('\000a')||
'  when others then'||unistr('\000a')||
'    raise;'||unistr('\000a')||
'end dynamic_authentication;'||unistr('\000a')||
''
 ,p_session_sentry_function => 'session_recycler'
 ,p_authentication_function => 'dynamic_authentication'
 ,p_standard_attributes => 'INVALID_SESSION'
 ,p_substitute_attributes => true
 ,p_version_identifier => '0.2.01'
 ,p_about_url => 'https://github.com/CaptEgg/Plasti-Auth'
 ,p_plugin_comment => 'PL/SQL code embedded in this plugin is publicly available for use as per MIT'||unistr('\000a')||
'licence...'||unistr('\000a')||
''||unistr('\000a')||
'The MIT License (MIT)'||unistr('\000a')||
'Copyright © 2012 Charles Darwin University, http://www.cdu.edu.au/'||unistr('\000a')||
''||unistr('\000a')||
'Permission is hereby granted, free of charge, to any person obtaining a copy'||unistr('\000a')||
'of this software and associated documentation files (the "Software"), to deal'||unistr('\000a')||
'in the Software without restriction, including without limitation the rights'||unistr('\000a')||
'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell'||unistr('\000a')||
'copies of the Software, and to permit persons to whom the Software is'||unistr('\000a')||
'furnished to do so, subject to the following conditions:'||unistr('\000a')||
''||unistr('\000a')||
'The above copyright notice and this permission notice shall be included in'||unistr('\000a')||
'all copies or substantial portions of the Software.'||unistr('\000a')||
''||unistr('\000a')||
'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR'||unistr('\000a')||
'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,'||unistr('\000a')||
'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE'||unistr('\000a')||
'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER'||unistr('\000a')||
'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,'||unistr('\000a')||
'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN'||unistr('\000a')||
'THE SOFTWARE.'||unistr('\000a')||
''
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 59826841468479352973 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 59826725171557382866 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'Authentication Function Name'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_help_text => '<p>Same format as custom authentication scheme, enter here the name of a function defined as such:</p>'||unistr('\000a')||
'<pre>function my_authentication ('||unistr('\000a')||
'  p_username in varchar2,'||unistr('\000a')||
'  p_password in varchar2 )'||unistr('\000a')||
'return boolean</pre>'||unistr('\000a')||
''||unistr('\000a')||
'<p>In this example, you would enter "my_authentication" into this field.</p>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 59826844669536504686 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 59826725171557382866 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Enable Session Recycling'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => true
 ,p_default_value => 'N'
 ,p_is_translatable => false
 ,p_help_text => '<p>Should the session stored in the browser cookie attempt to be activated before sending a user to the login page? Enabling this option generally comes with risks.</p>'||unistr('\000a')||
''||unistr('\000a')||
'<p>External links into the system may be generated by an email notification or shared amongst colleagues. By default, such external links will trigger a new session to be created. The old session cookie is lost as soon as the login screen is displayed leaving the user with no way to recover their existing session.</p>'||unistr('\000a')||
''||unistr('\000a')||
'<p>Enabling session recycling avoids the need for the user to log in when clicking such links, but can also expose Cross-site Request Forgery vulnerabilities (CSRF). For this reason a whitelist of pages permitted for external linking must be filled in and any REQUEST variable passed in such links will be ignored to further reduce the risk of inadvertent DML from clicking a link.</p>'||unistr('\000a')||
''||unistr('\000a')||
'<p>IMPORTANT: To guard against CSRF, do not place DML page processes on whitelisted pages unless they are conditional on the REQUEST variable either explicitly or due to button submit conditions.</p>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 59826847762572900000 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 59826725171557382866 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Page Whitelist - Session Recycling'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 59826844669536504686 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => '<p>Comma separated list of page numbers to permit session recycling.</p>'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 59826909876641420182 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 59826725171557382866 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Confirmation Page Content'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_default_value => 'Only trust links shared by collegues or legitimate notification emails.'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 59826844669536504686 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => 'Y'
 ,p_help_text => '<p>This message will be displayed as a warning to the user before confirming this operation is legitimate.</p>'
  );
null;
 
end;
/

commit;
begin 
execute immediate 'begin dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
