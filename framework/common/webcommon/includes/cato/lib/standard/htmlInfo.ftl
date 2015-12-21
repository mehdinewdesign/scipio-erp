<#--
* 
* Informational/notification element HTML template include, standard Cato markup.
*
* Included by htmlTemplate.ftl.
*
* NOTE: May have implicit dependencies on other parts of Cato API.
*
-->

<#-- 
*************
* Modal
************
  * Usage Example *  
    <@modal id="dsadsa" attr="" >
        Modal Content 
    </@modal>        
            
  * Parameters *
    id              = set id (required)
    label           = set anchor text (required)
    icon            = generates icon inside the link (Note: has to be the full set of classes, e.g. "fa fa-fw fa-info")
-->
<#assign modal_defaultArgs = {
  "id":"", "label":"", "href":"", "icon":""
}>
<#macro modal args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.modal_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <@modal_markup id=id label=label href=href icon=icon origArgs=origArgs><#nested></@modal_markup>
</#macro>

<#-- @modal main markup - theme override -->
<#macro modal_markup id="" label="" href="" icon="" origArgs={} catchArgs...>
  <a href="#" data-reveal-id="${id}_modal"<#if href?has_content> data-reveal-ajax="${href!}"</#if>><#if icon?has_content><i class="${icon!}"></i> </#if>${label}</a>
  <div id="${id}_modal" class="${styles.modal_wrap!}" data-reveal>
    <#nested>
    <a class="close-reveal-modal">&#215;</a>
  </div>
</#macro>

<#-- 
*************
* Alert box
************
Alert box for messages that should grab user attention.
NOTE: Should avoid using this for regular, common inlined message results such as "no records found" unless
it's an unexpected result, error or one that requires user action. See other macros such as @resultMsg and @errorMsg.

  * Usage Example *  
    <@alert type="info">
        This is an alert!
    </@alert>            
                    
  * Parameters *
    type           = (info|success|warning|secondary|alert|error), default info
    class          = classes or additional classes for nested container
                     supports prefixes:
                       "+": causes the classes to append only, never replace defaults (same logic as empty string "")
                       "=": causes the class to replace non-essential defaults (same as specifying a class name directly)
-->
<#assign alert_defaultArgs = {
  "type":"info", "class":"", "id":""
}>
<#macro alert args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.alert_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <#local typeClass = "alert_type_${type!}"/>
  <#if type="error">
    <#local type = "alert">
  </#if>
  <@alert_markup type=type class=class typeClass=typeClass id=id origArgs=origArgs><#nested></@alert_markup>
</#macro>

<#-- @alert main markup - theme override -->
<#macro alert_markup type="info" class="" typeClass="" id="" origArgs={} catchArgs...>
  <#local class = addClassArg(class, styles.grid_cell!"")>
  <#local class = addClassArgDefault(class, "${styles.grid_large!}12")>
  <div class="${styles.grid_row!}"<#if id?has_content> id="${id}"</#if>>
    <div class="${styles.grid_large!}12 ${styles.grid_cell!}">
      <div data-alert class="${styles.alert_wrap!} ${styles[typeClass]!}">
        <div class="${styles.grid_row!}">
          <div<@compiledClassAttribStr class=class />>
            <a href="#" class="close" data-dismiss="alert">&times;</a>
            <#nested>
          </div>
        </div>
      </div>
    </div>
  </div>
</#macro>

<#--
*************
* Panel box
************
  * Usage Example *  
    <@panel type="">
        This is a panel.
    </@panel>            
                    
  * Parameters *
    type           = (callout|) default:empty
    title          = Title
-->
<#assign panel_defaultArgs = {
  "type":"", "title":""
}>
<#macro panel args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.panel_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <@panel_markup type=type title=title origArgs=origArgs><#nested></@panel_markup>
</#macro>

<#-- @panel main markup - theme override -->
<#macro panel_markup type="" title="" origArgs={} catchArgs...>
  <div class="${styles.panel_wrap!} ${type}">
    <div class="${styles.panel_head!}"><#if title?has_content><h5 class="${styles.panel_title!}">${title!}</h5></#if></div>
    <div class="${styles.panel_body!}"><p><#nested></p></div>
  </div>
</#macro>

<#-- 
*************
* Query Result Message
************
Common query result message wrapper.
Note: this is ONLY for expected, non-error messages, such as no records found in a query.
Other messages such as for missing params/record IDs are usually errors.

  * Usage Example *  
    <@resultMsg>${uiLabelMap.CommonNoRecordFound}.</@resultMsg>            
                    
  * Parameters *
    class       = classes or additional classes for nested container
                  (if boolean, true means use defaults, false means prevent non-essential defaults; prepend with "+" to append-only, i.e. never replace non-essential defaults)
-->
<#assign resultMsg_defaultArgs = {
  "class":"", "id":""
}>
<#macro resultMsg args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.resultMsg_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <@resultMsg_markup class=class id=id origArgs=origArgs><#nested></@resultMsg_markup>
</#macro>

<#-- @resultMsg main markup - theme override -->
<#macro resultMsg_markup class="" id="" origArgs={} catchArgs...>
  <p<@compiledClassAttribStr class=class defaultVal="result-msg" /><#if id?has_content> id="${id}"</#if>><#nested></p>
</#macro>

<#-- 
*************
* Error Result Message
************
Common error result message wrapper.
Abstracts/centralizes method used to display error, since of no consequence to most
templates: currently @alert.

  * Usage Example *  
    <@errorMsg type="permission">${uiLabelMap.CommonNoPermission}.</@errorMsg>            
                    
  * Parameters *
    type           = [permission|security|error], default error
    class          = classes or additional classes for nested container
                     (if boolean, true means use defaults, false means prevent non-essential defaults; prepend with "+" to append-only, i.e. never replace non-essential defaults)
-->
<#assign errorMsg_defaultArgs = {
  "type":"error", "class":"", "id":""
}>
<#macro errorMsg args={} inlineArgs...>
  <#local args = mergeArgMaps(args, inlineArgs, catoStdTmplLib.errorMsg_defaultArgs)>
  <#local dummy = localsPutAll(args)>
  <#local origArgs = args>
  <@errorMsg_markup type=type class=class id=id origArgs=origArgs><#nested></@errorMsg_markup>
</#macro>

<#-- @errorMsg main markup - theme override -->
<#macro errorMsg_markup type="error" class="" id="" origArgs={} catchArgs...>
  <@alert type="error" class=class id=id><#nested></@alert>
</#macro>
