<html>
<head></head>
<body>
<script>
/*
	Created By :  Kevin Ubay-Ubay (kevin.ubayubay@melissadata.com)
	Modified By : Gaurav Sinha Melissa data Api(gsinha@appirio.com)
    Express Entry for Listware for Salesforce
    
    Copyright 2015 - All rights reserved.
*/

var j$;

var countryISOMap = [
    {value: "US", label: "US - United States of America"}, {value: "AF", label: "AF - Afghanistan"}, {value: "AX", label: "AX - Aland Islands"}, {value: "AL", label: "AL - Albania"}, {value: "DZ", label: "DZ - Algeria"}, {value: "AD", label: "AD - Andorra"}, {value: "AO", label: "AO - Angola"},
    {value: "AI", label: "AI - Anguilla"}, {value: "AG", label: "AG - Antigua and Barbuda"}, {value: "AR", label: "AR - Argentina"}, {value: "AM", label: "AM - Armenia"}, {value: "AW", label: "AW - Aruba"}, {value: "AU", label: "AU - Australia"}, {value: "AT", label: "AT - Austria"}, {value: "AZ", label: "AZ - Azerbaijan"},
    {value: "BS", label: "BS - Bahamas"}, {value: "BH", label: "BH - Bahrain"}, {value: "BD", label: "BD - Bangladesh"}, {value: "BB", label: "BB - Barbados"}, {value: "BY", label: "BY - Belarus"}, {value: "BE", label: "BE - Belgium"}, {value: "BZ", label: "BZ - Belize"}, {value: "BJ", label: "BJ - Benin"},
    {value: "BM", label: "BM - Bermuda"}, {value: "BT", label: "BT - Bhutan"}, {value: "BO", label: "BO - Bolivia"}, {value: "BA", label: "BA - Bosnia and Herzegovina"}, {value: "BW", label: "BW - Botswana"}, {value: "BV", label: "BV - Bouvet Island"}, {value: "BR", label: "BR - Brazil"},
    {value: "IO", label: "IO - British Indian Ocean Territory"}, {value: "BN", label: "BN - Brunei Darussalam"}, {value: "BG", label: "BG - Bulgaria"}, {value: "BF", label: "BF - Burkina Faso"}, {value: "BI", label: "BI - Burundi"}, {value: "KH", label: "KH - Cambodia"},
    {value: "CM", label: "CM - Cameroon"}, {value: "CA", label: "CA - Canada"}, {value: "CV", label: "CV - Cape Verde"}, {value: "BQ", label: "BQ - Caribbean Netherlands "}, {value: "KY", label: "KY - Cayman Islands"}, {value: "CF", label: "CF - Central African Republic"},
    {value: "TD", label: "TD - Chad"}, {value: "CL", label: "CL - Chile"}, {value: "CN", label: "CN - China"}, {value: "CX", label: "CX - Christmas Island"}, {value: "CC", label: "CC - Cocos (Keeling) Islands"}, {value: "CO", label: "CO - Colombia"}, {value: "KM", label: "KM - Comoros"},
    {value: "CG", label: "CG - Congo"}, {value: "CD", label: "Congo, Democratic Republic of"}, {value: "CK", label: "CK - Cook Islands"}, {value: "CR", label: "CR - Costa Rica"}, {value: "CI", label: "Cote D'Ivoire"}, {value: "HR", label: "HR - Croatia"},
    {value: "CU", label: "CU - Cuba"}, {value: "CW", label: "CW - Curacao"}, {value: "CY", label: "CY - Cyprus"}, {value: "CZ", label: "CZ - Czech Republic"}, {value: "DK", label: "DK - Denmark"}, {value: "DJ", label: "DJ - Djibouti"}, {value: "DM", label: "DM - Dominica"}, {value: "DO", label: "DO - Dominican Republic"},
    {value: "EC", label: "EC - Ecuador"}, {value: "EG", label: "EG - Egypt"}, {value: "SV", label: "SV - El Salvador"}, {value: "GQ", label: "GQ - Equatorial Guinea"}, {value: "ER", label: "ER - Eritrea"}, {value: "EE", label: "EE - Estonia"}, {value: "ET", label: "ET - Ethiopia"}, {value: "FK", label: "FK - Falkland Islands"},
    {value: "FO", label: "FO - Faroe Islands"}, {value: "FJ", label: "FJ - Fiji"}, {value: "FI", label: "FI - Finland"}, {value: "FR", label: "FR - France"}, {value: "GF", label: "GF - French Guiana"}, {value: "PF", label: "PF - French Polynesia"}, {value: "TF", label: "TF - French Southern Territories"},
    {value: "GA", label: "GA - Gabon"}, {value: "GM", label: "GM - Gambia"}, {value: "GE", label: "GE - Georgia"}, {value: "DE", label: "DE - Germany"}, {value: "GH", label: "GH - Ghana"}, {value: "GI", label: "GI - Gibraltar"}, {value: "GR", label: "GR - Greece"}, {value: "GL", label: "GL - Greenland"}, {value: "GD", label: "GD - Grenada"},
    {value: "GP", label: "GP - Guadeloupe"}, {value: "GT", label: "GT - Guatemala"}, {value: "GG", label: "GG - Guernsey"}, {value: "GN", label: "GN - Guinea"}, {value: "GW", label: "Guinea-Bissau"}, {value: "GY", label: "GY - Guyana"}, {value: "HT", label: "HT - Haiti"},
    {value: "HM", label: "HM - Heard and McDonald Islands"}, {value: "HN", label: "HN - Honduras"}, {value: "HK", label: "HK - Hong Kong"}, {value: "HU", label: "HU - Hungary"}, {value: "IS", label: "IS - Iceland"}, {value: "IN", label: "IN - India"}, {value: "ID", label: "ID - Indonesia"},
    {value: "IR", label: "IR - Iran"}, {value: "IQ", label: "IQ - Iraq"}, {value: "IE", label: "IE - Ireland"}, {value: "IM", label: "IM - Isle of Man"}, {value: "IL", label: "IL - Israel"}, {value: "IT", label: "IT - Italy"}, {value: "JM", label: "JM - Jamaica"}, {value: "JP", label: "JP - Japan"}, {value: "JE", label: "JE - Jersey"},
    {value: "JO", label: "JO - Jordan"}, {value: "KZ", label: "KZ - Kazakhstan"}, {value: "KE", label: "KE - Kenya"}, {value: "KI", label: "KI - Kiribati"}, {value: "KW", label: "KW - Kuwait"}, {value: "KG", label: "KG - Kyrgyzstan"}, {value: "LA", label: "Lao People's Democratic Republic"},
    {value: "LV", label: "LV - Latvia"}, {value: "LB", label: "LB - Lebanon"}, {value: "LS", label: "LS - Lesotho"}, {value: "LR", label: "LR - Liberia"}, {value: "LY", label: "LY - Libya"}, {value: "LI", label: "LI - Liechtenstein"}, {value: "LT", label: "LT - Lithuania"}, {value: "LU", label: "LU - Luxembourg"},
    {value: "MO", label: "MO - Macau"}, {value: "MK", label: "MK - Macedonia"}, {value: "MG", label: "MG - Madagascar"}, {value: "MW", label: "MW - Malawi"}, {value: "MY", label: "MY - Malaysia"}, {value: "MV", label: "MV - Maldives"}, {value: "ML", label: "ML - Mali"}, {value: "MT", label: "MT - Malta"},
    {value: "MQ", label: "MQ - Martinique"}, {value: "MR", label: "MR - Mauritania"}, {value: "MU", label: "MU - Mauritius"}, {value: "YT", label: "YT - Mayotte"}, {value: "MX", label: "MX - Mexico"}, {value: "MD", label: "MD - Moldova"}, {value: "MC", label: "MC - Monaco"}, {value: "MN", label: "MN - Mongolia"},
    {value: "ME", label: "ME - Montenegro"}, {value: "MS", label: "MS - Montserrat"}, {value: "MA", label: "MA - Morocco"}, {value: "MZ", label: "MZ - Mozambique"}, {value: "MM", label: "MM - Myanmar"}, {value: "NA", label: "NA - Namibia"}, {value: "NR", label: "NR - Nauru"}, {value: "NP", label: "NP - Nepal"},
    {value: "NC", label: "NC - New Caledonia"}, {value: "NZ", label: "NZ - New Zealand"}, {value: "NI", label: "NI - Nicaragua"}, {value: "NE", label: "NE - Niger"}, {value: "NG", label: "NG - Nigeria"}, {value: "NU", label: "NU - Niue"}, {value: "NF", label: "NF - Norfolk Island"},
    {value: "KP", label: "KP - North Korea"}, {value: "NO", label: "NO - Norway"}, {value: "OM", label: "OM - Oman"}, {value: "PK", label: "PK - Pakistan"}, {value: "PS", label: "Palestinian Territory, Occupied"}, {value: "PA", label: "PA - Panama"},
    {value: "PG", label: "PG - Papua New Guinea"}, {value: "PY", label: "PY - Paraguay"}, {value: "PE", label: "PE - Peru"}, {value: "PH", label: "PH - Philippines"}, {value: "PN", label: "PN - Pitcairn"}, {value: "PL", label: "PL - Poland"}, {value: "PT", label: "PT - Portugal"},
    {value: "QA", label: "QA - Qatar"}, {value: "RE", label: "RE - Reunion"}, {value: "RO", label: "RO - Romania"}, {value: "RU", label: "RU - Russian Federation"}, {value: "RW", label: "RW - Rwanda"}, {value: "BL", label: "BL - Saint Barthelemy"}, {value: "SH", label: "SH - Saint Helena"},
    {value: "KN", label: "KN - Saint Kitts and Nevis"}, {value: "LC", label: "LC - Saint Lucia"}, {value: "VC", label: "VC - Saint Vincent and the Grenadines"}, {value: "MF", label: "Saint-Martin (France)"}, {value: "SX", label: "Saint-Martin (Pays-Bas)"},
    {value: "WS", label: "WS - Samoa"}, {value: "SM", label: "SM - San Marino"}, {value: "ST", label: "ST - Sao Tome and Principe"}, {value: "SA", label: "SA - Saudi Arabia"}, {value: "SN", label: "SN - Senegal"}, {value: "RS", label: "RS - Serbia"}, {value: "SC", label: "SC - Seychelles"},
    {value: "SL", label: "SL - Sierra Leone"}, {value: "SG", label: "SG - Singapore"}, {value: "SK", label: "SK - Slovakia (Slovak Republic)"}, {value: "SI", label: "SI - Slovenia"}, {value: "SB", label: "SB - Solomon Islands"}, {value: "SO", label: "SO - Somalia"},
    {value: "ZA", label: "ZA - South Africa"}, {value: "GS", label: "South Georgia & S Sandwich Islands"}, {value: "KR", label: "KR - South Korea"}, {value: "SS", label: "SS - South Sudan"}, {value: "ES", label: "ES - Spain"}, {value: "LK", label: "LK - Sri Lanka"},
    {value: "PM", label: "PM - St. Pierre and Miquelon"}, {value: "SD", label: "SD - Sudan"}, {value: "SR", label: "SR - Suriname"}, {value: "SJ", label: "SJ - Svalbard and Jan Mayen Islands"}, {value: "SZ", label: "SZ - Swaziland"}, {value: "SE", label: "SE - Sweden"},
    {value: "CH", label: "CH - Switzerland"}, {value: "SY", label: "SY - Syria"}, {value: "TW", label: "TW - Taiwan"}, {value: "TJ", label: "TJ - Tajikistan"}, {value: "TZ", label: "TZ - Tanzania"}, {value: "TH", label: "TH - Thailand"}, {value: "NL", label: "NL - The Netherlands"},
    {value: "TL", label: "Timor-Leste"}, {value: "TG", label: "TG - Togo"}, {value: "TK", label: "TK - Tokelau"}, {value: "TO", label: "TO - Tonga"}, {value: "TT", label: "TT - Trinidad and Tobago"}, {value: "TN", label: "TN - Tunisia"}, {value: "TR", label: "TR - Turkey"},
    {value: "TM", label: "TM - Turkmenistan"}, {value: "TC", label: "TC - Turks and Caicos Islands"}, {value: "TV", label: "TV - Tuvalu"}, {value: "UG", label: "UG - Uganda"}, {value: "UA", label: "UA - Ukraine"}, {value: "AE", label: "AE - United Arab Emirates"},
    {value: "GB", label: "GB - United Kingdom"}, {value: "UY", label: "UY - Uruguay"}, {value: "UZ", label: "UZ - Uzbekistan"}, {value: "VU", label: "VU - Vanuatu"}, {value: "VA", label: "VA - Vatican"}, {value: "VE", label: "VE - Venezuela"}, {value: "VN", label: "VN - Vietnam"},
    {value: "VG", label: "VG - Virgin Islands (British)"}, {value: "WF", label: "WF - Wallis and Futuna Islands"}, {value: "YE", label: "YE - Yemen"}, {value: "ZM", label: "ZM - Zambia"}, {value: "ZW", label: "ZW - Zimbabwe"}
];

var iframeId = "ext-comp-1024";
var eeToken = '';
var autocompleteSet = false;
var mapping = null;
var mappingFuncs = new Object();
var currentCountry = '';
var defaultCountry = 'US';
var objectPrefix = '';
var eeMinLookup = 3;
var eeToggleCase = 'MIXED';

// borrowed from here: http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#JavaScript
/*
  Copyright (c) 2011 Andrei Mackenzie

  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
function getEditDistance(a, b) {
  if(a.length === 0) return b.length; 
  if(b.length === 0) return a.length; 
 
  var matrix = [];
 
  // increment along the first column of each row
  var i;
  for(i = 0; i <= b.length; i++){
    matrix[i] = [i];
  }
 
  // increment each column in the first row
  var j;
  for(j = 0; j <= a.length; j++){
    matrix[0][j] = j;
  }
 
  // Fill in the rest of the matrix
  for(i = 1; i <= b.length; i++){
    for(j = 1; j <= a.length; j++){
      if(b.charAt(i-1) == a.charAt(j-1)){
        matrix[i][j] = matrix[i-1][j-1];
      } else {
        matrix[i][j] = Math.min(matrix[i-1][j-1] + 1, // substitution
                                Math.min(matrix[i][j-1] + 1, // insertion
                                         matrix[i-1][j] + 1)); // deletion
      }
    }
  }
 
  return matrix[b.length][a.length];
};

function setupAutocomplete() {  
    for (i = 0; i < mapping.length; i++) {   
        if (objectPrefix == mapping[i].MDPERSONATOR__objectPrefix__c) {
            mappingFuncs[mapping[i].MDPERSONATOR__streetField__c] = { streetField : mapping[i].MDPERSONATOR__streetField__c,
                                                                      cityField : mapping[i].MDPERSONATOR__cityField__c,
                                                                      postalField : mapping[i].MDPERSONATOR__postalField__c,
                                                                      countryField : mapping[i].MDPERSONATOR__countryField__c,
                                                                      stateField : mapping[i].MDPERSONATOR__stateField__c };
            
            mappingFuncs[mapping[i].MDPERSONATOR__postalField__c] = { cityField : mapping[i].MDPERSONATOR__cityField__c,
                                                                      streetField : mapping[i].MDPERSONATOR__streetField__c,
                                                                      countryField : mapping[i].MDPERSONATOR__countryField__c,
                                                                      stateField : mapping[i].MDPERSONATOR__stateField__c };

			var iframeList = window.parent.parent.document.getElementsByTagName("iframe");
			for(var inc = 0; inc < iframeList.length; inc++) {
                try { 
                    if(iframeList[inc].contentDocument.getElementById(mapping[i].MDPERSONATOR__streetField__c) != null){
                        iframeId = iframeList[inc].id;
                        j$(window.parent.parent.document.getElementById(iframeId).contentDocument.getElementsByTagName("head")[0]).append( j$('<link rel="stylesheet" type="text/css" />').attr('href', 'https://code.jquery.com/ui/1.11.3/themes/redmond/jquery-ui.css') );			
							
                        j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mapping[i].MDPERSONATOR__countryField__c)).autocomplete({
							source: countryISOMap,
							delay: 0,
							select: function( event, ui ) { event.stopPropagation(); }
						}).data('ui-autocomplete')._renderItem = function( ul, item ) {
							var srchTerm = j$.trim(this.term).split(/\s+/).join ('|');
							var strNewLabel = item.label;
							regexp = new RegExp ('(' + srchTerm + ')', "ig");
							var strNewLabel = strNewLabel.replace(regexp,"<span style='font-weight:bold;'>$1</span>");
							return j$( "<li></li>" )
							.data( "ui-autocomplete-item", item )
							.append( "<a>" + strNewLabel + "</a>" )
							.appendTo( ul )
							;
						};

                        j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mapping[i].MDPERSONATOR__streetField__c)).dblclick(function(event) {
                            j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].streetField)).val("");
                            j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].cityField)).val("");
                            j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].postalField)).val("");
                            j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].stateField)).val("");
                            
                            j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].countryField)).val(defaultCountry);
                            
                            currentCity = "";
                            currentState = "";
                            currentPostal = "";
                            currentCountry = j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].countryField)).val();
                            event.stopPropagation();
                        });
                        
						j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mapping[i].MDPERSONATOR__streetField__c)).focus(function(event) {
							if (j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].countryField)).val() == "") {
							   j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].countryField)).val(defaultCountry);
							}
							currentCity = j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].cityField)).val();
                            currentState = j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].stateField)).val();
                            currentPostal = j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].postalField)).val();
							currentCountry = j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].countryField)).val();
						});
							
						j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mapping[i].MDPERSONATOR__streetField__c)).autocomplete({
							showHeader: true, 
							minLength: eeMinLookup,   
							delay: 1,                                                                                                                 
							source: function(request, response) {								
								if (currentPostal != null && currentPostal.trim() != "") {
                                    j$.getJSON("https://expressentry.melissadata.net/jsonp/GlobalExpressAddress?callback=?", {format: "jsonp", id: eeToken, address1: request.term, locality: currentCity, administrativearea: currentState, postalcode: currentState, country: currentCountry, maxrecords: "10"}, function (data) {
                                        var suites = [];
                                        var results = j$.map(data.Results, function( item ) {
                                            if (item.Address.SubBuilding != null && item.Address.SubBuilding != "") {
                                                var suiteArray = item.Address.SubBuilding.split(",");
                                                var secondaryPostalCode = item.Address.PostalCodeSecondary.split(",");
                                                for (var i = 0; i < suiteArray.length; i++) {
                                                    var postalCode = item.Address.PostalCode;
                                                    if (item.Address.PostalCodePrimary != null && item.Address.PostalCodePrimary != "") {
                                                        if (secondaryPostalCode[i] != null && secondaryPostalCode[i] != "") {
                                                            postalCode = item.Address.PostalCodePrimary + "-" + secondaryPostalCode[i];
                                                        }
                                                    }
                                                    var m_completeAddress = item.Address.DeliveryAddress + " " + suiteArray[i];
                                                    if (eeToggleCase == "UPPER") {
                                                        m_completeAddress = (m_completeAddress != null) ? m_completeAddress.toUpperCase() : m_completeAddress;
                                                        
                                                        item.Address.DeliveryAddress = (item.Address.DeliveryAddress != null) ? item.Address.DeliveryAddress.toUpperCase() : null;
                                                        item.Address.PostalCode = (item.Address.PostalCode != null) ? item.Address.PostalCode.toUpperCase() : null;
                                                        item.Address.Locality = (item.Address.Locality != null) ? item.Address.Locality.toUpperCase() : null;
                                                        item.Address.AdministrativeArea = (item.Address.AdministrativeArea != null) ? item.Address.AdministrativeArea.toUpperCase() : null;
                                                        item.Address.SubAdministrativeArea = (item.Address.SubAdministrativeArea != null) ? item.Address.SubAdministrativeArea.toUpperCase() : null;
                                                        item.Address.DoubleDependentLocality = (item.Address.DoubleDependentLocality != null) ? item.Address.DoubleDependentLocality.toUpperCase() : null;
                                                        item.Address.DependentLocality = (item.Address.DependentLocality != null) ? item.Address.DependentLocality.toUpperCase() : null;
                                                
                                                        suites.push({label: m_completeAddress, value: item.Address.DeliveryAddress + " " + suiteArray[i].toUpperCase(),
                                                            deliveryAddress: item.Address.DeliveryAddress + " " + suiteArray[i].toUpperCase(), postalCode: postalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                                                            subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality});
                                                    } else {
                                                        suites.push({label: m_completeAddress, value: item.Address.DeliveryAddress + " " + suiteArray[i],
                                                            deliveryAddress: item.Address.DeliveryAddress + " " + suiteArray[i], postalCode: postalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                                                            subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality});
                                                    }
                                                }
                                            }
                                            
                                            var m_completeAddress = item.Address.DeliveryAddress;
                                            
                                            if (eeToggleCase == "UPPER") {
                                                m_completeAddress = (m_completeAddress != null) ? m_completeAddress.toUpperCase() : m_completeAddress;
                                                        
                                                item.Address.DeliveryAddress = (item.Address.DeliveryAddress != null) ? item.Address.DeliveryAddress.toUpperCase() : null;
                                                item.Address.PostalCode = (item.Address.PostalCode != null) ? item.Address.PostalCode.toUpperCase() : null;
                                                item.Address.Locality = (item.Address.Locality != null) ? item.Address.Locality.toUpperCase() : null;
                                                item.Address.AdministrativeArea = (item.Address.AdministrativeArea != null) ? item.Address.AdministrativeArea.toUpperCase() : null;
                                                item.Address.SubAdministrativeArea = (item.Address.SubAdministrativeArea != null) ? item.Address.SubAdministrativeArea.toUpperCase() : null;
                                                item.Address.DoubleDependentLocality = (item.Address.DoubleDependentLocality != null) ? item.Address.DoubleDependentLocality.toUpperCase() : null;
                                                item.Address.DependentLocality = (item.Address.DependentLocality != null) ? item.Address.DependentLocality.toUpperCase() : null;
                                                
                                                return{label: m_completeAddress, value: item.Address.DeliveryAddress,
                                                    deliveryAddress: item.Address.DeliveryAddress, postalCode: item.Address.PostalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                                                    subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality};
                                            }
                                            
                                            return{label: m_completeAddress, value: item.Address.DeliveryAddress,
                                                deliveryAddress: item.Address.DeliveryAddress, postalCode: item.Address.PostalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                                                subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality};
                                        });
                                        
                                        for (var i = 0; i < suites.length; i++) {
                                            results.push(suites[i]);
                                        }
                
                                        results = results.sort(function(a,b) {
                                            return getEditDistance(a.deliveryAddress.toUpperCase(),request.term.toUpperCase()) - getEditDistance(b.deliveryAddress.toUpperCase(),request.term.toUpperCase());
                                        });
                                        
                                        response(results);
                                    });
                                } else {
            
                                j$.getJSON("https://expressentry.melissadata.net/jsonp/GlobalExpressFreeForm?callback=?", {format: "jsonp", id: eeToken, FF: request.term, country: currentCountry, maxrecords: "10"}, function (data) {
                                    var suites = [];
                                    var results = j$.map(data.Results, function( item ) {
                                        if (item.Address.SubBuilding != null && item.Address.SubBuilding != "") {
                                            var suiteArray = item.Address.SubBuilding.split(",");
                                            var secondaryPostalCode = item.Address.PostalCodeSecondary.split(",");
                                            for (var i = 0; i < suiteArray.length; i++) {
                                                var postalCode = item.Address.PostalCode;
                                                if (item.Address.PostalCodePrimary != null && item.Address.PostalCodePrimary != "") {
                                                    if (secondaryPostalCode[i] != null && secondaryPostalCode[i] != "") {
                                                        postalCode = item.Address.PostalCodePrimary + "-" + secondaryPostalCode[i];
                                                    }
                                                }
                                                var m_completeAddress = item.Address.DeliveryAddress + " " + suiteArray[i] + ", " + item.Address.Locality + ", " + item.Address.AdministrativeArea + ", " + postalCode;
                                                if (eeToggleCase == "UPPER") {
                                                    m_completeAddress = m_completeAddress.toUpperCase();
                                                    
                                                    item.Address.DeliveryAddress = (item.Address.DeliveryAddress != null) ? item.Address.DeliveryAddress.toUpperCase() : null;
                                                    item.Address.PostalCode = (item.Address.PostalCode != null) ? item.Address.PostalCode.toUpperCase() : null;
                                                    item.Address.Locality = (item.Address.Locality != null) ? item.Address.Locality.toUpperCase() : null;
                                                    item.Address.AdministrativeArea = (item.Address.AdministrativeArea != null) ? item.Address.AdministrativeArea.toUpperCase() : null;
                                                    item.Address.SubAdministrativeArea = (item.Address.SubAdministrativeArea != null) ? item.Address.SubAdministrativeArea.toUpperCase() : null;
                                                    item.Address.DoubleDependentLocality = (item.Address.DoubleDependentLocality != null) ? item.Address.DoubleDependentLocality.toUpperCase() : null;
                                                    item.Address.DependentLocality = (item.Address.DependentLocality != null) ? item.Address.DependentLocality.toUpperCase() : null;
                                                    
                                                    suites.push({label: m_completeAddress, value: item.Address.DeliveryAddress + " " + suiteArray[i].toUpperCase(),
                                                    deliveryAddress: item.Address.DeliveryAddress + " " + suiteArray[i].toUpperCase(), postalCode: postalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                                                    subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality});
                                                } else {
                                                    suites.push({label: m_completeAddress, value: item.Address.DeliveryAddress + " " + suiteArray[i],
                                                        deliveryAddress: item.Address.DeliveryAddress + " " + suiteArray[i], postalCode: postalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                                                        subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality});
                                                }
                                            }
                                        }
                                        
                                        var m_completeAddress = item.Address.DeliveryAddress + ", " + item.Address.Locality + ", " + item.Address.AdministrativeArea + ", " + item.Address.PostalCode;
                                        if (eeToggleCase == "UPPER") {
                                            m_completeAddress = m_completeAddress.toUpperCase();
                                            
                                            item.Address.DeliveryAddress = (item.Address.DeliveryAddress != null) ? item.Address.DeliveryAddress.toUpperCase() : null;
                                            item.Address.PostalCode = (item.Address.PostalCode != null) ? item.Address.PostalCode.toUpperCase() : null;
                                            item.Address.Locality = (item.Address.Locality != null) ? item.Address.Locality.toUpperCase() : null;
                                            item.Address.AdministrativeArea = (item.Address.AdministrativeArea != null) ? item.Address.AdministrativeArea.toUpperCase() : null;
                                            item.Address.SubAdministrativeArea = (item.Address.SubAdministrativeArea != null) ? item.Address.SubAdministrativeArea.toUpperCase() : null;
                                            item.Address.DoubleDependentLocality = (item.Address.DoubleDependentLocality != null) ? item.Address.DoubleDependentLocality.toUpperCase() : null;
                                            item.Address.DependentLocality = (item.Address.DependentLocality != null) ? item.Address.DependentLocality.toUpperCase() : null;
                                            
                                            return{label: m_completeAddress, value: item.Address.DeliveryAddress,
                                            deliveryAddress: item.Address.DeliveryAddress, postalCode: item.Address.PostalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                                            subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality};
                                        }
                                        
                                        return{label: m_completeAddress, value: item.Address.DeliveryAddress,
                                            deliveryAddress: item.Address.DeliveryAddress, postalCode: item.Address.PostalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                                            subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality};
                                    });
                                    
                                    for (var i = 0; i < suites.length; i++) {
                                        results.push(suites[i]);
                                    }
            
                                    results = results.sort(function(a,b) {
                                        return getEditDistance(a.deliveryAddress.toUpperCase(),request.term.toUpperCase()) - getEditDistance(b.deliveryAddress.toUpperCase(),request.term.toUpperCase());
                                    });
                                    
                                    response(results);
                                });
                                
                                }
							},
							select: function(event, ui) {
								event.stopPropagation();
								j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].stateField)).val(ui.item.administrativeArea);
								j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].cityField)).val(ui.item.locality);
								j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].postalField)).val(ui.item.postalCode);    
								j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].streetField)).val(ui.item.deliveryAddress);					
								
							    if (j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g,     "\\3A")].countryField)).val() == "US") {
									setTimeout(function() { sforce.apex.execute('MDPERSONATOR/MD_ExpressEntry', 'consumeCredits', {}); }, 0);
								} else {
									setTimeout(function() { sforce.apex.execute('MDPERSONATOR/MD_ExpressEntry', 'globalConsumeCredits', {}); }, 0);
								}
							}
						})
							.data('ui-autocomplete')._renderItem = function( ul, item ) {
								var srchTerm = j$.trim(this.term).split(/\s+/).join ('|');
								var strNewLabel = item.label;
								regexp = new RegExp ('(' + srchTerm + ')', "ig");
								var strNewLabel = strNewLabel.replace(regexp,"<span style='font-weight:bold;'>$1</span>");
								return j$( "<li></li>" )
								.data( "ui-autocomplete-item", item )
								.append( "<a>" + strNewLabel + "</a>" )
								.appendTo( ul )
								;
							}
						;
							
						j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mapping[i].MDPERSONATOR__postalField__c)).focus(function(event) {
                            currentCountry = j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].countryField)).val();
						});
							
						j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mapping[i].MDPERSONATOR__postalField__c)).autocomplete({
							showHeader: true,
							minLength: 2,
							delay: 1,
							source: function(request, response) {
								j$.getJSON("https://expressentry.melissadata.net/jsonp/GlobalExpressPostalCode?callback=?", {format: "jsonp", id: eeToken, postalcode: request.term, country: currentCountry, maxrecords: "10"}, function (data) {
									response(j$.map(data.Results, function( item ) {  
										var m_completeAddress = item.Address.PostalCodePrimary + ", " + item.Address.Locality + ", " + item.Address.AdministrativeArea;
										return{label: m_completeAddress, value: item.Address.PostalCodePrimary, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea};
									}));
								});
							},
							select: function(event, ui) {
								event.stopPropagation();
								
								j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].cityField)).val(ui.item.locality);
							    j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].stateField)).val(ui.item.administrativeArea);
								j$(j$(window.parent.parent.document.getElementById(iframeId))[0].contentDocument.getElementById(mappingFuncs[String(event.target.id).replace(/\:/g, "\\3A")].streetField)).val('');
							}
						})
							.data('ui-autocomplete')._renderItem = function( ul, item ) {
								var srchTerm = j$.trim(this.term).split(/\s+/).join ('|');
								var strNewLabel = item.label;
								regexp = new RegExp ('(' + srchTerm + ')', "ig");
								var strNewLabel = strNewLabel.replace(regexp,"<span style='font-weight:bold;'>$1</span>");
								return j$( "<li></li>" )
								.data( "ui-autocomplete-item", item )
								.append( "<a>" + strNewLabel + "</a>" )
								.appendTo( ul );
							}
						;

                        j$(".ui-autocomplete").css("z-index", 100000000000);
                    }
                } catch(e) {}
            }// end of Iframe List Loop
        }// End of objectPrefix == mapping[i].MDPERSONATOR__objectPrefix__c
    }// End of Mapping Loop
}// End of Function

var expressEntrySetup = function() { 
    j$ = jQuery.noConflict();

    j$(".ui-autocomplete").css("z-index", 100000000000);
    
    var hideComponentArray = ['expressEntryBox'];
    j$("h2.brandPrimaryFgr").each(function(){
        if(j$.inArray(j$(this).text(), hideComponentArray) != -1){
            console.log(j$(this).text());
            j$(this).parent("div.sidebarModuleHeader").parent("div.linksModule").hide();
        }
    });

    var sessionID = location.search.split('q=')[1].split("&prefix=")[0];
	objectPrefix =  location.search.split('prefix=')[1];
    sforce.connection.sessionId = sessionID;
    
    // get eeMinLookup
    var eeSetting = sforce.connection.query('SELECT ID, MDPERSONATOR__eeMinLookup__c, MDPERSONATOR__eeToggleCase__c FROM MDPERSONATOR__MD_suiteSetting__c').getArray('records');
    eeMinLookup = parseInt(eeSetting[0].MDPERSONATOR__eeMinLookup__c);
    eeToggleCase = (eeSetting[0].MDPERSONATOR__eeToggleCase__c != null) ? eeSetting[0].MDPERSONATOR__eeToggleCase__c : "MIXED";
    
    mapping = sforce.connection.query('SELECT ID, MDPERSONATOR__objectPrefix__c, MDPERSONATOR__streetField__c, MDPERSONATOR__postalField__c, MDPERSONATOR__countryField__c, MDPERSONATOR__cityField__c, MDPERSONATOR__stateField__c FROM MDPERSONATOR__MD_expressEntryMap__c').getArray('records');
			
    if (objectPrefix == null) {
        objectPrefix = window.location.pathname.substr(1,3);
    }

    for (i = 0; i < mapping.length; i++) {
        if (objectPrefix == mapping[i].MDPERSONATOR__objectPrefix__c) {
            eeToken = sforce.apex.execute('MDPERSONATOR/MD_ExpressEntry', 'getExpressToken', {})[0];
            defaultCountry = sforce.connection.query('SELECT ID, MDPERSONATOR__eeCountry__c FROM MDPERSONATOR__MD_suiteSetting__c');
            
            if (defaultCountry != null) {
                defaultCountry = defaultCountry.getArray('records')[0].MDPERSONATOR__eeCountry__c;
            } else {
                defaultCountry = 'US';
            }
            
            j$(function() {
                if (!autocompleteSet) {
                    setupAutocomplete();
                    
                    autocompleteSet = true;
                }
            });
            
            break;
        }
    }
};

var sessionID = location.search.split('q=')[1];

var connectionScript = document.createElement('script');
connectionScript.src = 'https://code.jquery.com/jquery-1.11.2.js';
connectionScript.onload = function() {
    $.getScript('https://code.jquery.com/ui/1.11.3/jquery-ui.min.js', function(data, textStatus, jqxhr) {
        $.getScript('/soap/ajax/32.0/connection.js', function(data, textStatus, jqxhr) {
            $.getScript('/soap/ajax/32.0/apex.js', function(data, textStatus, jqxhr) {
                $('head').append( $('<link rel="stylesheet" type="text/css" />').attr('href', 'https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/base/jquery-ui.css') );
                expressEntrySetup();
            });
        });
    });
}

document.head.appendChild(connectionScript);
</script>
</body>
</html>
