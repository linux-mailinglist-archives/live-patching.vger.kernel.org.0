Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939173884AE
	for <lists+live-patching@lfdr.de>; Wed, 19 May 2021 04:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbhESCOz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 18 May 2021 22:14:55 -0400
Received: from esa5.fujitsucc.c3s2.iphmx.com ([68.232.159.76]:3818 "EHLO
        esa5.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234810AbhESCOy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 18 May 2021 22:14:54 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 May 2021 22:14:53 EDT
IronPort-SDR: bd4eegYa2L29knS/I57zZzGPwqJtQZ6iHKuebob6KdLMIxIh/mnHlVP1ePQJ7NlilaWzSDmu3F
 ptP8OXmvsnV4FFC0VV7rXMN2WuVWSy7n+kkpOEQMT40S63R33jmX9Ufz5V5IwXPCv4yZpjo16n
 dJze9ygTgeiwG6Umq3pp5MTOCF0PqS3NopPaNuho3xlk/wun5qv2q2IcTJuZ/EfFDN4oCf6/tu
 gd6XhYNaKFmcAB5zLiiimcNI8dzk63TgdvGK64S9krVUbIcM2M8PAttjRB08uzHwp5/6Z7d5kw
 Oz0=
X-IronPort-AV: E=McAfee;i="6200,9189,9988"; a="31533535"
X-IronPort-AV: E=Sophos;i="5.82,310,1613401200"; 
   d="scan'208";a="31533535"
Received: from mail-os2jpn01lp2054.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.54])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 11:06:23 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emA5Fb7de7D5X9qX/skI5QfrdRwu/jjDMOSu9x8hv4tV3KhudZnZyUvgi4h2CKJ0QqlCrQIXrlZ0NvQVfXLs0qoLOSaiweoOZGd9GlTteec8D0DhKr5qW0Kn2YaqTCLAb2n0TocYCPQ0xF2Ju8SHF8P49T2dnDtDwc/WKVEVZcgonN6MHGdRebD9MRYk8T+4/DWnK3jbeuJTjdDXYq4lUVAnvl2PCNChcqZsWmY1+FxoSGoGlqc2/Z5gey6mnRF2LWg4urE+7wyTJRT6+6PZQlGV1LeDFkmypwm2jHVYKdce6Fc+9XTsV34Dw4TocUPkjqlcpR6PR4pnoE1o/w2+aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=830DGdgKZZnvQ1IVmL2WDK1oKbuJPE5tak25+Y7sFYY=;
 b=e/H0itRpHa6edt+YyItm+fVvZ4vS62P5XQgKJMjkswZUWpEY1PGMSsRobbhH2u2YqMFcCOjiCsAhsst5/t3f68RRl/4Bn8puKBpPgO2E7zDoUqc83YaxBHJ77XVHnLsTVRelAFMswHNc9/hZjmp6j7v9ZblzrgmmtX1xNvUL41l8srcHbpF/Ylzp9HTmaz1hUx7yLK2guw+I0kCKURKkWFXxw3Pl23ghoiYmWnztYkxuQ8MivDia37KweVEPfFjZ8H7bNdz5ROlSNpO7VtFYqWowCEhXsTfbP8xturFtNUSNuhgE9bp2xGDNCibIg7evXxgu0s4P7dSPBZfj2/k4Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=830DGdgKZZnvQ1IVmL2WDK1oKbuJPE5tak25+Y7sFYY=;
 b=abk4768tIBEnnFAIV3+jsGSbtkPR1huYCto02/djO43zDZSiXsrEEuRCma1Yd3rWUEUD9dkLmz4LyyF5maqsOheWz4rx1kOIE0/AyGmbI/4wci2aRM728TPTk6fAcZ47fkgDBPnKs4iK7xbemB5240zStwpVU5bM5hxSaq6VDik=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by TYCPR01MB6127.jpnprd01.prod.outlook.com (2603:1096:400:48::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 02:06:20 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::1dd1:7e9c:e09d:d1da]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::1dd1:7e9c:e09d:d1da%6]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 02:06:20 +0000
From:   "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
To:     "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>
CC:     "broonie@kernel.org" <broonie@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "jthierry@redhat.com" <jthierry@redhat.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: [RFC PATCH v4 2/2] arm64: Create a list of SYM_CODE functions,
 blacklist them in the unwinder
Thread-Topic: [RFC PATCH v4 2/2] arm64: Create a list of SYM_CODE functions,
 blacklist them in the unwinder
Thread-Index: AQHXSgkhR4DELDlZmEi65W09XM1I3KrqArXF
Date:   Wed, 19 May 2021 02:06:20 +0000
Message-ID: <TY2PR01MB5257FA9C1E94B136E1977790852B9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>,<20210516040018.128105-3-madvenka@linux.microsoft.com>
In-Reply-To: <20210516040018.128105-3-madvenka@linux.microsoft.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=fujitsu.com;
x-originating-ip: [210.162.30.55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6a06dc3-c54b-46ff-95da-08d91a6ab1ec
x-ms-traffictypediagnostic: TYCPR01MB6127:
x-microsoft-antispam-prvs: <TYCPR01MB6127BF4E58FDFD519635AD3A852B9@TYCPR01MB6127.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:565;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4KOSQJuguv3hJOX0Zjzh1poFU3b3R6FaArDO95eswPj2pTwk718rF/F2Lv3SoJvM9I43wR77qT/0DdmkuAtdh+ew/bkfbOVH/L9pfaYrDx5AaFVaQqre8hLmXrbFloIkDPyFxp06KyKpbqAM8+iu39NI2Bv0znqDGDsbHuOEIUKmfcEm4VBFaSEAraXs3GtX2tWRuNK+tk4WBekb0RZg9r7zi+naHfKHiEgR/YRpbxzTnvuO+iSrq8MxS8ozzyEF7e6EqU3/4o1X5UPUIzZVfvR5CYUjOKZUNJmi4UzTJQpX0JZpufvtSy1iUXuAU+3tzFnlX9XH/or15ymhOv3ijH1lFuwjpvCP1kr2KO94G2GFMpI0BAkqQ/4C7PVfrtj4grC1dfFoZgTTGlMC64cqDxKyMBONxmGimQehGLVSqqIrthnIojdhgKVt/lGT7+63ga0Jp4aPmRvJf0/mNVbXn2gYEyWo/V0MG6IdJ0DIg/2oDoNljN3gDpypLDljrC00S5Xvrm1h1KrswLHu6f/dFno5vCP+c6CcXSH0KoRnaJ5X1Nk2cjaIGaEq3ZIdP+WhYWBvjiDYyOEsqsOuyu5+FNWyBCB577fHkvhbO3biGfA9ESaQsZR5dsDJGIkU+29sbI8Olk61d8fDPzIxL7sPNWlYopOtvDB6Bxyb6EbTcXjELdOc4vIp6Q7ZdkojRCCMn8lXEpclUhsFBqIsKi3ghQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(4326008)(122000001)(86362001)(54906003)(186003)(2906002)(26005)(55016002)(4744005)(9686003)(66946007)(6916009)(71200400001)(76116006)(6506007)(33656002)(66446008)(52536014)(478600001)(7696005)(66476007)(8936002)(64756008)(8676002)(85182001)(66556008)(38100700002)(316002)(966005)(7416002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?U2F5dmthdXdNaFBJSEUvNC9ZY0NNQTBrWURPVGdMVlE0alFHSDkrSXJv?=
 =?iso-2022-jp?B?eE1pVUtoNnY1QzRSdHVDYTJKZFVSd2ptUGxBMFNSd0xrcndtKzdPb0hw?=
 =?iso-2022-jp?B?YTVROHZmL2pCSU9kMnJ1UGRYcjFNK0JuZzRXemljU0h6NFRGRENRQXNz?=
 =?iso-2022-jp?B?TWpibGwvUnF1VFB3NW5nOGI2eFlhak9PQmhUR1pTV2NIWWh6WmRjbXFs?=
 =?iso-2022-jp?B?NTZXeE96Vlg0Y005MzY0VEx5ZVdkMU5aeUl2NVMwSTlvSURCdXl3dTAr?=
 =?iso-2022-jp?B?Z1R1SkV6b1czWFlsZzlIQ3JNOUJ1RUFnVzRBTHNRUk5telNYU2pncTU3?=
 =?iso-2022-jp?B?bXpYNlI1empZTWE3QmVKZG5yY2V4d0lzcFl4N2xHQ2grTnBNYXg2WUdh?=
 =?iso-2022-jp?B?ZzlpTFBuVTV0VEsvcjd3Y3lrVy9VemVtY0xYYUpLVWRPcGU0VUtHSXk3?=
 =?iso-2022-jp?B?SW9SUjZ1ZEllYVVBSGw2eWNPWEZ6S08vWndsd3EwYUluS3JDYTNBNFZP?=
 =?iso-2022-jp?B?UnQ4c1QxY0N5bUlzdEgyK1FxRVVWWHdOYmN6TlZoTnNSSVpXcjFHZWtU?=
 =?iso-2022-jp?B?YnpoRUI1Qm9GTitCd2J4Slg3QnVPeVdrOFlUVllxRTFjdGJiNjJINDN2?=
 =?iso-2022-jp?B?NnZWbTg3dFh5QXliMUpidXhZT1hGMlVXc0txeS95Q3ROZTNlY29SekVX?=
 =?iso-2022-jp?B?TjlSS25TRFlkcGlYMFhwV05qdjFzOXA1eHJiR2tpL05VWkV1MDVVUGZF?=
 =?iso-2022-jp?B?MnZrMHAzN0JGWU93ZlhPTWN6aUFYNlBWRWFyaXBkclZMRzdSVCtnRldh?=
 =?iso-2022-jp?B?N3h1YWswMjhrQ283eHB5U3JxWGhRU0ZkRS9NTGw4M2NFVjRvTFRnS2N2?=
 =?iso-2022-jp?B?OGJWd0JtYmJISUhjTHV1NFVpY0V4b3pFYjQrWk4rTlhVSDhrY1ZvMmZm?=
 =?iso-2022-jp?B?blBpSFY3M2RidkUzWGowbXdPcENRVmVNK2Rsc0VQTXJYWUdwMTdyWThy?=
 =?iso-2022-jp?B?QndiTC9DL28zOEttUzZuUnhWanRvQm1lZUQ3ZVZ3MjB2VGxRYTNFa1BI?=
 =?iso-2022-jp?B?aXZVV1B3QWJPQ2ZzNXJBVzZkT3FhZUhxSk5wc3hTRXpLSFVUWjUyMWNq?=
 =?iso-2022-jp?B?Q3JYdmp3cWFVa2FjTlREaVpCaDZNS3ZVUHVtdm00SFp6bXBnck16Q2ta?=
 =?iso-2022-jp?B?YW51c28veE5PS1YwVjdpY3VEb1ErTk1BSCtIcFNTSHhKVGYxek82N1N0?=
 =?iso-2022-jp?B?bkM2aDlDWWJsRlg1bFUvT0ZQOG14RjFoTGdGUFpsUlRSVUFLajB0RS92?=
 =?iso-2022-jp?B?N0dWdHU2eDdwR0poenJCTWh0Yi9XZjgyeUNEc3hONm9yOE8xdXYvN25Y?=
 =?iso-2022-jp?B?dWlJVUpTQUcwMkJZWjJyUHhFMlNZRFhNVHdHRWEvZ1NNQzkrOTl0WmpF?=
 =?iso-2022-jp?B?aHdUd05EOWlmemx3UEE4cWJQZ3VuQ000RmtERTBGQS80NFdIT2E5ZGMw?=
 =?iso-2022-jp?B?VGJualZUam5ZSHF0MU13cmdNcndZS25vMWxLdWdqYjZwU3ZCeG00NHlE?=
 =?iso-2022-jp?B?Q28zZ0tRdUY5YmtLZFZtaCtJemhVYVFxZVozL0xmL3BxUnlJbW9ITGxv?=
 =?iso-2022-jp?B?eG5pMFVCV1E5MHFZc1NTRkN1cWNwcmxqcWpQZXlwcHZlbE5BWE5aSUlt?=
 =?iso-2022-jp?B?Vms4QUtwNVdvTGJpbjh3U0ZaZDdHSHhwUGxkcTJSL3VFaWxQQTc5d1FX?=
 =?iso-2022-jp?B?a3V2WVVIMzhsbkd2cEVabHQyMTdaS1AyQytGSmFuYTFkQjhDZUtRZUlu?=
 =?iso-2022-jp?B?YS9mMUlTaUhXYVFNUmNhaWxIZ2hKUVNBMk5MN2JSWFh2MERpN01Gb3pK?=
 =?iso-2022-jp?B?WUxYTHJCdDFmRzJYRDFmR2JvRCtjPQ==?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6a06dc3-c54b-46ff-95da-08d91a6ab1ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 02:06:20.2214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uF+JgbKZBNSvyHnzaEhKb6CX4DAumutC20FMgcEKUajsyNF+ahVGHyAdAUySpuqbQcnS71rsT+yqPBSxeilUI+hPETIpAUVEl7fWmDqKH/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6127
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,=0A=
=0A=
> +static bool unwinder_blacklisted(unsigned long pc)=0A=
> +{=0A=
=0A=
I've heard that the Linux community is currently avoiding the introduction =
of the=0A=
term 'blacklist', see:=0A=
=0A=
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D49decddd39e5f6132ccd7d9fdc3d7c470b0061bb=0A=
=0A=
=0A=
Thanks & Best Regards,=0A=
Keiya Nobuta=
