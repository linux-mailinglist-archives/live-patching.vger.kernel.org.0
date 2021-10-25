Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3BF438D6B
	for <lists+live-patching@lfdr.de>; Mon, 25 Oct 2021 04:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhJYCUw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 24 Oct 2021 22:20:52 -0400
Received: from esa15.fujitsucc.c3s2.iphmx.com ([68.232.156.107]:24614 "EHLO
        esa15.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229665AbhJYCUw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 24 Oct 2021 22:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1635128311; x=1666664311;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=y2/5X9uG34CRviwzr0YtNGvMrjbbtie1jyeu2NY/w7U=;
  b=YVFpDavM2S7fGte4aLMHoQrS1RPsBCOszAsGxUi2Bbc1BvP6KUvcRJcc
   3iIQTdEU89HSnxBY7wS7WTfgxG/ukrdLXQegQE1R4bJyh2P5bt1W40fyY
   nTD+kAmcQGxpKqvHq0n6FevqU6lkp+giWxTd1+pSKdOC2wTm6UM6DTyff
   Iot+MO9CIKhdjtAj/YBaEZXG9CPrjzuW4bFpql4Bbte8A1wIudTUfTB+B
   ZRcvJBU2AcFkKPSa0+DVaz6NAKbnWysdIxMlPJuHfyXTuIAFWKO5kpUm6
   kSdi7/MPo0ix4IraDNso1iUKcItDGgxtDK6uyS8eizWPSb1GUDXB+UgKC
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10147"; a="42020801"
X-IronPort-AV: E=Sophos;i="5.87,179,1631545200"; 
   d="scan'208";a="42020801"
Received: from mail-os2jpn01lp2054.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.54])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 11:18:26 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7ghr84dhiWVh5ahnrR2CRDzBHh8E0u7W99R6Q5R2KBPVlvuZ5iLI63WE8wtZid7b47OhWkjm2QYSDn/uPULRif/EM1f1NhoI5Rod8ydQQ+4ncYhuWbqxyWY3LoMlHGQggoASS2+guG+aVRS9BeiyMYzk32xobf3aDz35qb3IPKxL1BxUQOybH2a77duV4HCXChQSXnm7+R2MIxWyEqSDrDxZettyCjiFnCCGW2VmJHhleU+7R8YBpG4EvGJjS5tcoQL6G1JeaJwYmaPArbyxCiS/5kCg3ZSvxngGxKxnp2ieM0P6xUNbVaG031+bPL6UkUKjFgvIiZjd7rav2HvbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCzWn8iL1lYCz0MF+MUXu2HlQ7hGTD7+NlM0OjmsAPU=;
 b=BphJG7QbYh2dZGeKRWnboljUFIG6HTB29qe0fA4fXZH19SwZYHlwpGDakBbXUIi5iwEDL/p+ixz3EXgyjpg/W4WqYo2EiDEzpNmOzUT+fAa1fPxUtsQxgv4GzRgeWRlANDcB5heHGZYm0/8ZoO1Km85cW0vs6lj3Q6FcKHGf3zBQ5kTM/vXvAbbYt/Zam8+jn/A3DPgownrN5f5g2hKd/EZGqgiaZdzDNM1DQrv5DBWxp4iRjSETjHh8LlbmuI3HIO3ERlgG2ZXBbNB0Lnfqrz14NX9on/H5TC5v790hC0P8a1NEvR9taG6tXeq2cQzgzgKup+/EknjbgSnTpO7tVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCzWn8iL1lYCz0MF+MUXu2HlQ7hGTD7+NlM0OjmsAPU=;
 b=QOvVdWfiyQfLSTwT23HN0fVq6GD8TNiZL1Xi/x00YvmJh3KvYCBtGeW7PUKHN3X28bxzbC9BzCDKVeZqdhDK3fjIVIRNCWhOEeT3E5Of4rRv62ypZtA/ScC0JoQjQO5xM643KrHvzY+AZfFxmjUr2JYSd0vlq7uRfovv11mEz7w=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by TY2PR01MB4729.jpnprd01.prod.outlook.com (2603:1096:404:11b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Mon, 25 Oct
 2021 02:18:23 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::3115:35e1:f76a:df06]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::3115:35e1:f76a:df06%6]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 02:18:22 +0000
From:   "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
To:     "'madvenka@linux.microsoft.com'" <madvenka@linux.microsoft.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v10 06/11] arm64: Make profile_pc() use arch_stack_walk()
Thread-Topic: [PATCH v10 06/11] arm64: Make profile_pc() use arch_stack_walk()
Thread-Index: AQHXwXCij/u2YLmRUkWgzMm8xn+b86vjBcHA
Date:   Mon, 25 Oct 2021 02:18:22 +0000
Message-ID: <TY2PR01MB5257A65FD9D19AE3516D447285839@TY2PR01MB5257.jpnprd01.prod.outlook.com>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-7-madvenka@linux.microsoft.com>
In-Reply-To: <20211015025847.17694-7-madvenka@linux.microsoft.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckermailid: 68a9d866bc4248e9b1fc7a1daf7249e1
x-securitypolicycheck: OK by SHieldMailChecker v2.6.3
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-10-25T02:02:11Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=3a090ed2-2dba-4378-8cc6-052a8c0a2842;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cefd746f-73d0-4335-049d-08d9975db83d
x-ms-traffictypediagnostic: TY2PR01MB4729:
x-microsoft-antispam-prvs: <TY2PR01MB4729AF1A406ADDF8A56B23AE85839@TY2PR01MB4729.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O09sjl8vwdebMkNHt7rcqY2UUtZSU/yD0YxsT3ickDkX2Yklti0JX5mP3XBcPjKjj+CHPDD5lcs57rHfCA1qbkNpyx0GpjzYCFaaW0cL3lxnGZVZC4geKev8czq+zz5zsdqTS+DmBv+iz/VWQpvQfbPmHNsaueKvhhlbS+eSJg2AEVgRdoZ2UtGgnYSsXANlgWo2W9A02pJM38CuWpaDoh1HKRxIz0VbzW36vg72BJTV+j95ON2qXJteP2X/d96RHrLOy2kn7FXco/w59qr7KX/Xawb3qdxG/kK5NCHeNZy3ezrTK9TVC7EFFJ73AX8JmecMKPRy62hYmJNKvvr9Xjj9lc9TgE5K8jZCFQodcSCWK8Eb1EBXT5c/s4Ht1J3s9uXGwGudaLJu327hjQKEFLauXAolRZFZqIj3DCThE/dJkz3TL1ubXdk7iGufypGoJf5M9F2jMkequwl21FkfXJ08ke4l5HiOzKcpm7Ekge2SOSQUk0T4XNvkkY3aGjtHSg6PMo/0xqmNRFhhjN3zgwos32QAXVMG7cPF7LRG72WUX22Y9CnnPCpXizu++uMii2Nv5xl9kGDCO/9JKTYG6lPz4sbQS6MPdjzI+7XmNyKx677IKhPxARVoEVs+ETOYPd2g+z/+n6ikwJmx6QDvBkd4X6ZOavh1E12u5S7c2Op6QEBB3gD9/SaBVtHm4JyhRdgqaZx5zGKdwFkC7mZBwngguV559C4WrmsV7kWjE1831JVS15kOBCt3PQDGQxCZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(33656002)(7696005)(82960400001)(53546011)(38070700005)(9686003)(26005)(186003)(64756008)(52536014)(38100700002)(71200400001)(2906002)(7416002)(5660300002)(85182001)(76116006)(316002)(8936002)(83380400001)(86362001)(66446008)(8676002)(6506007)(508600001)(122000001)(921005)(110136005)(66556008)(66476007)(66946007)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?c0NncmFoZWRzbkgvVnZuNUM0VUdoSE00UlpiWDAxQlAxdnBaQXpHNGwr?=
 =?iso-2022-jp?B?K1E2UDdTUm9zV05KaUJEZDBRUVE2dGJvQmdEdzNlMXFybVhCYnBqdlZy?=
 =?iso-2022-jp?B?U3QwR2VzOFdHbkNJeXlEYlhMeVJ4SzNqdVBSdGF0bGlQSU9WVHowS05L?=
 =?iso-2022-jp?B?dTQ4VEZsWVdFL1crQkI4Unl6OTFLTE1SdnNKbzEwWWREdUcxL1BBUmU5?=
 =?iso-2022-jp?B?TDY2R0pwK2ZiNGFOb2xqODkwQ2J4V2RwWGNTamQrZ2tzOUtPT1h5L3l4?=
 =?iso-2022-jp?B?dmtoZFFhYzJsbUFTaHRRc1hKMlZvazZQRDlYeHBsTkFoWVBpMC9KZTV5?=
 =?iso-2022-jp?B?dnI5U2JZNUV0SjBHSHdmZ3R0Nldrd202WG9oaWs2L0VPamNpQ0tGQnJD?=
 =?iso-2022-jp?B?eXNoMmgxSzQyWUJuMU1LRjFaR1N0ZHZoOHlmNVlBL0xZS1lnTlhUanVy?=
 =?iso-2022-jp?B?eEJOZ2x3dTlNV1R2RHRyQ2svZ1hQWGNna09uRVdDZ0xZT0dBMTFkMFdS?=
 =?iso-2022-jp?B?N21CUXBJV3hQSVpEdHBCcU84QnF2ZlhlOEZPRkF0bVJ3ZW9UYk40L0Jl?=
 =?iso-2022-jp?B?TVVORnlpSGpjKzlESEcrbUVOc3hjWldYVndYekpzeitJSloyOXUzajM1?=
 =?iso-2022-jp?B?Qnh6MW9VL2dGQjdmRkVYZm9vM2ZsSERSbXRZQmpHSmVuUFFJWCtzYXQx?=
 =?iso-2022-jp?B?OHV0VXh0Sjdhb3dmZnB5ZEo4TWpwVDRJTlc4VFN0VjlGb0Juam04aDRW?=
 =?iso-2022-jp?B?YmdFMFY3RngzSCt3T0NncEtIM1RCeHBXclZWMGZyV1BFQytqUlBmZTJN?=
 =?iso-2022-jp?B?eXprb1FYTm1jRjNiM1pYSmJTWGcrb3NCTithTDRRQkpobE1UYzRWK014?=
 =?iso-2022-jp?B?ODhRRjBSSHFRQWxlZTh2QTZNKzk4bmxqTzBDMCtyV210ckVWR01wTmgx?=
 =?iso-2022-jp?B?MndSSWU5Sk5kV2oxMHBxbzdwMUNxMTFkUE45WWVGWVBtMDMxYk1IUWNn?=
 =?iso-2022-jp?B?NGZLeHBpYWdQYlRybnN4Qys1Tkt3YWVEV3dDbS9XV2Y4VnZuVkw3TGIy?=
 =?iso-2022-jp?B?dXFFKzU2QmZ5cUhNK24xNlNXb2RidW5JTHIrdHpiNXM5T3haZ1BZM29S?=
 =?iso-2022-jp?B?R3dQUmRBZG9NTGFickpuQWNYTEhhbnZraTA1Q0RDM0MzeGJsTGhZWnh0?=
 =?iso-2022-jp?B?UHZQcGtyOUxSWEZ6djhySUllUUdLdVdnKzdHZi93RFJveGtzQWhGTGtX?=
 =?iso-2022-jp?B?bkZnekdjRStOSHcrME10SlpzRVNtSGFXTWx2bW9JcWwrc0hlc2FHS0to?=
 =?iso-2022-jp?B?RXhwQjgwNGJiVnNkOVpHOGM4YmlDRFo1UlE1UEwxcHEwRUY1LzZsMmw0?=
 =?iso-2022-jp?B?N1JQNlQ1VjRPSytkcEVNWG43ZXR3MWpJK1N5bWVuak9XMU9zR3RwZnkw?=
 =?iso-2022-jp?B?L3FIMWFZYlVTM2x3ampXaGRla0N3ekJ3QlYvMTdqdW1XS093NXdnSWln?=
 =?iso-2022-jp?B?WHk1RnFIZWhNVGhibTJrMlB1aEdjYkNLL2p5bjRUZ3h2b1k5WGdRUFVr?=
 =?iso-2022-jp?B?amJNUmxuYkhpQ2FNRjArODB0eWhnTDVTWkl4amdEbnZwYWtGVW4wckNZ?=
 =?iso-2022-jp?B?Q2lWN3NCbm5qemUrdmZaTmRyV21oZnJvYkFiajBVYWRLL295WFZ6SUlm?=
 =?iso-2022-jp?B?a0xPY1FOK2lrazdIVzVZZm82NkdjVGhQS0xMbXlmSzVWSTNBRWdoWnFt?=
 =?iso-2022-jp?B?cWFwWlQ1NitaMy9xMmdQaGVwbmpmUjNYdFVmMG13QjVmY2VuZGdkVzRO?=
 =?iso-2022-jp?B?MldlYW8xRkdEc0kwektZK1hhU3FFQWNrcTdQaGdDV010Y0w4WnpYaE9t?=
 =?iso-2022-jp?B?YmNqY1pONEczdDJ2L0prTGxheHRiclpvb2x3eS90UkNnditpN1A1UXZC?=
 =?iso-2022-jp?B?dU1JMWxmRlRZeHZzWEFIcHVVUmFFWHJUL3poMXN4Tzd6eDZ0Q3hoOGFv?=
 =?iso-2022-jp?B?NkkvVkhsTmE4VFVzak1FRzBFZDlCWWxBWGJST3Jpd2Z3MUtLRGpVZ3VG?=
 =?iso-2022-jp?B?ZXJxbHdKSGRydUFUaG5kUmF3N2NVZHhPR0NBRllLMXozd0FLMldDOUlE?=
 =?iso-2022-jp?B?TW1ibHBwTktJYjAzM29tYVZGaXVjRzlNMkt3OHd4VlRTNlNXS2lwMGJC?=
 =?iso-2022-jp?B?MW5vVUlTQWcwMVlSNlI2WStpZmRzOW1LZng5QkJBQzZ0YW9mZmc2akQ2?=
 =?iso-2022-jp?B?a0Q5ZGFUcmFPcVozYTZobGdSQWlocG1ERlFKZTh3UXJ0VXhGaVNPek9k?=
 =?iso-2022-jp?B?OGx1MXNzTWljTXgzLzhJYkpLVStOaFhXWXJRenZVb0lnV0xXMk53Q0lt?=
 =?iso-2022-jp?B?M20rRUdZNGI3bDY5ekxIVnlGay9wTno4QmR3L0NBZXJzWlp1T0ROOTlU?=
 =?iso-2022-jp?B?Nk5hZmxnPT0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cefd746f-73d0-4335-049d-08d9975db83d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2021 02:18:22.7595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tiAQWg2mLFGX84e8t2NxnV0Y3tmBYUj55ejcC/QeiJlUxiJBlcS9BGNzWDnT+ZYOHkP/Lk/uV+yR8k1NrZlQHHdY1Xds6rmPhkI5TKGIiOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB4729
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

> -----Original Message-----
> From: madvenka@linux.microsoft.com <madvenka@linux.microsoft.com>
> Sent: Friday, October 15, 2021 11:59 AM
> To: mark.rutland@arm.com; broonie@kernel.org; jpoimboe@redhat.com; ardb@k=
ernel.org; Nobuta, Keiya/=1B$B?.ED=1B(B =1B$B7=3D:H=1B(B
> <nobuta.keiya@fujitsu.com>; sjitindarsingh@gmail.com; catalin.marinas@arm=
.com; will@kernel.org; jmorris@namei.org;
> linux-arm-kernel@lists.infradead.org; live-patching@vger.kernel.org; linu=
x-kernel@vger.kernel.org;
> madvenka@linux.microsoft.com
> Subject: [PATCH v10 06/11] arm64: Make profile_pc() use arch_stack_walk()
>=20
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Currently, profile_pc() in ARM64 code walks the stack using
> start_backtrace() and unwind_frame(). Make it use arch_stack_walk() inste=
ad. This makes maintenance easier.
>=20
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/time.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c index ee=
bbc8d7123e..671b3038a772 100644
> --- a/arch/arm64/kernel/time.c
> +++ b/arch/arm64/kernel/time.c
> @@ -32,22 +32,26 @@
>  #include <asm/stacktrace.h>
>  #include <asm/paravirt.h>
>=20
> +static bool profile_pc_cb(void *arg, unsigned long pc) {
> +	unsigned long *prof_pc =3D arg;
> +
> +	if (in_lock_functions(pc))
> +		return true;
> +	*prof_pc =3D pc;
> +	return false;
> +}
> +
>  unsigned long profile_pc(struct pt_regs *regs)  {
> -	struct stackframe frame;
> +	unsigned long prof_pc =3D 0;
>=20
>  	if (!in_lock_functions(regs->pc))
>  		return regs->pc;
>=20
> -	start_backtrace(&frame, regs->regs[29], regs->pc);
> -
> -	do {
> -		int ret =3D unwind_frame(NULL, &frame);
> -		if (ret < 0)
> -			return 0;
> -	} while (in_lock_functions(frame.pc));
> +	arch_stack_walk(profile_pc_cb, &prof_pc, current, regs);
>=20
> -	return frame.pc;
> +	return prof_pc;
>  }
>  EXPORT_SYMBOL(profile_pc);
>=20
> --
> 2.25.1


I've got build error with CONFIG_ACPI=3Dn:
=3D=3D=3D=3D
arch/arm64/kernel/time.c: In function 'profile_pc':
arch/arm64/kernel/time.c:52:2: error: implicit declaration of function 'arc=
h_stack_walk' [-Werror=3Dimplicit-function-declaration]
   52 |  arch_stack_walk(profile_pc_cb, &prof_pc, current, regs);
      |  ^~~~~~~~~~~~~~~
=3D=3D=3D=3D

I think it should include <linux/stacktrace.h> instead of <asm/stacktrace.h=
>.


Thanks,
Keiya
