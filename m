Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1E9737788
	for <lists+live-patching@lfdr.de>; Wed, 21 Jun 2023 00:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjFTWgV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 18:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjFTWgU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 18:36:20 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77194DC
        for <live-patching@vger.kernel.org>; Tue, 20 Jun 2023 15:36:18 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35KLTdZs005824
        for <live-patching@vger.kernel.org>; Tue, 20 Jun 2023 15:36:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=fOMHY4RI52fH6uNeuMy2cfSwubuNbQfXsY+kQ1POk0Q=;
 b=YE9Fg/CxZ628na+elGWExgkO1MGiRdKtpYdB60W8bqfh7lEubZGksnyHECfUL1nBsDsQ
 r6zXVWM5d8x2Rbl5bEAQ1PuVBesL9gAa/pwPnRhzCVcEWGNH2/IoFG8u6nNJ8QPvyjti
 wnEvaxlr1OaSwi1lkcI+vxTQmM+VKJxbe6Keudtaav5NQ7/AILjpv1sm8isZct/BGk0v
 oZkZT3Ta3qeMdDdnch8rPcWdcxxd7QH0kQRg2aJXOSfi5v995+jle0jYrcBDpp/6TEZI
 R1AOcNCIx9NMz9iKLpnhF1tIHha0AKjHwYr6epVu6elq0dluso1qV4MitXmMJGJ0KF7W bQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3rbdp3kuhw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Tue, 20 Jun 2023 15:36:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLHqhkUqBTBzRlj8Zl9y5hVnW+MdbRiylTqdwBzsk8ombvMsad9rPzCAuIvl97T0/qidDklC9scdWc0FCJ+SAM/B4phC5IoZ+tdjZV/pQBHjt7ymFXBhK2bra1Wm5ZmqycjWPJYclvHDHBMj3Ks1hqwgMgtIlnCXU8he57+aioCtUkoJbWatwQzNscy74T1sXW+0TWAg2qPEDzAWtB9xOLPNCYv7I489FpBiy4IPKWT3sB51CU3eau1hO6op7uTb8fszOLE4cl70WEbZr3MQq6WJrFKacQ2dmE/pSY8Kd9GLxnjMqcyBxfTSDFGPgbHweU23x5V2WKeS6T0ZuLUCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOMHY4RI52fH6uNeuMy2cfSwubuNbQfXsY+kQ1POk0Q=;
 b=OjdWS3XEjCUYukMO8P1y1GJuH38f2WaXdUlKIxHGvWN06qB3jQh5vODTxeBmkZA0NLPzsaOasrk0Yj26n9pdayX2cGdkJ5Yt2GG6VLLiZ5IPh9X05W1JAnxmNBjY/3Ie+fERHKEbxx7v7d8GL3FvWKR0OZm+ap9VnH23xCqFob1YwfdWn9m10UnEttg8xoWYDC7VfAxVd+ThAKIPwCJXrc0XyAPZgjC48d9wq7Hlb2WJGxoF4oj4+RkU8shqSmQfpXxm6T3NLZboFGTmw/hEcQNwnVXIKFWjo7y0Wq+ImTrqtfp1BNBIJceSMSZAYQl3Wb0uZjxwSEY2Q+ygCXtNMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB5813.namprd15.prod.outlook.com (2603:10b6:510:297::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 22:36:14 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%7]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 22:36:14 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Petr Mladek <pmladek@suse.com>
CC:     Song Liu <song@kernel.org>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        Song Liu <songliubraving@meta.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
Thread-Topic: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match
 symbols exactly
Thread-Index: AQHZn6r1VuNYFv7wzUinZRrB36Nwc6+NK0aAgACH3YCAA8rIgIAAGgiAgABsKACAAkvAAA==
Date:   Tue, 20 Jun 2023 22:36:14 +0000
Message-ID: <47E4EA81-717E-43A2-8D6D-E7E0F2569944@fb.com>
References: <20230615170048.2382735-1-song@kernel.org>
 <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
 <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
 <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
 <ZJA8yohmmf6fKsJQ@alley>
In-Reply-To: <ZJA8yohmmf6fKsJQ@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB5813:EE_
x-ms-office365-filtering-correlation-id: 99904452-d44c-49c3-3d3b-08db71dec183
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NyQyMrOfuJgQo8wUHJl+zxPb+/5dDl/t/FVhayWuP8/BIyaSVQg+kObQuhWP+V2cG3FPEmNG9IIOOfOZT58nCpqv6vm2K3K1ak9Ac+mFx9InFM48elXYohD9th8TuNUDFJDa4qpmAshOh+BdCGh4T84x61vjdVNRF14CA5gHiXilj6dS6lJWd+jlhRgpRTJrCtUrTlmGtTAPLhSv8AXA9Z4nN5qSc/jkOSvbT5zxTGnDr6keuGIOJXrFjKryISCcLDmV/uQdYhK8gxrP0a/DhwNfNHYI4YydEG9W6GWq7+sJrhBUGLJBpjej77QBMfsQxOs8TXcCN34UDf886ImZ5ZIDyyJ+XsRwIOENeAx19HE9mzdNSj7RuttsePnPCmVrmaU++i58As8j9TVSPuR/6YiAbZ0Wp2SsWXPMCk8bYYrI+bovE32cIa/0woGKSTW0/oTwtGkZ/kvngzR9BhIZez/xUzCAuaZ2pu3fKLJS84lIhgMKj+5leV3iWfShhXXKqZUit9cn2KJKISQ7u396nEX1K4j7NZTtDbuVRdUzaARkUua69rfzvk0C/yaoVJ9Yl6IbcgkDAThV+7vs51GR0Ze+XvIOeGJmhROuDJLLqurVWVPhtlrIZDTnh8d/YUN3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199021)(186003)(54906003)(71200400001)(6486002)(9686003)(86362001)(53546011)(6506007)(6512007)(478600001)(316002)(38100700002)(66946007)(122000001)(76116006)(91956017)(66446008)(64756008)(66476007)(66556008)(6916009)(4326008)(41300700001)(5660300002)(38070700005)(2906002)(36756003)(33656002)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHp5akNtU2NhZ2hac0Z2SDc0R0JtNkdWUUQ5QlAvQmZjZkFFdHFRNHgxbzk1?=
 =?utf-8?B?cVNYUjgzdG1DY2RWNjZEUGZVTzRtZGVpTjVSaFRMaHRJRCtEZzlONFhmbDAz?=
 =?utf-8?B?anRoZ0JQQTN6cmpEVzdwL2wzRnVLNTNqNGN5ZVdObm5ITGFqV2hvU3QrSDBx?=
 =?utf-8?B?dStSY0w2NS9tYlNiUUpFS01RY3BxL0JqZ3ZrQ2NXVXp2c2pqOUErUW9COVpS?=
 =?utf-8?B?c29xbFNYV1VNcWlOSlI1VmdaVG9uVjJVdHFXY0wzbld6V1ovNklEck55K2M0?=
 =?utf-8?B?Q0J2YUh1eEdJSmJ3RWxPZ1MxOFVwcWhEYUtYTnVxMnlTeVpKbmxlR0F2cjRI?=
 =?utf-8?B?alRJenhjalZiU0xmaThYK0RWMElDMWY4Tjl0SkJFS0Z3ZnFGY29LMmxBZm5H?=
 =?utf-8?B?aFcwTHRjYmNRUE1YWnNJSE9ZanBqQ1lFNU1wYnQwTUFGN0RaeFlxbUFYb2sv?=
 =?utf-8?B?cXZ2MEtPTW1xNXlFZHJMUVBoMWNWSVo2UG5TQUM2UGFKa2FTeDgvb0tMaDQ5?=
 =?utf-8?B?RlMyU2I0bzR6cWN3WjVMT2RLcnExQ2w2MCt1SW9kQU9KcVgrdDJyK2JPNFlm?=
 =?utf-8?B?QjM0QUtWN3RpWlBMc1Zyc1VsaEhDSkxMMWx4TXB2M3RXK0tGWHBKWXhxRG5p?=
 =?utf-8?B?WUtLTUVCZ1NNMlBKengyS1pGMVVQSGNwclVqSEFjT3plUndmUW9NS0g2Uzd6?=
 =?utf-8?B?eWF2RFIvcFdhZy94cU9mdVg2alNDT1Y3RG9mMFNNV3lpUVpYcXNCdUhhVE5i?=
 =?utf-8?B?cUdYSVp5UnJvUk9qTkxXVDhuUDMxeVd0SXkwY0JMWE5yMEZHN2dmNDI2cEgx?=
 =?utf-8?B?dlZ6VWJYekI5RGFCaEdGOWN0UFJoSmR1ajJ5SWhyVW1DUnNCZEgwSWxzL1lN?=
 =?utf-8?B?MnZZbkZWaTM0ejFsK0c5OXI5ZlZFYzhldGMvQWhreVFmOWViaGZrMDRjZDR5?=
 =?utf-8?B?bVZWMG1DVjFiTEdJb2g1L3V5T01HTms3endoTGZVSE55c1MzRGNkV0lic0dx?=
 =?utf-8?B?Rnp0SDhGcXluU2NaejkwczFWSVkyWUlCdm9PazhxSGhVYy9iN1FLT0NvWWJH?=
 =?utf-8?B?NXZTU1dmY2xvNDJMTWtZNGF1enFLTkNJQVNITEluK3kwUHIwQlNFVWRYUkZL?=
 =?utf-8?B?dER5OS9hSVgvTWM3bmdLZnoxeSt3WkpuWHhvQUFWS3lJTnU5d3JjL3oyYjYz?=
 =?utf-8?B?SzhxQklRUEtzSzFSU20zTGtWaUplekxXVUtXNGRyc2tuUUtINFR2bitFTytw?=
 =?utf-8?B?M21GVFdaM0N1U25yWitKLzVEU1hvaFNoeW5sQW5wVmdaRWRSWkFldHcyQzN1?=
 =?utf-8?B?WDVnUVpMeFpvRE1Zd3V2OWtXUzNNTE52bmp5NTd6YVpwd0crMVhuZVg5S2xR?=
 =?utf-8?B?QUtzZ2g5bnU0RDhJMVNneDVVRzc2WXRxenJtQTR0ZTJ5ZFlWRE90Z0VFR1ZZ?=
 =?utf-8?B?TTJzZXBDdjB4R1NUazZqaXpacjBIKzhUditmdHFJbWVEcWVORUdMck1PWnVx?=
 =?utf-8?B?T3JUb3J2bTBnZHhXa1NnOUxOWE1TZVdKc3hBQ2dhak9hRTVleElRNklmckFx?=
 =?utf-8?B?NngyZy9lakY1YUhiZ1dsTFpvODJISlJ4bjRnMEtWY3dBdi9HNlQzdmxrdjZv?=
 =?utf-8?B?V3VyRURjRng5M2VTa0xZOG9kL1hzNVVIeDdkeUE2bWZHUitHQndobFUxM1pY?=
 =?utf-8?B?aEdFeVhpdkUzR2l2Ty94ZU1HWmpHSUFITWRQQnNpdytoRGpyOVYrUTNZT2NV?=
 =?utf-8?B?VDlvdTNjNXUzLzllcEpmVG82YTRKZW40bE9aeFhhTFNxOTJEaHJBYTQ0LzY4?=
 =?utf-8?B?eGZ3Zk51ckUzbTR4VnpVRy94RldNZ25wTUpORlRkVHd0UmdhT29vTlhkejdU?=
 =?utf-8?B?bDFsWVNVNHJnVDc0S1VleU5PSjdVbWxEYTZkY0R1UEE1Ujh6TnVVZjVYVjVa?=
 =?utf-8?B?TTR6QStWWnQyVDZ4UERoRHBkbDBLVytyRlI0NkdJblUvekhnTnIzOW91Q3lj?=
 =?utf-8?B?dGRBL3FnNDRUZzBBc3hodXhVQm9NcTdqbmJUUE41YzhkdS9JdHZPc2xhR3ZV?=
 =?utf-8?B?MGtYU2RwL2RLdEhQYmZuMXFDMDVrSXR2eXpWbktnWDdWczZhbFdPWFhTV1Vn?=
 =?utf-8?B?cmp0aVo4bVBtbmUrYkI4VUQra3JDVDFLcVREV0U5WDM0V2w3OFFqVUEyOWk2?=
 =?utf-8?Q?VLTVlUe9NsJA7HcipHlovJo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4AD2EBA29173B4283A26656258A7A34@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99904452-d44c-49c3-3d3b-08db71dec183
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 22:36:14.6260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 72mzsuiPG1uyoBUFKGr1fqpFeg9nMgz0P4OEFbYcO39jLZFfLG6vvpn+aN7sFsrAnAQxgdcR+h1Kmnjkhfickg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5813
X-Proofpoint-ORIG-GUID: b1tw8WsaI0XgfH_jjruuEgqyHHShzF9u
X-Proofpoint-GUID: b1tw8WsaI0XgfH_jjruuEgqyHHShzF9u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-20_16,2023-06-16_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCj4gT24gSnVuIDE5LCAyMDIzLCBhdCA0OjMyIEFNLCBQZXRyIE1sYWRlayA8cG1sYWRla0Bz
dXNlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBTdW4gMjAyMy0wNi0xOCAyMjowNToxOSwgU29uZyBM
aXUgd3JvdGU6DQo+PiBPbiBTdW4sIEp1biAxOCwgMjAyMyBhdCA4OjMy4oCvUE0gTGVpemhlbiAo
VGh1bmRlclRvd24pDQo+PiA8dGh1bmRlci5sZWl6aGVuQGh1YXdlaS5jb20+IHdyb3RlOg0KDQpb
Li4uXQ0KDQo+Pj4+Pj4gDQo+Pj4+Pj4gQEAgLTE5NSw3ICsxOTUsNyBAQCBzdGF0aWMgaW50IGNv
bXBhcmVfc3ltYm9sX25hbWUoY29uc3QgY2hhciAqbmFtZSwgY2hhciAqbmFtZWJ1ZikNCj4+Pj4+
PiBpZiAoIXJldCkNCj4+Pj4+PiByZXR1cm4gcmV0Ow0KPj4+Pj4+IA0KPj4+Pj4+IC0gaWYgKGNs
ZWFudXBfc3ltYm9sX25hbWUobmFtZWJ1ZikgJiYgIXN0cmNtcChuYW1lLCBuYW1lYnVmKSkNCj4+
Pj4+PiArIGlmICghbWF0Y2hfZXhhY3RseSAmJiBjbGVhbnVwX3N5bWJvbF9uYW1lKG5hbWVidWYp
ICYmICFzdHJjbXAobmFtZSwgbmFtZWJ1ZikpDQo+Pj4+PiANCj4+Pj4+IFRoaXMgbWF5IGFmZmVj
dCB0aGUgbG9va3VwIG9mIHN0YXRpYyBmdW5jdGlvbnMuDQo+Pj4+IA0KPj4+PiBJIGFtIG5vdCBm
b2xsb3dpbmcgd2h5IHdvdWxkIHRoaXMgYmUgYSBwcm9ibGVtLiBDb3VsZCB5b3UgZ2l2ZSBhbg0K
Pj4+PiBleGFtcGxlIG9mIGl0Pw0KPj4+IA0KPj4+IEhlcmUgYXJlIHRoZSBjb21tZW50cyBpbiBj
bGVhbnVwX3N5bWJvbF9uYW1lKCkuIElmIHRoZSBjb21waWxlciBhZGRzIGEgc3VmZml4IHRvIHRo
ZQ0KPj4+IHN0YXRpYyBmdW5jdGlvbiwgYnV0IHdlIGRvIG5vdCByZW1vdmUgdGhlIHN1ZmZpeCwg
d2lsbCB0aGUgc3ltYm9sIG1hdGNoIGZhaWw/DQo+Pj4gDQo+Pj4gICAgICAgIC8qDQo+Pj4gICAg
ICAgICAqIExMVk0gYXBwZW5kcyB2YXJpb3VzIHN1ZmZpeGVzIGZvciBsb2NhbCBmdW5jdGlvbnMg
YW5kIHZhcmlhYmxlcyB0aGF0DQo+Pj4gICAgICAgICAqIG11c3QgYmUgcHJvbW90ZWQgdG8gZ2xv
YmFsIHNjb3BlIGFzIHBhcnQgb2YgTFRPLiAgVGhpcyBjYW4gYnJlYWsNCj4+PiAgICAgICAgICog
aG9va2luZyBvZiBzdGF0aWMgZnVuY3Rpb25zIHdpdGgga3Byb2Jlcy4gJy4nIGlzIG5vdCBhIHZh
bGlkDQo+Pj4gICAgICAgICAqIGNoYXJhY3RlciBpbiBhbiBpZGVudGlmaWVyIGluIEMuIFN1ZmZp
eGVzIG9ic2VydmVkOg0KPj4+ICAgICAgICAgKiAtIGZvby5sbHZtLlswLTlhLWZdKw0KPj4+ICAg
ICAgICAgKiAtIGZvby5bMC05YS1mXSsNCj4+PiAgICAgICAgICovDQo+PiANCj4+IEkgdGhpbmsg
bGl2ZXBhdGNoIHdpbGwgbm90IGZhaWwsIGFzIHRoZSB0b29sIGNoYWluIHNob3VsZCBhbHJlYWR5
IG1hdGNoIHRoZQ0KPj4gc3VmZml4IGZvciB0aGUgZnVuY3Rpb24gYmVpbmcgcGF0Y2hlZC4gSWYg
dGhlIHRvb2wgY2hhaW4gZmFpbGVkIHRvIGRvIHNvLA0KPj4gbGl2ZXBhdGNoIGNhbiBmYWlsIGZv
ciBvdGhlciByZWFzb25zIChtaXNzaW5nIHN5bWJvbHMsIGV0Yy4pDQo+IA0KPiBjbGVhbnVwX3N5
bWJvbF9uYW1lKCkgaGFzIGJlZW4gYWRkZWQgYnkgdGhlIGNvbW1pdCA4YjhlNmI1ZDNiMDEzYjBi
ZDgNCj4gKCJrYWxsc3ltczogc3RyaXAgVGhpbkxUTyBoYXNoZXMgZnJvbSBzdGF0aWMgZnVuY3Rp
b25zIikuIFRoZQ0KPiBtb3RpdmF0aW9uIGlzIHRoYXQgdXNlciBzcGFjZSB0b29scyBwYXNzIHRo
ZSBzeW1ib2wgbmFtZXMgZm91bmQNCj4gaW4gc291cmNlcy4gVGhleSBkbyBub3Qga25vdyBhYm91
dCB0aGUgInJhbmRvbSIgc3VmZml4IGFkZGVkDQo+IGJ5IHRoZSAicmFuZG9tIiBjb21waWxlci4N
Cg0KSSBhbSBub3QgcXVpdGUgc3VyZSBob3cgdHJhY2luZyB0b29scyB3b3VsZCB3b3JrIHdpdGhv
dXQga25vd2luZyBhYm91dA0Kd2hhdCB0aGUgY29tcGlsZXIgZGlkIHRvIHRoZSBjb2RlLiBCdXQg
SSBndWVzcyB3ZSBhcmUgbm90IGFkZHJlc3NpbmcNCnRoYXQgcGFydCBoZXJlLiANCg0KPiANCj4g
V2hpbGUgbGl2ZXBhdGNoaW5nIG1pZ2h0IHdhbnQgdG8gd29yayB3aXRoIHRoZSBmdWxsIHN5bWJv
bCBuYW1lcy4NCj4gSXQgaGVscHMgdG8gbG9jYXRlIGF2b2lkIGR1cGxpY2F0aW9uIGFuZCBmaW5k
IHRoZSByaWdodCBzeW1ib2wuDQo+IA0KPiBBdCBsZWFzdCwgdGhpcyBzaG91bGQgYmUgYmVuZWZp
Y2lhbCBmb3Iga3BhdGNoIHRvb2wgd2hpY2ggd29ya3MgZGlyZWN0bHkNCj4gd2l0aCB0aGUgZ2Vu
ZXJhdGVkIHN5bWJvbHMuDQo+IA0KPiBXZWxsLCBpbiB0aGVvcnksIHRoZSBjbGVhbmVkIHN5bWJv
bCBuYW1lcyBtaWdodCBiZSB1c2VmdWwgZm9yDQo+IHNvdXJjZS1iYXNlZCBsaXZlcGF0Y2hlcy4g
QnV0IHRoZXJlIG1pZ2h0IGJlIHByb2JsZW0gdG8NCj4gZGlzdGluZ3Vpc2ggZGlmZmVyZW50IHN5
bWJvbHMgd2l0aCB0aGUgc2FtZSBuYW1lIGFuZCBzeW1ib2xzDQo+IGR1cGxpY2F0ZWQgYmVjYXVz
ZSBvZiBpbmxpbmluZy4gV2VsbCwgd2UgdGVuZCB0byBsaXZlcGF0Y2gNCj4gdGhlIGNhbGxlciBh
bnl3YXkuDQoNCkkgYW0gbm90IHF1aXRlIGZvbGxvd2luZyB0aGUgZGlyZWN0aW9uIGhlcmUuIERv
IHdlIG5lZWQgbW9yZSANCndvcmsgZm9yIHRoaXMgcGF0Y2g/DQoNClRoYW5rcywNClNvbmcNCg0K
