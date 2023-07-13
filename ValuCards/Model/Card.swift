//
//  ValuCards.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import Foundation

struct Cards2: Decodable {
    let itemSummaries: [Card]?
    let total: Int
}

struct Card: Decodable {
    let itemId: String
    let title: String
    let subtitle: String
    let shortDescription: String
    let price: Price
    let categoryPath: String
    let categoryIdPath: Double
    let condition: String
    let conditionId: Double
    
    let image: Image
    let seller: Seller
    
    struct Price: Decodable {
        let value: Double
        let currency: String
    }
    
    struct Image: Decodable {
        let imageUrl: String
    }
    
    struct Seller: Decodable {
        let username: String
        let feedbackPercentage: Double
        let feedbackScore: Int
    }
}

let JSON = """
{
    "itemId": "v1|1**********0|0",
    "sellerItemRevision": "1",
    "title": "Sample Item",
    "shortDescription": "Summary",
    "price": {
        "value": "29.00",
        "currency": "USD"
    },
    "categoryPath": "Home & Garden|Patio, Lawn & Garden|Outdoor Power Equipment|Other Outdoor Power Equipment Accessories",
    "categoryIdPath": "159907|159912|29518|261019",
    "condition": "New",
    "conditionId": "1000",
    "itemLocation": {
        "city": "A**********h",
        "stateOrProvince": "T**********e",
        "postalCode": "3****",
        "country": "US"
    },
    "image": {
        "imageUrl": "https://i.ebayimg.com/images/g/Z**********l/s-l1600.jpg"
    },
    "brand": "test",
    "seller": {
        "username": "c**********r",
        "feedbackPercentage": "98.6",
        "feedbackScore": 16632
    },
    "mpn": "DCA800SSK2C",
    "estimatedAvailabilities": [
        {
            "deliveryOptions": [
                "SHIP_TO_HOME"
            ],
            "estimatedAvailabilityStatus": "IN_STOCK",
            "estimatedAvailableQuantity": 2,
            "estimatedSoldQuantity": 0
        }
    ],
    "shippingOptions": [
        {
            "shippingServiceCode": "Economy Shipping",
            "type": "Economy Shipping",
            "shippingCost": {
                "value": "950.00",
                "currency": "USD"
            },
            "quantityUsedForEstimate": 1,
            "minEstimatedDeliveryDate": "2020-11-06T10:00:00.000Z",
            "maxEstimatedDeliveryDate": "2020-11-06T10:00:00.000Z",
            "additionalShippingCostPerUnit": {
                "value": "950.00",
                "currency": "USD"
            },
            "shippingCostType": "FIXED"
        }
    ],
    "shipToLocations": {
        "regionIncluded": [
            {
                "regionName": "United States",
                "regionType": "COUNTRY",
                "regionId": "US"
            }
        ],
        "regionExcluded": [
            {
                "regionName": "Alaska/Hawaii",
                "regionType": "COUNTRY_REGION",
                "regionId": "_AH"
            },
            {
                "regionName": "US Protectorates",
                "regionType": "COUNTRY_REGION",
                "regionId": "_PR"
            },
            {
                "regionName": "APO/FPO",
                "regionType": "COUNTRY_REGION",
                "regionId": "_AP"
            },
            {
                "regionName": "Angola",
                "regionType": "COUNTRY",
                "regionId": "AO"
            },
            {
                "regionName": "Cameroon",
                "regionType": "COUNTRY",
                "regionId": "CM"
            },
            {
                "regionName": "Cambodia",
                "regionType": "COUNTRY",
                "regionId": "KH"
            },
            {
                "regionName": "Cayman Islands",
                "regionType": "COUNTRY",
                "regionId": "KY"
            },
            {
                "regionName": "Djibouti",
                "regionType": "COUNTRY",
                "regionId": "DJ"
            },
            {
                "regionName": "French Polynesia",
                "regionType": "COUNTRY",
                "regionId": "PF"
            },
            {
                "regionName": "Honduras",
                "regionType": "COUNTRY",
                "regionId": "HN"
            },
            {
                "regionName": "Libya",
                "regionType": "COUNTRY",
                "regionId": "LY"
            },
            {
                "regionName": "Mongolia",
                "regionType": "COUNTRY",
                "regionId": "MN"
            },
            {
                "regionName": "Ecuador",
                "regionType": "COUNTRY",
                "regionId": "EC"
            },
            {
                "regionName": "El Salvador",
                "regionType": "COUNTRY",
                "regionId": "SV"
            },
            {
                "regionName": "Suriname",
                "regionType": "COUNTRY",
                "regionId": "SR"
            },
            {
                "regionName": "Guyana",
                "regionType": "COUNTRY",
                "regionId": "GY"
            },
            {
                "regionName": "Panama",
                "regionType": "COUNTRY",
                "regionId": "PA"
            },
            {
                "regionName": "Mauritius",
                "regionType": "COUNTRY",
                "regionId": "MU"
            },
            {
                "regionName": "Somalia",
                "regionType": "COUNTRY",
                "regionId": "SO"
            },
            {
                "regionName": "Brunei Darussalam",
                "regionType": "COUNTRY",
                "regionId": "BN"
            },
            {
                "regionName": "Chad",
                "regionType": "COUNTRY",
                "regionId": "TD"
            },
            {
                "regionName": "Madagascar",
                "regionType": "COUNTRY",
                "regionId": "MG"
            },
            {
                "regionName": "New Caledonia",
                "regionType": "COUNTRY",
                "regionId": "NC"
            },
            {
                "regionName": "Western Samoa",
                "regionType": "COUNTRY",
                "regionId": "WS"
            },
            {
                "regionName": "Bahamas",
                "regionType": "COUNTRY",
                "regionId": "BS"
            },
            {
                "regionName": "Bermuda",
                "regionType": "COUNTRY",
                "regionId": "BM"
            },
            {
                "regionName": "Iran",
                "regionType": "COUNTRY",
                "regionId": "IR"
            },
            {
                "regionName": "Jamaica",
                "regionType": "COUNTRY",
                "regionId": "JM"
            },
            {
                "regionName": "Saint Kitts-Nevis",
                "regionType": "COUNTRY",
                "regionId": "KN"
            },
            {
                "regionName": "Saint Lucia",
                "regionType": "COUNTRY",
                "regionId": "LC"
            },
            {
                "regionName": "Trinidad and Tobago",
                "regionType": "COUNTRY",
                "regionId": "TT"
            },
            {
                "regionName": "Western Sahara",
                "regionType": "COUNTRY",
                "regionId": "EH"
            },
            {
                "regionName": "Wallis and Futuna",
                "regionType": "COUNTRY",
                "regionId": "WF"
            },
            {
                "regionName": "Nepal",
                "regionType": "COUNTRY",
                "regionId": "NP"
            },
            {
                "regionName": "Bolivia",
                "regionType": "COUNTRY",
                "regionId": "BO"
            },
            {
                "regionName": "Mali",
                "regionType": "COUNTRY",
                "regionId": "ML"
            },
            {
                "regionName": "Fiji",
                "regionType": "COUNTRY",
                "regionId": "FJ"
            },
            {
                "regionName": "Gambia",
                "regionType": "COUNTRY",
                "regionId": "GM"
            },
            {
                "regionName": "Kyrgyzstan",
                "regionType": "COUNTRY",
                "regionId": "KG"
            },
            {
                "regionName": "Laos",
                "regionType": "COUNTRY",
                "regionId": "LA"
            },
            {
                "regionName": "Papua New Guinea",
                "regionType": "COUNTRY",
                "regionId": "PG"
            },
            {
                "regionName": "Congo, Republic of the",
                "regionType": "COUNTRY",
                "regionId": "CG"
            },
            {
                "regionName": "Seychelles",
                "regionType": "COUNTRY",
                "regionId": "SC"
            },
            {
                "regionName": "Sudan",
                "regionType": "COUNTRY",
                "regionId": "SD"
            },
            {
                "regionName": "Guadeloupe",
                "regionType": "COUNTRY",
                "regionId": "GP"
            },
            {
                "regionName": "Uganda",
                "regionType": "COUNTRY",
                "regionId": "UG"
            },
            {
                "regionName": "Vanuatu",
                "regionType": "COUNTRY",
                "regionId": "VU"
            },
            {
                "regionName": "Venezuela",
                "regionType": "COUNTRY",
                "regionId": "VE"
            },
            {
                "regionName": "Burma",
                "regionType": "COUNTRY",
                "regionId": "MM"
            },
            {
                "regionName": "Antigua and Barbuda",
                "regionType": "COUNTRY",
                "regionId": "AG"
            },
            {
                "regionName": "Burundi",
                "regionType": "COUNTRY",
                "regionId": "BI"
            },
            {
                "regionName": "Cuba, Republic of",
                "regionType": "COUNTRY",
                "regionId": "CU"
            },
            {
                "regionName": "Congo, Democratic Republic of the",
                "regionType": "COUNTRY",
                "regionId": "CD"
            },
            {
                "regionName": "Kiribati",
                "regionType": "COUNTRY",
                "regionId": "KI"
            },
            {
                "regionName": "Reunion",
                "regionType": "COUNTRY",
                "regionId": "RE"
            },
            {
                "regionName": "Yemen",
                "regionType": "COUNTRY",
                "regionId": "YE"
            },
            {
                "regionName": "Aruba",
                "regionType": "COUNTRY",
                "regionId": "AW"
            },
            {
                "regionName": "Barbados",
                "regionType": "COUNTRY",
                "regionId": "BB"
            },
            {
                "regionName": "Belize",
                "regionType": "COUNTRY",
                "regionId": "BZ"
            },
            {
                "regionName": "Ghana",
                "regionType": "COUNTRY",
                "regionId": "GH"
            },
            {
                "regionName": "Grenada",
                "regionType": "COUNTRY",
                "regionId": "GD"
            },
            {
                "regionName": "Haiti",
                "regionType": "COUNTRY",
                "regionId": "HT"
            },
            {
                "regionName": "Liberia",
                "regionType": "COUNTRY",
                "regionId": "LR"
            },
            {
                "regionName": "Nicaragua",
                "regionType": "COUNTRY",
                "regionId": "NI"
            },
            {
                "regionName": "Sierra Leone",
                "regionType": "COUNTRY",
                "regionId": "SL"
            },
            {
                "regionName": "Central African Republic",
                "regionType": "COUNTRY",
                "regionId": "CF"
            },
            {
                "regionName": "Comoros",
                "regionType": "COUNTRY",
                "regionId": "KM"
            },
            {
                "regionName": "Martinique",
                "regionType": "COUNTRY",
                "regionId": "MQ"
            },
            {
                "regionName": "Tuvalu",
                "regionType": "COUNTRY",
                "regionId": "TV"
            },
            {
                "regionName": "Dominica",
                "regionType": "COUNTRY",
                "regionId": "DM"
            },
            {
                "regionName": "Lebanon",
                "regionType": "COUNTRY",
                "regionId": "LB"
            },
            {
                "regionName": "Niger",
                "regionType": "COUNTRY",
                "regionId": "NE"
            }
        ]
    },
    "returnTerms": {
        "returnsAccepted": true,
        "refundMethod": "MONEY_BACK",
        "returnShippingCostPayer": "BUYER",
        "returnPeriod": {
            "value": 14,
            "unit": "CALENDAR_DAY"
        }
    },
    "taxes": [
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Alabama",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "AL"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Arizona",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "AZ"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Arkansas",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "AR"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "California",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "CA"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Colorado",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "CO"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Connecticut",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "CT"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "District of Columbia",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "DC"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Georgia",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "GA"
            },
            "taxType": "STATE_SALES_TAX",
            "taxPercentage": "7.0",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": false
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Hawaii",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "HI"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Idaho",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "ID"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Illinois",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "IL"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Indiana",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "IN"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Iowa",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "IA"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Kansas",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "KS"
            },
            "taxType": "STATE_SALES_TAX",
            "taxPercentage": "8.039",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": false
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Kentucky",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "KY"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Louisiana",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "LA"
            },
            "taxType": "STATE_SALES_TAX",
            "taxPercentage": "9.14",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": false
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Maine",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "ME"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Maryland",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "MD"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Massachusetts",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "MA"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Michigan",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "MI"
            },
            "taxType": "STATE_SALES_TAX",
            "taxPercentage": "6.0",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": false
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Minnesota",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "MN"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Nebraska",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "NE"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Nevada",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "NV"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "New Jersey",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "NJ"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "New Mexico",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "NM"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "New York",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "NY"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "North Carolina",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "NC"
            },
            "taxType": "STATE_SALES_TAX",
            "taxPercentage": "6.922",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": false
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "North Dakota",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "ND"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Ohio",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "OH"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Oklahoma",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "OK"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Pennsylvania",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "PA"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Rhode Island",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "RI"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "South Carolina",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "SC"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "South Dakota",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "SD"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Tennessee",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "TN"
            },
            "taxType": "STATE_SALES_TAX",
            "taxPercentage": "9.25",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": false
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Texas",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "TX"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Utah",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "UT"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Vermont",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "VT"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Virginia",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "VA"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Washington",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "WA"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "West Virginia",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "WV"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Wisconsin",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "WI"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        },
        {
            "taxJurisdiction": {
                "region": {
                    "regionName": "Wyoming",
                    "regionType": "STATE_OR_PROVINCE"
                },
                "taxJurisdictionId": "WY"
            },
            "taxType": "STATE_SALES_TAX",
            "shippingAndHandlingTaxed": true,
            "includedInPrice": false,
            "ebayCollectAndRemitTax": true
        }
    ],
    "localizedAspects": [
        {
            "type": "STRING",
            "name": "Brand",
            "value": "Multiquip"
        },
        {
            "type": "STRING",
            "name": "Model",
            "value": "DCA800SSK2C"
        },
        {
            "type": "STRING",
            "name": "MPN",
            "value": "DCA800SSK2C"
        }
    ],
    "primaryProductReviewRating": {
        "reviewCount": 0,
        "averageRating": "0.0",
        "ratingHistograms": [
            {
                "rating": "5",
                "count": 0
            },
            {
                "rating": "4",
                "count": 0
            },
            {
                "rating": "3",
                "count": 0
            },
            {
                "rating": "2",
                "count": 0
            },
            {
                "rating": "1",
                "count": 0
            }
        ]
    },
    "priorityListing": true,
    "topRatedBuyingExperience": false,
    "buyingOptions": [
        "FIXED_PRICE"
    ],
    "itemWebUrl": "https://www.ebay.com/itm/Sample-Item/1**********0",
    "description": "Detailed description",
    "paymentMethods": [
        {
            "paymentMethodType": "WALLET",
            "paymentMethodBrands": [
                {
                    "paymentMethodBrandType": "PAYPAL"
                }
            ]
        },
        {
            "paymentMethodType": "CREDIT_CARD",
            "paymentMethodBrands": [
                {
                    "paymentMethodBrandType": "VISA"
                },
                {
                    "paymentMethodBrandType": "MASTERCARD"
                },
                {
                    "paymentMethodBrandType": "AMERICAN_EXPRESS"
                },
                {
                    "paymentMethodBrandType": "DISCOVER"
                }
            ]
        }
    ],
    "enabledForGuestCheckout": false,
    "eligibleForInlineCheckout": true,
    "lotSize": 0,
    "legacyItemId": "1**********0",
    "adultOnly": false,
    "categoryId": "261019"
}
"""

 
