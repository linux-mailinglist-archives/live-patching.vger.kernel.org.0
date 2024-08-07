Return-Path: <live-patching+bounces-448-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D45949CB9
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 02:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8BECB20E35
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 00:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023348C06;
	Wed,  7 Aug 2024 00:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="KtX8xCc8"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149DB4A06;
	Wed,  7 Aug 2024 00:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722989968; cv=fail; b=ZTLTty9x5ze79qq+QpO9vHb6uEsu6cpyVu6MbK5OW9OqDd/rAhe20ZyBDMGCZdg2Orq5IW3GNpF4xUKkshti2PWTd/DMLcH+oNQMMary/g9gjnd4GqXtJUYvSNOfOLYXzpmNP37uPjEEbk6MZX6Y6zUF5vZ7s3E2wKgeVqzZRpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722989968; c=relaxed/simple;
	bh=ySg82LXvKgKLgo7H60rgB6MB2iwMPmGJd0XA9UoMqyc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lyOhlVm8KhRrPYwciIC6tASuIZz5QxIVwzCyW8jog8bSkfgU7B7+tUxBpMZ6Bkxgs4UDrcKFn35ahbBjBBI7a7P3ScXaUYamO2WVIU7YzVmVN5gnBXJiTEHYB6G0Nt7eYZo/F356FwWVSAmp9mwRvRceG28bZanC/D/X+yUO5ZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=KtX8xCc8; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 476Leqg7025708;
	Tue, 6 Aug 2024 17:19:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=ySg82LXvKgKLgo7H60rgB6MB2iwMPmGJd0XA9UoMqyc
	=; b=KtX8xCc8z/O+tdl9hE4Oc9PG+EeiRuuGMTDT518V+ISmkkFS5swdHYXyKnA
	05hSRpO7vTTPtPIm1YZoWWqF6LOG5yC5z1c7zq1PHw/aKocA+9+1+dpsO9Dh1zGU
	H2aXu/i5HeUIff7sQF1jnBSO2hz/hbuDQgjUjQWXz83qdla+PoWE0WdQlp/O7AIj
	trpczLnKyE8lqDaffJ+9Rjai3Fl4JaoCG/9uoqeAwh2gx20ECUCjE7iYPSjX9uOu
	Cs+ddMb6UJHockX7x75HKe1cvpK9U1rMwGK4ASN9Wouz0ieNkqpCGXoxdgC6LW/T
	qfOkHR8CNzTjwgdWmxKoKeAHSVQ==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by m0001303.ppops.net (PPS) with ESMTPS id 40usns9r15-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 17:19:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P4cDbSAcnRUneUv9hEF6O3gQCUcKCs9riPkdhz4WsTq/7x5yXDnjkp2arvTZYkqoL+VB3rJob+2pZ44PPGlyxIHYkHxwY57DiJZCxYx80HVP9jFEiE4wBwJOcj4k8g2bX3XNt78cmeI/+5+l24m8sQ/57Mlx1SwuWM7Wj0/cwQXKJRBFdgkadLNRLpQbVuA9EiSeohI3yHYuTvg0L9/Z/ILSHrVK6et4kPfWqjBYP2K3VZFfcahheEAB1xuHIaZ1tv3LccOBAnMN07q0dwwddg37c13nZamNzBiE4FGO2TSZcPJEdmlEyP32vuIOwqWw/WssMC3rjiPvWJ1Hn+WI1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySg82LXvKgKLgo7H60rgB6MB2iwMPmGJd0XA9UoMqyc=;
 b=TxyKn17jaeq5ZJXGYuV7JVyPTdKIKvfGUA31QoXNIXZpM52/3oLSaYTYA+Ggv9mYX6j0iKN777CZ1i04Iy+y2Pbdbpl+iWb68NmUU9Aq6q+DaNrphA4w2a3xQ2twi793T4sv0uDVNcQ3JXurBvgyAZo/mj+oVypeOt6H68pdANOCrjum6lZW0zdkq4mSjNaHv1G4ekdAowqNwUDVkIZ8g0aMPmKmMscEL6qENXeKqN/jf7tNrE9cu6dIJh2W1PZGikwvMzz1FSP1Bm9kLbQpHbB4k0dGTmvK5LoFIq36NLRf1FHLt9UNKeNPHEYjlVsUNVzWHsyR2uQzkawfPTj7+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA6PR15MB6593.namprd15.prod.outlook.com (2603:10b6:806:40d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.24; Wed, 7 Aug
 2024 00:19:20 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 00:19:20 +0000
From: Song Liu <songliubraving@meta.com>
To: Masami Hiramatsu <mhiramat@kernel.org>
CC: Song Liu <songliubraving@meta.com>, Steven Rostedt <rostedt@goodmis.org>,
        Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence
	<joe.lawrence@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leizhen <thunder.leizhen@huawei.com>,
        "kees@kernel.org" <kees@kernel.org>,
        Kernel Team <kernel-team@meta.com>,
        Matthew Maurer <mmaurer@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Topic: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Index:
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAAD/9AIAABNyA
Date: Wed, 7 Aug 2024 00:19:20 +0000
Message-ID: <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
In-Reply-To: <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA6PR15MB6593:EE_
x-ms-office365-filtering-correlation-id: 28fe58e0-02cc-48ba-21d5-08dcb6769504
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?U1lxWVl5SU5LbzQwZlpEb3oxZzNpalFUQjB2bzFYcFhMVEpwZUFvY2RtVWNh?=
 =?utf-8?B?YWU4NjNuaG8wcHl5OEpjRDdjVTZ5Y0J0RFFWd1VEeGZYMlF4eHY4d2NBQWR0?=
 =?utf-8?B?Ni9qWnllK1pBb2x3Ym5FaVhMK1BkTk43SjZrQkVqclhOdXRidDdvWjd2RzhL?=
 =?utf-8?B?MWdZdlBlVDgxU2Z4b1dkQU1JUFVsNUhnZHlDaVF0RGxtOW9nT0toSHhjak1V?=
 =?utf-8?B?SnZiMGdja3QyQW5RWTV2Y2dZVDhmYjBSVGk0T2pGWlhoTldWWGJqSktLY2Ro?=
 =?utf-8?B?ZFBmWGtnSDBUZmRWZ1FGVGJock9FYzFzQWlHNGVVTlVtUG5DZ2hXdUltNUdp?=
 =?utf-8?B?blBzamo3Ujh2REVhS3d4M2lVaGlHNVNpZGpLSndZZGJWbEl4VDBtVEZLTi9m?=
 =?utf-8?B?c3dyUDR0Q1Q5eTVlV082RG5ab25ZQXhicUFGK2ZSWStPTzBVOUNMbkZuVFM1?=
 =?utf-8?B?UzRTVm44UjF2WnE0RERsR2JjTUlPQkJMQ0V0SVVsTTdOWFRtRFAxVXBGM0F4?=
 =?utf-8?B?b3hxRjFxNnArQXBweTRFRGkrUEFBcVI2anMwVzIzcmJTNURZdGlabW5mZG4z?=
 =?utf-8?B?eFVtU054U0k3Ym1aN3llTi9reWkxV3pFWEE2TjAvZ1kvL2pXbXhneHQ0cWZ3?=
 =?utf-8?B?UzRGcHlQTHRaUUdqWjUra3RQVGVTK3YvWGJNOHlwaC9RVjYvWU1TTEJjSzVZ?=
 =?utf-8?B?UW95Yjc4SDVUQzhnZjRaT1FCLzFzTmdpKzliRExCWDlvV0F5RDdNSzA2bXpx?=
 =?utf-8?B?NXg4QTltM20yaE5JLzU0dU1lakd6a044RVNpQTMxNFM0Vlpob0dCTkFlaHZS?=
 =?utf-8?B?L0gzaTI3QXQvdnByNGNGU3JURG5vYVA1R0lWRUE1VGVka25temtVdTV3bmRI?=
 =?utf-8?B?Tndrc1RKUEdFa0JlckdCaFZzcGFTVGJyOWNqSE41a1lGMTlCOUxnSFZQTktN?=
 =?utf-8?B?SHliS1FKL1RGaVgwU1hLc1ZBVEV2eWpkaWJqUzN5TDRsTDEzTStTT1liWWVs?=
 =?utf-8?B?eTBHWGV0Zk9RZXpCczM5b3JwSTBCVDBmTjlDSkdOUmtmMDFPd1JHSFVDMFhY?=
 =?utf-8?B?OWVMMFViVXc1TjZQaGJYSnlwc3h1VW41QW5YNVhxVmprR2xnb3FmcWdKRDFr?=
 =?utf-8?B?VXJCWlZFcitqRHRtbW5mVFFrMFpKNnR3YW13eDFxNmNxSEszbGVOR0RDeHMv?=
 =?utf-8?B?YkFyZ1hhZWEvekd5bjhFZUhIbEpCaGxPcFNSZEw5TFlMdHMzRmJtY29KQUNq?=
 =?utf-8?B?S3VpRVJDUFRqNEVGbXVSZlYvQXF1SWJ5MHVwSEZpNiszWlo2eWtNcllVeTVF?=
 =?utf-8?B?T2ozTjJrKzA2Ym9XTDBNVW9JeEFNN3YxYW91aXpJKzFZa2lUaDJIa1F4RDhk?=
 =?utf-8?B?aDA0djRVQjlvSko1d01WN01tb0VZbUM5OEIwSHJZZm5xdTZuaGpaNXE3Y0R1?=
 =?utf-8?B?MlJ2TWZkRUdLRjVtMTNkVWNiYzlLTkd4SnRSd3VOYkdwR2lSM3daYmQ3N0dw?=
 =?utf-8?B?Y05UNm5TZHlDNHlubXhtSDBFQkF3UjA1QzRncHk3QjA2YVgvQW9aUlNPUHcz?=
 =?utf-8?B?V3REMGdsN3dIZi93WmNYOEI4Y04zcGNxQlprTTJLbTUvNERmQWZIS2ZxaEtn?=
 =?utf-8?B?ZUJkNnlTRGg5bWNKdTR1MUszOWViSjRZRFRNM21TMHI1ZHloZFRxRHdxMDBR?=
 =?utf-8?B?Y3V4RE8xYzlNSHdMdFhBekV0N2VhTXMvK3ozUTg1L3BYSk43Zmt5KzhiSUtz?=
 =?utf-8?B?bjVLQi81ZXI1N1QvY0VrcnBrYXdYNHBWdFRQMVovQ3BMQzVIclRhUVpUbEhC?=
 =?utf-8?Q?mMoWYNWGeKkonlDTPIsJBMc2QEKOOw8t7yAZo=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WmRGSE1uNHAwS1BDRkVRbkFNcUhWQUp5L2FuRVppeHBsS0p0cFcrTGk4U1ZZ?=
 =?utf-8?B?V0ZWc2ZZVmNIU2dnNkJOVS9sVmNLZTJoVjFQOVovc3JIVlVXS3BQV1NtcUpk?=
 =?utf-8?B?MU1wbUpqR3VQVktqUTcxR0Q0dm5tOVNTaTFLWm5zZW5wc0o1dU1SQWhoZUFv?=
 =?utf-8?B?cThqZTZ2b053bkpLNENvUHZKN1dEWnBTNElyV1NFU3ZkYlIzeXJDbnpDelJp?=
 =?utf-8?B?Z3dja0FKd082ckV6ZkFrS0RYNmxORFE3aTd1UytVWDdDbU54bEE4dlBxOHlH?=
 =?utf-8?B?dklMeU5TdkxuV0pPK0l4bmtSc0M1Z0pKV3FKcHROUmtTYXFzbExINHR0aTAv?=
 =?utf-8?B?VVFHODdEalNkQ3BpNWZ5MU5sb094NnQ3Wm9jNmhXWlgvOUNxSUpuUGlWSW5o?=
 =?utf-8?B?YzU1enFWdVNicWVXWGtDRFV6MnF6dEhVMEprcHIvbWZrSmNCVjVRWTR4Tzhv?=
 =?utf-8?B?dDFDUmdaWld6MUlndEQwN3ZDZjhoOU1pZzJReC81akwyczRnV1I3WGFJb1Z6?=
 =?utf-8?B?bzFyU0Frb29vcWJFOWpWUjl1S05EaEV0Qk43WG5oOHpCNnVsMlM3dWQ5MHZS?=
 =?utf-8?B?WGtRZllic3o2Z0htRGpnM2NhclhaOGZoMGdhVjZTVE1scC83SldzRzQrbklm?=
 =?utf-8?B?U293QlFiSnJSNEFRK3VDT3A1VTdRaDJPZE9Tb2tGMjJvcWRtblQ0TmVxTTh3?=
 =?utf-8?B?dUdkVFJNMkV6RDdVQXhuZmRuYVpaRlZ4UnNVRTRoMHd0SWQ3Y1ZLTHFJb3By?=
 =?utf-8?B?Y3BMVHg3RmIzb2dyT3lqZkljQjhLek9BZFVaSVdZMWlJZjcrS2NoQVpNNjZ1?=
 =?utf-8?B?ekFFNDVhdVo4M1lWN3hGRXBndlpsMTNEcys5S2ZYTk1HZFZpRWthQWxPd0dB?=
 =?utf-8?B?WStlaG5UYXZRNDRqNEdNaTk0cUxmZ1dyVW52eHVsbnd5OE81M205R2w0KzAr?=
 =?utf-8?B?b3NCUm5MOEhWeGhFb05VVkdEQkNJMmtmczgyY3BYYmRjNDI5L0F5ZnA3R081?=
 =?utf-8?B?cEhKZGlwdnFxTUZmSzlxVlcyV3FmZThVYzRwN0xmS0NGbDdZWGgrbDFXdUE1?=
 =?utf-8?B?M2hBR0hlQkVRY2lvM1RoNWk5TFBFRTNzekpKdXhNRXVJOGxIdjZkb2tIUStT?=
 =?utf-8?B?Q0M5Q3dpd3pCUEMzZE1oTDAvWE1CZHJyLy9qQ2hZcFdUV0hyU3RHS2ZuUnVV?=
 =?utf-8?B?aFM5VTIwcm95L0Q2VXFjdnZDUnFROFo3ZzdWc3VaZEFjYytaUHVMSTZuRWtl?=
 =?utf-8?B?bElESUxTUlRWY1RucHF2dTBMMjJROHB6MTNMdldLL1dmMjE3NnRYeGlUdlZl?=
 =?utf-8?B?WDd2R21nTGxnYkVyUjdFaHY5RElRcjBQR2l4K0NSVXpldEFHdHdjOG1jTmgv?=
 =?utf-8?B?a1Z6eEhTbDBRR0VIN3hWTlFzdVIrQzFJaVR1aXJXd0tFZENZR2M4R255TlFy?=
 =?utf-8?B?UjhZNGtkSkQ4ZkRVMUhmazdIbkt6L3pSc1k2R3pKMUpPSmpkVHdLVyt2bGk1?=
 =?utf-8?B?dkdWU3FiWnBUandQZzJBbTZidHVKRTJuUitNWUdhMnE3blF1T3ZLSlhDMmx5?=
 =?utf-8?B?dTZkQ1JEMUVOcWpjQk5wRC9yb20ySUhTVGI0U2xrMVc2ZE4zNmpuMTBqY0U3?=
 =?utf-8?B?aThsMkFoYldoOENIbkJzbXZFbmd5YjFOTlorc3YxaUZ5TVF6cU5pT3lCTDBw?=
 =?utf-8?B?ektSNHg4MUFmWkx2T3BpZmVlWkF0Ky9ETEt1QnBvVkhiQ0VwWEdySDFVV2JK?=
 =?utf-8?B?VFpLaXpGaWt3WDZrcjdqd09TUjRCMkowU3oycXgyRnpIQzUxT01vNlB0S0lD?=
 =?utf-8?B?eTAwaytNTCtpZ01lMVR2NVNhdWNWUHowaTdmQjhXL2hsM0RQSTZrbzd4bFQ2?=
 =?utf-8?B?Ukd6ZGFkdmVrWkx4R0F3cmFQVDBta0lJSFRVYlRLSDZZa3AvcGxyVmJuRTBB?=
 =?utf-8?B?WmFuYWE3NDlBV2JaeFI5MzRDa3VFdGEzZXFhLzhpVmNPRGR3Y1NUamYza0RR?=
 =?utf-8?B?UUczdThNL1M5dTFHd2J4Q0RmL2V0Y3FsWlJiUk44Y3h1RHQrZHBjME9oZ3Zo?=
 =?utf-8?B?V2tOSzZQTUFWcW5jZGRpZTROb01MNU0zZDRVS1grYzlkVW5KckVrMm5aa2dp?=
 =?utf-8?B?MEZ1Vnp3UW5vUFFUVmlhTXV1UnpYL29hUWVBVzM1aWt2elZuUFZGY1R5MThs?=
 =?utf-8?B?MHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8B4ABA451B1F4478A28DDF778E8E745@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28fe58e0-02cc-48ba-21d5-08dcb6769504
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 00:19:20.1700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BRrXXUByFBPOrglto0GGuciku5d+OwLqjBl3z9V86wpQCvA18WxVv4RJeXKq1YfvO4TJ25GNKeDuRSxCwbPHpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR15MB6593
X-Proofpoint-ORIG-GUID: -ASID9Xjw8Msro3O7xM59n9IKaaGVwbG
X-Proofpoint-GUID: -ASID9Xjw8Msro3O7xM59n9IKaaGVwbG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_19,2024-08-06_01,2024-05-17_01

DQoNCj4gT24gQXVnIDYsIDIwMjQsIGF0IDU6MDHigK9QTSwgTWFzYW1pIEhpcmFtYXRzdSA8bWhp
cmFtYXRAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIDYgQXVnIDIwMjQgMjA6MTI6
NTUgKzAwMDANCj4gU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQG1ldGEuY29tPiB3cm90ZToNCj4g
DQo+PiANCj4+IA0KPj4+IE9uIEF1ZyA2LCAyMDI0LCBhdCAxOjAx4oCvUE0sIFN0ZXZlbiBSb3N0
ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPiB3cm90ZToNCj4+PiANCj4+PiBPbiBUdWUsIDYgQXVn
IDIwMjQgMTY6MDA6NDkgLTA0MDANCj4+PiBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBnb29kbWlz
Lm9yZz4gd3JvdGU6DQo+Pj4gDQo+Pj4+Pj4+ICsgaWYgKElTX0VOQUJMRUQoQ09ORklHX0xUT19D
TEFORykgJiYgIWFkZHIpDQo+Pj4+Pj4+ICsgYWRkciA9IGthbGxzeW1zX2xvb2t1cF9uYW1lX3dp
dGhvdXRfc3VmZml4KHRyYWNlX2twcm9iZV9zeW1ib2wodGspKTsNCj4+Pj4+Pj4gKyAgICANCj4+
Pj4+PiANCj4+Pj4+PiBTbyB5b3UgZG8gdGhlIGxvb2t1cCB0d2ljZSBpZiB0aGlzIGlzIGVuYWJs
ZWQ/DQo+Pj4+Pj4gDQo+Pj4+Pj4gV2h5IG5vdCBqdXN0IHVzZSAia2FsbHN5bXNfbG9va3VwX25h
bWVfd2l0aG91dF9zdWZmaXgoKSIgdGhlIGVudGlyZSB0aW1lLA0KPj4+Pj4+IGFuZCBpdCBzaG91
bGQgd29yayBqdXN0IHRoZSBzYW1lIGFzICJrYWxsc3ltc19sb29rdXBfbmFtZSgpIiBpZiBpdCdz
IG5vdA0KPj4+Pj4+IG5lZWRlZD8gICAgDQo+Pj4+PiANCj4+Pj4+IFdlIHN0aWxsIHdhbnQgdG8g
Z2l2ZSBwcmlvcml0eSB0byBmdWxsIG1hdGNoLiBGb3IgZXhhbXBsZSwgd2UgaGF2ZToNCj4+Pj4+
IA0KPj4+Pj4gW3Jvb3RAfl0jIGdyZXAgY19uZXh0IC9wcm9jL2thbGxzeW1zDQo+Pj4+PiBmZmZm
ZmZmZjgxNDE5ZGMwIHQgY19uZXh0Lmxsdm0uNzU2Nzg4ODQxMTczMTMxMzM0Mw0KPj4+Pj4gZmZm
ZmZmZmY4MTY4MDYwMCB0IGNfbmV4dA0KPj4+Pj4gZmZmZmZmZmY4MTg1NDM4MCB0IGNfbmV4dC5s
bHZtLjE0MzM3ODQ0ODAzNzUyMTM5NDYxDQo+Pj4+PiANCj4+Pj4+IElmIHRoZSBnb2FsIGlzIHRv
IGV4cGxpY2l0bHkgdHJhY2UgY19uZXh0Lmxsdm0uNzU2Nzg4ODQxMTczMTMxMzM0MywgdGhlDQo+
Pj4+PiB1c2VyIGNhbiBwcm92aWRlIHRoZSBmdWxsIG5hbWUuIElmIHdlIGFsd2F5cyBtYXRjaCBf
d2l0aG91dF9zdWZmaXgsIGFsbA0KPj4+Pj4gb2YgdGhlIDMgd2lsbCBtYXRjaCB0byB0aGUgZmly
c3Qgb25lLiANCj4+Pj4+IA0KPj4+Pj4gRG9lcyB0aGlzIG1ha2Ugc2Vuc2U/ICANCj4+Pj4gDQo+
Pj4+IFllcy4gU29ycnksIEkgbWlzc2VkIHRoZSAiJiYgIWFkZHIpIiBhZnRlciB0aGUgIklTX0VO
QUJMRUQoKSIsIHdoaWNoIGxvb2tlZA0KPj4+PiBsaWtlIHlvdSBkaWQgdGhlIGNvbW1hbmQgdHdp
Y2UuDQo+Pj4gDQo+Pj4gQnV0IHRoYXQgc2FpZCwgZG9lcyB0aGlzIG9ubHkgaGF2ZSB0byBiZSBm
b3IgbGx2bT8gT3Igc2hvdWxkIHdlIGRvIHRoaXMgZm9yDQo+Pj4gZXZlbiBnY2M/IEFzIEkgYmVs
aWV2ZSBnY2MgY2FuIGdpdmUgc3RyYW5nZSBzeW1ib2xzIHRvby4NCj4+IA0KPj4gSSB0aGluayBt
b3N0IG9mIHRoZSBpc3N1ZSBjb21lcyB3aXRoIExUTywgYXMgTFRPIHByb21vdGVzIGxvY2FsIHN0
YXRpYw0KPj4gZnVuY3Rpb25zIHRvIGdsb2JhbCBmdW5jdGlvbnMuIElJVUMsIHdlIGRvbid0IGhh
dmUgR0NDIGJ1aWx0LCBMVE8gZW5hYmxlZA0KPj4ga2VybmVsIHlldC4NCj4+IA0KPj4gSW4gbXkg
R0NDIGJ1aWx0LCB3ZSBoYXZlIHN1ZmZpeGVzIGxpa2UgIi5jb25zdHByb3AuMCIsICIucGFydC4w
IiwgIi5pc3JhLjAiLCANCj4+IGFuZCAiLmlzcmEuMC5jb2xkIi4gV2UgZGlkbid0IGRvIGFueXRo
aW5nIGFib3V0IHRoZXNlIGJlZm9yZSB0aGlzIHNldC4gU28gSSANCj4+IHRoaW5rIHdlIGFyZSBP
SyBub3QgaGFuZGxpbmcgdGhlbSBub3cuIFdlIHN1cmUgY2FuIGVuYWJsZSBpdCBmb3IgR0NDIGJ1
aWx0DQo+PiBrZXJuZWwgaW4gdGhlIGZ1dHVyZS4NCj4gDQo+IEhtbSwgSSB0aGluayBpdCBzaG91
bGQgYmUgaGFuZGxlZCBhcyBpdCBpcy4gVGhpcyBtZWFucyBpdCBzaG91bGQgZG8gYXMNCj4gbGl2
ZXBhdGNoIGRvZXMuIFNpbmNlIEkgZXhwZWN0ZWQgdXNlciB3aWxsIGNoZWNrIGthbGxzeW1zIGlm
IGdldHMgZXJyb3IsDQo+IHdlIHNob3VsZCBrZWVwIHRoaXMgYXMgaXQgaXMuIChpZiBhIHN5bWJv
bCBoYXMgc3VmZml4LCBpdCBzaG91bGQgYWNjZXB0DQo+IHN5bWJvbCB3aXRoIHN1ZmZpeCwgb3Ig
dXNlciB3aWxsIGdldCBjb25mdXNlZCBiZWNhdXNlIHRoZXkgY2FuIG5vdCBmaW5kDQo+IHdoaWNo
IHN5bWJvbCBpcyBrcHJvYmVkLikNCj4gDQo+IFNvcnJ5IGFib3V0IHRoZSBjb25jbHVzaW9uIChz
byBJIE5BSyB0aGlzKSwgYnV0IHRoaXMgaXMgYSBnb29kIGRpc2N1c3Npb24uIA0KDQpEbyB5b3Ug
bWVhbiB3ZSBkbyBub3Qgd2FudCBwYXRjaCAzLzMsIGJ1dCB3b3VsZCBsaWtlIHRvIGtlZXAgMS8z
IGFuZCBwYXJ0IA0Kb2YgMi8zIChyZW1vdmUgdGhlIF93aXRob3V0X3N1ZmZpeCBBUElzKT8gSWYg
dGhpcyBpcyB0aGUgY2FzZSwgd2UgYXJlIA0KdW5kb2luZyB0aGUgY2hhbmdlIGJ5IFNhbWkgaW4g
WzFdLCBhbmQgdGh1cyBtYXkgYnJlYWsgc29tZSB0cmFjaW5nIHRvb2xzLiANCg0KU2FtaSwgY291
bGQgeW91IHBsZWFzZSBzaGFyZSB5b3VyIHRob3VnaHRzIG9uIHRoaXM/IA0KDQpJZiB0aGlzIHdv
cmtzLCBJIHdpbGwgc2VuZCBuZXh0IHZlcnNpb24gd2l0aCAxLzMgYW5kIHBhcnQgb2YgMi8zLiAN
Cg0KVGhhbmtzLA0KU29uZw0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjEw
NDA4MTgyODQzLjE3NTQzODUtOC1zYW1pdG9sdmFuZW5AZ29vZ2xlLmNvbS8NCg0K

