from copy import deepcopy
from bson import ObjectId

class Organizations:
    def __init__(self):
        self._default_template = {
            "__v": 0,
            "_id": None,
            "name": None,
            "processed": False,
            "version": 3,
            "minimumRetriggerTime": "06:00",
            "enableCheckOut": True,
            "activeAllDay": True,
            "tags": [],
            "categoryTags": [],
            "brandTags": [],
            "category": "Custom",
            "subcategory": "Outdoor Media",
            "lease": False,
            "country": "NZ",
            "organisationType": "physical",
            "managed": False,
            "travelPast": True,
            "datasource": "travelPast"
        }

        self._fields = [
            {
                "name": "travelPast",
                "address": "travelPast",
                "requiredFor": [
                    "brandAffinity",
                    "audienceOptimiser"
                ],
                "required": True,
                "default": True,
                "values": [],
            },
            {
                "name": "datasource",
                "address": "datasource",
                "requiredFor": [
                    "brandAffinity",
                    "audienceOptimiser"
                ],
                "required": True,
                "default": "travelPast",
                "values": [
                    "travelPast"
                ],
            },
        ]

        self._supportedOrganizations = {
            "Calibre":[
                {
                    "organizationName": "Calibre-Sites",
                    "organizationId": "60b31bcd8e1e1fde00bf3706",
                    "panelProduct": "Roadside",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "organizationName": "Calibre - Place Based",
                    "organizationId": "62eb8a9bb3cfc8578d78efb8",
                    "panelProduct": "Placebased",
                    "archived": False,
                    "siteClass": "PB_SC",
                    "siteSubClass": "PB_SC"
                }
            ],
            "MediaOwners":[
                {
                    "clientName": "oOh Media",
                    "organizationName": "oOh Media - Retail Panels",
                    "organizationId": "62202ff63a20c0394efe4dc6",
                    "panelProduct": "Placebased",
                    "archived": True,
                    "siteClass": "PB_SC",
                    "siteSubClass": "PB_SC"
                },
                {
                    "clientName": "oOh Media",
                    "organizationName": "oOh Media - Street Furniture",
                    "organizationId": "629f165d4cd545e19c36e489",
                    "panelProduct": "Roadside",
                    "archived": True,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "oOh Media",
                    "organizationName": "oOhMedia - Roadside - Classic",
                    "organizationId": "66f10d3bc7e9bf6c5950c2bb",
                    "panelProduct":"Roadside",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "oOh Media",
                    "organizationName": "oOhMedia - Roadside - Digital",
                    "organizationId": "66f10d3bc7e9bf6c5950c2ba",
                    "panelProduct":"Roadside",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "oOh Media",
                    "organizationName": "oOhMedia - ShoppingCentre - Classic",
                    "organizationId": "66f10d3bc7e9bf6c5950c2bc",
                    "panelProduct":"Placebased",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "PB_SC",
                    "siteSubClass": "PB_SC"
                },
                {
                    "clientName": "oOh Media",
                    "organizationName": "oOhMedia - ShoppingCentre - Digital",
                    "organizationId": "66f10d3bc7e9bf6c5950c2bd",
                    "panelProduct":"Placebased",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "PB_SC",
                    "siteSubClass": "PB_SC"
                },
                {
                    "clientName": "JCDecaux",
                    "organizationName": "JCDecaux - Airport - Digital",
                    "organizationId": "66b1bbf394c91b1e4b777287",
                    "panelProduct":"Placebased",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "PB_AP",
                    "siteSubClass": "PB_AP"
                },
                {
                    "clientName": "JCDecaux",
                    "organizationName": "JCDecaux - Airport - Classic",
                    "organizationId": "66ceac5a2a46524df7d5603e",
                    "panelProduct":"Placebased",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "PB_AP",
                    "siteSubClass": "PB_AP"
                },
                {
                    "clientName": "JCDecaux",
                    "organizationName": "JCDecaux - Roadside - Classic",
                    "organizationId": "66ceac5a2a46524df7d5603f",
                    "panelProduct":"Roadside",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "JCDecaux",
                    "organizationName": "JCDecaux - Roadside - Digital",
                    "organizationId": "66ce9d092a46524df7d55fbb",
                    "panelProduct":"Roadside",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "VAST Billboards",
                    "organizationName": "VAST Billboards - Roadside - Digital",
                    "organizationId": "66de4f84c005a7e4b04b3235",
                    "panelProduct":"Roadside",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "VAST Billboards",
                    "organizationName": "VAST Billboards - Roadside - Classic",
                    "organizationId": "66de4f83c005a7e4b04b3234",
                    "panelProduct":"Roadside",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "JOLT",
                    "organizationName": "JOLT",
                    "organizationId": "65544188397e42fb7d0055cb",
                    "panelProduct": None,
                    "panelFormat": None,
                    "archived": True,
                    "siteClass": None,
                    "siteSubClass": None
                },
                {
                    "clientName": "JOLT",
                    "organizationName": "JOLT - Roadside - Digital",
                    "organizationId": "66de4f1bc005a7e4b04b3228",
                    "panelProduct":"Roadside",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "MediaWorks",
                    "organizationName": "MediaWorks - Airport - Classic",
                    "organizationId":"66d1ac9cdfac96b384da9b17",
                    "panelProduct":"Placebased",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "PB_AP",
                    "siteSubClass": "PB_AP"
                },
                {
                    "clientName": "MediaWorks",
                    "organizationName": "MediaWorks - Airport - Digital",
                    "organizationId":"66d1abc1dfac96b384da99e6",
                    "panelProduct":"Placebased",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "PB_AP",
                    "siteSubClass": "PB_AP"
                },
                {
                    "clientName": "MediaWorks",
                    "organizationName": "MediaWorks - Roadside - Classic",
                    "organizationId":"66d1ac9cdfac96b384da9b18",
                    "panelProduct":"Roadside",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "MediaWorks",
                    "organizationName": "MediaWorks - Roadside - Digital",
                    "organizationId":"66d1abc1dfac96b384da99e8",
                    "panelProduct":"Roadside",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "Mediaworks",
                    "organizationName": "MediaWorks - Shopping Centre - Classic",
                    "organizationId": "67be6b7996e30f9cb0936a3e",
                    "panelProduct":"Placebased",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "PB_SC",
                    "siteSubClass": "PB_SC"
                },
                {
                    "clientName": "Mediaworks",
                    "organizationName": "MediaWorks - Shopping Centre - Digital",
                    "organizationId": "67be6b7996e30f9cb0936a3f",
                    "panelProduct":"Placebased",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "PB_SC",
                    "siteSubClass": "PB_SC"
                },
                {
                    "clientName": "Bekon",
                    "organizationName": "Bekon - Roadside - Digital",
                    "organizationId": "66de4f83c005a7e4b04b322d",
                    "panelProduct":"Roadside",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "Go Media - sales",
                    "organizationName": "GoMedia - Roadside - Classic",
                    "organizationId": "66ea6165c7e9bf6c5950c2b6",
                    "panelProduct": "Roadside",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "Go Media - sales",
                    "organizationName": "GoMedia - Roadside - Digital",
                    "organizationId": "66ea6166c7e9bf6c5950c2b7",
                    "panelProduct": "Roadside",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "Go Media - sales",
                    "organizationName": "GoMedia - Airport - Digital",
                    "organizationId": "67c4fb6f6b52ef7d5c354819",
                    "panelProduct": "Placebased",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "PB_AP",
                    "siteSubClass": "PB_AP"
                },
                {
                    "clientName": "LUMO",
                    "organizationName": "LUMO - Roadside - Digital",
                    "organizationId": "66f29f96bd6ba976cf04bb79",
                    "panelProduct": "Roadside",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "Ad-Vantage Media",
                    "organizationName": "Ad-Vantage Media",
                    "organizationId": "5f7fbd46159345000459c2e4",
                    "panelProduct":"Roadside",
                    "panelFormat": None,
                    "archived": True,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "Ad-Vantage Media",
                    "organizationName": "Ad-Vantage Media - Roadside - Digital",
                    "organizationId": "67db88fc3ee9d3b7115cae04",
                    "panelProduct":"Roadside",
                    "panelFormat": "Digital",
                    "archived": False
                },
                {
                    "clientName": "Ad-Vantage Media",
                    "organizationName": "Ad-Vantage Media - Roadside - Classic",
                    "organizationId": "67db88fc3ee9d3b7115cae05",
                    "panelProduct":"Roadside",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "Media5",
                    "organizationName": "Media5",
                    "organizationId": "5f7fbdaf159345000459c2ea",
                    "panelProduct":"Roadside",
                    "panelFormat": None,
                    "archived": True,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "Media5",
                    "organizationName": "Media5 - Roadside - Classic",
                    "organizationId": "66de4f83c005a7e4b04b322e",
                    "panelProduct":"Roadside",
                    "panelFormat": "Classic",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                },
                {
                    "clientName": "Media5",
                    "organizationName": "Media5 - Roadside - Digital",
                    "organizationId":"66de4f83c005a7e4b04b322f",
                    "panelProduct":"Roadside",
                    "panelFormat": "Digital",
                    "archived": False,
                    "siteClass": "RS",
                    "siteSubClass": "RS"
                }
            ]
        }

    @property
    def default_template(self):
        return deepcopy(self._default_template)

    @property
    def fields(self):
        return self._fields

    @property
    def supportedOrganizations(self):
        return self._supportedOrganizations