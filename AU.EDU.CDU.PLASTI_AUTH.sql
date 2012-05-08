function page_head return varchar2 is
begin
  -- Perfect use case for files in authentication plugins...
  return  q'@  <style>
      body{background:#EEE;margin:0; padding:0;}
      h1.confirm{color:#444; font-size:32px; font-family:arial; text-align:center; margin:20px}
      h2.confirm{font-size:24px; font-family:arial; padding:20px 20px 0 20px; margin-bottom:5px}
      .subheading{font-style:italic; margin-bottom:5px}
      .content-box{
        margin: 10px auto 0px auto;
        border:1px solid #BBB;
        border-radius: 5px;
        background:#FFF;
        position:relative;
        font-size:14px;
        font-family:arial, sans-serif;
        padding:0px 20px 70px 20px;}
      .content-box img{padding:40px;position:relative;float:left}
      .confirmation {padding:20px 0}
      .button-box {position:absolute;float:right;margin:10px 60px; padding:10px;bottom:0;right:0}
      .footer {margin:10px 0; text-align:center;}
      .footer *{font-size:11px; font-family:arial; color:#888; text-align: center;}
      .footer a{color:#222;}
      a.button {
        background-image: linear-gradient(bottom, #888 0%, #CCC 100%);
        background-image: -o-linear-gradient(bottom, #888 0%, #CCC 100%);
        background-image: -moz-linear-gradient(bottom, #888 0%, #CCC 100%);
        background-image: -webkit-linear-gradient(bottom, #888 0%, #CCC 100%);
        background-image: -ms-linear-gradient(bottom, #888 0%, #CCC 100%);
        background-color: #CCC;
        color:#333;
        line-height:24px;
        height:24px;
        padding:5px 10px;
        border-right:1px solid #777;
        border-bottom:1px solid #777;
        text-decoration:none;
        border-radius: 2px;
        font-weight:bold;
        margin-right:10px;
        }
      a.button:hover {
        border:none;
        border-top:1px solid #777;
        border-left:1px solid #777;
        background-image: linear-gradient(top, #888 0%, #CCC 100%);
        background-image: -o-linear-gradient(top, #888 0%, #CCC 100%);
        background-image: -moz-linear-gradient(top, #888 0%, #CCC 100%);
        background-image: -webkit-linear-gradient(top, #888 0%, #CCC 100%);
        background-image: -ms-linear-gradient(top, #888 0%, #CCC 100%);
        background-color: #AAA;
        color:#DDD;
        }
    </style>@';
end page_head;

function fallback_template(p_error varchar2 default NULL, p_title varchar2 default 'Link Confirmation') return varchar2 is
  l_template varchar2(32676);
begin
  l_template := q'@<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang="en" xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com" xmlns:apex="http://apex.oracle.com">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <title>#PLUGIN.TITLE#</title>
  #PLUGIN.HEAD#
</head>
<body>
  <div style="width:640px; margin:0 auto;">
    #PLUGIN.BODY#
  </div>
 <div class="footer">
   <span><i>#PLUGIN.ERROR#</i></span>
 </div>
</body>
</html>
@';
  l_template := replace(l_template,'#PLUGIN.TITLE#',p_title);
  l_template := replace(l_template,'#PLUGIN.HEAD#',page_head());
  l_template := replace(l_template,'#PLUGIN.ERROR#',p_error);
  return l_template;
end;

function populate_template(p_page_id number default null) return varchar2 is
  l_head varchar2(32767);
  l_body varchar2(32767);
  l_foot varchar2(32767);
  l_nav  varchar2(32767); -- TODO: Implement #NAVIGATION_BAR# substitutions... perhaps
begin
  if p_page_id is null then
    return fallback_template;
  elsif OWA_UTIL.GET_CGI_ENV('HTTP_HOST') = 'apex.oracle.com' then
    -- APEX views are too slow on apex.oracle.com to find a page template
    return fallback_template('Using fallback template on apex.oracle.com for performance reasons.');
  end if;

  -- Get the the page template currently in use by p_page_id
  select  pgt.HEADER_TEMPLATE,
          pgt.PAGE_BODY,
          pgt.FOOTER_TEMPLATE,
          pgt.NAVBAR_ENTRY
  into    l_head,
          l_body,
          l_foot,
          l_nav
  from  apex_applications app,
        apex_application_pages page,
        apex_application_templates templ,
        apex_application_temp_page pgt
  where app.APPLICATION_ID = APEX_APPLICATION.G_FLOW_ID
  and   page.APPLICATION_ID = app.APPLICATION_ID
  and   page.page_id = p_page_id
  and   templ.THEME_NUMBER = app.theme_number
  and   templ.TEMPLATE_TYPE = 'Page'
  and   templ.TEMPLATE_NAME = page.PAGE_TEMPLATE
  and   pgt.template_id = templ.template_id;

  -- Populate Head
  l_head := replace(l_head, '#TITLE#', 'Link Confirmation');
  l_head := replace(l_head, '#HEAD#', page_head());
  l_head := regexp_replace(l_head,
    '#(NAVIGATION_BAR|FORM_OPEN|NOTIFICATION_MESSAGE|SUCCESS_MESSAGE|GLOBAL_NOTIFICATION|JAVASCRIPT_CODE|ONLOAD)#');
  l_head := apex_plugin_util.replace_substitutions(l_head);
  
  -- Populate Body
  l_body := replace(l_body, '#BOX_BODY#', '#PLUGIN.BODY#');
  l_body := regexp_replace(l_body,
  '#(TAB_CELLS|PARENT_TAB_CELLS|TITLE|WELCOME_USER|NAVIGATION_BAR|APP_VERSION|FORM_OPEN|NOTIFICATION_MESSAGE|SUCCESS_MESSAGE|GLOBAL_NOTIFICATION|FORM_CLOSE|LOGO|ACCESSABILITY_TOGGLE|FEEDBACK|REGION_POSITION_0.)#');
  l_body := apex_plugin_util.replace_substitutions(l_body);
  
  -- Populate Footer
  l_foot := regexp_replace(l_foot,
  '#(FORM_CLOSE|JAVASCRIPT_CODE|CUSTOMIZE|APP_VERSION|REGION_POSITION_0.)#');
  l_foot := apex_plugin_util.replace_substitutions(l_foot);

  return  l_head || l_body || l_foot;
exception
  when NO_DATA_FOUND then
    return fallback_template('Error: Could not find page template of specified page (ID #'||p_page_id||').');
  when TOO_MANY_ROWS then
    return fallback_template('Error: Specified page (ID #'||p_page_id||') has multiple page templates.');
end;

function session_recycler (
  p_authentication in apex_plugin.t_authentication,
  p_plugin         in apex_plugin.t_plugin,
  p_is_public_page in boolean )
  return apex_plugin.t_authentication_sentry_result
is
  l_session_recycle   varchar2(1)     := p_authentication.attribute_02;
  l_whitelist         varchar2(32767) := p_authentication.attribute_03;
  l_title             varchar2(32767) := p_authentication.attribute_04;
  l_confirmation      varchar2(32767) := p_authentication.attribute_05;
  l_mimic_page_id     number          := p_authentication.attribute_06;
  l_body              varchar2(32767) := p_authentication.attribute_07;
  l_seamless_mode     varchar2(1)     := p_authentication.attribute_08;
  l_error_title       varchar2(32767) := p_authentication.attribute_09;
  l_error_message     varchar2(32767) := p_authentication.attribute_10;
  l_error_body        varchar2(32767) := p_authentication.attribute_11;
  l_cancel_url        varchar2(32767) := p_authentication.attribute_12;
  l_cookie_session_id number;
  l_user              APEX_WORKSPACE_SESSIONS.USER_NAME%TYPE;
  l_result            apex_plugin.t_authentication_sentry_result;
  l_valid             boolean;
  l_query_string      varchar2(32767) := null;
  l_app               varchar2(30)    := null;
  l_page              varchar2(30)    := null;
  l_session           varchar2(256)   := null;
  l_tail              varchar2(32767) := null;
  l_footer            clob;
  l_app_name          varchar2(32767) := null;
  l_notification_page varchar2(32767) := null;
  l_debug_log         varchar2(32767) := null;
  
  procedure dbg(p_str in varchar2) is
  begin
    l_debug_log := l_debug_log || p_str || chr(10);
    apex_application.debug('plasti-auth.session_recycler: ' || p_str);
  end dbg;
  
  function is_recycle_permitted(p_session_recycle varchar2,
                                p_page_whitelist  varchar2,
                                p_page_id         number) return boolean is
  begin
    -- Returns true if permitted to recycle sessions on this page
    if p_page_id IS NULL or p_page_whitelist is null THEN RETURN
      FALSE; --Sanity check
    end if;
    
    -- Regex will match when exact page number occurs in a comma separated list
    return (p_session_recycle = 'Y' and
            regexp_like(p_page_whitelist,'(^|,)'||p_page_id||'(,|$)'));
  end is_recycle_permitted;
  
  function is_recycle_candidate(session_id number) return boolean is
  begin
    -- Returns true if the cookie session appears a safe alternative
    if session_id is null then
      return false;
    elsif :SESSION is null then
      return true;
    elsif :SESSION != session_id then
      return true;
    end if;
    return false;
  end is_recycle_candidate;
  
  function get_session_user(session_id number) return varchar2 is
    l_user APEX_WORKSPACE_SESSIONS.USER_NAME%TYPE;
  begin
    select user_name
      into l_user
      from APEX_WORKSPACE_SESSIONS
     where nvl(user_name,'nobody') != 'nobody'
       and apex_session_id = session_id;
    return l_user;
  exception when NO_DATA_FOUND then
    return null;
  end get_session_user;
begin

  -- Public page check
  if p_is_public_page = true then
    l_result.is_valid := true;
    dbg('public page - sentry succeeded');
    -- TODO: this will essentially nuke our old session, is this a problem?
    -- Will make this behaviour configurable (proposed feature listed on my github wiki).
    return l_result;
  end if;

  -- Check authenticated session
  l_result.is_valid := (apex_custom_auth.is_session_valid and
                        nvl(:APP_USER,'nobody') != 'nobody');

  if (not l_result.is_valid) then
    if (is_recycle_permitted(l_session_recycle, l_whitelist, :APP_PAGE_ID)) then
      dbg('user unauthenticated - session recycle permitted on page #'||:APP_PAGE_ID);

      l_cookie_session_id := APEX_CUSTOM_AUTH.GET_SESSION_ID_FROM_COOKIE;

      if is_recycle_candidate(l_cookie_session_id) then
        -- Validate cookie session and get username
        l_user := get_session_user(l_cookie_session_id);
        if l_user is not null then
          l_result.is_valid := true;
        else
          l_result.is_valid := false;
          dbg('cookie session invalid - sentry failed');
        end if;

        if l_result.is_valid then
          dbg('recycling session from cookie');

          if l_confirmation is null then
            -- Recycle session
            APEX_CUSTOM_AUTH.DEFINE_USER_SESSION (
              p_user       => l_user,
              p_session_id => l_cookie_session_id);
              
            -- Clear REQUEST to reduce risk of DML via external links
            APEX_APPLICATION.G_REQUEST := NULL; 
          else
            -- Undocumented functions that apparently break apart the query string...
            l_query_string := WWV_FLOW_UTILITIES.URL_DECODE2(OWA_UTIL.GET_CGI_ENV('QUERY_STRING'));
            WWV_FLOW_UTILITIES.PARSE_QUERY_STRING(l_query_string,l_app,l_page,l_session,l_tail); 

            -- Clear REQUEST to reduce risk of DML via external links
            -- Regex will match all character that are not ":" from the begining of the string
            -- so the regexp_replace essentially clears the REQUEST section of the URL
            l_tail := regexp_replace(l_tail,'^[^:]+');
            
            -- Force seamless mode on cancel link requests
            if REGEXP_LIKE(l_cancel_url, 'f?'||OWA_UTIL.GET_CGI_ENV('QUERY_STRING')||'$') then
              -- TODO: extend the regexp to check path and domain components also match
              l_seamless_mode := 'Y';
            end if;
            
            if l_seamless_mode != 'Y' then
              -- Display confirmation page with a link to the requested page
              dbg('user must confirm this action - rendering confirmation page and halting apex');
              
              -- Find the app name for template substitutions
              select application_name into l_app_name
              from apex_applications where application_id = :app_id;
              
              -- Build the confirmation page
              l_body := REPLACE(l_body, '#PLUGIN.APP_NAME#', l_app_name);
              l_body := REPLACE(l_body, '#PLUGIN.TITLE#', l_title);
              l_body := REPLACE(l_body, '#PLUGIN.CONTENT#', l_confirmation);
              l_body := REPLACE(l_body, '#PLUGIN.REDIRECT_URL#', 'f?p='||:APP_ID||':'||l_page||':'||l_cookie_session_id||':'||l_tail);
              l_body := REPLACE(l_body, '#PLUGIN.CANCEL_URL#', l_cancel_url);
              l_notification_page := populate_template(l_mimic_page_id);
              l_notification_page := REPLACE(l_notification_page, '#PLUGIN.BODY#', l_body);

              -- Redirect to the old session (via the confirmation page)
              htp.init;
              htp.p(l_notification_page);

              --TODO: Debug log here seems pretty redundand as it all gets logged in APEX anyway
              htp.p('<!-- Debug Log...');
              htp.p(l_debug_log);
              htp.p('-->');
            else 
              -- Redirect to the old session the good old fashion way
              htp.init;
              owa_util.redirect_url('f?p='||:APP_ID||':'||l_page||':'||l_cookie_session_id||':'||l_tail);
            end if;
            apex_application.g_unrecoverable_error := true;
          end if;
        end if;
      else
        l_result.is_valid := false; -- Nothing to recycle
        dbg('no session to recycle - sentry failed');
      end if;
    else
      dbg('session recycling not permitted - sentry failed');
    
      -- Recycle not permitted, check if we should render the error page
      if APEX_APPLICATION.G_REQUEST = 'NEW_SESSION' then
        APEX_APPLICATION.G_REQUEST := NULL;
        dbg('URL explicitly requests to kill the cookie session');
      elsif l_seamless_mode != 'Y' then
        l_cookie_session_id := APEX_CUSTOM_AUTH.GET_SESSION_ID_FROM_COOKIE;
        if is_recycle_candidate(l_cookie_session_id) then
          -- Validate cookie session and get username
          l_user := get_session_user(l_cookie_session_id);
          if l_user is not null then
            dbg('rendering error page and halting apex');
            
            -- Rebuild the URL with a special REQUEST variable used to kill the cookie session
            l_query_string := WWV_FLOW_UTILITIES.URL_DECODE2(OWA_UTIL.GET_CGI_ENV('QUERY_STRING'));
            WWV_FLOW_UTILITIES.PARSE_QUERY_STRING(l_query_string,l_app,l_page,l_session,l_tail); 
            l_tail := 'NEW_SESSION'||regexp_replace(l_tail,'^[^:]+');
            
            -- Find the app name for template substitutions
            select application_name into l_app_name
            from apex_applications where application_id = :app_id;
            
            -- Build the error page
            l_error_body := REPLACE(l_error_body, '#PLUGIN.APP_NAME#', l_app_name);
            l_error_body := REPLACE(l_error_body, '#PLUGIN.TITLE#', l_error_title);
            l_error_body := REPLACE(l_error_body, '#PLUGIN.CONTENT#', l_error_message);
            l_error_body := REPLACE(l_error_body, '#PLUGIN.REDIRECT_URL#', 'f?p='||:APP_ID||':'||l_page||':'||l_session||':'||l_tail);
            l_error_body := REPLACE(l_error_body, '#PLUGIN.CANCEL_URL#', l_cancel_url);
            l_notification_page := populate_template(l_mimic_page_id);
            l_notification_page := REPLACE(l_notification_page, '#PLUGIN.BODY#', l_error_body);
            
            -- Render and halt
            htp.init;
            htp.p(l_notification_page);
            l_result.is_valid := true;
            apex_application.g_unrecoverable_error := true;
          end if;
        end if;
      end if;
    end if;
  else
    dbg('session valid');
  end if;
  
  return l_result;
end session_recycler;

function dynamic_authentication (
  p_authentication in apex_plugin.t_authentication,
  p_plugin         in apex_plugin.t_plugin,
  p_password       in varchar2 )
  return apex_plugin.t_authentication_auth_result
is
  l_auth_func   varchar2(255) := p_authentication.attribute_01;
  l_auth_return integer;
  l_dynsql      VARCHAR2(32767);
  l_username    varchar2(255) := p_authentication.username;
  l_result      apex_plugin.t_authentication_auth_result;
  plsql_exception  exception;
  pragma        exception_init(plsql_exception,-6550);
begin
  l_dynsql :=  'declare
                  l_result boolean;'||
                  p_authentication.plsql_code||'
                begin
                  l_result := '||dbms_assert.qualified_sql_name(l_auth_func)||'(:1, :2);
                     :3 := sys.diutil.bool_to_int(l_result);
                end;';
  execute immediate l_dynsql using in l_username, in p_password, out l_auth_return;

  l_result.is_authenticated := sys.diutil.int_to_bool(l_auth_return);
  return l_result;
exception
  when plsql_exception then
    raise_application_error( -20001,
      'Authentication Plugin: authentication function must be of the format '||
      '"Function_Name(p_username varchar2, p_password varchar2) return boolean"');
  when others then
    raise;
end dynamic_authentication;
