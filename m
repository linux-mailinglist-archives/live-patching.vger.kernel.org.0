Return-Path: <live-patching+bounces-486-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C88B6950F11
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 23:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 514391F247E8
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 21:20:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8631C1AD3F5;
	Tue, 13 Aug 2024 21:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="jsThv5IQ"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7751AC44E;
	Tue, 13 Aug 2024 21:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723583750; cv=fail; b=N71hEqvY1s95XyBbbza6UIuYBD9Js1YOOX75wU7/n9jIWxsbQBq+Pprkoab0iH7H+6qMzzXyFEgBMiUZ9i42NgdSsmLYI/W+cNQqbKpRSkw8IRkOe6KXZXIbk0aqnvb0c+Ipqz1tqyghTIgB4w+v+6BcUyAx6muwo0ZUGq8LNbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723583750; c=relaxed/simple;
	bh=N1D1MmZD9EviwzufyDjFcqwnk7npIIIeLDc7JtuiqRA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WFVdvM+lxAPfrWZDJybdF/O597oi3OxoUs6ZeTqGnYnjUunxokvsqbXLYfEZpkDezrtUOru1czoEubFwfIG8vfy+46Jjb8WjBPv/87DXVgUm7sZfKwI2BUSgp5ees/lsNZc0Zy46ZLYYN/wvMFy4tC/BrWKl8qolvmW5n3U83WQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=jsThv5IQ; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47DLDxYI007436;
	Tue, 13 Aug 2024 14:15:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=N1D1MmZD9EviwzufyDjFcqwnk7npIIIeLDc7JtuiqRA
	=; b=jsThv5IQyRLyt1IYQ8CohxLTeYtQhSnrys769sL0ccOubSy7UkoaAsLb4Oe
	3upIS8gtfPEdYEKMySwGIrvFVFNcLLYmsnf0eJhIQ3qwjLjZSm1a6YaLMlSLvEqQ
	yim0eAGZ7/ngTV+DV+Z4ZqKFBItN2+2PN6xaDmmf35AY9g9TnAS4xjRLfAmDcEG4
	PUPLJ8n5aY49z0CrfEbbjzJsqQ0biaLNhdxnrMHnbEng8tPC34n8Jq62SE0ZtRGz
	72L0y5kLgsIkrTt1mLNmRTHRvLA8fIMCc/andbH8uPSepfTkgPjw6ErO0e5TT4SP
	eB5HancPalOaM4QAEA1pVdEWD8A==
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4103kcckas-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Aug 2024 14:15:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T96xDSBY8o4N9ZbBRpqIxnABye73G/QWX0S2FG4VeEJryCfpRUeY4a7inlkl1lCyViijCGgZGh/1d2Bztdy8Psy+sNXpSzJrwSFmixpP0fHEr5reUrGVHD1yOKgcJHF5JOjRPsWRiMT/lVRvkYcuQKbxT3WApz0yWKbxPXUm4djwt6Bf9ZPKwzjXCFCsyyvnoWxzr321ficN+0DTSgDUBLW0p99GHQMtHAk6H3WahAomhSuvotYbgxC1oMm9gShupgpt3NmSli1XcNwzh/c4h2T0RfTfYCmYNiL3sFdOnt9hx0y5iAr9uZQwITcvtEHJtQgi4GVXlQrsoWt1Q8dsZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1D1MmZD9EviwzufyDjFcqwnk7npIIIeLDc7JtuiqRA=;
 b=BFhTvTm08ZwAAAQKqxqLnNYggL77WGZ4dKpbRsEYhK6Mjclc1A5EyqHBtK31oDX1nMGOW6tBTdBTAPsRYx7lct7UKTbSkGRTPksM0MPD4L0HbW25nQBi/e57Vj6rCVY62MBQVLyJIZn5mcRHQNKDrgPp7i52RT5BZsEyqkJ10R4xgPLKEIqmjtdWGhV3Zp9FmhZHH3CUJ1D02ObxZHBKhboQjEKtGhcj6Z0SsCq6SNJjMi+srNJ/ETCJrNxoGNrxbtBBOYy1wH8MF49WVao6lH37Ft/wymaqoyTN+sin1CblG7AB6KsvqEnqm836FAOKR6Hg5l5lKaji009N3JXwig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW4PR15MB5160.namprd15.prod.outlook.com (2603:10b6:303:187::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Tue, 13 Aug
 2024 21:15:44 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7849.021; Tue, 13 Aug 2024
 21:15:43 +0000
From: Song Liu <songliubraving@meta.com>
To: Song Liu <song@kernel.org>
CC: "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        LKML
	<linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek
	<pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Nathan Chancellor
	<nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        Justin Stitt
	<justinstitt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leizhen
	<thunder.leizhen@huawei.com>,
        "kees@kernel.org" <kees@kernel.org>,
        Kernel
 Team <kernel-team@meta.com>,
        Matthew Maurer <mmaurer@google.com>,
        Sami
 Tolvanen <samitolvanen@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 1/2] kallsyms: Do not cleanup .llvm.<hash> suffix
 before sorting symbols
Thread-Topic: [PATCH v3 1/2] kallsyms: Do not cleanup .llvm.<hash> suffix
 before sorting symbols
Thread-Index: AQHa6RYWMtYCd61ONkGa/JznFx3CWLIlubGA
Date: Tue, 13 Aug 2024 21:15:43 +0000
Message-ID: <BE78D994-83E8-49E4-868E-8ECEDD39D580@fb.com>
References: <20240807220513.3100483-1-song@kernel.org>
 <20240807220513.3100483-2-song@kernel.org>
In-Reply-To: <20240807220513.3100483-2-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW4PR15MB5160:EE_
x-ms-office365-filtering-correlation-id: c870c3ad-182e-4c94-39ca-08dcbbdd1787
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UDZ2TDdHSlJSWkpham1FSldtY3RFSzA2T1NUUTk2cG9KaFhFV3dsRVQ3Yk8v?=
 =?utf-8?B?cGR6WkxuTngzVWE1cmtSODVKS1M2L3UxZHlOVCsxbFYrU0tMU0dvQ3VpTDBV?=
 =?utf-8?B?UU1uVjJDQS9ONDh4bE1WbVhKZVR2cW5lVHJoQ0Z2RG9YUWxMSXpqdkw4bU5I?=
 =?utf-8?B?NHdwUVFVOUVCNi9Kak45ekJXT2w2ZFo5ek91SkhPWk5aaERqRjQ0cmwwL1ZL?=
 =?utf-8?B?N2lzVWY5RW4rUkR6RFVzRDZ3YzVwOHAvYklqaEVBRkhWdGx0T2pjV0cwNlNM?=
 =?utf-8?B?WksrQ3FUb1c4eVpXSlVralVNdktkS1JEVzNyQ21zandDVC9Qa0REUHcyYjg5?=
 =?utf-8?B?c2dJd2ZCeldqa282cTNtL0FuN1ZFNzFNSGJ1WGpFSzRyTnh6R240amIzcUhH?=
 =?utf-8?B?NXplYWtZcXFNaGF5emZXK2g1SlozQVNkY2tpWGhrdWc4WTRKMXdPVEQ1MGlh?=
 =?utf-8?B?L0xlMWw2V09XaS8zczA2MkNtL1lCZkpXb2t1bitwdnd2Z3RKOW5PWmRwbkta?=
 =?utf-8?B?bWc4UTY0NGNvVkR6RkNFVHJNTW9kYmZ2Y3NKanlxU2ExZ2xTak9vVGx1cXhN?=
 =?utf-8?B?MXJNM05iUlc5SjBwKzQzZ015cjI3OG9zUXJRcGtYSC8rVFpBbjU0RDRLNzFk?=
 =?utf-8?B?WnRBQzBvclBiME9TTWo4aStlOE5WSlVQN3NlblRKL3NLVkJyaEhEU0gveXJW?=
 =?utf-8?B?cGJoRGVKYUhpcmxiUUJiS2R3eWFoZWdsUThDMGRSeHR0Z0hZODN6MCt6M2E1?=
 =?utf-8?B?Q0pkMEsvYUVOdnEwWmtTWFVsNVdiRXRObUMvaFE1RE13U1dRRVNHOUozc3Ey?=
 =?utf-8?B?RkcxMHRLWnhMRWtFRUtKcjdSSWcvclhDRmZMMWIxR1F6VDlTTml5YW0vWUR5?=
 =?utf-8?B?RUZyM29FTHFINzNKMWh1Z1U5aGFOQUNkSE1iZ0hoY1NWcTFEcTVRdGxDVjVn?=
 =?utf-8?B?WHZ4RUE5SytuQTRmRHNwa3hodTdNbTlVOE9IMit1MDdrblIxdnNSb1lzamR3?=
 =?utf-8?B?Tk5hVVo4NHMwT1NtOURoSkJpdmIxelhJdkRJYU9GQ29MVDBRaUowZEF3bmhh?=
 =?utf-8?B?c1RKQzZrWVdDcHphaEllVy9LU1hFMVNaajJmNEZmR3NMeFI1UHlXTHlmdEpR?=
 =?utf-8?B?TTF5NGh6N2xNTERZYUJzY2krMHlsU3RGa3VoUHJNT1J6VWNrQUxQb2FzcmJE?=
 =?utf-8?B?TzlubWtDY01pUUxmUzNtZFdLWEY0b2JnS2pNV1ZDSXJDQk1lTzJucVF3WWpP?=
 =?utf-8?B?WkR6eTl3bWlkMXZrNXkwcE9oazhiRXU5aGJvZ213ekJTRE5zQWNxcm9qYkQx?=
 =?utf-8?B?NzZPZkhtbXhWdmFpNmRPSzlITFphNmQraExZbGpwdVFTYUZMVjM0QnNkM3NI?=
 =?utf-8?B?V0lXbXBZM0M3TXlGcUFtUmZ0Y3RHVkdXc20rUXVIZ0ZYeEhUcGhNK0dQMk5V?=
 =?utf-8?B?QmNCcmFjQTVJUnVNMmpyS2doSm9Pck9UZDVsRktVakFXMUJHM0JxKytXTG9y?=
 =?utf-8?B?MG4vYXN0ZEJpbUlyNkJxUFcrVTduL3I1K2d1dGNubGZHemlzNzdaR1NQWkhH?=
 =?utf-8?B?WkcrdENoRUtBcnd3R0ZJT0pqT3BhakZUMHltbmE5Mk9JRCtMMGN5dm9hTklR?=
 =?utf-8?B?ZGZYc1FwZ2wwZEN1NmNqNlI0Y3N3b0lnY01jYUFDd1NtaUJPMENOWmZpb0VN?=
 =?utf-8?B?NHZjMTVsYnpMMXhmOEhQZVkrNC9QdmZNOGRidUlwU21YWWpCS2o0d2ZRb3FI?=
 =?utf-8?B?LzBXUDRyZCtQYm8yY0NTbHdmc1QvS1kyUzUrNmlBWnJTK1VIR2RjdHQ3Sk85?=
 =?utf-8?B?d3FQNHgxMVdFZzBKcHg3emVmRjlaWFNrUllZQmZpeVhJUlFoVEVaRXN3R2tO?=
 =?utf-8?B?NWRjd1FUQWc2L1p4SjFDQVhld2xkTGZTc2FzS0poYWtVWFE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aE82eHYyRG1pUGxHRU0wSTV0dTZ5SXVvQUJwMU9aMzhQNnN3RTVRM2QwVTZ5?=
 =?utf-8?B?R1ExUGFpcGxLS29Ub29MVFFOdlRJQjRPUldvdkE3TDJISmFtZ2Q4ZnA2eHo3?=
 =?utf-8?B?dEk4K3BDOERndTlwcEJvU1VFNTZKYklBV0g4VEp3SGxOS1hrUE1JVEhnRWFE?=
 =?utf-8?B?OE04WUN3eGRRM2hMUVBKQzRld1NwMmlaZ2Mya2pqdUhRMlhMUWZzbUkyY08w?=
 =?utf-8?B?U203UWRhR0ZkWUllcnVDY3BOaXUxM3d5dmE5MmswVEpLUUxCMXZvdDMrSEVU?=
 =?utf-8?B?blY4UnJDOE1mYnJEdk1OSGNIdFEydmVrbWNQTmVRZ25Za0x3VS9KVVdrQ0Z6?=
 =?utf-8?B?d3ZXWU84UnhLVzE3cmdSbVZTc1JkRWswUGdSdzRtVzZXY2w5RDNCbjNORUF0?=
 =?utf-8?B?OXV4Si95cFhQbTAvalY2SWxURUs3SDQvVEIvMURVQWhzeFMxaWFveWpteEJm?=
 =?utf-8?B?aGg0WmIwd2dEVUpxZDFOVW1LaVdST29LOEJjVEFjajlkY1hNeUx3LzVJYmwr?=
 =?utf-8?B?dDZMSSt2SVFUZnh4VkozbDllYWhiL2pSbmFWVG1RTHJmcDRSR3d0aWYrTkZO?=
 =?utf-8?B?a0N3SWhrRmJxRURremVjc1hQVElLcTBLNDc2OFhVdVlvZEMvNVdxR0RESnRF?=
 =?utf-8?B?S1laQms3ckpJdVZwMFFpMGoxa2JYS3Q3MENVbFBhc1NhdGJ5NW5SUForWkNh?=
 =?utf-8?B?RDNPWUloZUNYNFpjKzlNTlVFVFRZSE1HTnpIWHJ3aUNGcndLRThtWXR6M05y?=
 =?utf-8?B?MElNYlZ5bmlqa0dWMkhwNytYT0krTFphR3NDK1RkS0xPRHVESDFOWnV3Z0tw?=
 =?utf-8?B?Rk52b2ZoMlFibHdsNmI0UWthbGZUV1dpUS8rVXVSZDVXMDR5eVhiSS9kQlJt?=
 =?utf-8?B?U25hNmhOeUNBQk42TVFvVGtaWVlUanFHTjRDVnZSUENKL2paSFlJVG9MNWZs?=
 =?utf-8?B?eVQ3eFVBaFB3OFp0V3BUTUp6bFhTOWJjUjl4L3ZIa2Y3eWVpV0FYTUkwVXJM?=
 =?utf-8?B?bzhYNGJXM1ppUUdieStKMVdkTTFHOVh1d2ZybVpEMTFOWkc1K3ZRVDdCajNK?=
 =?utf-8?B?bWZtWnRhZ3ZxajZ6aHlWSGhoeDBNbHBDQUFNK25qZ0ExWUNacTZ1NU9CVkNO?=
 =?utf-8?B?YUtUeHV2bWhPT2xHSHVqODJmQU5mRElWYmRpM3d6aW1EQ0xTMDZCVUlqL3hy?=
 =?utf-8?B?TUJGbjZWWGh4WDlzdVVXc2NVWEIwY1N2MmhNaVI5ZEpWV2hQNUtaNkp6R285?=
 =?utf-8?B?MTMvSk10dS9HTStHc0ZJMUtPcFJDWnpzSlpkWitNSVRkRHJPTlh0Z3lHOGNj?=
 =?utf-8?B?bzduQTEzckR3NklRa0lETzhDeE40OFFrYmFqT0ZYVHhBSEc5dUxwLzFSZHQr?=
 =?utf-8?B?V29GSEVOZ1hCcis1T1VpeUxXdkRydFliTUtvMHZ5dnFvbFR2TWZ2RTBTcEJn?=
 =?utf-8?B?UWQ4dWRaRmMwVUdESEVZTEFwV1lGN2tkZllZOFV5eGVyUGJQUWpkN2lia1ZI?=
 =?utf-8?B?aStXYnR5ZS94STd0MlY2WWFrVGNpRlVHd1lLK3lTVWtpcWdmVWgxeDhhTnl3?=
 =?utf-8?B?UFd5TDV2azgxVmlQZk1PUHhoSVU1WFJYRm40ZWFRUW81djltTnhva3diak84?=
 =?utf-8?B?Q0JRUCtnbTRxaVJKQ0ozS0lwamM1VnVzNkliTmpNbkRqQktRSjgrWGJIMHg1?=
 =?utf-8?B?SGRWRTF4WUpEbEtEVDhMakRtbnlsekpCbjB6cUR5cWNtNEROakNORWJ0TU9t?=
 =?utf-8?B?OS8wdXVHYzJyd1gwTlFxMEM3bWFQdGxKN3JZbWFRejg5L2JSaGxQamVTajlF?=
 =?utf-8?B?emorUXovbHRuQTdMRE43Yi8wblR4OVY3S2wrMjVHQXNGdWd6ZHM4ckZwUGtR?=
 =?utf-8?B?bHQxU3RTelNxczh5eGhManp0bnF6ZG41dm11N0UxQkUyTUsrQkNITENXVk1F?=
 =?utf-8?B?Nmc5eFdGSkhmekRKeVJ5RFNqSWt4V0IwWERLUnVCY1VpYkVoSkR1d3YyOEl5?=
 =?utf-8?B?T3hsd0dsUG9ubGFwVTNDSFk1R3hzMWd5Zm1pckhSSjRSNEk3Q2tmeWZOdGtN?=
 =?utf-8?B?ai9ERGdiOHRpMEFEWGZsOE5xZFVTZ0JzREc3RVRJTTl1YWhFUXJkYUtUbnFK?=
 =?utf-8?B?SDE4ZjZaSGw2TkF5cktGYzJ3TjNVUzlnVmhoakt0WVJkTE5mUXJjOU94YWF4?=
 =?utf-8?Q?6+H19WNtcsRZ+2Dyx1oi0ik=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D5ADBB13849B54DAF819C93AC0801A7@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c870c3ad-182e-4c94-39ca-08dcbbdd1787
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2024 21:15:43.6488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K5mrMntoFCsdM3CNFaVv8b2p3f/ybBbtOc8pDmf/tWBNIXX5T2blNr7mMS7z/+Jr035T2riVieFxTJlkO3J9Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB5160
X-Proofpoint-GUID: 4ue7caAgOPEbiVVp14kwjF8Wzr9HXU4Z
X-Proofpoint-ORIG-GUID: 4ue7caAgOPEbiVVp14kwjF8Wzr9HXU4Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-13_12,2024-08-13_02,2024-05-17_01

DQoNCj4gT24gQXVnIDcsIDIwMjQsIGF0IDM6MDXigK9QTSwgU29uZyBMaXUgPHNvbmdAa2VybmVs
Lm9yZz4gd3JvdGU6DQo+IA0KPiBDbGVhbmluZyB1cCB0aGUgc3ltYm9scyBjYXVzZXMgdmFyaW91
cyBpc3N1ZXMgYWZ0ZXJ3YXJkcy4gTGV0J3Mgc29ydA0KPiB0aGUgbGlzdCBiYXNlZCBvbiBvcmln
aW5hbCBuYW1lLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU29uZyBMaXUgPHNvbmdAa2VybmVsLm9y
Zz4NCg0KRml4ZXM6IDhjYzMyYTliYmYyOSAoImthbGxzeW1zOiBzdHJpcCBMVE8tb25seSBzdWZm
aXhlcyBmcm9tIHByb21vdGVkIGdsb2JhbCBmdW5jdGlvbnMiKQ0KDQoNCg==

