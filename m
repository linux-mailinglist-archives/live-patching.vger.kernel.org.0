Return-Path: <live-patching+bounces-1822-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAAC1C0F8D5
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 18:11:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DE1419C1279
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 17:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF2D4314D19;
	Mon, 27 Oct 2025 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="f4G6uzKk"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA3B2D12EB;
	Mon, 27 Oct 2025 17:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761585076; cv=fail; b=hYEGNpt7g9zBaz2Jq0eGHKpYGOsGLfs1mcBW08MtyGWLgU4506UXHXOnQv1y+rpgqiF4DCDV1Fd6w3fGL5ebpK+TsM9gfiqug1Q5ZsT2BXcfbRKDqQDsQwDjEc0IjkSBqrkXbQ7MZkC7p3b4wLjt9/POj4l4GtayVn1rUwTBcNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761585076; c=relaxed/simple;
	bh=z2VBU40cQf04F26sxr5PHWju2Q20kZvWY/O3hBm+nXc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U2ymxHuZx4GSobQ92M8t7iYpd481rSLPhMIKd4gIRyZ95FShx6dEM45n8K/xqUZh9MZotseE42LGGg/Dt0+K4ULLoq5ONEUq3YRcEPRqOW6WXG3rFwA3fjF8BAZs/MIF4XXzugLE77irlfvkaIry01YkoShprGJfnORvo4k00eQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=f4G6uzKk; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59REkMtc3589299;
	Mon, 27 Oct 2025 10:11:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2025-q2; bh=z2VBU40cQf04F26sxr5PHWju2Q20kZvWY/O3hBm+nXc=; b=
	f4G6uzKku4MoiIo9V29OPphvJhWQZ8jikHSFtC+vZiEwxV5KoB6b133dEWPUvYUq
	VSFve+kIOhBrRKrXXUmVJGS3/i0ed8eXkNSJVepps6C3nObDKG10el3/cx/cwnfN
	KD8LimAjDTTFA96RgOlybZWoYBwy9yVZygKnY/a2V3FHmdFB/hvZmSIk5arZe846
	kx7ylT97de3q4eoZ/48zgSAKYBRp6C05QxQ9d3HclyUsNE7LnH3i8jO1A/k5QAys
	eqtse/KbtzVvXDOGfUhLCdqpdJOkHPSfMLg5WHfuCL1bmeHEDwi30hWZNF2/UxZV
	XRYPcbvof/OWDdwjPg3wcA==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013018.outbound.protection.outlook.com [40.93.196.18])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a2aswhd5q-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 10:11:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cCcHYq+JtQ+G3Drdup3L2Gt6eH9oHvKVUXBc7dWASB0nk0ThzK8HLZziGi/NsELysgzRpunvjQ9RsA/HDC25RRGPple58iKkBH9YJFR+9XcucmimlaRq1Ju4zmKUN858iySJodI+7svxAml7RgTBc9xQrRrdOqxS5auYJD3hR+e9JTvYYWX9WTJnS3/DQ1Rt7oNxV9vEsNvS6s6/H5ZcLCf8uq1dyTR4rpwW0xazs+MZwHs1sOqclL+ymi5Ph8bQbYVNcgxwwoDWFEjcRcJEW7mNXHu5R0tDQBo+ssH2AMH3HthbVxlaeLOLCTKe9INitrDj6D9dX3Xhx+FvHMwEiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2VBU40cQf04F26sxr5PHWju2Q20kZvWY/O3hBm+nXc=;
 b=qV1KqT2gsx3DAdYhgb4NFQ3NqCCDw7zucdqzTHjKNNUGm/oXbX4wNWa6SLxsLqY1bZVYJIy6wwZ2RwX0/Al/JCex+T8i3yk/vTvy2NZDeJAn5QIPrmU4BENcmQ2uUfj5AySD7TmXSc+mW79zBApbomfnCpeF5RGQH3kYGa94jA5xdI8sm0jFQ3G0LXHsI3VRtKfkO5wqDW15NFAUr52xKA6MOH5JiM7VcPcNd4FCYrgZtXxsXNdZ+kwlSk1gemdHN4ssP7DrFVC345OK74aW3XW56Q2djjuz6syIAVlvqcoX5bWOL/eLuB/RUvV84FlwAxDWZGIPLhBAxz2dmWSwRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by IA0PPFD47E330F9.namprd15.prod.outlook.com (2603:10b6:20f:fc04::b48) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 17:11:10 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 17:11:10 +0000
From: Song Liu <songliubraving@meta.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Song Liu <song@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net"
	<daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "andrey.grodzovsky@crowdstrike.com" <andrey.grodzovsky@crowdstrike.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        Kernel Team
	<kernel-team@meta.com>,
        "olsajiri@gmail.com" <olsajiri@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 bpf 1/3] ftrace: Fix BPF fexit with livepatch
Thread-Topic: [PATCH v3 bpf 1/3] ftrace: Fix BPF fexit with livepatch
Thread-Index: AQHcRrrMbVQld49egUuB0IkrNG9bN7TWOR+AgAACv4A=
Date: Mon, 27 Oct 2025 17:11:10 +0000
Message-ID: <9795A640-397D-4146-87EF-D748AEE9AB20@meta.com>
References: <20251026205445.1639632-1-song@kernel.org>
 <20251026205445.1639632-2-song@kernel.org>
 <20251027130109.4065026f@gandalf.local.home>
In-Reply-To: <20251027130109.4065026f@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|IA0PPFD47E330F9:EE_
x-ms-office365-filtering-correlation-id: 99f38192-1f31-4015-549c-08de157bd326
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cmFRVjRLdkNBSFU4QnJJRi82RDNsWHMrSU51ZERNOWhUdmk0TExjUEt0eVdK?=
 =?utf-8?B?eGUyZndQOWhvYWpnWlN2TUx6aDl6RDZ1VW1RS2xIT1R5emdhY0RTM0JUQ0hy?=
 =?utf-8?B?Vmp3aTRuZ0pKTlJsbWV5SmEramhIZy9aR1Q3dEMvcUFmYmJTc0lSNlcrRjU3?=
 =?utf-8?B?UzhGSUt2OUNja1BoVlZyQmVmZ3E4UldDc2ltdk8vQ0IxSVoySm9DYWRHUWlx?=
 =?utf-8?B?dC83SC9Qc3E5ckJ4dFEvTEhxbmVzdTFkWHgxMG9Ga3czWDdFWEE1YnBKVitU?=
 =?utf-8?B?MjA4TG94ZmtocERxelBUeWg0Z3AxWGVpSlcwcVE5NWltaVpENXNjZFVIb2JZ?=
 =?utf-8?B?UytnZWZ0ZUN6ZU1wWXd3VWZJKzhlK0EydTRNKzdaMkhLbmZnZDMxV01FcjBl?=
 =?utf-8?B?VzNjRG91aGxBNzlBRUE1cmRXd1BlZCtSMHdybzNlaXBwbjFnOXVRZUJ2S2NL?=
 =?utf-8?B?bFJUbmdRQk9PckZGd2R4WmFaQnlYZzFteEF1NlFkcFpUUjNhNG1xQnhJd3VP?=
 =?utf-8?B?Q2JqZnRPWG10MEpGbzMyekwrVG5SNzl2OG4zdktiUEVwWCtrZUQyVXFtUHVp?=
 =?utf-8?B?VjBnaGp2Q2JaWTlGQ3h1KzJ4SnV1aDBHLy91NHlGNXNpOHZtMEVkTnFodGxU?=
 =?utf-8?B?U1dOUDRJRm5lWTdSZ3RHcHZnL1c5Wnk4N0lGRXBtYzliY3EyQ2MyOWFISld2?=
 =?utf-8?B?RG5GejdqRzJOcnowQ3ZEWUVIMk1wQ1F5am1iQk85NUJIYkFDMUpaYXZLMmxL?=
 =?utf-8?B?VGMzblRUWVhub01sWnh6ZVN6bnl2SEZmSFhaWWVGdHl4UVlmVjd2aW9SbC80?=
 =?utf-8?B?Lys1R0VqTjkvQzhYUUlPbFM0RzNyVDJGVnlSZE9lNElQaTRhWnlBRlVUd09l?=
 =?utf-8?B?ZndrY2V0SjJteUU3ZzNsMzlyUXBCZmkycU1odXBGcUVnMEQxK1Z4REtIUmVp?=
 =?utf-8?B?Qm1lcGp6WWh2ZHU1K2dHQ2gxV0dOaldKRzBXeFlaRmcvclB5UzVJUXowOWhv?=
 =?utf-8?B?NVpJQTh4UE9GeDFKRTV0ekhlM0Z2VHlqaVU2MitycHphdldUeFlLUXN2ejRk?=
 =?utf-8?B?bmo5czFBY3I0TU42L1kvWXo4OUFRYUhpTS9hVUEwaEdVRjlkZGhrVmo1WVM4?=
 =?utf-8?B?b0JLeDBwek4rMUtRN29UNVZUb1l0eG5pOVVYRW5nNjlNZVl0bkdCaEFxUFhN?=
 =?utf-8?B?OUdiNmdhNVBGZkhJVjNEb0J5V29YZ3ZiblpNd0taUnJ1VWRWQzBHc3BIWjBj?=
 =?utf-8?B?Y29TVEZmZTFvTzFuWjVyYksrSFh6UXN0U0dBSDgxeXZjSGJqRnJ5M2k4Qjkz?=
 =?utf-8?B?OFppbDVjczlCVUdDbW9nOG1ZaTFkZHRQQzFJbWVJQjl3bFlnQmNmRzh2VlJZ?=
 =?utf-8?B?bElyaWlXcFRjQ0pBclFjaW1HVGQzZm8yOHlOdURBZlRTbC9WUytaWTUyaWVE?=
 =?utf-8?B?eTB4c3lmUlA2NHlhL3VFRFl1STg0YmRRL3N0UmtCRzdLVmdFWWtROWpQaERO?=
 =?utf-8?B?dEpBU0tJWUhRZ3UrRlhCMXNkR2V0c0pwN0ZLSEpXVURFaWpnZFYzT2N2aGRG?=
 =?utf-8?B?R09IQjlYcnRlZ0lxLzhnY2t5VndXNEpzUCtFd2dKMjh3VzcySWtYc3hJbklF?=
 =?utf-8?B?dlowZW5ocHRZRTYwbFUwNndaWXVhV3plbWswekVTbWE5V1I0blVaT0EvNXBN?=
 =?utf-8?B?a0k4K3NnTGJIY2FJREdlV1VxMW5UNUJQV2trUncvZEwraTd1UmxnbjJZV21o?=
 =?utf-8?B?UFNRNFdmQ2pVYTA4NW9rcTRPc05YNXVyUDQveUJsdE9QaEpkcnBpQlk1a3pO?=
 =?utf-8?B?QW5WSjY3WUVaMUlSTndrVEdTRVF3VzdxbWYzRGlFVEl1Y2tIandiSytHQ3I1?=
 =?utf-8?B?YjY2WmJVZlc5dTFUdjNXOFNNV3NPSG9lc3g3bEF1THJjdi81SDU4a2tGU0xo?=
 =?utf-8?B?QjFlRTFyUHZVdE9rTTZhcEhlZ2x1L09YeHE2UzJaYStScVNkOVNjaXFoeko1?=
 =?utf-8?B?ZXhobTE1L2lSK1lsNjU1aXp3bzZKT3JoOUYzaERIT1ZDMU8yUTY4QUpMRUk5?=
 =?utf-8?Q?AKDoR2?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dWdKMkh5UzhLQWRnck83aWxtNEtiakpsd09vSkM4dDdqVjBaNkN5ZmVGZnV3?=
 =?utf-8?B?c0U1MFNob1ZnZ1NIb1hTNGNlZVZ2N29YOTZzWGdsVjFSenVoVUVtMWRjU3k3?=
 =?utf-8?B?algvaytWTHNxR093L2RReHB1YlhVZi9ZellQcUZzK1ErTDAxYmNDa2JFemZx?=
 =?utf-8?B?Y0ptMmM0K292YnNXUGxZM1FDay9ieVBHM2RGYlFLOWRZMFZvMmN0ZG5iemhx?=
 =?utf-8?B?MkJiek5abVBkM3RqKzFld3BBSk9LdkdEWmFwMUFCT3pqaWNDUzZxU3FMUXFi?=
 =?utf-8?B?bW11K1k2M200ZDM1czF5dkFLdlNCK0Q0T0p1a1ovMCtsVWFEbHFLZmhaYWw0?=
 =?utf-8?B?SWxyK0p5MDBTb2gvQnVVMGRPU3hUS0xlbU1CUmp4WVpkUnphdWxXK3o0NW9Y?=
 =?utf-8?B?MTlrVTV5a1RKWXJISUx2OGhBeXhVT0d2eEVYNFYwbHdYRFVhS1lOWFhtcURu?=
 =?utf-8?B?ME01YXdNR1paVmV4cGVscjlSRzkrc1JZb3dyMzB1VnZ0b0JHQ3NwWnhvN2V2?=
 =?utf-8?B?MmovMlRPN0NzLytwQ1RxTE0yTWRXb2ZLN2RseXZYZHRmV2UzUGhhd25rckp5?=
 =?utf-8?B?S3duck9uVWlaVlBnUVNEMmVIT1pRdHhHdDJTRUFPazR5VG0xUWUrQjNsMS8w?=
 =?utf-8?B?Z3VYQ0cvSm50WG00NXg5MFJQckh3OStPL09VbFF0MzhVQ2d2NnRSb1NTN2hj?=
 =?utf-8?B?aE9mODkxQWdZcitKUFhPOTNrWWZodHUxQ01FemdRVHJDckZiejJ2am9haStR?=
 =?utf-8?B?WmxZMHRCc0h0K0s3YVVCNzBUZmVpNUZZd0t4R2xMbVN4aENza3c5ZGlkWEx1?=
 =?utf-8?B?UzJaUFA0dDgzTngvUTk2bzVUZ2M5K0E1WjVyYkhtcWpXcG1FL2wwRElLTzkz?=
 =?utf-8?B?TFJIeXloU3V0Q0lhZTRJYkN1SGFGTFdkeDlSM2NYUEg0RlUrcm1FcUR2d3Bs?=
 =?utf-8?B?ODlhMDhYOGFydmdFSzArSHhOWVVlVFp0QmQ2M2JOMjk2dHFqQTMybXR6Vm93?=
 =?utf-8?B?SE1XZHdSaFN1ZGU1dld1ZzUyUlBNUWVZTnAyMUNHbGhPWU5rYkxWYlBMY2tL?=
 =?utf-8?B?L256ZmpKMHpOSEFnWGlESkY0bWRKVnRoTFlkVjU5MkJPZ3NMNC9jQ1ZSOGI4?=
 =?utf-8?B?V1RTZzBXNGNadDNxQzRrWkdONWV4VWJyUjd0ZUMxNDFwaHNTNlE2Sng4QUxo?=
 =?utf-8?B?T1hCaTBZQldNVVJIcy8ydTdZMDZPaXU0emo3M1Q1N2xTRVkxMXVleXBObGdO?=
 =?utf-8?B?aWJnWURXNmZMZFBkRE5ML0VMeUQwUmFUNXRsMHJGOWdOaE5qTWZ6WlJOVktT?=
 =?utf-8?B?bk1oVUFxaHVJUDZOWEdNUmFnSUs5dGhPbmJZdDFKbFpSdWsycDZTWU9YbzJK?=
 =?utf-8?B?dFlyTmNTWUtVYXprZEc5czBBZTlQK3d6UW8yNmR2R3JiR1M0M2hCTDBYQSsv?=
 =?utf-8?B?Q0FtbEJpSi9LUUNYZjZhMTJPcHlvNC9EVU5HL3d5bHFnM1N6ajZ6azYvR1dj?=
 =?utf-8?B?VzhpOGVsNlF5WGhZUjAvbGRoSkcrVTdHK0ZUWlp6RFR2NTEzQmlUeWN2TUlw?=
 =?utf-8?B?eTF0RE5LQUhncjhCdzlNaW9yd1B6akIwSitYdXUvRnpnc3JjSFRjcVY4Zksy?=
 =?utf-8?B?bWhNaWFTRkFZZ1lOc2F5dHpoM3U3NVlHT1g5d0RPbTAyVktIRllERWpyU2hJ?=
 =?utf-8?B?M0g0QzFmcFBJR2tBRjFueDVOYjhucTZaeVVkWkU0S0NXV3ZKMUk0b2ljSVR0?=
 =?utf-8?B?ekxWZnlxWFV6c0lMWmVKOHhGakdXaitBZHplcXFtVmtHSElEeW5NckdyLy9a?=
 =?utf-8?B?dmI1b2U2bWlPQ2JsUVFES2N2M0QwTVlXOG1XSGxOa3BLa0tJNGVUVjVscmFn?=
 =?utf-8?B?TUN3emhEY3NHYUcyVFk3MXZkNVdmdVJsOWhJMHAzY1RCOGpsNGJTRWNaSjQ3?=
 =?utf-8?B?N0xaQ0FsaEErTXA2WFJJTDV4bGY5T2pWbU9zMzJ1aTlSbXFqZXRCamZ1ajk2?=
 =?utf-8?B?Rm9KQk40RG9YYzdaU1orYU9odTYraDM1SG9LL25JRXFsWDlzV1dwdDAwV1M3?=
 =?utf-8?B?dHpKK1BhcHkvS3JsZXJhb1FZSVJwNkVtQzVkeWJmcVpsSGdqMEwwOTN1UHlP?=
 =?utf-8?B?M3V0MlRya1Z2T0psNmZLa2VEb0lERDRvcENYc3BXU1l4QVV6MzZiUlYzcDF4?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68CACBBD6EEC9940AC6A8F1014A407D5@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 99f38192-1f31-4015-549c-08de157bd326
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2025 17:11:10.0340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FquHiPirhv76QdCLHrhqix406Ur+yr/GYqqDcDJjG8QOdleL4V+rM/DtDf9w4AlA+aGFQwNDIy89O7WOh392pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFD47E330F9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDE1OSBTYWx0ZWRfX1qkytCsbv3lI
 xpNshIn+zmbczrT5PjOnfMGSi5v2LgfwbMcqyGIEzYNNSHsa3/fzs7eJRlFtuJMAA4fQqAIZkN5
 LVUPij2ZTZkR/RSrWFa8vuChGI9mhviGXIXSlZ59aLL4qgeW5yFac1UGwdwIo91f8QvB2Xm+A26
 gkMmol259PLB5M7iPnp8k4oy7+HTfWkjumtUFL84p5z3oi4QsnDTsa/yuWrjXZuUpJoJ0VqxgkF
 ty6tKXuepXTkseLNKUBmh1DVELgjM9INfWnC8FgWG321sLtuPd2IGSiodtpaV/HD0wuYPPzVUSC
 jKtasadZYm/7wCpysqIgRCqiOWvGnqUOIvV4THSpnTFsgnstcEpLWJph99/HsQmpSMeIs7aIncj
 b9OdZwGFB5zNTsZBjOmmZyAoAUUqkQ==
X-Proofpoint-ORIG-GUID: cUU_Zbaz6uKrt241F8t_CKoElaHUNu8z
X-Authority-Analysis: v=2.4 cv=aNv9aL9m c=1 sm=1 tr=0 ts=68ffa7b1 cx=c_pps
 a=H/ESeL7FTwDXaNlIHo07Cw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8
 a=XuS_cIleqAqBKHKdNkIA:9 a=QEXdDO2ut3YA:10 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-GUID: cUU_Zbaz6uKrt241F8t_CKoElaHUNu8z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_07,2025-10-22_01,2025-03-28_01

DQoNCj4gT24gT2N0IDI3LCAyMDI1LCBhdCAxMDowMeKAr0FNLCBTdGV2ZW4gUm9zdGVkdCA8cm9z
dGVkdEBnb29kbWlzLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBTdW4sIDI2IE9jdCAyMDI1IDEzOjU0
OjQzIC0wNzAwDQo+IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4+IC0t
LSBhL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KPj4gKysrIGIva2VybmVsL3RyYWNlL2Z0cmFjZS5j
DQo+PiBAQCAtNjA0OCw2ICs2MDQ4LDEyIEBAIGludCByZWdpc3Rlcl9mdHJhY2VfZGlyZWN0KHN0
cnVjdCBmdHJhY2Vfb3BzICpvcHMsIHVuc2lnbmVkIGxvbmcgYWRkcikNCj4+IG9wcy0+ZGlyZWN0
X2NhbGwgPSBhZGRyOw0KPj4gDQo+PiBlcnIgPSByZWdpc3Rlcl9mdHJhY2VfZnVuY3Rpb25fbm9s
b2NrKG9wcyk7DQo+PiArIGlmIChlcnIpIHsNCj4+ICsgLyogY2xlYW51cCBmb3IgcG9zc2libGUg
YW5vdGhlciByZWdpc3RlciBjYWxsICovDQo+PiArIG9wcy0+ZnVuYyA9IE5VTEw7DQo+PiArIG9w
cy0+dHJhbXBvbGluZSA9IDA7DQo+PiArIHJlbW92ZV9kaXJlY3RfZnVuY3Rpb25zX2hhc2goaGFz
aCwgYWRkcik7DQo+PiArIH0NCj4+IA0KPiANCj4gQXMgeW91IEFJIGJvdCBub3RpY2VkIHRoYXQg
aXQgd2FzIG1pc3Npbmcgd2hhdCB1bnJlZ2lzdGVyX2Z0cmFjZV9kaXJlY3QoKQ0KPiBkb2VzLCBp
bnN0ZWFkLCBjYW4gd2UgbWFrZSBhIGhlbHBlciBmdW5jdGlvbiB0aGF0IGJvdGggdXNlPyBUaGlz
IHdheSBpdA0KPiB3aWxsIG5vdCBnZXQgb3V0IG9mIHN5bmMgYWdhaW4uDQo+IA0KPiBzdGF0aWMg
dm9pZCByZXNldF9kaXJlY3Qoc3RydWN0IGZ0cmFjZV9vcHMgKm9wcywgdW5zaWduZWQgbG9uZyBh
ZGRyKQ0KPiB7DQo+IHN0cnVjdCBmdHJhY2VfaGFzaCAqaGFzaCA9IG9wcy0+ZnVuY19oYXNoLT5m
aWx0ZXJfaGFzaDsNCj4gDQo+IG9wcy0+ZnVuYyA9IE5VTEw7DQo+IG9wcy0+dHJhbXBvbGluZSA9
IDA7DQo+IHJlbW92ZV9kaXJlY3RfZnVuY3Rpb25zX2hhc2goaGFzaCwgYWRkcik7DQo+IH0NCj4g
DQo+IFRoZW4gd2UgY291bGQgaGF2ZToNCj4gDQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2Uv
ZnRyYWNlLmMgYi9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCj4gaW5kZXggMGM5MTI0N2E5NWFiLi41
MWMzZjVkNDZmZGUgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KPiArKysg
Yi9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCj4gQEAgLTYwNjIsNyArNjA2Miw3IEBAIGludCByZWdp
c3Rlcl9mdHJhY2VfZGlyZWN0KHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMsIHVuc2lnbmVkIGxvbmcg
YWRkcikNCj4gDQo+IGVyciA9IHJlZ2lzdGVyX2Z0cmFjZV9mdW5jdGlvbl9ub2xvY2sob3BzKTsN
Cj4gaWYgKGVycikNCj4gLSByZW1vdmVfZGlyZWN0X2Z1bmN0aW9uc19oYXNoKGhhc2gsIGFkZHIp
Ow0KPiArIHJlc2V0X2RpcmVjdChvcHMsIGFkZHIpOw0KPiANCj4gIG91dF91bmxvY2s6DQo+IG11
dGV4X3VubG9jaygmZGlyZWN0X211dGV4KTsNCj4gQEAgLTYwOTUsNyArNjA5NSw2IEBAIEVYUE9S
VF9TWU1CT0xfR1BMKHJlZ2lzdGVyX2Z0cmFjZV9kaXJlY3QpOw0KPiBpbnQgdW5yZWdpc3Rlcl9m
dHJhY2VfZGlyZWN0KHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMsIHVuc2lnbmVkIGxvbmcgYWRkciwN
Cj4gICAgIGJvb2wgZnJlZV9maWx0ZXJzKQ0KPiB7DQo+IC0gc3RydWN0IGZ0cmFjZV9oYXNoICpo
YXNoID0gb3BzLT5mdW5jX2hhc2gtPmZpbHRlcl9oYXNoOw0KPiBpbnQgZXJyOw0KPiANCj4gaWYg
KGNoZWNrX2RpcmVjdF9tdWx0aShvcHMpKQ0KPiBAQCAtNjEwNSwxMyArNjEwNCw5IEBAIGludCB1
bnJlZ2lzdGVyX2Z0cmFjZV9kaXJlY3Qoc3RydWN0IGZ0cmFjZV9vcHMgKm9wcywgdW5zaWduZWQg
bG9uZyBhZGRyLA0KPiANCj4gbXV0ZXhfbG9jaygmZGlyZWN0X211dGV4KTsNCj4gZXJyID0gdW5y
ZWdpc3Rlcl9mdHJhY2VfZnVuY3Rpb24ob3BzKTsNCj4gLSByZW1vdmVfZGlyZWN0X2Z1bmN0aW9u
c19oYXNoKGhhc2gsIGFkZHIpOw0KPiArIHJlc2V0X2RpcmVjdChvcHMsIGFkZHIpOw0KPiBtdXRl
eF91bmxvY2soJmRpcmVjdF9tdXRleCk7DQo+IA0KPiAtIC8qIGNsZWFudXAgZm9yIHBvc3NpYmxl
IGFub3RoZXIgcmVnaXN0ZXIgY2FsbCAqLw0KPiAtIG9wcy0+ZnVuYyA9IE5VTEw7DQo+IC0gb3Bz
LT50cmFtcG9saW5lID0gMDsNCj4gLQ0KPiBpZiAoZnJlZV9maWx0ZXJzKQ0KPiBmdHJhY2VfZnJl
ZV9maWx0ZXIob3BzKTsNCj4gcmV0dXJuIGVycjsNCg0KTWFrZSBzZW5zZS4gSSB3aWxsIHVzZSB0
aGlzIGluIHY0LiANCg0KVGhhbmtzLA0KU29uZw0KDQo=

