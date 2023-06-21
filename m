Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BAF738FEA
	for <lists+live-patching@lfdr.de>; Wed, 21 Jun 2023 21:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjFUTSQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Jun 2023 15:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjFUTSM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Jun 2023 15:18:12 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D11619A1
        for <live-patching@vger.kernel.org>; Wed, 21 Jun 2023 12:18:07 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LIjjdp006992
        for <live-patching@vger.kernel.org>; Wed, 21 Jun 2023 12:18:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=igg7x2bTPciQ/D5NE9czJjgq5urbtfam1RMDjiBiz/w=;
 b=P5kbVK/dzPZCyaRPPEnLzyBaAU6JP1/ecp6hhjZWufJOXCQwT7Aiia1dyWUwLLciu1QX
 EWtHBmdw7viDLzVWvHcVmtKBIUUIFBPUfHIBGJJZ67RDaNHRcZ+tuot7qZreT9yTz248
 Q+l+aaq5Dp6TOMCIG4IEBRD+6uQVRJ84Nju3wjXR417IdG1okk+KaU2tqdMWhNCgIulA
 61PqXtbbQqRiFcXe7pb0ctaoX58E5rkgyJ7BbO8+LD0XRKuyUVKHgR6ex4/Sd+DG/ed/
 U2yTugybNLKXv3aPeVpmjk3wNnxRDVgl3UX6+qePQOSwXJBzpv9cXAToZNtbMFSKUXJc QA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3rc05hv2bj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Wed, 21 Jun 2023 12:18:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIurnD8Lb5lvtDk7ih+FPyAk8el/zSuehawntMfhO1TWjQ+AZp4h8WvIK8qluJlElf2bK3ewsRWeOR3Rf7ugs4KXS1rzwcSTUwGaBq/INYRtG39SwOVweFFV/isy6Ef377+Lk9hE5Kovur7H2p83VHhDl6PLsBntS+HugHnwopqjtf8RDx+s8ja4mII+1E3Exc/fWIk59OTsd0yGSxemTvVcpbY6SCCaFUQ3/Z7+WflTnByraPuiX99x58Jgn6VZh3VYusl+MmCefID8L8j5xsOXujlGjGYL07LwAxdlWt1Z2fUDau1q9Q+weToZGUZepOS/2hHdhyiD90N1qphFPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=igg7x2bTPciQ/D5NE9czJjgq5urbtfam1RMDjiBiz/w=;
 b=NV5ajbAuG5arurjUb9e/MhcpJHeozfPFyyGXzI8nLy2wmYGTjzx3E+6v1D01E4OS28FTYX8wSO9MEbAsg+X/RzsHRw7uq1G/BWI8dW9llwC4G5dcD8w3ff/0ZQElzzXyMSkvXUltPHOs2H5frVrtvnh+ZRcMEUpbTyLpZS8qI0C4kDHQybCUDbvQPVvGrPmVjFQdSMaU4LMeh0LrZLnQJQeoqPEmkyjlOgY50koAY/7WVjc/WX3UfbMuIbCUEUEO/KFCCfzqubSVFEPs9kymYCd4nkHKJgHdNuFngx1VJAASNY+RCX7q+heWD+JfMB5B5sDpWORj7yjYc5wyisx/WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM4PR15MB5961.namprd15.prod.outlook.com (2603:10b6:8:181::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Wed, 21 Jun
 2023 19:18:03 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%7]) with mapi id 15.20.6500.040; Wed, 21 Jun 2023
 19:18:03 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Petr Mladek <pmladek@suse.com>
CC:     Song Liu <songliubraving@meta.com>, Song Liu <song@kernel.org>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
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
Thread-Index: AQHZn6r1VuNYFv7wzUinZRrB36Nwc6+NK0aAgACH3YCAA8rIgIAAGgiAgABsKACAAkvAAIAArFmAgACumwA=
Date:   Wed, 21 Jun 2023 19:18:03 +0000
Message-ID: <E47B9D18-299C-4F95-B4F6-24DB6A54A79F@fb.com>
References: <20230615170048.2382735-1-song@kernel.org>
 <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
 <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
 <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
 <ZJA8yohmmf6fKsJQ@alley> <47E4EA81-717E-43A2-8D6D-E7E0F2569944@fb.com>
 <ZJK5tiO3wXHiBeBh@alley>
In-Reply-To: <ZJK5tiO3wXHiBeBh@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DM4PR15MB5961:EE_
x-ms-office365-filtering-correlation-id: f581b263-9a52-4c10-ad09-08db728c3c0c
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gicFlmfI6mWCNf7LoUAz8adSXv07EQxb26TL5j8bLMIwdaDk6SGjhFOU/d/5YaD6Qltx0bZQMXCCrt2aJbPkBHWiY2PugzOGOuh2rR1+zqQjMd+vVsywHOAgxIVxaW1X5lMtDzrJjXMTic1F5Ndhz8Pw6sGwh7hH8TARV1AMUOD2+ssgbHbFiDHFYe3lmqBb9BvZ2qL/kl1aFMK7Vkrh1kPDfQlKHG+mAMmHchl0nZRD9/AZEls7Opb9Voaznwb6CuS5ak5NnwpRAgVWoMp53tCNbIvC+K876pDUE/lHKP7lHHAGw0wZ/iUv48CQLvuAQ5cLrM0tzVhrm7k0RtT0r4Hk0qCqKyKBS5o70fi57L8b9n0WRYaJ4qKPoHEmhPiTzPrNqe4nr+f0pENCIn4yJrR72K4MlBIPq3HINFKRHGSqXi0ua86YXK0g/XOInsQXFd5cW92sZakuy3D+xbftMzqcHZhNSuiuxNcKuNwqwL7cqA4UIt5qM7d08am+N4ir2As4Qv6aEIsJt4tD6XFIcAXKqUN6KMwkkCbzuH+bZjy1I4f8NaMtji8+KGV1FXuqu31sf8HJee3gmnCeGAt7yTkR/6FWHNnKe/RDVhshbxIJ8ODQoMozVQN1DXof9zEo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199021)(66899021)(36756003)(33656002)(66476007)(5660300002)(86362001)(8936002)(6916009)(76116006)(8676002)(38070700005)(66446008)(41300700001)(66556008)(316002)(122000001)(38100700002)(91956017)(66946007)(4326008)(6486002)(2906002)(6512007)(9686003)(186003)(6506007)(53546011)(64756008)(71200400001)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDlQM0wrdGhXbkxudnE0YitXeCt5a1BybkN4WkhKenVKZWhkNDFreUl3ZWpW?=
 =?utf-8?B?a3lJQitadGxURFNTMVRWZXRXcU5ORDlMR1kwZytnWmNnMnU3WHR3S0lTQUZp?=
 =?utf-8?B?M29UeC9nV21PSWJ6VGJQVjdRaUF3c3pWV0pDTW5DanJaOHZrdDRHYjJaTDhB?=
 =?utf-8?B?QnprUVJIR0ZlWUs0SWxtTGlud0wrNWZuQWNoL2NySWlnZFZZUjQwYzFSRnZC?=
 =?utf-8?B?Q2lIbmk4c2cxcWcwc0hTeU1UZW84NisyWllQL0NQRVNMNmtoMmdBQ3lndVlD?=
 =?utf-8?B?UVBuSXU1TjZiRGtDNnN2UGpkSGhZa2wxRC9leUc0NDM2bnQxRTQvS0FIbzV0?=
 =?utf-8?B?Nm5IZ1Bub0pLdVJkUlZjMlBpQklpK253Zm1PamJqcjIxT0UxMDF3SUIrU1Jk?=
 =?utf-8?B?bjNLbTdUd1V2ZnBLNmJsZHEzZ3JqQURjMmUxUlNEcTVvNURHVm5OLzgyRmM0?=
 =?utf-8?B?M2VQN0JWdGRYOFhVSFlsMnJBa2JPYVhVeTFqRXAyd3NtMkg3c0NQQnRkZTJh?=
 =?utf-8?B?K200YlpKalpqNkdQTHQzYmdpd2JyNWZHSjhHeUFRbXdGRkhwUVRQODk0dncz?=
 =?utf-8?B?NjNzaU16Wk1QQUVpZnN4TkhJbjAwNDRQTzFTTXdJWEt3NzBBZEJpOVpQK2FN?=
 =?utf-8?B?WTZ0cDFDZGFXQ2hpZWlRcnh1bnp3U08velBRRVN6WkVZOThsZm9JUG1waDZR?=
 =?utf-8?B?YjIzU2NSTjNOZkV0cFZ5RGluM0ZxNW5FOU9kMS8zeE1NR0swdWhRcVJwaStq?=
 =?utf-8?B?ZWJQNExrNHZBWVJsMEtVdEthVVdDdmQ3VFhZdCsyQys0THJjWlBndjE2cDVh?=
 =?utf-8?B?bFBrd2szc3JmbnRjWXlvc3RKTmpTendhbGM5c1VxWGZDWXpkdU5EeWNBT1ly?=
 =?utf-8?B?Z3ZDZGpDV1JyNDVMaStneGR6N21kL0J0dkxMWWczcHNYMzJIcGQrcExQam1S?=
 =?utf-8?B?ellLSGpwSVhXNzI0bEtZZ2VpemNlNUk4NUJ0eWR0eWUrek00YUlKN0VZWmlC?=
 =?utf-8?B?cW94UFk3KzBhYWhTRFdScG1oazhPQklQdjlOQnJYU1BwZ3M4S2hEWHFKWFN2?=
 =?utf-8?B?QldKSU9aZ1BDMmpTbVZYNXM1K0NTSnhmdEt3ak8xbVVkakQzelAzTmJnQTM4?=
 =?utf-8?B?RHVEZGx1TWhmZjUvaFJ6RlJPa1FaeDFXeGgvMzZlZ0xQQThEU2NrK1FzbFAv?=
 =?utf-8?B?TjY2eFV4c0kwWG9Dek5Ld0ZSYTM5M2xHdy9WN3NEeFBva3RKYm1hbHBBQ3Ja?=
 =?utf-8?B?WWQzTGRLUUJDcThGbUltVk1lNk1lTHpWS2xmRDlGNHYyd2xVUG1rVEsvdlVk?=
 =?utf-8?B?ODMwYm5WeldxNDdTTHlnZHUvclRQSXdkblNQb0lVMUkxckdZUWNTUFZyZnJC?=
 =?utf-8?B?enNDMjIzWk0xT0l1QmEyNStqcjNwNXNxUk0vcVhsQWVmOEFNWDBmcE4xdFMy?=
 =?utf-8?B?RU0ra1R5QVlINFMyMzVZOGQxSXVvY3BNUElkOXNSTk9Dd0VBNzBkbzd3QzY1?=
 =?utf-8?B?dzJoeVlmTUJkTGZkbHhtVEFlRy9saXZ3bXRXV09BaUJ2WU9GRmhqK1d6Z1Fp?=
 =?utf-8?B?cU1PNmhpWmtvY25vUVR0ViszelRZcDdPQnpYU1daa1MyV1JmZGNDZ3BxdEgz?=
 =?utf-8?B?Uk5HMnVlcGN2dFliUjJxYkc3SXdKUGd1SWcrZ2FRYUtiVFFQR2Z3aDlycUJw?=
 =?utf-8?B?R3VKYVJITi85L0dCQ2VSeE16Q0RUTSs1dDBGZGlFWHZEOW9EYzlQazM4REZH?=
 =?utf-8?B?dTd0eFhwMWNVWjg3aVdBeXJ1UzNlbE5QaC96czlMNFU1SXBFKzF4QlZkcHFT?=
 =?utf-8?B?YWpMc1p0NDFGeEt5bTFPRzNzaUphby9KVmdwSStHUXc1elFwb1ZvK0ZnQ25Q?=
 =?utf-8?B?NTBKWjBidmpEOEVxeXBRc25KaUJSWHNhbGJmejdIVEF5UmR0aEFFK3JQOG5t?=
 =?utf-8?B?SitLQnJBcXhTODQ1Wk5iQU9pRHcwSmVVNGx5SGkyY1Y2b0xjWVpEUzZKRitx?=
 =?utf-8?B?MkJsN2Z5NEpMK3lyZndnamNsTXgwdzU2amhlYjYwVk9GdG1vbWJMeEFtOUc4?=
 =?utf-8?B?WVhOc0VNdStPcCtQd3JiRHJyd2RTYUlwc0d4UW9CbTRRRnZpZVBpeXJVdFkz?=
 =?utf-8?B?L1VjLy92OFZpc2VtOTZNSWY2QTMyWVFtMHFybGMwZDlvRGtOZnluVm95OUJl?=
 =?utf-8?Q?gjQl1tR1q1De0dOCYt301E4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58906C1A6C46574398729FB8A4939482@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f581b263-9a52-4c10-ad09-08db728c3c0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2023 19:18:03.0992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sSyP4rzB3j78spCHb6e9/D9gwip2vEB3gK8PLoy8k43mzE6drBMnX24HH73bpQwPUv9s8KRz3B/ve1iCUqyK9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5961
X-Proofpoint-GUID: WdiLYsp5WPRokIP71Ev3T7o-HShXtmWA
X-Proofpoint-ORIG-GUID: WdiLYsp5WPRokIP71Ev3T7o-HShXtmWA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_11,2023-06-16_01,2023-05-22_02
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

DQoNCj4gT24gSnVuIDIxLCAyMDIzLCBhdCAxOjUyIEFNLCBQZXRyIE1sYWRlayA8cG1sYWRla0Bz
dXNlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUgMjAyMy0wNi0yMCAyMjozNjoxNCwgU29uZyBM
aXUgd3JvdGU6DQo+Pj4gT24gSnVuIDE5LCAyMDIzLCBhdCA0OjMyIEFNLCBQZXRyIE1sYWRlayA8
cG1sYWRla0BzdXNlLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gT24gU3VuIDIwMjMtMDYtMTggMjI6
MDU6MTksIFNvbmcgTGl1IHdyb3RlOg0KPj4+PiBPbiBTdW4sIEp1biAxOCwgMjAyMyBhdCA4OjMy
4oCvUE0gTGVpemhlbiAoVGh1bmRlclRvd24pDQo+Pj4+IDx0aHVuZGVyLmxlaXpoZW5AaHVhd2Vp
LmNvbT4gd3JvdGU6DQo+PiANCj4+IFsuLi5dDQoNClsuLi5dDQoNCj4+IA0KPj4gSSBhbSBub3Qg
cXVpdGUgZm9sbG93aW5nIHRoZSBkaXJlY3Rpb24gaGVyZS4gRG8gd2UgbmVlZCBtb3JlIA0KPj4g
d29yayBmb3IgdGhpcyBwYXRjaD8NCj4gDQo+IEdvb2QgcXVlc3Rpb24uIEkgcHJpbWFyeSB0cmll
ZCB0byBhZGQgbW9yZSBkZXRhaWxzIHNvIHRoYXQNCj4gd2UgYmV0dGVyIHVuZGVyc3RhbmQgdGhl
IHByb2JsZW0uDQo+IA0KPiBIb25lc3RseSwgSSBkbyBub3Qga25vdyB0aGUgYW5zd2VyLiBJIGFt
IG5laXRoZXIgZmFtaWxpYXIgd2l0aA0KPiBrcGF0Y2ggbm9yIHdpdGggY2xhbmcuIExldCBtZSB0
aGluayBsb3VkbHkuDQo+IA0KPiBrcGF0Y2ggcHJvZHVjZSBsaXZlcGF0Y2hlcyBieSBjb21wYXJp
bmcgYmluYXJpZXMgb2YgdGhlIG9yaWdpbmFsDQo+IGFuZCBmaXhlZCBrZXJuZWwuIEl0IGFkZHMg
YSBzeW1ib2wgaW50byB0aGUgbGl2ZXBhdGNoIHdoZW4NCj4gdGhlIHNhbWUgc3ltYm9sIGhhcyBk
aWZmZXJlbnQgY29kZSBpbiB0aGUgdHdvIGJpbmFyaWVzLg0KPiANCj4gU28gb25lIGltcG9ydGFu
dCBxdWVzdGlvbiBpcyBob3cgY2xhbmcgZ2VuZXJhdGVzIHRoZSBzdWZmaXguDQo+IElzIHRoZSBz
dWZmaXggdGhlIHNhbWUgaW4gZXZlcnkgYnVpbGQ/IElzIGl0IHRoZSBzYW1lIGV2ZW4NCj4gYWZ0
ZXIgdGhlIGZ1bmN0aW9uIGdldHMgbW9kaWZpZWQgYnkgYSBmaXg/DQo+IA0KPiBJZiB0aGUgc3Vm
Zml4IGlzIGFsd2F5cyB0aGUgc2FtZSB0aGVuIHRoZW4gdGhlIGZ1bGwgc3ltYm9sIG5hbWUNCj4g
d291bGQgYmUgYmV0dGVyIGZvciBrcGF0Y2guIGtwYXRjaCB3b3VsZCBnZXQgaXQgZm9yIGZyZWUu
DQo+IEFuZCBrcGF0Y2ggd291bGQgbm90IGxvbmdlciBuZWVkIHRvIHVzZSAib2xkX3N5bXBvcyIu
DQoNClRoaXMgaXMgcHJldHR5IGNvbXBsaWNhdGVkLiANCg0KMS4gY2xhbmcgd2l0aCBMVE8gZG9l
cyBub3QgdXNlIHRoZSBzdWZmaXggdG8gZWxpbWluYXRlZCBkdXBsaWNhdGVkDQprYWxsc3ltcywg
c28gb2xkX3N5bXBvcyBpcyBzdGlsbCBuZWVkZWQuIEhlcmUgaXMgYW4gZXhhbXBsZToNCg0KIyBn
cmVwIGluaXRfb25jZSAvcHJvYy9rYWxsc3ltcw0KZmZmZmZmZmY4MTIwYmE4MCB0IGluaXRfb25j
ZS5sbHZtLjE0MTcyOTEwMjk2NjM2NjUwNTY2DQpmZmZmZmZmZjgxMjBiYTkwIHQgaW5vZGVfaW5p
dF9vbmNlDQpmZmZmZmZmZjgxM2VhNWQwIHQgYnBmX3VzZXJfcm5kX2luaXRfb25jZQ0KZmZmZmZm
ZmY4MTNmZDViMCB0IGluaXRfb25jZS5sbHZtLjE3OTEyNDk0MTU4Nzc4MzAzNzgyDQpmZmZmZmZm
ZjgxM2ZmYmYwIHQgaW5pdF9vbmNlDQpmZmZmZmZmZjgxM2ZmYzYwIHQgaW5pdF9vbmNlDQpmZmZm
ZmZmZjgxM2ZmYzcwIHQgaW5pdF9vbmNlDQpmZmZmZmZmZjgxM2ZmY2QwIHQgaW5pdF9vbmNlDQpm
ZmZmZmZmZjgxM2ZmY2UwIHQgaW5pdF9vbmNlDQoNClRoZXJlIGFyZSB0d28gImluaXRfb25jZSIg
d2l0aCBzdWZmaXgsIGJ1dCB0aGVyZSBhcmUgYWxzbyBvbmVzIA0Kd2l0aG91dCB0aGVtLiANCg0K
Mi4ga3BhdGNoLWJ1aWxkIGRvZXMgIkJ1aWxkaW5nIG9yaWdpbmFsIHNvdXJjZSIsICJCdWlsZGlu
ZyBwYXRjaGVkIA0Kc291cmNlIiwgYW5kIHRoZW4gZG8gYmluYXJ5IGRpZmYgb2YgdGhlIHR3by4g
RnJvbSBvdXIgZXhwZXJpbWVudHMsIA0KdGhlIHN1ZmZpeCBkb2Vzbid0IGNoYW5nZSBiZXR3ZWVu
IHRoZSB0d28gYnVpbGRzLiBIb3dldmVyLCB3ZSBuZWVkDQp0byBtYXRjaCB0aGUgYnVpbGQgZW52
aXJvbm1lbnQgKHBhdGggb2Yga2VybmVsIHNvdXJjZSwgZXRjLikgdG8gDQptYWtlIHN1cmUgc3Vm
Zml4IGZyb20ga3BhdGNoIG1hdGNoZXMgdGhlIGtlcm5lbC4gDQoNCjMuIFRoZSBnb2FsIG9mIHRo
aXMgcGF0Y2ggaXMgTk9UIHRvIHJlc29sdmUgZGlmZmVyZW50IHN1ZmZpeCBieSANCmxsdm0gKC5s
bHZtLlswLTldKykuIEluc3RlYWQsIHdlIGFyZSB0cnlpbmcgZml4IGlzc3VlcyBsaWtlOg0KDQoj
ICBncmVwIGJwZl92ZXJpZmllcl92bG9nIC9wcm9jL2thbGxzeW1zDQpmZmZmZmZmZjgxNTQ5ZjYw
IHQgYnBmX3ZlcmlmaWVyX3Zsb2cNCmZmZmZmZmZmODI2OGI0MzAgZCBicGZfdmVyaWZpZXJfdmxv
Zy5fZW50cnkNCmZmZmZmZmZmODI4MmE5NTggZCBicGZfdmVyaWZpZXJfdmxvZy5fZW50cnlfcHRy
DQpmZmZmZmZmZjgyZTEyYTFmIGQgYnBmX3ZlcmlmaWVyX3Zsb2cuX19hbHJlYWR5X2RvbmUNCg0K
V2l0aCBleGlzdGluZyBjb2RlLCBjb21wYXJlX3N5bWJvbF9uYW1lKCkgd2lsbCBtYXRjaCANCmJw
Zl92ZXJpZmllcl92bG9nIHRvIGFsbCB0aGVzZSB3aXRoIENPTkZJR19MVE9fQ0xBTkcuDQoNCldl
IGNhbiBwcm9iYWJseSB0ZWFjaCBjb21wYXJlX3N5bWJvbF9uYW1lKCkgdG8gbm90IHRvIG1hdGNo
DQp0aGVzZSBzdWZmaXgsIGFzIFpoZW4gc3VnZ2VzdGVkLiANCg0KSWYgdGhpcyBpcyBub3QgaWRl
YWwsIEkgYW0gb3BlbiB0byBzdWdnZXN0aW9ucyB0aGF0IGNhbiBzb2x2ZQ0KdGhlIHByb2JsZW0u
IA0KDQo+IEJ1dCBpZiB0aGUgc3VmZml4IGlzIGRpZmZlcmVudCB0aGVuIGtwYXRjaCBoYXMgYSBw
cm9ibGVtLg0KPiBrcGF0Y2ggd291bGQgbmVlZCB0byBtYXRjaCBzeW1ib2xzIHdpdGggZGlmZmVy
ZW50IHN1ZmZpeGVzLg0KPiBJdCB3b3VsZCBiZSBlYXN5IGZvciBzeW1ib2xzIHdoaWNoIGFyZSB1
bmlxdWUgYWZ0ZXIgcmVtb3ZpbmcNCj4gdGhlIHN1ZmZpeC4gQnV0IGl0IHdvdWxkIGJlIHRyaWNr
eSBmb3IgY29tcGFyaW5nIHN5bWJvbHMNCj4gd2hpY2ggZG8gbm90IGhhdmUgYW4gdW5pcXVlIG5h
bWUuIGtwYXRjaCB3b3VsZCBuZWVkIHRvIGZpbmQNCj4gd2hpY2ggc3VmZml4IGluIHRoZSBvcmln
aW5hbCBiaW5hcnkgbWF0Y2hlcyBhbiBvdGhlciBzdWZmaXgNCj4gaW4gdGhlIGZpeGVkIGJpbmFy
eS4gSW4gdGhpcyBjYXNlLCBpdCBtaWdodCBiZSBlYXNpZXINCj4gdG8gdXNlIHRoZSBzdHJpcHBl
ZCBzeW1ib2wgbmFtZXMuDQo+IA0KPiBBbmQgdGhlIHN1ZmZpeCBtaWdodCBiZSBwcm9ibGVtYXRp
YyBhbHNvIGZvciBzb3VyY2UgYmFzZWQNCj4gbGl2ZXBhdGNoZXMuIFRoZXkgZGVmaW5lIHN0cnVj
dCBrbHBfZnVuYyBpbiBzb3VyY2VzIHNvDQo+IHRoZXkgd291bGQgbmVlZCB0byBoYXJkY29kZSB0
aGUgc3VmZml4IHRoZXJlLiBJdCBtaWdodA0KPiBiZSBlYXN5IHRvIGtlZXAgdXNpbmcgdGhlIHN0
cmlwcGVkIG5hbWUgYW5kICJvbGRfc3ltcG9zIi4NCj4gDQo+IEkgZXhwZWN0IHRoYXQgdGhpcyBw
YXRjaCBhY3R1YWxseSBicmVha3MgdGhlIGxpdmVwYXRjaA0KPiBzZWxmdGVzdHMgd2hlbiB0aGUg
a2VybmVsIGlzIGNvbXBpbGVkIHdpdGggY2xhbmcgTFRPLg0KDQpOb3QgcmVhbGx5LiBUaGlzIHBh
dGNoIHBhc3NlcyBsaXZlcGF0Y2ggc2VsZnRlc3RzLiANCg0KVGhhbmtzLA0KU29uZw0KDQo=
