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

<#macro maskSensitiveNumber cardNumber>
  <#assign cardNumberDisplay = "">
  <#if cardNumber?has_content>
    <#assign size = cardNumber?length - 4>
    <#if (size > 0)>
      <#list 0 .. size-1 as foo>
        <#assign cardNumberDisplay = cardNumberDisplay + "*">
      </#list>
      <#assign cardNumberDisplay = cardNumberDisplay + cardNumber[size .. size + 3]>
    <#else>
      <#-- but if the card number has less than four digits (ie, it was entered incorrectly), display it in full -->
      <#assign cardNumberDisplay = cardNumber>
    </#if>
  </#if>
  ${cardNumberDisplay!}
</#macro>

  <#assign menuHtml>
    <#if security.hasEntityPermission("PAY_INFO", "_CREATE", session) || security.hasEntityPermission("ACCOUNTING", "_CREATE", session)>
      <li><a href="<@ofbizUrl>editeftaccount?partyId=${partyId}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.AccountingCreateNewEftAccount}</a></li>
      <li><a href="<@ofbizUrl>editgiftcard?partyId=${partyId}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.AccountingCreateNewGiftCard}</a></li>
      <li><a href="<@ofbizUrl>editcreditcard?partyId=${partyId}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.AccountingCreateNewCreditCard}</a></li>
      <li><a href="<@ofbizUrl>EditBillingAccount?partyId=${partyId}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.AccountingCreateBillingAccount}</a></li>
    </#if>  
  </#assign>
  <@section id="partyPaymentMethod" title="${uiLabelMap.PartyPaymentMethodInformation}" menuHtml=menuHtml>
      <#if paymentMethodValueMaps?has_content || billingAccounts?has_content>
        <@table type="data-complex" class="basic-table" cellspacing="0">
        <@tbody>
        <#if paymentMethodValueMaps?has_content>
          <#list paymentMethodValueMaps as paymentMethodValueMap>
            <#assign paymentMethod = paymentMethodValueMap.paymentMethod/>
            <@tr>
              <#macro deleteButton>
                <#if security.hasEntityPermission("PAY_INFO", "_DELETE", session) || security.hasEntityPermission("ACCOUNTING", "_DELETE", session)>
                  <a href="<@ofbizUrl>deletePaymentMethod/viewprofile?partyId=${partyId}&amp;paymentMethodId=${paymentMethod.paymentMethodId}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonExpire}</a>
                <#else>
                  &nbsp;
                </#if>
              </#macro>
              <#if "CREDIT_CARD" == paymentMethod.paymentMethodTypeId && paymentMethodValueMap.creditCard?has_content>
                <#assign creditCard = paymentMethodValueMap.creditCard/>
                <@td>
                  ${uiLabelMap.AccountingCreditCard}
                </@td>
                <@td>
                  <#if creditCard.companyNameOnCard?has_content>${creditCard.companyNameOnCard}&nbsp;</#if>
                  <#if creditCard.titleOnCard?has_content>${creditCard.titleOnCard}&nbsp;</#if>
                  ${creditCard.firstNameOnCard}&nbsp;
                  <#if creditCard.middleNameOnCard?has_content>${creditCard.middleNameOnCard}&nbsp;</#if>
                  ${creditCard.lastNameOnCard}
                  <#if creditCard.suffixOnCard?has_content>&nbsp;${creditCard.suffixOnCard}</#if>
                  &nbsp;-&nbsp;
                  <#if security.hasEntityPermission("PAY_INFO", "_VIEW", session) || security.hasEntityPermission("ACCOUNTING", "_VIEW", session)>
                    ${creditCard.cardType}
                    <@maskSensitiveNumber cardNumber=creditCard.cardNumber!/>
                    ${creditCard.expireDate}
                  <#else>
                    ${Static["org.ofbiz.party.contact.ContactHelper"].formatCreditCard(creditCard)}
                  </#if>
                  <#if paymentMethod.description?has_content>(${paymentMethod.description})</#if>
                  <#if paymentMethod.glAccountId?has_content>(for GL Account ${paymentMethod.glAccountId})</#if>
                  <#if paymentMethod.fromDate?has_content>(${uiLabelMap.CommonUpdated}:&nbsp;${paymentMethod.fromDate!})</#if>
                  <#if paymentMethod.thruDate?has_content><b>(${uiLabelMap.PartyContactEffectiveThru}:&nbsp;${paymentMethod.thruDate})</#if>
                </@td>
                <@td class="button-col">
                  <#if security.hasEntityPermission("MANUAL", "_PAYMENT", session)>
                    <a href="/accounting/control/manualETx?paymentMethodId=${paymentMethod.paymentMethodId}${StringUtil.wrapString(externalKeyParam)}">${uiLabelMap.PartyManualTx}</a>
                  </#if>
                  <#if security.hasEntityPermission("PAY_INFO", "_UPDATE", session) || security.hasEntityPermission("ACCOUNTING", "_UPDATE", session)>
                    <a href="<@ofbizUrl>editcreditcard?partyId=${partyId}&amp;paymentMethodId=${paymentMethod.paymentMethodId}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonUpdate}</a>
                  </#if>
                  <@deleteButton />
                </@td>
              <#elseif "GIFT_CARD" == paymentMethod.paymentMethodTypeId>
                <#assign giftCard = paymentMethodValueMap.giftCard>
                <@td>
                  ${uiLabelMap.AccountingGiftCard}
                </@td>
                <@td>
                  <#if security.hasEntityPermission("PAY_INFO", "_VIEW", session) || security.hasEntityPermission("ACCOUNTING", "_VIEW", session)>
                    ${giftCard.cardNumber!(uiLabelMap.CommonNA)} [${giftCard.pinNumber!(uiLabelMap.CommonNA)}]
                  <#else>
                    <@maskSensitiveNumber cardNumber=giftCard.cardNumber!/>
                    <#if !cardNumberDisplay?has_content>${uiLabelMap.CommonNA}</#if>
                  </#if>
                  <#if paymentMethod.description?has_content>(${paymentMethod.description})</#if>
                  <#if paymentMethod.glAccountId?has_content>(for GL Account ${paymentMethod.glAccountId})</#if>
                  <#if paymentMethod.fromDate?has_content>(${uiLabelMap.CommonUpdated}:&nbsp;${paymentMethod.fromDate!})</#if>
                  <#if paymentMethod.thruDate?has_content><b>(${uiLabelMap.PartyContactEffectiveThru}:&nbsp;${paymentMethod.thruDate.toString()}</b></#if>
                </@td>
                <@td class="button-col">
                  <#if security.hasEntityPermission("PAY_INFO", "_UPDATE", session) || security.hasEntityPermission("ACCOUNTING", "_UPDATE", session)>
                    <a href="<@ofbizUrl>editgiftcard?partyId=${partyId}&amp;paymentMethodId=${paymentMethod.paymentMethodId}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonUpdate}</a>
                  </#if>
                  <@deleteButton />
                </@td>
              <#elseif "EFT_ACCOUNT" == paymentMethod.paymentMethodTypeId>
                <#assign eftAccount = paymentMethodValueMap.eftAccount>
                <@td>
                    ${uiLabelMap.PartyEftAccount}
                </@td>
                <@td>
                  ${eftAccount.nameOnAccount} - <#if eftAccount.bankName?has_content>${uiLabelMap.PartyBank}: ${eftAccount.bankName}</#if> <#if eftAccount.accountNumber?has_content>${uiLabelMap.PartyAccount} #: ${eftAccount.accountNumber}</#if>                  <#if paymentMethod.description?has_content>(${paymentMethod.description})</#if>
                  <#if paymentMethod.glAccountId?has_content>(for GL Account ${paymentMethod.glAccountId})</#if>
                  <#if paymentMethod.fromDate?has_content>(${uiLabelMap.CommonUpdated}:&nbsp;${paymentMethod.fromDate!})</#if>
                  <#if paymentMethod.thruDate?has_content><b>(${uiLabelMap.PartyContactEffectiveThru}:&nbsp;${paymentMethod.thruDate.toString()}</#if>
                </@td>
                <@td class="button-col">
                  <#if security.hasEntityPermission("PAY_INFO", "_UPDATE", session) || security.hasEntityPermission("ACCOUNTING", "_UPDATE", session)>
                    <a href="<@ofbizUrl>editeftaccount?partyId=${partyId}&amp;paymentMethodId=${paymentMethod.paymentMethodId}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonUpdate}</a>
                  </#if>
                  <@deleteButton />
                </@td>
              <#elseif "COMPANY_CHECK" == paymentMethod.paymentMethodTypeId>
                <@td>
                  <#-- TODO: Convert hard-coded text to UI label properties -->
                  Company Check
                </@td>
                <@td>
                  <#if paymentMethod.description?has_content>(${paymentMethod.description})</#if>
                  <#if paymentMethod.glAccountId?has_content>(for GL Account ${paymentMethod.glAccountId})</#if>
                  <#if paymentMethod.fromDate?has_content>(${uiLabelMap.CommonUpdated}:&nbsp;${paymentMethod.fromDate!})</#if>
                  <#if paymentMethod.thruDate?has_content>(${uiLabelMap.PartyContactEffectiveThru}:&nbsp;${paymentMethod.thruDate.toString()}</#if>
                </@td>
                <@td class="button-col">
                  &nbsp;
                  <@deleteButton />
                </@td>
              <#else>
                <@td class="button-col">
                  &nbsp;
                  <@deleteButton />
                </@td>
              </#if>
            </@tr>
          </#list>
        </#if>
        <#-- Billing list-->
        <#if billingAccounts?has_content>
            <#list billingAccounts as billing>
            <@tr>
              <@td>${uiLabelMap.AccountingBilling}</@td>
              <@td>
                  <#if billing.billingAccountId?has_content>${billing.billingAccountId}</#if>
                  <#if billing.description?has_content>(${billing.description})</#if>
                  <#if billing.accountLimit?has_content>(${uiLabelMap.AccountingAccountLimit} $${billing.accountLimit})</#if>
                  <#if billing.accountBalance?has_content>(${uiLabelMap.AccountingBillingAvailableBalance} $${billing.accountBalance})</#if>
                  <#if billing.fromDate?has_content>(${uiLabelMap.CommonUpdated}:&nbsp;${billing.fromDate!})</#if>
                  <#if billing.thruDate?has_content><b>(${uiLabelMap.PartyContactEffectiveThru}:&nbsp;${billing.thruDate.toString()}</b></#if>
              </@td>
              <@td class="button-col">
                <a href="<@ofbizUrl>EditBillingAccount?billingAccountId=${billing.billingAccountId}&amp;partyId=${partyId}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonUpdate}</a>
                <a href="<@ofbizUrl>deleteBillingAccount?partyId=${partyId}&amp;billingAccountId=${billing.billingAccountId}</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.CommonExpire}</a>
              </@td>
          </@tr>
          </#list>
        </#if>
        </@tbody>
        </@table>
      <#else>
        <@resultMsg>${uiLabelMap.PartyNoPaymentMethodInformation}</@resultMsg>
      </#if>
  </@section>
