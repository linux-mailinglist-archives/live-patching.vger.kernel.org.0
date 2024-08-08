Return-Path: <live-patching+bounces-471-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ACA094C0DD
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 17:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09C92B2772D
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 15:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E2918FDA0;
	Thu,  8 Aug 2024 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="CIUKSkNX"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D7518F2DB;
	Thu,  8 Aug 2024 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130434; cv=fail; b=r+RT+D1jD6nE1+PjRkIiU5SP3HkkCFFEGHc4bsK3Vn0DUqLzWH5afiB1zRW2qxzILR1IvMXy/4tn1tP47xrylEh4vr5KFCmYohM3qXc18mfAMVUmXWe+QfSLQSaxt/iYulAhcNiGY7hbiSLQ4NGEqoBRWTTsmRHN//i2NcaW/QM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130434; c=relaxed/simple;
	bh=n40IhdpCGTm0UttDug8pR5y1Ic64bIE+gUfTY9CtHYs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B+avejSqNzhBGP+jhLcpMGrpq/x0y2Ry3n3lafbgzccQ+YCi6q5QxG/I43RqHy9si4uDMwsV9KPMKevS1/VLMnQ8CL+GFPC2YDxqCeFqY4Lyo6bJ1CsF8P8BJlEtQCCmoi41mvZoa4d3IYYuit4S5isw5tXobDWQi7wZrXG0NFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=CIUKSkNX; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 478Cq6ls024617;
	Thu, 8 Aug 2024 08:20:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=n40IhdpCGTm0UttDug8pR5y1Ic64bIE+gUfTY9CtHYs
	=; b=CIUKSkNXAVdOliSdmrhiRxVTrxVpvdTz1Fwaa+rUGRpNsJ4a1eTslmPcuCY
	PKoYO5EuqO6eX5jHCeoS1D1Qk4Rqw5nTjrNtJ3Wcvg9lSyInF8p3l0TLUNFCNw5G
	FyQykjdwRJ3roWSgq2ZRdBTRQ4D0Zjbd3c9qas42+lMM2QCIEYscgo8C3ezIyl2J
	X3vDbwJBpYtrKRIHWh6y1cO1u3zSQsfOfRvbhwXBrQ90EhVbbw7k1pil27y2w0c6
	y0HnLLWtoYKSZQWRgl5hRzDHmnO/Pv1fbDXDpRRu962HTgMiD88lvtr2onTPOdhr
	hdxRl3cKELugUNWWs6muwyaGRHg==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by m0089730.ppops.net (PPS) with ESMTPS id 40vjdsmjam-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 08:20:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LyOX4jIyXkLr1uqtogzh9lSlv1S9gXDRHgu8e7Tp6rn5UwoOnt2fERH+ntO/2jSc5cckQsgvaI6f3Y0v6x0Y/KuedooFbqTPA3qEPHGi5JiNifJZKsJUUubJsNKUBBfbjX9bPnGadOLfyF0CzWJJD2ugnLPx83lK1zsMlNz1Q1Cfwol6gCSntcnRl8QXAnAUirJbC9pSKa8EECU01rGgYfnulntjglnQfiZJjep8CA8Z0QL5vqMTDb0MyQYkngLmpHk1+6hJ5NJfqj7eN1ZK2M4YZzKGsZxt1ncpcnhndBpRpHWqRzSiZ4Xnb9Dr7bzroQ+per7U7fEV8y6/AGPH3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n40IhdpCGTm0UttDug8pR5y1Ic64bIE+gUfTY9CtHYs=;
 b=tEVmccm0XuMCOUcVFITvXm4QseNwuNWvd8/R5W9IkO9OimFxrsZvsxAL5Bmpf55+ZisW+PfFvJrhXBlnZSmbbN4qzWJo1VWvIQzbG4djCDXhif24fGjSll3x2BA0RAdeK/jOSab5O1L0j6rya0UdVoxQUsM3LwymtTxLyuN7V/jWGYwMWYO22NrTOPBQJMeLSnWxsgp+YOEVaPPNZ20xm8ko3CgYgc4/TxF9/VLDfWtdC6PBx44dzpzQoy4ZtGRy/5vrBjHc9T/Wuhy/HpwdQOC0bSZrMUtUDy/ZjwxTt334fVaQ0P8rmdpWI//jFsIT2uY0BT9rLW/Q2xe+vMRIFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SJ0PR15MB4392.namprd15.prod.outlook.com (2603:10b6:a03:371::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Thu, 8 Aug
 2024 15:20:27 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7849.013; Thu, 8 Aug 2024
 15:20:26 +0000
From: Song Liu <songliubraving@meta.com>
To: Petr Mladek <pmladek@suse.com>
CC: Song Liu <songliubraving@meta.com>,
        Sami Tolvanen
	<samitolvanen@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven
 Rostedt <rostedt@goodmis.org>, Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        LKML
	<linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
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
        "Alessandro Carminati (Red Hat)"
	<alessandro.carminati@gmail.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Topic: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Index:
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAAD/9AIAABNyAgACkkICAAFrMgIAAWCcAgADc1ACAAFnCAA==
Date: Thu, 8 Aug 2024 15:20:26 +0000
Message-ID: <A3701B71-D95F-4E99-A32D-C1604575D40F@fb.com>
References: <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
 <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
 <20240807190809.cd316e7f813400a209aae72a@kernel.org>
 <CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
 <09ED7762-A464-45FF-9062-9560C59F304E@fb.com>
 <ZrSW5KgFMjlB1Rn2@pathway.suse.cz>
In-Reply-To: <ZrSW5KgFMjlB1Rn2@pathway.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SJ0PR15MB4392:EE_
x-ms-office365-filtering-correlation-id: 1331e71a-7d00-4197-fb9b-08dcb7bda1b5
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eUEvRE54SmczaU9HT2o2d0dEcmo4WWFaUWRoU3JjQWdNdGliaTZkcTFDZEZh?=
 =?utf-8?B?VVE5UmVNR203ZGowRjVKdkJaS1d1N3BmQjN0eFRabGtVY1RNdHA5Lzc5MnUr?=
 =?utf-8?B?TXc3UVp3VndMa21nZVM0dFE2U0NWOEFrK3I5QkJkWE0xU1NCT0NYVWNwR3Y1?=
 =?utf-8?B?WFVYSTBwSWY3WHpmRFlyRXJNZWRnaHFZTHpFblBDRzh6d0xSK01HMEd0S0wy?=
 =?utf-8?B?SG5qSXBXUTIxTFVSVW45V0RITFl0NFFkUnZIMlZDbmZrcE9yeFk1Q1VlbnJ4?=
 =?utf-8?B?WGRpMER2enM0T3psbUx4SU5jOW9QdTJTbldQZ1lCQWoyNTlkaHlDQzlLSitp?=
 =?utf-8?B?cVJTajkyYnF3WFlOVGtuSUdCZ2FaV0FiUXI0SGpFb3k4SlgrMnk3ZHM1M2s0?=
 =?utf-8?B?NmhRY3RDcFhoRDNiS0tOTU9sZnY5VnBZa1MvZ3gyNThQNmVoMG5JUlppZ3Bj?=
 =?utf-8?B?QW5xVEJVSDVXVldHNko1bFo4UUc4V1dlTWp3VjVyK09GUityZHB6MWJtaG1i?=
 =?utf-8?B?UDRFSDBLa0pYRmk0aDJmcjJISGxCaXgxMlBQZCtjMS9WYXdKWmJqYklYYWh4?=
 =?utf-8?B?WTVEb1JodmtSNUowelRwWUY2VmF0cU9oZWkxcWxpZ2lsWTk1OUNlM1ArOGU3?=
 =?utf-8?B?dmc0L3FrRE8xRFdVYVRTc2Yyd0UzOC9FV2cybDhuQ0xjRXlPSHpmUDliR1Z3?=
 =?utf-8?B?SDFZZWlnOXN6L3lZWlhZWit4dGJGK3BraW9mUm5Ca1ZZcnVYdnl2NGdzNDAz?=
 =?utf-8?B?Vmp3VlRJYmJXcVdGaUExcnUvcmlnZXgrL1Q2RDlGNXJISUZ1SkVsWFp3K3pU?=
 =?utf-8?B?RmJUdjRtRmdJcVZBOXVFbVU2Sk1PVEZJZGJxZ2k2bUdseUhYZEJwdjQyYU9k?=
 =?utf-8?B?R0VKUnBnSlgwNkg1UDIzdjhVUi80cytLZWZxOEdOWVdVaXNhQVBleXNxMnF0?=
 =?utf-8?B?RnREdTBEdHMzNnB6T2ZCV1I3TjE5cVNkOVBqVjlyOXJMai82aUJQby8wTzRZ?=
 =?utf-8?B?bnFqcmNRRndkU2FtcmN2VmI5WUdpLzFVeDh2ajJCQ0Foai84ZzhmZG1QejlQ?=
 =?utf-8?B?Y01PSTFyaDBwWE0rVVdLQTBFdjdaSDZQTlB6MWhYanczZUpnMktuMms2ajNN?=
 =?utf-8?B?alAwLytKcHE1Q2pmcW4wZUE4aXR3Y25HQ2lHb2tZc3dOY2JjWEFXN3J5M3dV?=
 =?utf-8?B?OFBNK3ovdm1aZ0YxenlCS2tLdlNGWW5SS1FqUGVtTFZybElaYTk5dVhHREtG?=
 =?utf-8?B?ZzVzYlVveHE4cXJhQ0NmRGZRaXRCd0E3cE5VTDJXc1ZnQWh1MENNQm92NW52?=
 =?utf-8?B?UWNBelhMSkMyODZNRGlaNU0zL1hFQS90bWNMZHNKejRrNDVWcDJuVzhWNUZz?=
 =?utf-8?B?czgrVlVTTlZRUXRJTitHSjFWZkd2ZjZWdUg4ZDl0Q2FIR1NEdmp6NHVmanJk?=
 =?utf-8?B?NHNoSUhNM0VyemN4eTRGbm5VTmhCTWVZYkpMT2hXVkxIK2RRR3lLdjBGL1l0?=
 =?utf-8?B?bVQrUU1PUW03bWJrQkhFYmtsQ0M5dVQxbFlNUU1MZ1JPZGl1TFdSMEZkS01T?=
 =?utf-8?B?aGNsdllvZ3hlaWdwOUFVaGdTblZRN2M0Z1JrOGVWWHhYSXpVZGdZejByNlpI?=
 =?utf-8?B?cFp0KytDd0g1RXUrNEp3SWR3dkI1R2piZlJhMllYZFN5akN1b3hDRDlzM2hF?=
 =?utf-8?B?WVZNME1OVGxscFlPMHBrelRxV3BPNk53ME90YU0zcXk5ZnlvMGdxTVlVamR0?=
 =?utf-8?B?cnp3REQxeUswOXBmaFl0TndIS2pJU0c0UEFqeUNOaVQ4UW8xZTZoZXQ3SzVM?=
 =?utf-8?Q?szd49dhGnP0/pAgCJwpg20XUG5+uVa7ETwXNE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dTE0U3ZORXZxZTh5MERJRkZ0VExLNjBrQmJzYjVuQVp1R2F1UEhwSnRuK3FE?=
 =?utf-8?B?OVN0c2hWUnk2cFA4dlpOUDl5emZkczZ4Zk51cmU0RW9mNjE4TGROVXlCR2Nn?=
 =?utf-8?B?VE5aYXYrdGZieVE5VDhaazlIWW1JTmF5Y0Z0NGprUVJlNzZMclhvOFZZVUto?=
 =?utf-8?B?U25mL1dOL0FQbDZRMzBPdENXV1RWc251RCtBM1BHV0MzOThXTTliVndQU2kw?=
 =?utf-8?B?V3VsdC9xdmRnT0Jnams4TzRSc29CNnFNdnMzNktwa0x2Z3VCQ3ZTV1huVWI1?=
 =?utf-8?B?Smxtbmx1d1BRYTdjd25uZlY0b21SaGYrcnZPMDFYR3QvWEt5MVNaZGhrMm1l?=
 =?utf-8?B?OTQ5TnA1TnJteUNYWjNaQk5ML1lWQlFkTUVOa3UxQVJZVzVMUUI0L083SXhB?=
 =?utf-8?B?VG9IUC92WExlS0IvdllMUmZLaXdOR2VtTllpV1pJL0dKQXRZWEVUTTI4SFJR?=
 =?utf-8?B?VmVicjRCbGNzUXhVRFpOSEhhTitDSHZUeE9heDhBREcwYWk3dEd0eTE2SFVv?=
 =?utf-8?B?cGhWUDNoQ1FPWUllOS9aNVEvTWZnUHFGeE1BVGZqUTRtMUlQaC9YZDlueUIz?=
 =?utf-8?B?MnZhdU5TZ1Y1MXU3dGtKeUY3WmI5SHpTcWJqMG5xaVFvcG5GdTk4V3JSNTdu?=
 =?utf-8?B?NDJRSm9ISC9WSTFvL1EySEpNR25PakRMTThXSDdqN3EvRWdwa2VqUFdBMUJy?=
 =?utf-8?B?VlJlUFV3c1BqZ2JER0tILzRzcEFlUU9NelFYdVA3aFIyelVIV3dIUEFCZkw1?=
 =?utf-8?B?UGlWQkdxQ2RTNCtQUzQxQ1lKN2xUVkVMNmlqY1hHK3lqV1h6OTNRa1lIUWYw?=
 =?utf-8?B?UXhBYVFXaWhJdDN1YVNHeklJaG5qbTVHUWc3SThVMC9VVlZvWFJOODV2cG1I?=
 =?utf-8?B?SDV1UHNFSHNCam41NGhtNE8vQnhUS3VHMmlDZ1YwOFdva0p4NEExUXBzV3JB?=
 =?utf-8?B?WHlrMWN3cXBGRDhaazZRVHZ5ZzFhMWdrc3RKSlhJNmg5Ri85TFRSMWtpRmUz?=
 =?utf-8?B?bHQyOU1VQnZieE1CT2U3ZmUvekZPZWVRTDZDOXhQZk14QURYUGpOYW5RTDM4?=
 =?utf-8?B?WXAzUnR2dTJSQ0NPcHNZUUYvTW83dlhVQzNheWNOZHdEZitzSFEwRmN2bUt0?=
 =?utf-8?B?a3Q5Nm9PcnFrOHpqNzNJMGRpUjdidjNnU1NiUHdTQjZrSFpyRmE0ZG00M3Vs?=
 =?utf-8?B?bGt0VHpGUFEvdWFCbXZnNm1IQkJva3NuemFtZnBpaFFEWnpnRkRuN1NCaXdR?=
 =?utf-8?B?MEtkWVRMdGZSeFVVVTFhenVoMDhVa3BOc3RPYU54dTM2OERrNjV5WGF2Y2h4?=
 =?utf-8?B?UmcvZnpqeDdqN3FSN0hWRk5VS2hFZXlwMTBTWXpTOFh4NjNSS1BUN0Ntd0cw?=
 =?utf-8?B?Nmc2TFhpNDZ3T0ZTY293eWVNcnRVSEsxQW1DcVdFSkgyMVVHVys0NHUxRjAv?=
 =?utf-8?B?UXpTSG9HdFkyVVNKVEsrbEVqRXZSU2RncGhNU1JtdkxlbnZadGpGL1BwSXdC?=
 =?utf-8?B?TzJia0QrU1hIbWxEeDNXT1Y3WXcxVEE2ZEo4bCtnTVo4YjVxcDBEMitkRkFm?=
 =?utf-8?B?blRpV3BHc3dzeDlDQlRnK1pzQTJMNktNNE4ybnFhV3dtNlBvV2lGemNnd21N?=
 =?utf-8?B?U1BNVE4rWWdQTVdEMUFXTnlkMW5XaW9kUFVOL0RVcjdBK2t3RzduWndYUEpP?=
 =?utf-8?B?VE1Ob1N4d3ZMWndiWEhsekkyWFBESlBvNDBidWhVL1pVUS96NHFBdENCMDZ5?=
 =?utf-8?B?cmZoSmNkN1BDNndUdVJqQURIN2taL0syNGVKNVlleEFzSlJzcExBTElKQzh6?=
 =?utf-8?B?NDRKMlRJSFJVYWJoZHZZUnpCSVdIOEZBZEVaS0JMbGJsVHg0L3BZMk9HdnFS?=
 =?utf-8?B?RkhUQUl5MklVRkNYNmVFeGEyV1MvUzVwcjdpK1NSSVNnZjU1QUlJZnR2TElh?=
 =?utf-8?B?b1JrMnhvSGx5NDhmUFE5NlcxbDdvNnIyQ0I4ZGxNZjMvdFYxTHBjYVBmVGRm?=
 =?utf-8?B?VW1kMjFTK1J6OFRSWXlBdFNsTTM3a0FQeUJ0V2t1QU1lSjUrOW0zQlZIYmYv?=
 =?utf-8?B?T0plenZ3c0g0aUtOM3R1TWFPMHRreUZzVGZFSjBBYmFiN0dDL25KeURiRHVy?=
 =?utf-8?B?djIranloRGcwcmE2OWdUbi9weWVoSUxydkI4OWpZZWhtMWZ4dC9jTUVGMEZS?=
 =?utf-8?B?Smc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29EF1C490A3FAB4CA8A1428E41F78BC6@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1331e71a-7d00-4197-fb9b-08dcb7bda1b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2024 15:20:26.9453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aV0e49MXH/vSfBDXiN+G7LNzgKOSChAuFNnJbsRP1G4IFaXXpJzaEUEJ2f00kBWSEVQQbV+oj4GHvY741JIVjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4392
X-Proofpoint-GUID: VyPU3ivFZM39RO2mL78NShKOezkotvFV
X-Proofpoint-ORIG-GUID: VyPU3ivFZM39RO2mL78NShKOezkotvFV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_15,2024-08-07_01,2024-05-17_01

DQoNCj4gT24gQXVnIDgsIDIwMjQsIGF0IDI6NTnigK9BTSwgUGV0ciBNbGFkZWsgPHBtbGFkZWtA
c3VzZS5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkIDIwMjQtMDgtMDcgMjA6NDg6NDgsIFNvbmcg
TGl1IHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBBdWcgNywgMjAyNCwgYXQgODozM+KAr0FNLCBT
YW1pIFRvbHZhbmVuIDxzYW1pdG9sdmFuZW5AZ29vZ2xlLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4g
SGksDQo+Pj4gDQo+Pj4gT24gV2VkLCBBdWcgNywgMjAyNCBhdCAzOjA44oCvQU0gTWFzYW1pIEhp
cmFtYXRzdSA8bWhpcmFtYXRAa2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4+IA0KPj4+PiBPbiBXZWQs
IDcgQXVnIDIwMjQgMDA6MTk6MjAgKzAwMDANCj4+Pj4gU29uZyBMaXUgPHNvbmdsaXVicmF2aW5n
QG1ldGEuY29tPiB3cm90ZToNCj4+Pj4gDQo+Pj4+PiBEbyB5b3UgbWVhbiB3ZSBkbyBub3Qgd2Fu
dCBwYXRjaCAzLzMsIGJ1dCB3b3VsZCBsaWtlIHRvIGtlZXAgMS8zIGFuZCBwYXJ0DQo+Pj4+PiBv
ZiAyLzMgKHJlbW92ZSB0aGUgX3dpdGhvdXRfc3VmZml4IEFQSXMpPyBJZiB0aGlzIGlzIHRoZSBj
YXNlLCB3ZSBhcmUNCj4+Pj4+IHVuZG9pbmcgdGhlIGNoYW5nZSBieSBTYW1pIGluIFsxXSwgYW5k
IHRodXMgbWF5IGJyZWFrIHNvbWUgdHJhY2luZyB0b29scy4NCj4+Pj4gDQo+Pj4+IFdoYXQgdHJh
Y2luZyB0b29scyBtYXkgYmUgYnJva2UgYW5kIHdoeT8NCj4+PiANCj4+PiBUaGlzIHdhcyBhIGZl
dyB5ZWFycyBhZ28gd2hlbiB3ZSB3ZXJlIGZpcnN0IGFkZGluZyBMVE8gc3VwcG9ydCwgYnV0DQo+
Pj4gdGhlIHVuZXhwZWN0ZWQgc3VmZml4ZXMgaW4gdHJhY2luZyBvdXRwdXQgYnJva2Ugc3lzdHJh
Y2UgaW4gQW5kcm9pZCwNCj4+PiBwcmVzdW1hYmx5IGJlY2F1c2UgdGhlIHRvb2xzIGV4cGVjdGVk
IHRvIGZpbmQgc3BlY2lmaWMgZnVuY3Rpb24gbmFtZXMNCj4+PiB3aXRob3V0IHN1ZmZpeGVzLiBJ
J20gbm90IHN1cmUgaWYgc3lzdHJhY2Ugd291bGQgc3RpbGwgYmUgYSBwcm9ibGVtDQo+Pj4gdG9k
YXksIGJ1dCBvdGhlciB0b29scyBtaWdodCBzdGlsbCBtYWtlIGFzc3VtcHRpb25zIGFib3V0IHRo
ZSBmdW5jdGlvbg0KPj4+IG5hbWUgZm9ybWF0LiBBdCB0aGUgdGltZSwgd2UgZGVjaWRlZCB0byBm
aWx0ZXIgb3V0IHRoZSBzdWZmaXhlcyBpbiBhbGwNCj4+PiB1c2VyIHNwYWNlIHZpc2libGUgb3V0
cHV0IHRvIGF2b2lkIHRoZXNlIGlzc3Vlcy4NCj4+PiANCj4+Pj4gRm9yIHRoaXMgc3VmZml4IHBy
b2JsZW0sIEkgd291bGQgbGlrZSB0byBhZGQgYW5vdGhlciBwYXRjaCB0byBhbGxvdyBwcm9iaW5n
IG9uDQo+Pj4+IHN1ZmZpeGVkIHN5bWJvbHMuIChJdCBzZWVtcyBzdWZmaXhlZCBzeW1ib2xzIGFy
ZSBub3QgYXZhaWxhYmxlIGF0IHRoaXMgcG9pbnQpDQo+Pj4+IA0KPj4+PiBUaGUgcHJvYmxlbSBp
cyB0aGF0IHRoZSBzdWZmaXhlZCBzeW1ib2xzIG1heWJlIGEgInBhcnQiIG9mIHRoZSBvcmlnaW5h
bCBmdW5jdGlvbiwNCj4+Pj4gdGh1cyB1c2VyIGhhcyB0byBjYXJlZnVsbHkgdXNlIGl0Lg0KPj4+
PiANCj4+Pj4+IA0KPj4+Pj4gU2FtaSwgY291bGQgeW91IHBsZWFzZSBzaGFyZSB5b3VyIHRob3Vn
aHRzIG9uIHRoaXM/DQo+Pj4+IA0KPj4+PiBTYW1pLCBJIHdvdWxkIGxpa2UgdG8ga25vdyB3aGF0
IHByb2JsZW0geW91IGhhdmUgb24ga3Byb2Jlcy4NCj4+PiANCj4+PiBUaGUgcmVwb3J0cyB3ZSBy
ZWNlaXZlZCBiYWNrIHRoZW4gd2VyZSBhYm91dCByZWdpc3RlcmluZyBrcHJvYmVzIGZvcg0KPj4+
IHN0YXRpYyBmdW5jdGlvbnMsIHdoaWNoIG9idmlvdXNseSBmYWlsZWQgaWYgdGhlIGNvbXBpbGVy
IGFkZGVkIGENCj4+PiBzdWZmaXggdG8gdGhlIGZ1bmN0aW9uIG5hbWUuIFRoaXMgd2FzIG1vcmUg
b2YgYSBwcm9ibGVtIHdpdGggVGhpbkxUTw0KPj4+IGFuZCBDbGFuZyBDRkkgYXQgdGhlIHRpbWUg
YmVjYXVzZSB0aGUgY29tcGlsZXIgdXNlZCB0byByZW5hbWUgX2FsbF8NCj4+PiBzdGF0aWMgZnVu
Y3Rpb25zLCBidXQgb25lIGNhbiBvYnZpb3VzbHkgcnVuIGludG8gdGhlIHNhbWUgaXNzdWUgd2l0
aA0KPj4+IGp1c3QgTFRPLg0KPj4gDQo+PiBJIHRoaW5rIG5ld2VyIExMVk0vY2xhbmcgbm8gbG9u
Z2VyIGFkZCBzdWZmaXhlcyB0byBhbGwgc3RhdGljIGZ1bmN0aW9ucw0KPj4gd2l0aCBMVE8gYW5k
IENGSS4gU28gdGhpcyBtYXkgbm90IGJlIGEgcmVhbCBpc3N1ZSBhbnkgbW9yZT8NCj4+IA0KPj4g
SWYgd2Ugc3RpbGwgbmVlZCB0byBhbGxvdyB0cmFjaW5nIHdpdGhvdXQgc3VmZml4LCBJIHRoaW5r
IHRoZSBhcHByb2FjaA0KPj4gaW4gdGhpcyBwYXRjaCBzZXQgaXMgY29ycmVjdCAoc29ydCBzeW1z
IGJhc2VkIG9uIGZ1bGwgbmFtZSwNCj4gDQo+IFllcywgd2Ugc2hvdWxkIGFsbG93IHRvIGZpbmQg
dGhlIHN5bWJvbHMgdmlhIHRoZSBmdWxsIG5hbWUsIGRlZmluaXRlbHkuDQo+IA0KPj4gcmVtb3Zl
IHN1ZmZpeGVzIGluIHNwZWNpYWwgQVBJcyBkdXJpbmcgbG9va3VwKS4NCj4gDQo+IEp1c3QgYW4g
aWRlYS4gQWx0ZXJuYXRpdmUgc29sdXRpb24gd291bGQgYmUgdG8gbWFrZSBtYWtlIGFuIGFsaWFz
DQo+IHdpdGhvdXQgdGhlIHN1ZmZpeCB3aGVuIHRoZXJlIGlzIG9ubHkgb25lIHN5bWJvbCB3aXRo
IHRoZSBzYW1lDQo+IG5hbWUuDQo+IA0KPiBJdCB3b3VsZCBiZSBjb21wbGVtZW50YXJ5IHdpdGgg
dGhlIHBhdGNoIGFkZGluZyBhbGlhc2VzIGZvciBzeW1ib2xzDQo+IHdpdGggdGhlIHNhbWUgbmFt
ZSwgc2VlDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMzEyMDQyMTQ2MzUuMjkxNjY5
MS0xLWFsZXNzYW5kcm8uY2FybWluYXRpQGdtYWlsLmNvbQ0KDQpJIGd1ZXNzIHYzIHBsdXMgdGhp
cyB3b3JrIG1heSB3b3JrIHdlbGwgdG9nZXRoZXIuICANCg0KPiBJIHdvdWxkIGFsbG93IHRvIGZp
bmQgdGhlIHN5bWJvbHMgd2l0aCBhbmQgd2l0aG91dCB0aGUgc3VmZml4IHVzaW5nDQo+IGEgc2lu
Z2xlIEFQSS4NCg0KQ291bGQgeW91IHBsZWFzZSBkZXNjcmliZSBob3cgdGhpcyBBUEkgd291bGQg
d29yaz8gSSB0cmllZCBzb21lIA0KaWRlYSBpbiB2MSwgYnV0IGl0IHR1cm5lZCBvdXQgdG8gYmUg
cXVpdGUgY29uZnVzaW5nLiBTbyBJIGRlY2lkZWQgDQp0byBsZWF2ZSB0aGlzIGxvZ2ljIHRvIHRo
ZSB1c2VycyBvZiBrYWxsc3ltcyBBUElzIGluIHYyLiANCg0KVGhhbmtzLA0KU29uZw0KDQoNCg==

