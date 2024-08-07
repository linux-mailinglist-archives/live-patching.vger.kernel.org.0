Return-Path: <live-patching+bounces-452-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F83194B088
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 21:41:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A291B1C20F0C
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 19:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145F814431B;
	Wed,  7 Aug 2024 19:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="nek/XAy1"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0CC13DDC0;
	Wed,  7 Aug 2024 19:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059699; cv=fail; b=Fg35REUQfHtSwuGayO2ZPLsboa44LIP2wOz7Qq15E0YTIKAseR0D7vLrK2IgO8+ErZIoK6DKdKpOJI+Tp6XsiOU4Cf6BqTFfcaUdMZ13tANsACaU76xA9s0BFfUTi/134nL7xt0R5p3o5lsp0jfOLP5m/E+S86fxkkn5U9NsTXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059699; c=relaxed/simple;
	bh=AA90oSEt5UJ4GxQoWnZlUTbhxYOAERPPj4+whWP95uw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mEnWdUOHEGPRXyEDdjPRfJpV3vmooQjBXC2mDA6+5U3est/D4ZK7o6OK8uQ8f+uQpGtfeOTNQqrhpZS0NESBcC3iD24bFtNN3vtyvlCmJQloGr+vOb0nQREycSr5XuEorpOOChn5q0jqSzuxg0lkz+EHImSE4TWtwIHyHx+cWkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=nek/XAy1; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 477JKHVe031885;
	Wed, 7 Aug 2024 12:41:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=AA90oSEt5UJ4GxQoWnZlUTbhxYOAERPPj4+whWP95uw
	=; b=nek/XAy1PHIVOH2CzrK5mCPQxHYrvAUvbQ/MRQcSaw3CqMUHzqWYXFDCLJe
	9cKki5g9igsuITPibnZaRGaem2Ch1JUiKukS4h27mizJykaKLUO1uVy9GNkPre8c
	KSTfYEhLaMfZNuTBM+YL1QqxcRZvAvpYpKXvAR81tz8FN/uHqxQpeLyOtrQtIDvW
	ZndTP0aB8eLp48AqDrkJI/UKcgQtMTrWs8ZM1jLiZuOVIbX5efcItAcN0gMVHvF5
	5kAowwXE8XPZfFfmQzkCc5ZHyJt/Rr+SwVMj8nAZdmuJWoxud9A6Jk9pYd/i4ME3
	mH7+7tTK/ALmNeTqe38apiVS9VA==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40vb94226s-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Aug 2024 12:41:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qfqFGchGQWOOlcberjYOBHgAFePPA1jS5521LyHC0wT78OQBFGpx0G6m753x/g2Y0RdxCW3RuGOiKr0HrF+WHFJa1Ltqa213oQx3HV9O2bAgKb1QBRck3gxOqrFKs7pUpei6E4S+ldnICkN5Vznj7phUSWTa3ZulK49RuQ/lKXWrZ6TtkckxCqfrcEB5nKLwwOTwsmLizcVajo7BBuJtqWm87toPWEMPmEAo+Xyfhssy3ABEdnuqhsakzUnCnDz+CxtqdiIuPds2ImvM3KbGb6q9N6rBhwDDkEso7DS4yCqTngfb/YTsHO1O6l+aPINkAklNrhKmdWwIDNc6dltcww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AA90oSEt5UJ4GxQoWnZlUTbhxYOAERPPj4+whWP95uw=;
 b=zL/5p+QcjiHLm3Qk5LJtUSXCswtF8+jad75BUYBgsDyqsqi82Ys4XmHs0oDpPxIm77fTjJ682fRvFxVRowX2YjdCz9TEel77l+TU8jSkJ8hSjtrcSqqdcydJpzawrSVeh28nRj3+HfdXEw4Y9SNTHrbIc9N9uTB8S88O7TuSFAc9sHsONQQeLA91U6d9wWFa7xd4N6RilTaGBi9wgB3Ewinek1aCrhzSUOE12FiNIZeFUur+G+T2D2tlbOmXRLXsMCLTVXa1mCustLCji2FFZDxZm8Bh8ebgFE7b7NOiiKMt5FIXikA/exf0BjWdoyFJ2xozAYgvzzmg+uwp8mMjXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SJ0PR15MB4422.namprd15.prod.outlook.com (2603:10b6:a03:373::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Wed, 7 Aug
 2024 19:41:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 19:41:11 +0000
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
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAAD/9AIAABNyAgACkkICAAKAOAA==
Date: Wed, 7 Aug 2024 19:41:11 +0000
Message-ID: <2622EED3-19EF-4F3B-8681-B4EB19370436@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
 <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
 <20240807190809.cd316e7f813400a209aae72a@kernel.org>
In-Reply-To: <20240807190809.cd316e7f813400a209aae72a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SJ0PR15MB4422:EE_
x-ms-office365-filtering-correlation-id: 068da958-c24b-4016-ae06-08dcb718e411
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?enFNb1QrSlRrY1lSYU9mZ1VqUGZkY0ZudkN1cE5tMENzR1lMOVFPQ0c0RmJj?=
 =?utf-8?B?VjdpaXcrVFp3U0xBdGlWRGNqUm56Ym1tYlBMU2RRajZrU3BQU1BpeXV6V2dm?=
 =?utf-8?B?VVBjRnpKUGVUd29oMXlRYXk4MEVCSTAveVJIa1ErYXdFVWpSWDR4VHpOOTla?=
 =?utf-8?B?Y1p1amdwR25mYXN5dzduY2RaVXpQWEFZcU8vbW1TM1pqaTU0VEtZRzlObER2?=
 =?utf-8?B?cnZFbkhFMndseWVKS2dhTnhyRUpNai9MUWdWWjBwK2g0SlNHQmswcWVnVXZm?=
 =?utf-8?B?Ly8zbDJjdExtV3dwaWdMNGhWMHJwN01WY2llT0tBaWRUZlpUcm1NT1ZNdUNl?=
 =?utf-8?B?ZlE3RERxMUE3N21UQURXYk1aMWlHQ0NxR3grNnh4Mm5aMFNUY0kwdHRkWGVJ?=
 =?utf-8?B?cW8xZzdBeWFOU29QNkQ3bEFUN0IrbHhTU3pzWEg0dDY5RU9SVDZYSjVVMlcx?=
 =?utf-8?B?UDdWM2xJZ2FEUWNZOWJDdU9ESlZqQStvVzZUWXV4S0VRV28zVmZJSW1zS2h4?=
 =?utf-8?B?a3FFL0xKTld2RFhERzAxb1YrZi92WjV3YUNtU2gwUVB3eGUrQlM2YWFMNlRY?=
 =?utf-8?B?dU5nRi9HekJySTFHSUNETk02bERZTHd3ODkwWHE1T0tKb203b0l6ek1Oejd3?=
 =?utf-8?B?VTZxOXh0U2Q2K2JCS2p2c21vREFncTBoeTlXVFR4VDlhbGlRTDVSQVVMWGRB?=
 =?utf-8?B?bzhpY2hYaGZLSVRZVDgwaHcwb2tGMWp0L3l6bFZsbER5UnJVMkR0RC9uUklv?=
 =?utf-8?B?amFQaFQ5dW9FNzZkOG5YQ01CcUlsNkVqL1FPMHlubjcwMVdFUlJEUFhJalM1?=
 =?utf-8?B?c2dIeEJFL1MyRmRiYnN5RFgvQmg5MFRKNUpMbGNkVHVKWkxMdERncjBCY3dZ?=
 =?utf-8?B?ellnMjNhc09qdlBWQkt5TWg5c0VWV3NuckFPT3VUajBBREM3d0R2eDdlUWs0?=
 =?utf-8?B?ZXNjdTNGK0NnZ3V2NVM5alJ5VEc4ZTErejVXY1hsL2xTRVp5SEtSODZ6WVkv?=
 =?utf-8?B?ellBdDJTTjVQbTFiZUYvTVEva2Q1TUZsd1djYmdyT3h5Sy9QczFVZGRqZlpC?=
 =?utf-8?B?cXR4ck5pSmpSZm0rOFlNQjF4MkFsV1JtcjlpdlpTeWxkTjFkbSsyVGFWSDB1?=
 =?utf-8?B?aTB1VVRQVURBakNyOEZyWWpuLzFObk9MbE4wTVM0QXhma2l3SDI4bHlmYUdL?=
 =?utf-8?B?My9xNW9pUmc1RnFYRU9UZ3Q0L3VESmRsazRtWU5ULzZuWlgxbllSUk9jNGpI?=
 =?utf-8?B?UzluL0dSMkJ3S0RQWDViQy92NHpGZFN3R1ZsalVvaElNMHZzcFpURlFOeWxD?=
 =?utf-8?B?Sml5WG91UDlTRi8wZHlKQi9ncm1Bem5wWVlHQVA3c21XNG9aSWk1VWNPVERx?=
 =?utf-8?B?dUF4M2hTSG9SN3RxNytwWGUxdmMxYXFndTlqOVZMS1VLdnpBK1pWWk5ZT1V3?=
 =?utf-8?B?bldmK2l0NlNMSXUrTTkzRFpyeUx4UEN5YWJBMFhtRDFmMVdNN3BCZzUydTBt?=
 =?utf-8?B?YXd0YUVuTWdzTGVpanVsc2hiaHBqMlBaWldmWTBscjUvU01vVEw2Tzl6bEoy?=
 =?utf-8?B?dVFpT2VWczNIajFyb2doRVRvVEV1MDVmTDllRldLZkpwc3Y1RHZxblpDUGpn?=
 =?utf-8?B?dGl1M3JaT3NvSWQ2NmxsdUJoNzNuWTVsV1pCdTQrWlpOUFZ6SnliUnZIVzJ0?=
 =?utf-8?B?MGpyNEFKR2JLcjlOdVpMQURHZU10cUxsRURwNWROVWVpby9ReWlSTHhIUzhn?=
 =?utf-8?B?NldCcnBVY2wwOFBhUzZZUTRqeFF6VVVmRHRXMVh5RkxIbksyMkdRZ1pWMnNr?=
 =?utf-8?B?V2IzSTFRakUyUTc1WmlDSjE0OU9VRGxwWjNISS9rUStUUC8vQWpYSW52RUEw?=
 =?utf-8?B?ekpRRGhHTzZWdGRRUENyeVFSWDFTNjNlaTBNZ2FIUVZnTlE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TzEzdGVVbTZQWWYxd3BKZklPcTZ0ZWJ0NzFqMFRybTRYcWJhUjZjcjQ0cDZG?=
 =?utf-8?B?V1c4RkJ0N3hCYlBEb2krN2Fkck4yNmNQQmFsNXQ1WXoxMmRiaGhrNUFyMFFR?=
 =?utf-8?B?YzQ2TjRDZXRuMDZmMEc5ZFd6aXg3Z1hUL1VXd3g2YUpCRkJ1SUFFK1g2VDFN?=
 =?utf-8?B?cEx6ZklRZlZGaCtrVTBldUJpMnViV1cyTU5jOEhDTFRjcXE1bm85YUprYXZP?=
 =?utf-8?B?Y2FUN2Z5YWZjNkF5VjBnN09QN2RNMmJ1MW5Tb0M1N0xKbE5aZmx4bkFacGdO?=
 =?utf-8?B?VmlFbzdUT243aVFqVVo5SnJhSXYwcC9BdmpVSzR3YW52VFZNNjIrT3VaclFZ?=
 =?utf-8?B?cXE4MHBZd01hUDRWOFlWZHpYNEN2R2lBZGYwZ3FZa2c2L3FIQVRYTDFjTC9B?=
 =?utf-8?B?eW1wMU1YYzNBVEdmYURTbnQydFlxSEI3VE5pNEFCam16dXVIcHZrc2psSk54?=
 =?utf-8?B?aWhNcWxTS014L3pmV2VLUzZadlhwK1NzVzBUeGIyaXczVWQ3RUxPRkdQR0JL?=
 =?utf-8?B?aDB0QVJENmdTUmNqQVFUYmtGREptYTBJT2ZsM3pvZXJnNElYTnZFU3ZqV0Rx?=
 =?utf-8?B?Q1k0SENYcDBjckI5SnlubERaYXl6WHRDUFVua01zYXpwek1jdHNnclJNKzVr?=
 =?utf-8?B?UGNxdVExSDl6UzR4WXlIRzNueER4WjZYcUh4bjlqNUpxdXFNVnBWMG1rai94?=
 =?utf-8?B?MGszbnFabkh6Z1lVQ2NjenJLVnB6RXBrd1dwYzFvREtMZnd3dUF5TGt3OXBP?=
 =?utf-8?B?Y1BvWGllM0hKUEFONUlncWVDSXJkdFJLQVd5SFlwQkpFa1JCMlFsY2d1S3Q3?=
 =?utf-8?B?eFFRVE5MNHJ2UlZENEZRVE1EYmFKdFBzeTdYbnZMcnFkSDFWaU5NWitDaVIw?=
 =?utf-8?B?UjI4TG1raHhxT3N0TXZRZnd2eGhDNVFGN0cxNUQ2cTY4K1QrK0FtZlNUQkd2?=
 =?utf-8?B?V0NqRVUzK3RXRDhYUHZOeHhvTzVvcGpHOUQ4RWVsaDJsRU5xQm85VDgwQ2cv?=
 =?utf-8?B?SWdlcHJxbENlMUdVNVhYNXEzdGZRejBoMU40NkY0SklNYXRzVGpjZnRwQm9V?=
 =?utf-8?B?SUJCcUR1SGxDYjl1SUNDOEppUkFYVm5zZWQ3dnpsaEp4L04wbXpqSjJoYk1v?=
 =?utf-8?B?UElLUjZ2T0llOFVrN2VxNlBvWHo5OTd3T0JIYUk0OUJvUnVqNHRvWTNKQ1ZP?=
 =?utf-8?B?NHROejBZYnBmU3lpQytsS0dzN1VKM0tBZXVkMFhIZWNrdWdaWXVNUHJmZXh1?=
 =?utf-8?B?cHFsbmVERnpZUFpsWFBBK2grOGJXTW9LUnZlRE5yWEJhbDRhNUQwN0ZlZjlM?=
 =?utf-8?B?ZlM1b1ArN3ZjY3ZGaDZPVytzb2wwdTlnTFM4UjExUVFDeWdpSXdPWElSaWpY?=
 =?utf-8?B?dVJrSWtZYlF1b0p6WmdQa2FBR3dZeXB2MUVaNXNtMXcrQS96cUg3aFFLQjh3?=
 =?utf-8?B?M05lV3hoS3ZJUXRiMGhrWkQwTUF1WHpIZlZrOFkzWVUxS0NpbmNGWFRucUZO?=
 =?utf-8?B?ajMzQXJRYzZOdTdjK3Y3RWNCaE56SGdObUtXTzZTeVRuU0xsVGlPU2UvbjFX?=
 =?utf-8?B?MmhaS0pnZ2IwYmRLbi9wWW1uOXZrdncyVkxiWEczWXFCVWpKV0RndkNZS3Q1?=
 =?utf-8?B?RlVPcTdNWGVLbkVUWXh1Q3BVUjBQM3ZJOU5UZkZUUWNNMEoxbWtFQnd6NG5i?=
 =?utf-8?B?MXRKVjQ3ZTltZG15ZlRCby8xQkl5WFh1Z3RzVjdTYitZQzlsSXRYSFlYVE5h?=
 =?utf-8?B?RDVKekszUTE2S0JGamlhWmZ4aHZvNWRqbG9jSy9NQlNpVjhGdXNQUVNlN2lC?=
 =?utf-8?B?di83aE9rSXpBdnR3bzFPR2Y0M1RtU3Q3S0JZaExtQkd6MWJFYnBVM1NzaFVY?=
 =?utf-8?B?OVh4eVVmaTA0bFZtdGthbUl3RStnSXhHeU1TdHVhUFFYN0R4VHYxWnlGR2tQ?=
 =?utf-8?B?cERiWTZkdHhFWlV0dUhSVnVBL0lqZThsbFZrQTZEYk1scmM5WFZSL3VKYXVw?=
 =?utf-8?B?TzY4VkpNRDE2dWp1TllOTnlhRzRJeWZmNlBRdDJwbXd1cllyZk0xOWRkTS9N?=
 =?utf-8?B?a2NRY0VmdXpVc2t5dUVuajFVK1BxcGFDOU9kUlJjb21zdisvN1RsM0t4RXBX?=
 =?utf-8?B?elV3T2ZYUFNYN1BsQXNjYXdXa3BJaXA5K2c5aTZIb0dEY01jZWRreTJVcGVp?=
 =?utf-8?Q?+3BwgssMAS7wB8vURP6Mq4c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E895C579DE22646B1BFD09FCA3C5F38@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 068da958-c24b-4016-ae06-08dcb718e411
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 19:41:11.2950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 06q3M8H4w9OoLHLJzv2W0IUGOW1d9Fs9AEaR1Dx+AimKTB9LmJkRePKg5cPXyHAeDUWQwrvRCr1wD6H87pEZpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4422
X-Proofpoint-ORIG-GUID: 3ISCpCc6Z3Q-Pr-aOXGQBXOV3NnclFB7
X-Proofpoint-GUID: 3ISCpCc6Z3Q-Pr-aOXGQBXOV3NnclFB7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-07_11,2024-08-07_01,2024-05-17_01

DQoNCj4gT24gQXVnIDcsIDIwMjQsIGF0IDM6MDjigK9BTSwgTWFzYW1pIEhpcmFtYXRzdSA8bWhp
cmFtYXRAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIDcgQXVnIDIwMjQgMDA6MTk6
MjAgKzAwMDANCj4gU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQG1ldGEuY29tPiB3cm90ZToNCj4g
DQo+PiANCj4+IA0KPj4+IE9uIEF1ZyA2LCAyMDI0LCBhdCA1OjAx4oCvUE0sIE1hc2FtaSBIaXJh
bWF0c3UgPG1oaXJhbWF0QGtlcm5lbC5vcmc+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIFR1ZSwgNiBB
dWcgMjAyNCAyMDoxMjo1NSArMDAwMA0KPj4+IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BtZXRh
LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4+IA0KPj4+PiANCj4+Pj4+IE9uIEF1ZyA2LCAyMDI0LCBh
dCAxOjAx4oCvUE0sIFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPiB3cm90ZToN
Cj4+Pj4+IA0KPj4+Pj4gT24gVHVlLCA2IEF1ZyAyMDI0IDE2OjAwOjQ5IC0wNDAwDQo+Pj4+PiBT
dGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBnb29kbWlzLm9yZz4gd3JvdGU6DQo+Pj4+PiANCj4+Pj4+
Pj4+PiArIGlmIChJU19FTkFCTEVEKENPTkZJR19MVE9fQ0xBTkcpICYmICFhZGRyKQ0KPj4+Pj4+
Pj4+ICsgYWRkciA9IGthbGxzeW1zX2xvb2t1cF9uYW1lX3dpdGhvdXRfc3VmZml4KHRyYWNlX2tw
cm9iZV9zeW1ib2wodGspKTsNCj4+Pj4+Pj4+PiArICAgIA0KPj4+Pj4+Pj4gDQo+Pj4+Pj4+PiBT
byB5b3UgZG8gdGhlIGxvb2t1cCB0d2ljZSBpZiB0aGlzIGlzIGVuYWJsZWQ/DQo+Pj4+Pj4+PiAN
Cj4+Pj4+Pj4+IFdoeSBub3QganVzdCB1c2UgImthbGxzeW1zX2xvb2t1cF9uYW1lX3dpdGhvdXRf
c3VmZml4KCkiIHRoZSBlbnRpcmUgdGltZSwNCj4+Pj4+Pj4+IGFuZCBpdCBzaG91bGQgd29yayBq
dXN0IHRoZSBzYW1lIGFzICJrYWxsc3ltc19sb29rdXBfbmFtZSgpIiBpZiBpdCdzIG5vdA0KPj4+
Pj4+Pj4gbmVlZGVkPyAgICANCj4+Pj4+Pj4gDQo+Pj4+Pj4+IFdlIHN0aWxsIHdhbnQgdG8gZ2l2
ZSBwcmlvcml0eSB0byBmdWxsIG1hdGNoLiBGb3IgZXhhbXBsZSwgd2UgaGF2ZToNCj4+Pj4+Pj4g
DQo+Pj4+Pj4+IFtyb290QH5dIyBncmVwIGNfbmV4dCAvcHJvYy9rYWxsc3ltcw0KPj4+Pj4+PiBm
ZmZmZmZmZjgxNDE5ZGMwIHQgY19uZXh0Lmxsdm0uNzU2Nzg4ODQxMTczMTMxMzM0Mw0KPj4+Pj4+
PiBmZmZmZmZmZjgxNjgwNjAwIHQgY19uZXh0DQo+Pj4+Pj4+IGZmZmZmZmZmODE4NTQzODAgdCBj
X25leHQubGx2bS4xNDMzNzg0NDgwMzc1MjEzOTQ2MQ0KPj4+Pj4+PiANCj4+Pj4+Pj4gSWYgdGhl
IGdvYWwgaXMgdG8gZXhwbGljaXRseSB0cmFjZSBjX25leHQubGx2bS43NTY3ODg4NDExNzMxMzEz
MzQzLCB0aGUNCj4+Pj4+Pj4gdXNlciBjYW4gcHJvdmlkZSB0aGUgZnVsbCBuYW1lLiBJZiB3ZSBh
bHdheXMgbWF0Y2ggX3dpdGhvdXRfc3VmZml4LCBhbGwNCj4+Pj4+Pj4gb2YgdGhlIDMgd2lsbCBt
YXRjaCB0byB0aGUgZmlyc3Qgb25lLiANCj4+Pj4+Pj4gDQo+Pj4+Pj4+IERvZXMgdGhpcyBtYWtl
IHNlbnNlPyAgDQo+Pj4+Pj4gDQo+Pj4+Pj4gWWVzLiBTb3JyeSwgSSBtaXNzZWQgdGhlICImJiAh
YWRkcikiIGFmdGVyIHRoZSAiSVNfRU5BQkxFRCgpIiwgd2hpY2ggbG9va2VkDQo+Pj4+Pj4gbGlr
ZSB5b3UgZGlkIHRoZSBjb21tYW5kIHR3aWNlLg0KPj4+Pj4gDQo+Pj4+PiBCdXQgdGhhdCBzYWlk
LCBkb2VzIHRoaXMgb25seSBoYXZlIHRvIGJlIGZvciBsbHZtPyBPciBzaG91bGQgd2UgZG8gdGhp
cyBmb3INCj4+Pj4+IGV2ZW4gZ2NjPyBBcyBJIGJlbGlldmUgZ2NjIGNhbiBnaXZlIHN0cmFuZ2Ug
c3ltYm9scyB0b28uDQo+Pj4+IA0KPj4+PiBJIHRoaW5rIG1vc3Qgb2YgdGhlIGlzc3VlIGNvbWVz
IHdpdGggTFRPLCBhcyBMVE8gcHJvbW90ZXMgbG9jYWwgc3RhdGljDQo+Pj4+IGZ1bmN0aW9ucyB0
byBnbG9iYWwgZnVuY3Rpb25zLiBJSVVDLCB3ZSBkb24ndCBoYXZlIEdDQyBidWlsdCwgTFRPIGVu
YWJsZWQNCj4+Pj4ga2VybmVsIHlldC4NCj4+Pj4gDQo+Pj4+IEluIG15IEdDQyBidWlsdCwgd2Ug
aGF2ZSBzdWZmaXhlcyBsaWtlICIuY29uc3Rwcm9wLjAiLCAiLnBhcnQuMCIsICIuaXNyYS4wIiwg
DQo+Pj4+IGFuZCAiLmlzcmEuMC5jb2xkIi4gV2UgZGlkbid0IGRvIGFueXRoaW5nIGFib3V0IHRo
ZXNlIGJlZm9yZSB0aGlzIHNldC4gU28gSSANCj4+Pj4gdGhpbmsgd2UgYXJlIE9LIG5vdCBoYW5k
bGluZyB0aGVtIG5vdy4gV2Ugc3VyZSBjYW4gZW5hYmxlIGl0IGZvciBHQ0MgYnVpbHQNCj4+Pj4g
a2VybmVsIGluIHRoZSBmdXR1cmUuDQo+Pj4gDQo+Pj4gSG1tLCBJIHRoaW5rIGl0IHNob3VsZCBi
ZSBoYW5kbGVkIGFzIGl0IGlzLiBUaGlzIG1lYW5zIGl0IHNob3VsZCBkbyBhcw0KPj4+IGxpdmVw
YXRjaCBkb2VzLiBTaW5jZSBJIGV4cGVjdGVkIHVzZXIgd2lsbCBjaGVjayBrYWxsc3ltcyBpZiBn
ZXRzIGVycm9yLA0KPj4+IHdlIHNob3VsZCBrZWVwIHRoaXMgYXMgaXQgaXMuIChpZiBhIHN5bWJv
bCBoYXMgc3VmZml4LCBpdCBzaG91bGQgYWNjZXB0DQo+Pj4gc3ltYm9sIHdpdGggc3VmZml4LCBv
ciB1c2VyIHdpbGwgZ2V0IGNvbmZ1c2VkIGJlY2F1c2UgdGhleSBjYW4gbm90IGZpbmQNCj4+PiB3
aGljaCBzeW1ib2wgaXMga3Byb2JlZC4pDQo+Pj4gDQo+Pj4gU29ycnkgYWJvdXQgdGhlIGNvbmNs
dXNpb24gKHNvIEkgTkFLIHRoaXMpLCBidXQgdGhpcyBpcyBhIGdvb2QgZGlzY3Vzc2lvbi4NCj4+
IA0KPj4gRG8geW91IG1lYW4gd2UgZG8gbm90IHdhbnQgcGF0Y2ggMy8zLCBidXQgd291bGQgbGlr
ZSB0byBrZWVwIDEvMyBhbmQgcGFydCANCj4+IG9mIDIvMyAocmVtb3ZlIHRoZSBfd2l0aG91dF9z
dWZmaXggQVBJcyk/IElmIHRoaXMgaXMgdGhlIGNhc2UsIHdlIGFyZSANCj4+IHVuZG9pbmcgdGhl
IGNoYW5nZSBieSBTYW1pIGluIFsxXSwgYW5kIHRodXMgbWF5IGJyZWFrIHNvbWUgdHJhY2luZyB0
b29scy4NCj4gDQo+IFdoYXQgdHJhY2luZyB0b29scyBtYXkgYmUgYnJva2UgYW5kIHdoeT8NCj4g
DQo+IEZvciB0aGlzIHN1ZmZpeCBwcm9ibGVtLCBJIHdvdWxkIGxpa2UgdG8gYWRkIGFub3RoZXIg
cGF0Y2ggdG8gYWxsb3cgcHJvYmluZyBvbg0KPiBzdWZmaXhlZCBzeW1ib2xzLiAoSXQgc2VlbXMg
c3VmZml4ZWQgc3ltYm9scyBhcmUgbm90IGF2YWlsYWJsZSBhdCB0aGlzIHBvaW50KQ0KPiANCj4g
VGhlIHByb2JsZW0gaXMgdGhhdCB0aGUgc3VmZml4ZWQgc3ltYm9scyBtYXliZSBhICJwYXJ0IiBv
ZiB0aGUgb3JpZ2luYWwgZnVuY3Rpb24sDQo+IHRodXMgdXNlciBoYXMgdG8gY2FyZWZ1bGx5IHVz
ZSBpdC4NCg0KSXQgYXBwZWFycyB0aGVyZSBhcmUgbXVsdGlwbGUgQVBJcyB0aGF0IG1heSBuZWVk
IGNoYW5nZS4gRm9yIGV4YW1wbGUsIG9uIGdjYw0KYnVpbHQga2VybmVsLCAvc3lzL2tlcm5lbC90
cmFjaW5nL2F2YWlsYWJsZV9maWx0ZXJfZnVuY3Rpb25zIGRvZXMgbm90IHNob3cgDQp0aGUgc3Vm
Zml4OiANCg0KICBbcm9vdEAobm9uZSldIyBncmVwIGNtb3NfaXJxX2VuYWJsZSAvcHJvYy9rYWxs
c3ltcw0KICBmZmZmZmZmZjgxZGI1NDcwIHQgX19wZnhfY21vc19pcnFfZW5hYmxlLmNvbnN0cHJv
cC4wDQogIGZmZmZmZmZmODFkYjU0ODAgdCBjbW9zX2lycV9lbmFibGUuY29uc3Rwcm9wLjANCiAg
ZmZmZmZmZmY4MjJkZWM2ZSB0IGNtb3NfaXJxX2VuYWJsZS5jb25zdHByb3AuMC5jb2xkDQoNCiAg
W3Jvb3RAKG5vbmUpXSMgZ3JlcCBjbW9zX2lycV9lbmFibGUgL3N5cy9rZXJuZWwvdHJhY2luZy9h
dmFpbGFibGVfZmlsdGVyX2Z1bmN0aW9ucw0KICBjbW9zX2lycV9lbmFibGUNCg0KcGVyZi1wcm9i
ZSB1c2VzIF90ZXh0KzxvZmZzZXQ+IGZvciBzdWNoIGNhc2VzOg0KDQogIFtyb290QChub25lKV0j
IGNhdCAvc3lzL2tlcm5lbC90cmFjaW5nL2twcm9iZV9ldmVudHMNCiAgcDpwcm9iZS9jbW9zX2ly
cV9lbmFibGUgX3RleHQrMTQzNzQwMTYgDQoNCkkgYW0gbm90IHN1cmUgd2hpY2ggQVBJcyBkbyB3
ZSBuZWVkIHRvIGNoYW5nZSBoZXJlLiANCg0KVGhhbmtzLA0KU29uZw0KDQoNCg==

