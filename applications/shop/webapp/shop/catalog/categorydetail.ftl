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

<@section>
    
    <#if productCategory?exists  && solrProducts?has_content>
                <@paginate mode="content" layout="both"  viewSize=viewSize!1 viewIndex=viewIndex!0 listSize=listSize!0>
                    <@grid columns=4>
                    <#list solrProducts as solrProduct>
                            <li>${setRequestAttribute("productId", solrProduct.productId)}
                            ${screens.render(productsummaryScreen)}
                            </li>
                    </#list>
                    </@grid>
                </@paginate>
    <#else>
        <@alert type="info">${uiLabelMap.ProductNoProductsInThisCategory}</@alert>
    </#if>
 </@section>   