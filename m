Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383C34BE2EA
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 18:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiBUMWC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 07:22:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238103AbiBUMWB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 07:22:01 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120040.outbound.protection.outlook.com [40.107.12.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5139CF5;
        Mon, 21 Feb 2022 04:21:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9bFb9tGbCpxHVBVaSQFMFPVc9Sqmud4Pz+TdOrTVT8P5dqDUvMgGpWyOefNn2LUuEn+KFNARqz+kSeiJHDSACRsB1Xc7EVALA6kTObtxe8Nn7IlISdXGAs1+WX+TMCKjKW3lG2XQ5GvZurgmnCKfLz7ZRADYUrAfJ5a0Y36I3h8WiyOSLvYvATS0ocUvvLmX+gJBksWZaIxrPD9p6SrBPux6BotMgw2HF6d25uDy5qHFn0ijVSmAqdXvFl+djd73W8HO+ZDxjNOPrmy+bS1IHzLcsy1vPLEUSkVtJeTn+ekmRadMcG00/Az0p3kaNbV4GJhQPFu2molTRbKFGe44w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/len/AzuKT3K321Qc0DxYgxAqhMDwhrEzf7nzZgIRA=;
 b=AzaVFRN9s3Pt51WmKRUWZWer7TVTj0eLGb4ehuYkPMW8szu9Z5XgkOB86bGYO/vlhuXxymQelqlJL8DOnicgS0Dvi2KRyMMGQXkKNFcElKsPqa4KUtEm3fI7Koqqi/X1ta1pWriuo5KjnJox9xltHZ0yXL+eQgupeGt3/xWY8fCQGuUXFrSmQqK5Mun/yyfE8AgHDcOCVPT4C1EawkQ0Na0w8zCtnUMu6dfjYaBCYbvQVstFIFvI00d0r8eSQNfw0Q0Rhtc7SxQTlHfJATJjZOIIoFhgJmw9XWQK27s2kZwHdFmCQGQMJz8CmOyleqLicBLYA9Mm8xD4dus5WzoG0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB3405.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 12:21:34 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 12:21:34 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Aaron Tomlin <atomlin@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
CC:     "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Subject: Re: [PATCH v6 01/13] module: Move all into module/
Thread-Topic: [PATCH v6 01/13] module: Move all into module/
Thread-Index: AQHYJQ4Iyc5hoYSPF0yTCd/J8nGTMKyd8QOA
Date:   Mon, 21 Feb 2022 12:21:34 +0000
Message-ID: <69fcaad3-e48c-11ca-ed50-7a18831e3e91@csgroup.eu>
References: <20220218212511.887059-1-atomlin@redhat.com>
 <20220218212511.887059-2-atomlin@redhat.com>
In-Reply-To: <20220218212511.887059-2-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e698bf6f-45c4-4018-440a-08d9f534b32e
x-ms-traffictypediagnostic: PR1P264MB3405:EE_
x-microsoft-antispam-prvs: <PR1P264MB340524BC6F8208EB65B4D764ED3A9@PR1P264MB3405.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xgpL2woQLu7d9dQFr7AQX0aXmy7javV7XhP0u8eeg/oRhvldwrqiT3reYgU3nvrlBczFZ1zDp0FjQ4lmojvplXWkDZi1u0sKO7NaSLh8/1+IV/T94IozT8jmNjo3aWkES8ku/rKeCCzHdKpkzbuSs+mlM6aTnyCbtOHLzefZ7K7LHjovF8bRtN44DuhoCBetr3aeGNSZ/CSX/ApRTZGx5hinGfbGsneyPYS2FyAvCzyrrnU6U/lvjJArbURKLt93Cm7v9Vhy9Q0Vt37x5JieTH4QO8iOZyraC2HngE5A4diMuQ/Oe9Sd9SjfnXU+wr8KwsuU7BUqFT1qgxXXORKGy2OMmPFxpu0Zk6FjUzR+EopDmUhiRaBJHUnr8lNn3D1U3edAgcOLKlI60z4Nw2r56zKO7BY8r8Ltjp3H/y6nslmggdyG5uqO1IaLgsEOgDemdgB/HyxFeJ1Bh0eUJnF2qJBVJ1Cza1D+14XCp4IvHCLlHk6R6/WqER39LJOeQ1PJ6N2aP1QszwVwq1uJl0qavcmiOTzx6+Yj4uT/SoTY6/9dkC+f5OaLCKhzO2Rz7eIWzYoUBGm5pQh9bkkr4Q24eX3uJkh954pz+rvUv6EmUTDH2vINI5QxrY9Zl0AT+ImCiV02AbQWVFlr+IW3XSIbcM5Rg35CY0peazQuMqkAl0UG6t+PWSNx8pE/qemPCusXNXcxhaq2R1EFBIYxW2GGKldAv8lFy3cxSW8jyh6Ht9JrmycxZARya1Lv45A3oUq9X6zHUA8T5S3rydmybDn1+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(6506007)(36756003)(66556008)(6512007)(2906002)(31686004)(66446008)(86362001)(26005)(31696002)(66946007)(44832011)(4326008)(2616005)(8676002)(5660300002)(186003)(122000001)(6486002)(508600001)(38100700002)(64756008)(8936002)(71200400001)(7416002)(83380400001)(91956017)(76116006)(38070700005)(316002)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnhJNzZlMStSSXlvL2ZaOEJWVmJzZWRITGZCOFhuMjlHSnk2MmxLYXpqUzVR?=
 =?utf-8?B?NzJ4cUo0cWdVYzA2UjJRMTdMNURDN0lNWWlJeFdWOXRsZkkwYzdIRGdmcENu?=
 =?utf-8?B?OG5PdWpBVFU5Y1BiQjN2QXBiSFBlYWV4MVRiN3hsRWVVaXJzTDAydERRQ3ph?=
 =?utf-8?B?V0ZYTEc3dzB3eGRVTEEwaXR5WTFSbjlCQkptaFA1OEJhclIvVXZ3eEtUOUdW?=
 =?utf-8?B?MTFtbndTMnd6MmtlaDdWSUxqenJzV1FpOTdPaFE5VzM0OTFvT2lHTDF2bVpH?=
 =?utf-8?B?dmVhV2pTNS84NjRyUmlJM1RRYk41TGJzbURlNkZQRDJQUjBUeDM5ekRFVEFt?=
 =?utf-8?B?d3B4YllTT28rZTlxQlpYeE5hR200d0FlZ25xcnpvZ0F5UGFqQTA2a0lWSWds?=
 =?utf-8?B?ejlIOUtaUUJaalg5RU11RURzSGZYeUJ5dk8raHBmNUtDQ1YxY2srWW9kYnpR?=
 =?utf-8?B?VFdRQ0Y3c0JvdjdOQ3pVY2lpOFhGTDB6ZDNIclVJRHRFV0NrTHkxOTViUS9C?=
 =?utf-8?B?aGtRMDlBaUY1b3psbjRxd0VrVTZCQXJIaGFFZ0lSUlQ2Q2xRdWdOK0Zva1VM?=
 =?utf-8?B?eTRHQlZWSisrTk5qekxvcXBWbU5rQys2dlFnZFZJcmhxOWhaRExKVW9YVG1o?=
 =?utf-8?B?TVNrZnVRd05FelcrNE03TDI2NkFWdEpPSElFdXRrNHpCTVN2UjdIMzBoSTlE?=
 =?utf-8?B?dUpCS2htOUlpdDd0L0FhaFFvNURsMnIxc2lBZXVhN050Zm50TFA2clZNb0dP?=
 =?utf-8?B?cDBNTXhkZ2ZNUlhBTGRqQmRraGtVVk8yZWlLcjZ0czlEdW5KWXlIT2thcGhQ?=
 =?utf-8?B?bE1HK2x3Q3FoQ00vQkgyTlhTVjZ5N0hIcEpLaFkwclNhbW05d3pFQmlMdzdt?=
 =?utf-8?B?YUhoU0paN3RweXo4MlZVNVBDc0NSSWNkSVByY2QycER2TGlNYmNpNDdaVVZR?=
 =?utf-8?B?c29hRHdtcUpXZW9sb1psamZBTlVRQVpWOGxpTUpBL0dRNngyMXNpSUNnRFRk?=
 =?utf-8?B?S0MwN04yRkdsbkl1dEorUmc2bU9sVWpwdlVheU9EWG1iOHBIMm5sbGxmeVpR?=
 =?utf-8?B?NHNSdUthZXNWcTdxL0JHUDRIbVcxTEtJTlVmbitDanNIR3F5MFlaQ2hSaWJi?=
 =?utf-8?B?dXdUai8rSUE1T1Q2bkRHL1FSY3plaWppRnEyWmNBVTNucHJFcmFjT3ZuWldF?=
 =?utf-8?B?T3RneUFPU3BnVmYyRm5oOUlseTVaMmE2T0Y5cE9lak44eVNmdThEWm5leU1h?=
 =?utf-8?B?QlM1Ynh1OExoWFhSSi9KbEJLKzF3RElFZVV1SXVOOHF1TmZwMU9BQTVVTVdW?=
 =?utf-8?B?aENwTDlyc1p3eVVXa0hFdzdkazV2ek1wdW5TL3c5MDNROXA4YWJIS3R2ZmNR?=
 =?utf-8?B?NkRObUYxOWExbHppdnZCNmo0OEs5RzdUczl5Mzl1dG9qbzI0cjkxcVhoejdm?=
 =?utf-8?B?dERJeWdsVUFoVmg2TFd3TFN6K3JaNmtPeGxpaVVjWnNJMGpxV3Z3U0Qycmcv?=
 =?utf-8?B?RVlvWFJFZXp6VFhSUjR5VE1aYm4wdU1vaWk2KzlNYm9WQlNqQVdoUG83Z2h2?=
 =?utf-8?B?azZwcG9WZW8xZ0Q1b1k0N29PdzJKd1ZHUE45R2ExVzJhRlRPYkJFcXA4M01B?=
 =?utf-8?B?MW80bmN3dHRNd0dxaUpDTEtPTzlYSTJoQXJyU0ZiTGgzZDVaZjQvMXMyNVMr?=
 =?utf-8?B?U0xSdytSWWJ5WXpBSWhBWlQyajNuUjdoSytsOXlZWXRoRjNxOVZqVG9qWVFD?=
 =?utf-8?B?N2lCbFNqcjA3VGRGbCt6TlBDNlk5MFg1ZzhkL0dTWmVNWlB2aTVZRmZSNjg3?=
 =?utf-8?B?Q3dOaEVSV0dXRWVKRkZpQnhWNEhTbTJ4NnJ0clJTL3ZlZWRmTHBRTTZGWVJV?=
 =?utf-8?B?K1JuOVYrQnQzaFUwL1hUbEpNV3dkOWZmbCs4aG9TY1phN0gvek9hdUhNbjRw?=
 =?utf-8?B?M1JIbnlURllOOGlRNHJic0E4QXplelNVTmxOT3FxVGdxc0VuL294M0JIN24r?=
 =?utf-8?B?TmI5TmFzWVFsMzRnRGxlOFI0MGtGMUpFMVVCMWQ0VHV0VHRZR1dHYUN6L0Na?=
 =?utf-8?B?cU5pMzZXaTFxUDBmQTd1RWZEeEQ5eE9zRERvMGRsV3o4TXN2c2NOdEFoQ2xl?=
 =?utf-8?B?V0V6ZnBnYUZKSnAwcjhWWjRRMVZsT2duMlFDajIzcDNSTlp3N2FFZ3RvQlZy?=
 =?utf-8?B?SHNWeHNpNFVnRU1oTVZwTnBnN24zQkkwRmRzSXM2MjlyZ3hJTE43cHFYNGUz?=
 =?utf-8?Q?68BJA18HFV1/5qGiV2i5xK+c7niqJ7xqXOB1AumLyQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00622BCC324BCF46BA18DEC5262B94DF@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e698bf6f-45c4-4018-440a-08d9f534b32e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 12:21:34.2269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oeuynobti1xf55eSmUR1qF10c8r9Atu0Vp2FSGcUKuMzAqy/0v54cETG4pGjSfe2V3OUv9y7kZsfVS/Q2O4UGmoaYHiHfpxnEcLoJvBPqBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB3405
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDE4LzAyLzIwMjIgw6AgMjI6MjQsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZXMuDQo+IA0KPiBUaGlzIHBhdGNoIG1vdmVzIGFsbCBtb2R1bGUg
cmVsYXRlZCBjb2RlIGludG8gYSBzZXBhcmF0ZSBkaXJlY3RvcnksDQo+IG1vZGlmaWVzIGVhY2gg
ZmlsZSBuYW1lIGFuZCBjcmVhdGVzIGEgbmV3IE1ha2VmaWxlLiBOb3RlOiB0aGlzIGVmZm9ydA0K
PiBpcyBpbiBwcmVwYXJhdGlvbiB0byByZWZhY3RvciBjb3JlIG1vZHVsZSBjb2RlLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQWFyb24gVG9tbGluIDxhdG9tbGluQHJlZGhhdC5jb20+DQo+IC0tLQ0K
PiAgIE1BSU5UQUlORVJTICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
IDIgKy0NCj4gICBrZXJuZWwvTWFrZWZpbGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCA1ICstLS0tDQo+ICAga2VybmVsL21vZHVsZS9NYWtlZmlsZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgOSArKysrKysrKysNCj4gICBrZXJuZWwve21vZHVsZV9kZWNvbXBy
ZXNzLmMgPT4gbW9kdWxlL2RlY29tcHJlc3MuY30gfCAyICstDQo+ICAga2VybmVsL3ttb2R1bGUt
aW50ZXJuYWwuaCA9PiBtb2R1bGUvaW50ZXJuYWwuaH0gICAgIHwgMA0KPiAgIGtlcm5lbC97bW9k
dWxlLmMgPT4gbW9kdWxlL21haW4uY30gICAgICAgICAgICAgICAgICB8IDIgKy0NCj4gICBrZXJu
ZWwve21vZHVsZV9zaWduYXR1cmUuYyA9PiBtb2R1bGUvc2lnbmF0dXJlLmN9ICAgfCAwDQo+ICAg
a2VybmVsL3ttb2R1bGVfc2lnbmluZy5jID0+IG1vZHVsZS9zaWduaW5nLmN9ICAgICAgIHwgMiAr
LQ0KPiAgIDggZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkN
Cj4gICBjcmVhdGUgbW9kZSAxMDA2NDQga2VybmVsL21vZHVsZS9NYWtlZmlsZQ0KPiAgIHJlbmFt
ZSBrZXJuZWwve21vZHVsZV9kZWNvbXByZXNzLmMgPT4gbW9kdWxlL2RlY29tcHJlc3MuY30gKDk5
JSkNCj4gICByZW5hbWUga2VybmVsL3ttb2R1bGUtaW50ZXJuYWwuaCA9PiBtb2R1bGUvaW50ZXJu
YWwuaH0gKDEwMCUpDQo+ICAgcmVuYW1lIGtlcm5lbC97bW9kdWxlLmMgPT4gbW9kdWxlL21haW4u
Y30gKDk5JSkNCj4gICByZW5hbWUga2VybmVsL3ttb2R1bGVfc2lnbmF0dXJlLmMgPT4gbW9kdWxl
L3NpZ25hdHVyZS5jfSAoMTAwJSkNCj4gICByZW5hbWUga2VybmVsL3ttb2R1bGVfc2lnbmluZy5j
ID0+IG1vZHVsZS9zaWduaW5nLmN9ICg5NyUpDQo+IA0KDQpJJ20gd29uZGVyaW5nIHdoZXRoZXIg
d2Ugc2hvdWxkIGF2b2lkIG1vdmluZyBtb2R1bGVfc2lnbmF0dXJlLmMgYW5kIA0KbGVhdmUgaXQg
aW4ga2VybmVsLyBhcyB0aGlzIGZpbGUgaXMgdXNlZCBldmVuIHdoZW4gQ09ORklHX01PRFVMRVMg
aXMgbm90IA0Kc2VsZWN0ZWQsIGFuZCBoZSBpcyB0aGUgb25seSBvbmUgbGlrZSB0aGlzLg0KDQpL
ZWVwaW5nIGl0IG91dHNpZGUgb2Yga2VybmVsL21vZHVsZS8gd291bGQgYWxsb3cgdG8gY29uZGl0
aW9uYWx5IGJ1aWxkIA0KZW50aXJlIGtlcm5lbC9tb2R1bGUvIGJhc2VkIG9mIENPTkZJR19NT0RV
TEVTIGFuZCB0aGVuIGF2b2lkIGFsbCBjaGVja3MgDQphZ2FpbnN0IENPTkZJR19NT0RVTEVTIHdo
aWNoIGxvb2sgbWlzbGVhZGluZyBhdCB0aW1lcy4NCg0KDQpDaHJpc3RvcGhl
