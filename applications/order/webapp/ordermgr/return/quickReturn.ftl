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

<@section> <#--  title="${uiLabelMap.OrderReturnItems}" -->
        <#-- DO NOT CHANGE THE NAME OF THIS FORM, it will break the some of the multi-service pattern features -->
        <#assign selectAllFormName = "selectAllForm"/>
        <form name="selectAllForm" method="post" action="<@ofbizUrl>makeQuickReturn</@ofbizUrl>">
          <input type="hidden" name="_checkGlobalScope" value="Y"/>
          <input type="hidden" name="_useRowSubmit" value="Y"/>
          <input type="hidden" name="fromPartyId" value="${partyId!}"/>
          <input type="hidden" name="toPartyId" value="${toPartyId!}"/>
          <input type="hidden" name="orderId" value="${orderId}"/>
          <input type="hidden" name="needsInventoryReceive" value="${parameters.needsInventoryReceive?default("Y")}"/>
          <input type="hidden" name="destinationFacilityId" value="${destinationFacilityId!}"/>
          <input type="hidden" name="returnHeaderTypeId" value="${returnHeaderTypeId}"/>
        <#if (orderHeader?has_content) && (orderHeader.currencyUom?has_content)>
          <input type="hidden" name="currencyUomId" value="${orderHeader.currencyUom}"/>
        </#if>

    <#include "returnItemInc.ftl"/>

        <hr />
        
    <@section>
        <#if "CUSTOMER_RETURN" == returnHeaderTypeId>
          <@field type="generic" label="${uiLabelMap.FormFieldTitle_paymentMethodId}">
              <#if creditCardList?? || eftAccountList??>
                <select name='paymentMethodId'>
                  <option value=""></option>
                  <#if creditCardList?has_content>
                    <#list creditCardList as creditCardPm>
                      <#assign creditCard = creditCardPm.getRelatedOne("CreditCard", false)>
                      <option value="${creditCard.paymentMethodId}">CC:&nbsp;${Static["org.ofbiz.party.contact.ContactHelper"].formatCreditCard(creditCard)}</option>
                    </#list>
                  </#if>
                  <#if eftAccountList?has_content>
                    <#list eftAccountList as eftAccount>
                      <option value="${eftAccount.paymentMethodId}">EFT:&nbsp;${eftAccount.nameOnAccount!}, ${eftAccount.accountNumber!}</option>
                    </#list>
                  </#if>
                </select>
              <#else>
                <input type='text' size='20' name='paymentMethodId' />
              </#if>
              <#if (party.partyId)?has_content>
                <a href="/partymgr/control/editcreditcard?partyId=${party.partyId}${StringUtil.wrapString(externalKeyParam)}" target="partymgr" class="smallSubmit ${styles.button_default!}">${uiLabelMap.AccountingCreateNewCreditCard}</a>
              </#if>
          </@field>
        </#if>
          <#assign label><#if "CUSTOMER_RETURN" == returnHeaderTypeId>${uiLabelMap.OrderReturnShipFromAddress}<#else>${uiLabelMap["checkhelper.select_shipping_destination"]}</#if></#assign>
          <@field type="generic" label=label>
                <@table type="data-list" cellspacing="0"> <#-- orig: class="basic-table" -->
                  <#list shippingContactMechList as shippingContactMech>
                    <#assign shippingAddress = shippingContactMech.getRelatedOne("PostalAddress", false)>
                    <@tr>
                      <@td align="right" width="1%" valign="top" nowrap="nowrap">
                        <input type="radio" name="originContactMechId" value="${shippingAddress.contactMechId}"  <#if (shippingContactMechList?size == 1)>checked="checked"</#if> />
                      </@td>
                      <@td width="99%" valign="top" nowrap="nowrap">
                          <#if shippingAddress.toName?has_content><span>${uiLabelMap.CommonTo}</span>&nbsp;${shippingAddress.toName}<br /></#if>
                          <#if shippingAddress.attnName?has_content><span>${uiLabelMap.CommonAttn}</span></b>&nbsp;${shippingAddress.attnName}<br /></#if>
                          <#if shippingAddress.address1?has_content>${shippingAddress.address1}<br /></#if>
                          <#if shippingAddress.address2?has_content>${shippingAddress.address2}<br /></#if>
                          <#if shippingAddress.city?has_content>${shippingAddress.city}</#if>
                          <#if shippingAddress.stateProvinceGeoId?has_content><br />${shippingAddress.stateProvinceGeoId}</#if>
                          <#if shippingAddress.postalCode?has_content><br />${shippingAddress.postalCode}</#if>
                          <#if shippingAddress.countryGeoId?has_content><br />${shippingAddress.countryGeoId}</#if>
                          <#--<a href="<@ofbizUrl>editcontactmech?DONE_PAGE=checkoutoptions&amp;contactMechId=${shippingAddress.contactMechId}</@ofbizUrl>" class="${styles.button_default!}">[${uiLabelMap.CommonUpdate}]</a>-->
                        </@td>
                    </@tr>
                  </#list>
                </@table>
          </@field>
        </form>
    </@section>
</@section>