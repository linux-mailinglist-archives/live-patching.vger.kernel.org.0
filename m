Return-Path: <live-patching+bounces-1457-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B47B9AC1CAC
	for <lists+live-patching@lfdr.de>; Fri, 23 May 2025 07:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E62CC1BA31B2
	for <lists+live-patching@lfdr.de>; Fri, 23 May 2025 05:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BFEC223702;
	Fri, 23 May 2025 05:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="M7nw1Rox"
X-Original-To: live-patching@vger.kernel.org
Received: from esa16.fujitsucc.c3s2.iphmx.com (esa16.fujitsucc.c3s2.iphmx.com [216.71.158.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB9D1F3D52;
	Fri, 23 May 2025 05:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.158.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747979790; cv=fail; b=rFw/ngam0oO6KhWdzGtyjx8NrnZ3DJ+kjFLi0TU6H/u83LwW2ggSrA7sMpppNSXhqhI27zgNrDb8J6K1fv8JOI9Q+sRuApXsWUSmkThIHfm5hN2iwmKwsaaLvT2SzG0KbFEPL2NnXs3chEIHZG1304NRVhmodLTSbObOwhIvTSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747979790; c=relaxed/simple;
	bh=Q5PR7TrMgxrOzHSpoJSES+yIz47Ts9rL3B9rjrXRMjQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ec/xYwQguYkIzW2k1nrRhSxlqb6JPF0U2V/kmxbv7gkowm2IUnoPpIh+ld5GLDj8excnOoSb828E3bVm4rIQSJXkR2cklB3wbT/9Ua0jelKhGVm/Oo0/26PiQX1TkaTL+BFyyAfnMR7Nq8G7QBf088bnp+IoA5AYIlDFEHRSQhw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=M7nw1Rox; arc=fail smtp.client-ip=216.71.158.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1747979788; x=1779515788;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q5PR7TrMgxrOzHSpoJSES+yIz47Ts9rL3B9rjrXRMjQ=;
  b=M7nw1RoxJKMXQUpafLK9bxdKZ81uTvO4KYpa1Tw9rmMPUHWAhc4SeCu1
   pkAEhVo/B/6E3EVHP2UHQtdTuziVjGX4+f8wIRHN/jMs/NqYcJC7EauYW
   QBgbnXWjXZXbBqB7FRyE8vqFlpn54/UDlbSnXUCTNN1NkfLjsbjvTVCxv
   n66h5y85VB0sVkKfDSkt6BvfdxeM9aP/W1ptp2xSdFukFNnil35Dgw/HL
   Awt2u41NPCRRQL2hFzTvzh9U0vYhXHOR9f8GWkmH5JEZmCYvYonLJY3HL
   q/7SsXwStry69NwMybkVpDmRTbiCUaOSsJISJi2SLE2MJhVJoSiDGWSc3
   g==;
X-CSE-ConnectionGUID: vluo5Q+vTTqW278wVOUb4g==
X-CSE-MsgGUID: QkeW0pJlTISVeyuCTfUd3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="156370235"
X-IronPort-AV: E=Sophos;i="6.15,308,1739804400"; 
   d="scan'208";a="156370235"
Received: from mail-japaneastazlp17011029.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.29])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 14:55:11 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vGR5XT3IpBN4LVSxQK/p2FZz5J7Xf6FMBohlLMBy4/Y75DWGTvj6eeuMtv1oRr/qDzStz+82YKFNiaI4tOuoIwDk+puHabVKZIdoNUZMUX3VKOOGsvdJHYY1QkabgMVfqQuJScuQqBTAp2hutRdJ1WMnWnb+fsxIzSi+UyX88R7QjORLs92fyub/bpYkfXpCMLL7Rde1XZb/4DElxPE/wQXbbTEZTwv2ITG4u/433qxCoSJBrPob41pzzxUOZtHIND+TLgD5vxvYEZPaUBVne9XUfKuMLavQOf3C7QF2R9/gt2vbPlrgzUysHwGIEcx/863UUx9GpWZQk89ZHUuafw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5PR7TrMgxrOzHSpoJSES+yIz47Ts9rL3B9rjrXRMjQ=;
 b=DAL2F7J6emGhtLDqmplcT3uIfwOumbLuoDOzmC4Kd+LJQJQ53pgKeeqiFvuaxjAV8Wvq5jy1JuqcbzAINVJG4h41Xbalx7YVT13J9hzadap7Ct2dv7p9I2Xdmv8i0DPojT/aWzI7cCJ5sob0QzOSOGa9vP9kXQB8iSrYG+TIkeXf8fLidlMaJzYK+dCNp+XkGhrhVg89CtPeeVAQD//C2iOSHhh6hs5d2XcyEnqmJS6RVk0R2JkzZ63kxge4iJyk2Olc4QH6TKa2eDbe/JWthxBT3sszh6qx/SK2rFMxc9NeAYSe6dRiNYats7onMKRRmKmyoDNnqsJWg4xuqRQpIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY4PR01MB13777.jpnprd01.prod.outlook.com (2603:1096:405:1f8::9)
 by TYWPR01MB9311.jpnprd01.prod.outlook.com (2603:1096:400:1a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.20; Fri, 23 May
 2025 05:55:06 +0000
Received: from TY4PR01MB13777.jpnprd01.prod.outlook.com
 ([fe80::60b7:270b:27c7:4fcc]) by TY4PR01MB13777.jpnprd01.prod.outlook.com
 ([fe80::60b7:270b:27c7:4fcc%7]) with mapi id 15.20.8769.021; Fri, 23 May 2025
 05:55:06 +0000
From: "Toshiyuki Sato (Fujitsu)" <fj6611ie@fujitsu.com>
To: 'Dylan Hatch' <dylanbhatch@google.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, Miroslav
 Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe Lawrence
	<joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, Ard Biesheuvel
	<ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, Peter Zijlstra
	<peterz@infradead.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Dan Carpenter <dan.carpenter@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
	"Toshiyuki Sato (Fujitsu)" <fj6611ie@fujitsu.com>
Subject: RE: [PATCH v4 0/2] livepatch, arm64/module: Enable late module
 relocations.
Thread-Topic: [PATCH v4 0/2] livepatch, arm64/module: Enable late module
 relocations.
Thread-Index: AQHby1tudYCohoUJz0KMYCt5SP2jPLPffcBg
Date: Fri, 23 May 2025 05:55:05 +0000
Message-ID:
 <TY4PR01MB13777AB3A12DCA297E5642CEDD798A@TY4PR01MB13777.jpnprd01.prod.outlook.com>
References: <20250522205205.3408764-1-dylanbhatch@google.com>
In-Reply-To: <20250522205205.3408764-1-dylanbhatch@google.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9ZjM4YTMzYTMtNDc3Mi00MDU0LTg4NDUtOTViZmUyNDM0?=
 =?utf-8?B?MDI3O01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI1LTA1LTIzVDAyOjI4OjIyWjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?Q?81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY4PR01MB13777:EE_|TYWPR01MB9311:EE_
x-ms-office365-filtering-correlation-id: ddd5373f-af55-4195-edb2-08dd99be5e32
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TGtuVEZvSVo0SVdzUU92NC8wVGxHd1lXZDFNdHFGQkQ1SHJleXl0NlVVVUhF?=
 =?utf-8?B?TzJoRlkzMmJwY2RkMmp5WEFaQnpraTIwZmxqbGVjT3BxcGNMUUR4S1c0UGQ1?=
 =?utf-8?B?MVFnbCtHb0UrY1lYdGlQNW5lOU5GNmNHRmoxQ1BKaHlrQ216Mis3LzhpSEcz?=
 =?utf-8?B?SGgvMER3MzVSd0RMRW5WVU5RbEVtMUo2SzM4ZXVEbDFYTldSR3JQVEsycmFa?=
 =?utf-8?B?MVVtbVJaS1Mxd2FtZ2luN2RLbldya0w5NDlYMk5KOTlQME5LSStWM3Fxa1Mw?=
 =?utf-8?B?MndJVkpNQXVPNFRzVUo0NFVIQkFoamd0YnlpWW9WOE5GODJaWnV6a3BQdldO?=
 =?utf-8?B?NW5oZkhXVFlHT3pPRnArMFVWeWdUMVJpMFJSNm1DdjUxWTFTM2h5bFdFTm43?=
 =?utf-8?B?cXhZNitIWkFTaVJPUTA1dG14TWh2d0E1ZCswOWtnRHRDOFIyVFNmZzBwaEZk?=
 =?utf-8?B?QUc0bEJVemxMTUkzbzNtVlBpQUlRSFpIajdTamVSUnN0WTNHUlFRMzVxUHhS?=
 =?utf-8?B?K1pFSm1XUnVPVTJQY0JVUnFVd2IwTkV4dkxvSDJhV2ptZzNGSndpa0puSEM5?=
 =?utf-8?B?bzVRZEVJTERkNVBBNGFHVXRTSlBVRVFBVzgzUXgzckFZQUd1N3R4S2kzeG1i?=
 =?utf-8?B?UlRtTEp6ZW5CUHh4RTlRTUJVZjdRc0w0QXNSc044U1FMZEJ1NWpwZGZ0TUpF?=
 =?utf-8?B?Yit4K0V5bEJmUnFIc1ZvVHViQUl6clVvRk92LzV0aTBhNnBnbHJnZFdZMGdx?=
 =?utf-8?B?WVRHRjBidUF0TVgzWnhJK3dJdnJ3dXZPRDNoRjlGK2ppMkJqOVh1S1lXVkdH?=
 =?utf-8?B?VExQaEs2MWJuQWtldlI2ZXAwN3lFY0E4Zk9TM0hMb0N2T24yYWNsSWZkL0w0?=
 =?utf-8?B?VmQ3ZXNEMEhadW1uM0hldmgweUFtNUUxcDAxOXZVWGlVbUJZRWVnYUJhMllC?=
 =?utf-8?B?TklyL05nSVhKcTE3RUVMWXFZZi9yN1hDVk11WWU3NHl6RlNQajM1QWN1NWRz?=
 =?utf-8?B?Yy9jRGlmaTJCS2ZHaXRRL0V3VlVyTTBteTQrSkxtaEZoZ1g0Zm1jUVdVNGZS?=
 =?utf-8?B?cnVlTFZrSGIzUVV5c1F3WGl5RHZWSzdmOE1MRzVmOWk4bk9DYWdzbjk2Mlp1?=
 =?utf-8?B?RGxRNlBUeGQwc3dzT3dic2Uram15WmtoQjVhVkxUY2NCcFVWdFRBZUJBWGZV?=
 =?utf-8?B?emhFTExBV3ZzWFBKY210dStyWFh0UzMrZ0M4RXFpWGErRGtyZ2RaalNNYUNz?=
 =?utf-8?B?UHZMRzBtanRzeDVGSVNCZ29hRlJCNytKaisvbkJZdk9EbndPeEd3aDJmMTVT?=
 =?utf-8?B?bGRRbFJEY0E3U2M1KzZoZUhxWWU1NC9nMW90MGxzeEZaWURSNWpIZENiVnNP?=
 =?utf-8?B?NVBDakpsQ2dXWWNhWUNBOXJ1Zmh1K1RYOEhLNk9QQzBjZmdIVmVsdU1QWFNH?=
 =?utf-8?B?NXVqOFVTYmVQcHpiZDZsamZBcm5rcVVkWXdhY1ViTlJCdjlhY2U5YUg2RkVK?=
 =?utf-8?B?ZmVJSHoxMEZqUXlGRWlJUXd0cjJVMFp6ZWhBTmJUMktzeFNRM3NoVWprdVNX?=
 =?utf-8?B?RTdNZWVkT2dSNHRmSWdnRkJWSWFWMWJkU1hvY0swcmY0UTRjSFZSTmJyZ1NK?=
 =?utf-8?B?c05qbXltdnUveFRNL3lIdWRxWlFSWWQrUmJWUVNrSFNHM0xSaGpXK2tFTE1I?=
 =?utf-8?B?WWJzU2JjUFFRM2VJamdFbWthSzlhUUVBMWdBaFhGK05GdHlLMGpqeFQyU3N0?=
 =?utf-8?B?dFhaQ1AxTEZZUnNJK3BTTnptRjQrOFpsdC9YdWxhR3lXRGg1ekcyOU9yU1VK?=
 =?utf-8?B?b21iRDZYb2hia2F3K3QzQisvSWYrcUFMa0lYYytYSHo2VVpJQlNMaElkYnY3?=
 =?utf-8?B?RFVYTzV4OVA0SlNTMnNoSTZJMVEycWJaY0hmdlBMK1BRcTVTbFhFeXhMdmlE?=
 =?utf-8?B?OGxaSXdxZGdpanM0TVk0UUE5VUtreDJZS05UekV5UFNuMmlQNGtnaFd0aUpI?=
 =?utf-8?B?MjNEd0tJMmp3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY4PR01MB13777.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YWZwRk96blg3WXdwZldXK1AxQWE0S1Rta1ZuT3F5clN2L0lhWnNtK1ZyUmZI?=
 =?utf-8?B?aGFDekV1V1BqNFhPSFVzR0RoMEJmalRLV2VuZVIxbTVzOVFPNzV5dHlmcTZh?=
 =?utf-8?B?NVROTmRxYTNZU05ERHVUcjlKN2pGVEQ1MVdaTWlEQmMreFhlOEE5TFNmU3Zp?=
 =?utf-8?B?Y0RvNCtDUlNTWGJPSTF3ZFJtRkUvYlI4WWxkTHBjc2FBZkE2ZGtFSUNvWDdL?=
 =?utf-8?B?NXRWS3FGN2JJTDhHSVorUHRDbzZoT1p3L0cvRGlwRHMrMi9mTFJVRmdMN1Vl?=
 =?utf-8?B?RmVOWGNMd0lIbk5Bbm1abWdWK2ZVbmVGOVNaOC9kaFZ5WTJaNnphTEtPcTVJ?=
 =?utf-8?B?L2NUenZpOFhkODV5Tm5ON0N4MHhtVmlrU0U3MG5vZlhPQU5hNFpXU0FqUVZ2?=
 =?utf-8?B?bm5lZ2xMK05tT2E2VXd1ZUVpZy85TnNmNUJNeGVjbi9JYUF3OWhwUFVuOVBN?=
 =?utf-8?B?Tm10a1NONlZnY3Y2UkpXNERhMnRDemdxUzd1aHd5dDFhRlIyajMrSC9uK1pJ?=
 =?utf-8?B?aFFlUGFiNGsrRURSeGU1N0huWW92ZkFjWUs1dTh3dnRJZDl5NEZjdGRUVkxr?=
 =?utf-8?B?dmVMd2tyYTNLMWFGWTYxMnhTaWVLMml1MW1ubGNlNnY4cXIrRlE5Sm5zTlVq?=
 =?utf-8?B?cThsd2JqZjBvMnE0ZlZCdk90WlZmWTVCY3JNOWwzeDBoMTdRaW43bFNNK28z?=
 =?utf-8?B?M3RDaExZNjF1c0wwbzlZVExaNHErY0tVNEU4NEovcmhTanBxOXBLUFRmZDND?=
 =?utf-8?B?bDgzSm5mSTRqZnkzR3UwOFQxZWhjZzZYVkhrbzRJZWdnTjBoWEovdzlpRzRX?=
 =?utf-8?B?cFVVdnF6cFFOSU1GMHUxbCt6UFJmSlVvRVBZV01XTXc3Q0psdEJ4bXBVMGpN?=
 =?utf-8?B?SXBpUzVYQldUbWRkekIxYTByOXlwL2JYSFp4Q0N3U2JaWnZMTGhzcUlJUE9S?=
 =?utf-8?B?R2VUSkVnQ1JyUGoyUElwZmJGRk1Mb3FWZmhkVGtkTUpHM1FtVTJKaEF0ZU5S?=
 =?utf-8?B?ZWhxTVhvV2ZoaXlaeFVMemgzVDFEWjlSM2p5M0dReFhTdkhnVUpCNVNQQ2dH?=
 =?utf-8?B?dUpxVStXSjAveGluLzB5SVQrSEc2akFvTWwvRzk5eUl2K0ljM1BCeTI1bndW?=
 =?utf-8?B?ZzVZOUFWbWpIdkVuZ3YzcXorWVNEemNvMFFsd0QyWUNEQlhkb1NTbkZueE8v?=
 =?utf-8?B?TVVCenhTZEZEVDYxM2kyTDJBMXpkTGplZHB3YTZ0bDBUMStnK2ZpTkcrcEJB?=
 =?utf-8?B?TWpMbUlkQnJCTEU2WGkycHR4Tk03UzZWejdmVWw4WEhGeHR1SlkyaFJkN1Fa?=
 =?utf-8?B?L3RYd291WXd5Z3g5ZmRlVnRINStzYjl6dFArcTRZQndscEk1WFV1S2FGeThG?=
 =?utf-8?B?VUFia3dmdWVJbmc3WVRWTXlSeVF5czBRTVVKbWFid0NZdVBiMUp6dFE1MHZM?=
 =?utf-8?B?RW01MUdjSndaaWFobFZZOXFEcnVhVTBXc1ZGVkFPMlJON2U3S1BOdWlnOEp6?=
 =?utf-8?B?MVo5Z0dEZDZCTFhwaGpJL1p5SDVqYk9UYk9wUmRkQ2dVYlBrTm02aGpRWVFL?=
 =?utf-8?B?VDZZZFFZZnloYTNscU1yRElNWFludElKWjRRRDhLNzFDeitJTm5lVmNtbk5m?=
 =?utf-8?B?aFpXV2hhY2ZmOG9CbkRXbE5MTndFM1FHS2UydTEyYjF6WER4YVQvdmN5bXZS?=
 =?utf-8?B?V1pneXVCVzFXb0V5Ny9UYzR1amo4cHoxbzJjRGRGWEZWUGRkY1puek5BaTFB?=
 =?utf-8?B?US9EYWhKMmRrYmRhT2xuZnlSZWVvOU1Lc3B0cHVyR014ZUlTTUhwMVYwU05O?=
 =?utf-8?B?a2pjT3kwYkw2MjhFUUtKKzBKOTF6YTMwTkMzSGtKcGlrWG10RVpBQnhqQmN5?=
 =?utf-8?B?WUFkb1hkVXd2MXJaN1JHKzltcHg5U0lsSDJCMGRKRTRzeHQwTDJPa1FNVnlW?=
 =?utf-8?B?TkFqdXl4aUl4bXd6NkpTem82bDhtVmcrUStsYkpQakZoOTZJTW1sOEhMTzFM?=
 =?utf-8?B?RndtK1BVS3JJR2JkNlprTGRtdTVwa0lWa2drYkh6WUFxU1g4dkh3V0U1M2ZD?=
 =?utf-8?B?SnBCR0MvTFhPeVRDRXVpempOdk5oWWlYbStvM3BBS0NJK1VESThoMlMrRVpR?=
 =?utf-8?B?UGR2TU9WUk1hM2hjSjQxNGZESWpraTR5Q3R4YkVVVVpZcDdYMk56WGpGRHJC?=
 =?utf-8?B?enc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	okBidSN819T/MTHXdYl1hYpENWnD5NshB8zF9FqqBUfwuOUuUE12YIwifUPajfP9SytYa2U/d1ss8NSELpQOrGK3YdJVzJJeKRrxHvvtH3nQSWyRaekQ2wrpjKf9QahfSjsAm56UZuEilmLWx7NkcaMU+X4a8ElQZ9k1CSy7WAtsEMJxzVqwzIkk1fQ5C4E3cb6TKBCWViDd12vDUsxihp+NpGJCsvtHWnZkcQ0rJU54jLsuxvZHtejnmlqDgQ8RoCex3+YxfkoUyQDsDVZg23+oyi33VTIcq1bX56vo6l1PLfduMEBLqQOG0l3+Bjm57lyz8w0zeRgxAr1jifB04qG+sW/YPhIGyp6os5eou5TJ6YIg2St7litLVZedrS/suROfydqvzS46fj/zMA0TDm8BVrRtXkrAjK7dVyFGR204qCPWAubgkC2VmTVA+osEP/1n+fWjMF+mEFuBOARjVVr6V2SpUN29+RIN9ShkZMgYtmqJwzkgbqptX+v9BBhZQGRMAxTCKknrU3vk0aOP2IcCyV0wLGNb1JRu8nRebBDXBboDfkbzwvedJGEWy8fQrYDQlkndE2lHQ+3xnmC9zCOQ9weUEImMqY6RtGfcnK7ccKY7qpcrDgyUY72/ALWw
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY4PR01MB13777.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd5373f-af55-4195-edb2-08dd99be5e32
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2025 05:55:05.9257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9abhIgjZVwRH25syesTZ3j0LeDuzflT5oTiI1iCr4pcaUJ3TOCCN8ZPfS6/jJOgFsjvBh3tq73aW/Up7QY5ICizTC03zZbD72s03L3bHc0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9311

SGkgRHlsYW4sDQoNCj4gTGF0ZSByZWxvY2F0aW9ucyAoYWZ0ZXIgdGhlIG1vZHVsZSBpcyBpbml0
aWFsbHkgbG9hZGVkKSBhcmUgbmVlZGVkIHdoZW4NCj4gbGl2ZXBhdGNoZXMgY2hhbmdlIG1vZHVs
ZSBjb2RlLiBUaGlzIGlzIHN1cHBvcnRlZCBieSB4ODYsIHBwYywgYW5kIHMzOTAuDQo+IFRoaXMg
c2VyaWVzIGJvcnJvd3MgdGhlIHg4NiBtZXRob2RvbG9neSB0byByZWFjaCB0aGUgc2FtZSBsZXZl
bCBvZiBzdXBwb3J0IG9uDQo+IGFybTY0LCBhbmQgbW92ZXMgdGhlIHRleHQtcG9rZSBsb2NraW5n
IGludG8gdGhlIGNvcmUgbGl2ZXBhdGNoIGNvZGUgdG8gcmVkdWNlDQo+IHJlZHVuZGFuY3kuDQo+
IA0KPiBEeWxhbiBIYXRjaCAoMik6DQo+ICAgbGl2ZXBhdGNoLCB4ODYvbW9kdWxlOiBHZW5lcmFs
aXplIGxhdGUgbW9kdWxlIHJlbG9jYXRpb24gbG9ja2luZy4NCj4gICBhcm02NC9tb2R1bGU6IFVz
ZSB0ZXh0LXBva2UgQVBJIGZvciBsYXRlIHJlbG9jYXRpb25zLg0KPiANCj4gIGFyY2gvYXJtNjQv
a2VybmVsL21vZHVsZS5jIHwgMTEzDQo+ICsrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0NCj4gIGFyY2gveDg2L2tlcm5lbC9tb2R1bGUuYyAgIHwgICA4ICstLQ0KPiAga2VybmVs
L2xpdmVwYXRjaC9jb3JlLmMgICAgfCAgMTggKysrKy0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDg0
IGluc2VydGlvbnMoKyksIDU1IGRlbGV0aW9ucygtKQ0KPiANCj4gLS0NCj4gMi40OS4wLjExNTEu
Z2ExMjg0MTFjNzYtZ29vZw0KDQpUaGFua3MgZm9yIHBvc3RpbmcgdGhlIG5ldyBwYXRjaC4NCg0K
SSByYW4ga3BhdGNoJ3MgaW50ZWdyYXRpb24gdGVzdHMgYW5kIG5vIGlzc3VlcyB3ZXJlIGRldGVj
dGVkLg0KDQpUaGUgbGl2ZXBhdGNoIHBhdGNoZXMgWzFdWzJdIChNYW51YWxseSBhZGp1c3Rpbmcg
YXJjaC9hcm02NC9LY29uZmlnKSBoYXZlIGJlZW4gYXBwbGllZCB0byB0aGUga2VybmVsICg2LjE1
LXJjNykuDQpUaGUga3BhdGNoIHVzZXMgdGhlIHNhbWUgb25lIGFzIHRoZSBwcmV2aW91cyB0ZXN0
IFszXVs0XS4NCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI1MDUyMTExMTAw
MC4yMjM3NDcwLTEtbWFyay5ydXRsYW5kQGFybS5jb20vDQpbMl0gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvYWxsLzIwMjUwMzIwMTcxNTU5LjM0MjMyMjQtMy1zb25nQGtlcm5lbC5vcmcvDQpbM10g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1RZNFBSMDFNQjEzNzc3MzlGMUNDMDg1NDlBNjE5
Qzg2MzVEN0JBMkBUWTRQUjAxTUIxMzc3Ny5qcG5wcmQwMS5wcm9kLm91dGxvb2suY29tLw0KWzRd
IGh0dHBzOi8vZ2l0aHViLmNvbS9keW51cC9rcGF0Y2gvcHVsbC8xNDM5DQoNClRlc3RlZC1ieTog
VG9zaGl5dWtpIFNhdG8gPGZqNjYxMWllQGFhLmpwLmZ1aml0c3UuY29tPg0KDQpSZWdhcmRzLA0K
VG9zaGl5dWtpIFNhdG8NCg0K

