<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<!-- begin editeftaccount.ftl -->
<#if !eftAccount??>
  <#assign sectionTitle = "${uiLabelMap.AccountingAddNewEftAccount}">
<#else>
  <#assign sectionTitle = "${uiLabelMap.PageTitleEditEftAccount}">
</#if>
<@section title=sectionTitle>
    <#macro saveCancelMenu>
      <@menu type="button">
        <#-- this was used at bottom in original FTL, is an error?
        <a href="<@ofbizUrl>backHome</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonCancelDone}</a>-->
        <@menuitem type="link" href=makeOfbizUrl("${donePage}?partyId=${partyId}") text="${uiLabelMap.CommonCancelDone}" />
        <@menuitem type="link" href="javascript:document.editeftaccountform.submit()" text="${uiLabelMap.CommonSave}" />
      </@menu>
    </#macro>
    
    <@saveCancelMenu />
        
    <#if !eftAccount??>
      <form method="post" action='<@ofbizUrl>createEftAccount?DONE_PAGE=${donePage}</@ofbizUrl>' name="editeftaccountform">
    <#else>
      <form method="post" action='<@ofbizUrl>updateEftAccount?DONE_PAGE=${donePage}</@ofbizUrl>' name="editeftaccountform">
        <input type="hidden" name="paymentMethodId" value="${paymentMethodId}" />
    </#if>
        <input type="hidden" name="partyId" value="${partyId}"/>

        <@field type="generic" label="${uiLabelMap.AccountingNameAccount}">
            <input type="text" class="required" size="30" maxlength="60" name="nameOnAccount" value="${eftAccountData.nameOnAccount!}" />
            <span class="tooltip">${uiLabelMap.CommonRequired}</span>
        </@field>
        <@field type="generic" label="${uiLabelMap.AccountingCompanyNameAccount}">
            <input type="text" size="30" maxlength="60" name="companyNameOnAccount" value="${eftAccountData.companyNameOnAccount!}" />
        </@field>
        <@field type="generic" label="${uiLabelMap.AccountingBankName}">
            <input type="text" class="required" size="30" maxlength="60" name="bankName" value="${eftAccountData.bankName!}" />
            <span class="tooltip">${uiLabelMap.CommonRequired}</span>
        </@field>
        <@field type="generic" label="${uiLabelMap.AccountingRoutingNumber}">
            <input type="text" class="required" size="10" maxlength="30" name="routingNumber" value="${eftAccountData.routingNumber!}" />
            <span class="tooltip">${uiLabelMap.CommonRequired}</span>
        </@field>
        <@field type="generic" label="${uiLabelMap.AccountingAccountType}">
            <select name="accountType" class="required">
              <option>${eftAccountData.accountType!}</option>
              <option></option>
              <option>${uiLabelMap.CommonChecking}</option>
              <option>${uiLabelMap.CommonSavings}</option>
            </select>
            <span class="tooltip">${uiLabelMap.CommonRequired}</span>
        </@field>
        <@field type="generic" label="${uiLabelMap.AccountingAccountNumber}">
            <input type="text" class="required" size="20" maxlength="40" name="accountNumber" value="${eftAccountData.accountNumber!}" />
            <span class="tooltip">${uiLabelMap.CommonRequired}</span>
        </@field>
        <@field type="generic" label="${uiLabelMap.CommonDescription}">
            <input type="text" class="required" size="30" maxlength="60" name="description" value="${paymentMethodData.description!}" />
            <span class="tooltip">${uiLabelMap.CommonRequired}</span>
        </@field>
        <@field type="generic" label="${uiLabelMap.PartyBillingAddress}">
            <#-- Removed because is confusing, can add but would have to come back here with all data populated as before...
            <a href="<@ofbizUrl>editcontactmech</@ofbizUrl>" class="${styles.button_default!}">
              [Create New Address]</a>&nbsp;&nbsp;
            -->
            <@table type="data-list" autoAltRows=true cellspacing="0">
            <@tbody>
            <#if curPostalAddress??>
              <@tr>
                <@td class="button-col">
                  <input type="radio" name="contactMechId" value="${curContactMechId}" checked="checked" />
                </@td>
                <@td>
                  <p><b>${uiLabelMap.PartyUseCurrentAddress}:</b></p>
                  <#list curPartyContactMechPurposes as curPartyContactMechPurpose>
                    <#assign curContactMechPurposeType = curPartyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true)>
                    <div><b>${curContactMechPurposeType.get("description",locale)!}</b></div>
                    <#if curPartyContactMechPurpose.thruDate??>
                      <div>(${uiLabelMap.CommonExpire}:${curPartyContactMechPurpose.thruDate.toString()})</div>
                    </#if>
                  </#list>
                  <#if curPostalAddress.toName??><div><b>${uiLabelMap.CommonTo}:</b> ${curPostalAddress.toName}</div></#if>
                  <#if curPostalAddress.attnName??><div><b>${uiLabelMap.PartyAddrAttnName}:</b> ${curPostalAddress.attnName}</div></#if>
                  <#if curPostalAddress.address1??><div>${curPostalAddress.address1}</div></#if>
                  <#if curPostalAddress.address2??><div>${curPostalAddress.address2}</div></#if>
                  <div>${curPostalAddress.city}<#if curPostalAddress.stateProvinceGeoId?has_content>,&nbsp;${curPostalAddress.stateProvinceGeoId}</#if>&nbsp;${curPostalAddress.postalCode}</div>
                  <#if curPostalAddress.countryGeoId??><div>${curPostalAddress.countryGeoId}</div></#if>
                  <div>(${uiLabelMap.CommonUpdated}:&nbsp;${(curPartyContactMech.fromDate.toString())!})</div>
                  <#if curPartyContactMech.thruDate??><div><b>${uiLabelMap.CommonDelete}:&nbsp;${curPartyContactMech.thruDate.toString()}</b></div></#if>
                </@td>
              </@tr>
            <#else>
               <#-- <@tr type="meta">
                <@td valign="top" colspan='2'>
                  ${uiLabelMap.PartyNoBillingAddress}
                </@td>
              </@tr> -->
            </#if>
              <#-- is confusing
              <@tr>
                <@td valign="top" colspan='2'>
                  <b>Select a New Billing Address:</b>
                </@td>
              </@tr>
              -->
              <#list postalAddressInfos as postalAddressInfo>
                <#assign contactMech = postalAddressInfo.contactMech>
                <#assign partyContactMechPurposes = postalAddressInfo.partyContactMechPurposes>
                <#assign postalAddress = postalAddressInfo.postalAddress>
                <#assign partyContactMech = postalAddressInfo.partyContactMech>
                <@tr>
                  <@td class="button-col">
                    <input type='radio' name='contactMechId' value='${contactMech.contactMechId}' />
                  </@td>
                  <@td>
                    <#list partyContactMechPurposes as partyContactMechPurpose>
                      <#assign contactMechPurposeType = partyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true)>
                      <div><b>${contactMechPurposeType.get("description",locale)!}</b></div>
                      <#if partyContactMechPurpose.thruDate??><div>(${uiLabelMap.CommonExpire}:${partyContactMechPurpose.thruDate})</div></#if>
                    </#list>
                    <#if postalAddress.toName??><div><b>${uiLabelMap.CommonTo}:</b> ${postalAddress.toName}</div></#if>
                    <#if postalAddress.attnName??><div><b>${uiLabelMap.PartyAddrAttnName}:</b> ${postalAddress.attnName}</div></#if>
                    <#if postalAddress.address1??><div>${postalAddress.address1}</div></#if>
                    <#if postalAddress.address2??><div>${postalAddress.address2}</div></#if>
                    <div>${postalAddress.city}<#if postalAddress.stateProvinceGeoId?has_content>,&nbsp;${postalAddress.stateProvinceGeoId}</#if>&nbsp;${postalAddress.postalCode}</div>
                    <#if postalAddress.countryGeoId??><div>${postalAddress.countryGeoId}</div></#if>
                    <div>(${uiLabelMap.CommonUpdated}:&nbsp;${(partyContactMech.fromDate.toString())!})</div>
                    <#if partyContactMech.thruDate??><div><b>${uiLabelMap.CommonDelete}:&nbsp;${partyContactMech.thruDate.toString()}</b></div></#if>
                  </@td>
                </@tr>
              </#list>
              <#if !postalAddressInfos?has_content && !curContactMech??>
                  <@tr type="meta"><@td colspan="2">${uiLabelMap.PartyNoContactInformation}.</@td></@tr>
              </#if>
            </@tbody>
            </@table>
        </@field>

      </form>
      
      <@saveCancelMenu />
</@section>
<!-- end editeftaccount.ftl -->