Return-Path: <live-patching+bounces-1808-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D041CC08209
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 22:51:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 074C0406ACA
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 20:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEFAB2F9DB5;
	Fri, 24 Oct 2025 20:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="NF9dyLOj"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174FB13A258;
	Fri, 24 Oct 2025 20:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761338836; cv=fail; b=AmflHmwGlNtMCAN3Kl5doQ5Xr4v7TQ4PA4PKZaQlxdIIq/VlCsJckXxKOJYfMOEi9spSXNF9DWjZDuXMb728SPe9UKDNBejAxc/bJAcIcSWW1JJTgoouKQ14WaBAbEAbrYK/xcJ3sGm/AO/qUsM47nk/kl7pfxLfJJ9TGuMjlto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761338836; c=relaxed/simple;
	bh=pWtZKPHK1cUVtccxKH+G8WOL7Dkv3/c0WLiY/hCrslY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=amrrFPDB5vCVP69VW+qvzeYV7wCoBulDEnnpUL5gDR9oAwxdXlUi+6VDlOCGwFxABKv1rYaFdNtKTIDSZd3rcY5xLxgythQwOP54vD7vnXGYxBIwqKDG3J+SryFwx2VKD/XNmlFiLkXw/cHnBdQl+8vrKLlLFo3Y3q/THBRGll8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=NF9dyLOj; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59OFd4kF1068488;
	Fri, 24 Oct 2025 13:47:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2025-q2; bh=pWtZKPHK1cUVtccxKH+G8WOL7Dkv3/c0WLiY/hCrslY=; b=
	NF9dyLOj9ZQE13CYaoOHw3eayzlfJGUaymlDV0zKKKB82IQ0tyjS25WMTVzkPFdz
	oW/klH6B8dpIqgnpXezyps+cNTM0hXdNdm9HU6BjKsYQ+PbK3ahTasMiAX4oLwoR
	I/nkCCYVxajr7aPk+xPYjszscmOqHMSe7IuZWHjIIK1xNlvByIrh+zoIfS56fI9m
	qfYOgTdnMOT/m76QUZ5rXAqkb5FJ1pqhuXVAI+ZWjaBD3yM+7g2e/RbEz7UOVjWI
	OXRsUBHuIpmp8dchxmLgZxM5Anmp5tpyBBN00I5tfPuRwZ97NOlElYpOaMpCme/K
	zVdQW4JFWQM+lJGcnfN4Tw==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012015.outbound.protection.outlook.com [52.101.53.15])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a0c9ntfdu-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Oct 2025 13:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sHvTMg3+USdPVfCcGRLwfmsXxvQkycWAuszkj48HSsggLPCWiYDCrF8v0Fkda3KqbZHPVTb/UhHFRYZdwjnUAG+iaQqBEvSPec75RpOvdYFJ8oNXVfpxR+ZtuBmzK+TVEfnPgW94C0+8OEe0qU8eBiIhM7LddaRaoxGYekqha6P0JHCjmXrs9ymv2wR4UWDchdejthNj0Nud+Yis1QnGFmW4ESkGERDXdFol/g9FWHm8olbZAbJJH+bvBb0G+mIORheP6t/BxSE7RCBFzuBxqYEwkfofWmqP/8tIymgHba5nuN+Ekd5DoedEbyqnZNnPHC6YmswJU1VjqETOZwDsrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWtZKPHK1cUVtccxKH+G8WOL7Dkv3/c0WLiY/hCrslY=;
 b=hf/9JmnVBsIYy9VoRmXq36Qvbal79SMskZSF2mpry87IO/E70xEqLm0DSnz14HTb70mhB+43BCHUcc64chT4TLXKB1cW3MhpdnsbOafebLCRDAi22RZmhmUeeGb5zOTrAiLvTjB2lV9pcI8+g6I9AOuU+V6BQH8Yakz/L6VV4pH0efvYPY1yLzYU1I2yGMN30JssA6S/PeKRsoHEC07lol8xKcfctYaCqQz8w6/bBwvdSpzTEs38+/AvULZnNj28zzEZPwtYMK7tUiY+lQyKWEBTFz7BlKpanjf2/SLIXlM62GRyhORJOFeuWZal333ceomF0tbHR2gvki3lDU6sEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4573.namprd15.prod.outlook.com (2603:10b6:510:87::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Fri, 24 Oct
 2025 20:47:08 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 20:47:08 +0000
From: Song Liu <songliubraving@meta.com>
To: Song Liu <song@kernel.org>
CC: "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net"
	<daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "andrey.grodzovsky@crowdstrike.com" <andrey.grodzovsky@crowdstrike.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        Kernel Team
	<kernel-team@meta.com>,
        "olsajiri@gmail.com" <olsajiri@gmail.com>
Subject: Re: [PATCH v2 bpf 0/3] Fix ftrace for livepatch + BPF fexit programs
Thread-Topic: [PATCH v2 bpf 0/3] Fix ftrace for livepatch + BPF fexit programs
Thread-Index: AQHcRRQaecB0MO/YYkW70FMPDqTEArTRxIUA
Date: Fri, 24 Oct 2025 20:47:08 +0000
Message-ID: <8412F9AA-FEC6-4EFA-BACD-8B1579B90177@meta.com>
References: <20251024182901.3247573-1-song@kernel.org>
In-Reply-To: <20251024182901.3247573-1-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB4573:EE_
x-ms-office365-filtering-correlation-id: 678eb41c-8648-4883-2c3c-08de133e7fe6
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|10070799003|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WEM1NU9TMW5wZURzeUQvQ1VoUjB6dzJRWXdZdHpyclROU3BlaGJJQllLVGVr?=
 =?utf-8?B?V2RheXh2ckY0MXdnd0lMWnd1QTFHcGFSazJPUFlsY1FWcS9MbmVERkVHbkdX?=
 =?utf-8?B?QmRiVkFBMlVoK1NlWUEyd05NeEhQbnFvS0FHUjhzNE05aVNEV3VWMy9oK09W?=
 =?utf-8?B?TGJlL0hlNzM5S1lRN2QxNkxKSVFtVWpWN0lMY1hpRmRydzFRSURFWWI2RmNS?=
 =?utf-8?B?RC9yU1hlUmlvU1N6dG9EZnNZVVJ6OS9QNnBPWE8zay9yNEdDZFZCZUZaaExn?=
 =?utf-8?B?WmtNbXdyYkZNS3FaeEkwQXE5d0JOOWQrOTYrZHcrd2VtajRLbndtbE1jd1hS?=
 =?utf-8?B?a09LWnBPNWxSYkZDRXVQSlQwY1VOMkIvWTZlUXNHTXhKbnhHTjNrQkp1YVQx?=
 =?utf-8?B?QUtYWUNGcnVBbWxrK3hsTW9NTGtzeDA2RUtMNUlLUGZjWUdWakYwZUFNcnZo?=
 =?utf-8?B?aXQ5VGVTVkl4MDUzTjN1VUM5ZDBhdndwaEdlODFXQzB5ZFpMLy9TR1gybVhZ?=
 =?utf-8?B?NzFaejM5YmhBMkxXT08xMnhWWWRrMjdhc3pxaVdQN0JsQzBWUmtwb3ZFM1By?=
 =?utf-8?B?V1hyUWZjU0pJbGp5V0hSN1hYQ24yaUFoei9UTWYvZitiMEVSU0dZVkJaaEVt?=
 =?utf-8?B?cU5HbmwxcVBQUWNWcThQTjlFQXZsbFhrOHAwMVc4citmOVNzMXpUWW1wZlY1?=
 =?utf-8?B?eDZUdnZsUHZpclZTNmVubC9iREY3aEVuNFZPcnhxbSsyeXExeHZRRGVEQ0dD?=
 =?utf-8?B?d0VZcFdZU2JsL3pGbW1pSVNkLzB1WnhzYXdvYkQwbGJVRHdVbG5wMDhPbzk4?=
 =?utf-8?B?NFl2U1A2ZFRtV2pESGkwR2svQkJpRmV0WERoL0QyMHBIbXhOdWNzNDF2Qmhl?=
 =?utf-8?B?c2pqWis3R2RtNUg2UlVndjl1eGdlWU9Hbnh1YWtMUm51ajlkK3g0M1ZHVWI0?=
 =?utf-8?B?eEZkNnQ5RlVxUk1xdHBVZTNOaklJT0d0MU9HalBQRmo4SXB0VGsyZE8vNDlZ?=
 =?utf-8?B?QW82R2FZd3I0OTZtSnErUG5tRDUxK1V5UFM4c0VYTlhZaU1HemtlbURrQWVl?=
 =?utf-8?B?czdLRkFCd0ZFRVBHQ092aWR3VjF1amRSMEVZaGExazRZR2Z4OE5rYlIxMnIx?=
 =?utf-8?B?WVZPeFRacmJEeVBpUG1xUVdwOGNDZysyTno3cVhJTkNoWSthUE1lY3RlVTVJ?=
 =?utf-8?B?ZUZYR0p0SkVYQmJiM2ZwbkJTS3FJVkNUb3o0aHlMemM5bG5hRHJENFJHQjZo?=
 =?utf-8?B?SUNmSDljY3NRNzNHL0RrQWxtbkY0Y29CYmM4bnNqQjRqeTNnS3lWbGV2K0o1?=
 =?utf-8?B?TGdRZHA0a1FTSklyZTRDWnBXYmN3dDdQNmh0WmhTTVdpT3kvVTBMUVNwVm1z?=
 =?utf-8?B?UnNHLzc4NjNjYWhER3hOb2pVa0ZNVGg0NjFyb25PVnZ3dGF0d0lCTEkzWnl2?=
 =?utf-8?B?NEVzT1JkM1h5azVXRkpMWEx3cnRxQVFGVlZaaHVZOXN6K2FPMDVNUzE1RFYy?=
 =?utf-8?B?bk93NTFibVN6bUZ1L05MdzdjUkxzVmxSaWhWWlZMY2dRRHNLdjdGYzRQT0FR?=
 =?utf-8?B?c1NmZlVMK2tRclhoUXdSblhmd2tEWXVpOG9YZi9rREp1U0FONVlVc2tmejJZ?=
 =?utf-8?B?NTZtbmYyMHhOa3BqMy91WXdqRk5CQ1FnektnV3BmREVCN1FLemxUWnZZdWNt?=
 =?utf-8?B?OVg2Yy9KeDJpMFovTUpub2g0Sjg5RmtxTXU2a0JZL3kySmc0Z2g0MFlyY3lN?=
 =?utf-8?B?RGlWN3dWQlB2Tm9DaHpaYncvMTREZy9MaVdmVXVMV3RHRWdpbjI5SGxTdFRW?=
 =?utf-8?B?VmpmQ0JjczFyOVR3anY3VFhNOG9iaG1QYXF6ZTFBckxoTlZGbEhDSkRVN2xI?=
 =?utf-8?B?WHRsOHlIZDRxQ3pDOHRDQUcrRVRmbjRlaUNJdmc1RXpBVHROZ3M4WkZSSDlC?=
 =?utf-8?B?VnAvOTRKdFZ3MU1GWHVTYkhXS29aSUQ2TjdYYllGMHNtRGRpVk1jQXlPZUFZ?=
 =?utf-8?B?UGpTeTBtaXh3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(10070799003)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SWFUUlI2clhkK0ZKT0N0ZDJSM09RWTJIY3I5NXNNM25DSDZXZmVYdU9wOW1q?=
 =?utf-8?B?Y1IzT1pZNTdOVUx0U2phdVgzcFF2aHQ5Y2R0emVmSW5ZajllckY2M0grT0Qv?=
 =?utf-8?B?MVlMdXFCeHFYOXQ5NEdhUWZiU1IwMUNmUHBJYnRCcVdRVzM0MzRDVWdYOHFC?=
 =?utf-8?B?ZC81dFEzRGsyRTlqNVhLNjdxK2NXdGZ3a1owdE9CR21NckswOVE5SGRwREFm?=
 =?utf-8?B?UEFiSnhQZHZnRktpWlFZQU4zZGdmMC9SeXZyK2tqSmduSFptWWw5RUZMREpB?=
 =?utf-8?B?a0plLzlmaWw0cVE3OFBpamliSURYSDYzUnc5RFloL1FUcHdYYXVTKy92UkZv?=
 =?utf-8?B?VUtYUGJtcUdTdmR3d2ZUbkNzanpJVmNKcVQzUStVTllEWGxmclg5NFRPR2hB?=
 =?utf-8?B?SkxRR0ZmcTVDQWxDRlpSamkrOTZpRDFLVXNhUXU5T1MxWWFKRDk3dm1CL0Mv?=
 =?utf-8?B?TktSRzFGYUZFU2poOHVpSUluK2N3VTh1eEVrOG1nS0RkYURVOWJoQ09TNnJE?=
 =?utf-8?B?bkNoamtEb3U1NS95c0hMZ0Y1UlpIQ2FoVTUyQWxxRi9CaXRNbXlOMDlBOEZt?=
 =?utf-8?B?MFY5eENIeTMrdExOZTF2MlVPSzRmTzBLa2JKck50OHZ6QnU4Q0dndG9va29v?=
 =?utf-8?B?YVpwNlBNNG1iK1VOSDBYSkFXZndQOUtNUURQYy9zZFRqdGwwaDdnY2E4RXJz?=
 =?utf-8?B?eGpQSXEwdCtvUERPN0hmYUEvTFBidUxsWFNGKzJ4MkFjb2wyYTRHOGdaeGgx?=
 =?utf-8?B?RWhXUDhiSHNrZmFsdGxQdS9RQ3lIaDZBTjRaaWdIRE9mWkY1QzhzZEQzbEdP?=
 =?utf-8?B?RmtjYnVXQ0hyVEszeVlZQklzRjQ1NEU5Zi9JdEd3OEFBd3J1THdDNU1KZkZw?=
 =?utf-8?B?WUhRSFRIdmR1M281by9rcmxEcnpsZlNBaTBKRFhneGMvMnhNS3d2RWo5YVZR?=
 =?utf-8?B?eDcwKzl5eWhtNENnTk51YzlFL3diNnAzWlA0ZTlpWmRvZGpTcTk1MVhybUZ1?=
 =?utf-8?B?S2ZQNHFNQWFrT3lvRGRZRGJMRERkNHFyVGh4U1VqRkI1dUtZaEU3YmVlb1k5?=
 =?utf-8?B?eE83SUJWdkV0dzd4YXV4dUIxT0ZLeVNrTjZtRlBnbi8rRWNGUWk2K3J5MWNF?=
 =?utf-8?B?YmV2ZTJUNUt6UkovUDY1MmlwZmxFVzFZNG5uNDNBbEtBdXQ0QVZKQnJVOW1k?=
 =?utf-8?B?RXhLTCtOQ0R2QVUzdmhETStpOXVLbDhxK2J2RExtdWRGYklaRXJGVUZFVVpx?=
 =?utf-8?B?YWJRbGFDTHUwdFNhdHN6YUp0NkV4MkNjSGVvQml0OEhMR3hDUDVTT3FZZEZI?=
 =?utf-8?B?NXRtc1kzRGs3cThjbFEvcjJhK0hUc2hGLzZyVzNuQzFVRlFkdE9acGFFd1ZM?=
 =?utf-8?B?eHZxZE9GejNCTEZHajU3T1hGbXNoclhqMDhOcDBsMlRnY0JEMXBSWDJxZHlG?=
 =?utf-8?B?UW05WlhzS2xCTmpqVjUrL2N2eFVadGFzSWRWWTFTTm9NVGZHTmtYcDBpRzFh?=
 =?utf-8?B?a1BZQlVCRXFOdVF6cWVBWklPMXROdWRBWWlqbGlQNm1Db2hHYXZ1VjB4QXla?=
 =?utf-8?B?TzVONDlEZDdNZVBmcklCTURVZW9ndlVsVXF5N2dhOFVmWnhFOFVwQUI4VjB5?=
 =?utf-8?B?dUxHRXMxaitQSFlVTVlhUExIT01TbWVuZHptUFNDSUhjNFhDZGZJUkZDRDNZ?=
 =?utf-8?B?ODRKcjdnYzkxTDE0WFlvaWI2enJDazFmbHVrL2YyRVBpZWI5aWk4QjZPbDlB?=
 =?utf-8?B?R1RlWTJBajk3eDl2L1R6cGhMbHVOS1RwWFNiYysvR3QrV0dIbFlrRnBJZG1P?=
 =?utf-8?B?VUw1UmtBK2ZMUWV2bk1nc0VYOExxVHJKTEs1SnU3WEF4UGlOdTQwWGMrUWpL?=
 =?utf-8?B?Q1NhWVZyR1RVRjlxRGZlNUlHclZkSDFuYXJzY05sOUZPWUxWc2gyZVFheXZE?=
 =?utf-8?B?Qkt4bzVCam9TZm5RNFY2cnMyeUthQ3pSZHRHN09vc3h5ek5LcXl0TmN2enZu?=
 =?utf-8?B?Q0JTL1o2OEw3SmxsekF0Mk8zRlZtWjF1YnRic1hIOHVFRERNRGx1ZlhMa3dN?=
 =?utf-8?B?NVRtSmZMVjNXcklSL2ZJclZhdzNzVGVWdThTWGZIZGR3Ni9nV2xUMFlPemVR?=
 =?utf-8?B?TnFJTW80NEFwclRGTENjNFk4eG9scWx4ZG92Vm9CTHgvcXR5UDViN1lxcjNs?=
 =?utf-8?Q?C0Pb0PbbqKVJo2VOF7JMSJg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6432B6031BE0254DAA21F212AFB030B4@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 678eb41c-8648-4883-2c3c-08de133e7fe6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 20:47:08.7440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fz0rA/TQM4pqy32gAOhCn377ELMoiau661WrCgx1wF5E9TWxTLPlhj3YWAB29gEgHPEl3fGIgBPke71G7lZuZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4573
X-Proofpoint-ORIG-GUID: xYrxV7y8OCu-pP0-L278H2RMl9Qpw4fs
X-Authority-Analysis: v=2.4 cv=HPjO14tv c=1 sm=1 tr=0 ts=68fbe5d0 cx=c_pps
 a=0joluOkswiQ4lQw5hT3+aQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
 a=rSWsjG7SGlEph16kowYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: xYrxV7y8OCu-pP0-L278H2RMl9Qpw4fs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI0MDE4OCBTYWx0ZWRfX4cpM0QQiL4Q0
 4dYdYBozIAzhPLuUYmbpohluOPEvE4I1lF5RznmvOvaLJHL6mRiA62jN4rxBSCYXg3S//wZlu7i
 dsGZd+28XQTT8iI7+MSY67GYkilbiCrTLfdahOMHIs+4x75xsORZ/AXrJMYfeADo1949HAKeyBy
 4RrP9muhHh4dHHjE5eDpn3bR/crET/IFq4cNSWSh6x34Qm+8iJ4lKb24/H8rQo5Kfac36kO8UXI
 8wmNhrNa5BAvxEV396H3ehn1JCA+g8vOJaMfdYhYqTZe79VP4xVL+KGdVU6JrhS9c/8K+CLmTre
 KffGn/2g71xBcySb7Xbpc2eR6CgM7tJjUqblW7jOWrx8S7jxEMe4IIT2LnCCC0Kj0YXcDNWc26x
 nQbc5PyXJR1zf1VVSXZpILVoMQjgZw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_04,2025-10-22_01,2025-03-28_01

DQoNCj4gT24gT2N0IDI0LCAyMDI1LCBhdCAxMToyOOKAr0FNLCBTb25nIExpdSA8c29uZ0BrZXJu
ZWwub3JnPiB3cm90ZToNCj4gDQo+IGxpdmVwYXRjaCBhbmQgQlBGIHRyYW1wb2xpbmUgYXJlIHR3
byBzcGVjaWFsIHVzZXJzIG9mIGZ0cmFjZS4gbGl2ZXBhdGNoDQo+IHVzZXMgZnRyYWNlIHdpdGgg
SVBNT0RJRlkgZmxhZyBhbmQgQlBGIHRyYW1wb2xpbmUgdXNlcyBmdHJhY2UgZGlyZWN0DQo+IGZ1
bmN0aW9ucy4gV2hlbiBsaXZlcGF0Y2ggYW5kIEJQRiB0cmFtcG9saW5lIHdpdGggZmV4aXQgcHJv
Z3JhbXMgYXR0YWNoIHRvDQo+IHRoZSBzYW1lIGtlcm5lbCBmdW5jdGlvbiwgQlBGIHRyYW1wb2xp
bmUgbmVlZHMgdG8gY2FsbCBpbnRvIHRoZSBwYXRjaGVkDQo+IHZlcnNpb24gb2YgdGhlIGtlcm5l
bCBmdW5jdGlvbi4NCj4gDQo+IDEvMyBhbmQgMi8zIG9mIHRoaXMgcGF0Y2hzZXQgZml4IHR3byBp
c3N1ZXMgd2l0aCBsaXZlcGF0Y2ggKyBmZXhpdCBjYXNlcywNCj4gb25lIGluIHRoZSByZWdpc3Rl
cl9mdHJhY2VfZGlyZWN0IHBhdGgsIHRoZSBvdGhlciBpbiB0aGUNCj4gbW9kaWZ5X2Z0cmFjZV9k
aXJlY3QgcGF0aC4NCj4gDQo+IDMvMyBhZGRzIHNlbGZ0ZXN0cyBmb3IgYm90aCBjYXNlcy4NCg0K
QUkgaGFzIGEgZ29vZCBwb2ludCBvbiB0aGlzOg0KDQpodHRwczovL2dpdGh1Yi5jb20va2VybmVs
LXBhdGNoZXMvYnBmL3B1bGwvMTAwODgjaXNzdWVjb21tZW50LTM0NDQ0NjU1MDQNCg0KDQpJIHdp
bGwgd2FpdCBhIGJpdCBtb3JlIGZvciBodW1hbiB0byBjaGltZSBpbiBiZWZvcmUgc2VuZGluZyB2
MyB3aXRoIHRoZQ0Kc3VnZ2VzdGlvbiBieSBBSS4gDQoNClRoYW5rcywNClNvbmcNCg0K

