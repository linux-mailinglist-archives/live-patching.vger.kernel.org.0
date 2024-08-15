Return-Path: <live-patching+bounces-500-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 690C29537EF
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 18:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E923A1F26022
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 16:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A501B1417;
	Thu, 15 Aug 2024 16:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="YmphAaOE"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A661714CF;
	Thu, 15 Aug 2024 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723738157; cv=fail; b=NmPOP3ZfS2dsfld02jisoPQwtsl4n8hk1s2vrO5woOvW4EZCmJUOGQ0+y2NvHrRywrpkrosJSkL0eLqXa954P+LKU3CZH2GlaztOd/EYGgmd5FFRlHf1MjPe50+zd2/t9wdsWf1ZvO5uYi9vP9anX15/S9gSmilVmvkVrxLLYn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723738157; c=relaxed/simple;
	bh=ImJDkxv1QnHf92obe2/0kHSNhYzjEdq4c5mOJgaK74Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=an1tTKj77awwhoJvg0X3UA9WXwmqaA8aRMaL6IMpnAMwENdJyVO1w02Nsf01wWWaBhwyyAhLbHGu/adQ8H+tdT7QB8k+vaCRaKJmlnu6pkNq+1e1BZV7F/uMUDc6cJeapO16gSZEPalGS7vn92rVkD9swxaB4Z0LZMsdZDCrZSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YmphAaOE; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47FC2AqY020528;
	Thu, 15 Aug 2024 09:09:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=ImJDkxv1QnHf92obe2/0kHSNhYzjEdq4c5mOJgaK74Q
	=; b=YmphAaOEGLXsDVLc2TCjvfp5Tk2ET3GZrhWk3ypw7wvHEsjMNRq/WsU9TrS
	LaTJid3J0Fw7rHLBEGo8njf3G47nGfBJsaHF6CRL/t2Zs/TvsPGWGiv7L10Tegq5
	OgFiPq2Pthk9cMCDomUkkt1aBtMwY50QjC1gIfUr/XAprmeZfZd0f+mgJ2O4+wEM
	OWucJpgRkYj4IHzmIIVZDx1DfHHXBbQ6fxXfKdprr2Kycc4boXZiKR8HHuoNlULl
	aaCqWs2tgnpDEhXKA4ts3ixFBEKGuQ54f6GMdMC2CJc5PxEgxJuHaqmYpWayd5fy
	cAYbqbHiL2hfHzlkCZGHlSukJ5Q==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41140rctws-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Aug 2024 09:09:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xpEuf2fTTe5CLm6dJ86V3OpIDA+GBKnidfILwKYujZQjLVbByJN/qxRk7+vBj7TveG7CzsTP+71gBUb6eCDADOm9VNzLu7t1iZpjvTFAkbGNEaI+3mc1IbsXIfvUtgyjWZZCIDuVbln81xQK5Cx+E9apps5ZP/HreTkGqvCEqEvgCsuvhC7Ikx3nM8m9xi4Wzdv1kEWcKgo99/OBbp71L62ZGoVtnSLAWRa/rg8NhuKogcbb7flgK+fI00/TBBBCcjXfo0AC5m+XkkODbf9IAz2V1b4iWCOY9XRnApEFQ9GkDqTyei+QR1MlCylOK4UCkAKHOfYXA3Ao/jT1oO5Bgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImJDkxv1QnHf92obe2/0kHSNhYzjEdq4c5mOJgaK74Q=;
 b=S9xP8M90ynqtaVdcfxmGQFVipZLEdu1HhqGXeQgiXXXBbdurhnOTGBmjJ9zX4VaJF4a01VAurJ0sRPknY3N3ce3an4UGlxeZmU7QEn0zjqh9gD7GDqy0GF/WLATKReiMovSzSokbKcNVrgjtge61gzFOqQ1dkG63lYIXp54dGMt5JD0qhhFf2Lhtv9/StpJxnSEK2pUhlnYhWBE5JKWn0wZIYNTWu3uHg1BfIly1AHdKiO/77JBQDlKNPs5b0er9LUZo2rOi4up7xopgNfKFnKxcMtvp3YdrcXiK5OWxS4Ap1HvOZXP497UC35PnZbciwODGvT9HFHMCHyk1sdjugg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW3PR15MB3771.namprd15.prod.outlook.com (2603:10b6:303:4f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Thu, 15 Aug
 2024 16:09:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7875.018; Thu, 15 Aug 2024
 16:09:11 +0000
From: Song Liu <songliubraving@meta.com>
To: Kees Cook <kees@kernel.org>
CC: Song Liu <songliubraving@meta.com>, Luis Chamberlain <mcgrof@kernel.org>,
        Song Liu <song@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>, KE.LI <like1@oppo.com>,
        Padmanabha
 Srinivasaiah <treasure4paddy@gmail.com>,
        Sami Tolvanen
	<samitolvanen@google.com>,
        Fangrui Song <maskray@google.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        LKML
	<linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek
	<pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        "morbo@google.com" <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Leizhen <thunder.leizhen@huawei.com>,
        Kernel Team <kernel-team@meta.com>,
        Matthew Maurer <mmaurer@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Thread-Topic: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Thread-Index: AQHa6RXv/gSdKg0smE2fR+VNyjAMObIj1RMAgAAKOICAABUdgIAEk2oAgAAA4wA=
Date: Thu, 15 Aug 2024 16:09:11 +0000
Message-ID: <DF942C0E-A6FA-4482-8654-5779FEFC1B02@fb.com>
References: <20240807220513.3100483-1-song@kernel.org>
 <CAPhsuW64RyYhHsFeJSj7=+4uHBo7LucWtWY5xOxN20aujxadGg@mail.gmail.com>
 <Zro_AeCacGaLL3jq@bombadil.infradead.org>
 <5D28C926-467B-4032-A31F-06DBA50A1970@fb.com> <202408150905.97DAE1A@keescook>
In-Reply-To: <202408150905.97DAE1A@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW3PR15MB3771:EE_
x-ms-office365-filtering-correlation-id: c476acb3-8e57-4bc7-d408-08dcbd44999d
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?c2FSUUJSK01EWmxCek1YM255QlpUNEtZc0YyaWZsT0FwZFlTSDIyQTZ5T3dw?=
 =?utf-8?B?Z3N1NTl6SDdjWVY0cVJod05jNGZqcEpNOFFYY2ZxRXcrMW5ET2F3dWNnUFBV?=
 =?utf-8?B?SGc0Mk9LZGMvcXFlWTd6cnRuYjUvSlNRVXBvWUQrRkp3VFBlbFFxdVFSSmhm?=
 =?utf-8?B?dktLeVlnQ3lXbFdXZGlTRjhYZlI2V2s5S0M2ODd6OUxQandneTlyQVRNVzUv?=
 =?utf-8?B?WHdZM0FEeVAxYWhMV1IrZzFVTmNiYitRSDlHZEdOem5veEs0OWxvTGF0ckRL?=
 =?utf-8?B?dVVIdndTdlkxZENDUHBjaFZTa2ZXUjllWFNXYU5aNm9EaXVnRnpUeUlnR2cy?=
 =?utf-8?B?Y2s5NFlhTFJ4YVRkRE5OYzc1TlZZNXpCRkNOdklOTjN5a3RneW5ITWRJTmpS?=
 =?utf-8?B?V1QxUnJ3U2R0YmNvNS90MDc1VXR4aU54blNqRDhJeE5IRUdCOVYvdnUwRFNF?=
 =?utf-8?B?cDgvK0pEdFg3Zkh2ZVdsLzZGRzVlUEF1aHVEQVFyd3NkSTJHWCtxU21Wcmwy?=
 =?utf-8?B?Smw5Yk10MlQ1T043NVN2b05xVUhBT1FPV05wNm1JakVJRVNpUTMrQU53YUhy?=
 =?utf-8?B?OU40S3FvUXZXM1dsT3VSOU1hYkhKNTRGSVRPVWJhRnIrbjRTeWlJUUdzMG92?=
 =?utf-8?B?ZEt1VXZLWW03TkZPQnFBbVZGcnZCQ2g4SmFGMnVQRFYweWZlcTFacDdPR0pu?=
 =?utf-8?B?c0xwc0tOUXNHd1RoR2NKTUZQQ3pYb2t6MTM4TGE4bGFGaUNCQU9QdE5oQ3Qv?=
 =?utf-8?B?OHBZMnNheWUxbGt1Y3doLzJkUUhIZHFacUFJb0xhLy94Z1RJbDcxK2JCMnBR?=
 =?utf-8?B?Ymc2eHlLUnlpbDBVZWtOZUkxaFgzaSt2WkNnbkR3T1FqalNwSTZQQ3JMNENK?=
 =?utf-8?B?UVd5dVV1dEF1TUZJUzRUZWtua2VCOVJmdThMWlVqSDc3OWhOeEtPREh2cDBz?=
 =?utf-8?B?a0c0UGVvMFN1WVRxcHdVeHBOckdpZlF5cjlCL2dnR0hIT2lGdVpOQnIzSHlC?=
 =?utf-8?B?YStrVThuOUxVMHpxeG1oWFNqUG4xZnNBQXFFeVhVWm9CZG9vZDNoSWFuVkZ4?=
 =?utf-8?B?NkdwQ3I0ZGJ2dHdXK2hFNmpSQ3FSMjZCNTFkUTZwd3pBZ2crNWhuSG1KWHZo?=
 =?utf-8?B?dUVKYlFCdm50eXlKNnEvSk0veWpiSStHYVpFVUU5MWVJWXMwcm5qL1h2TDh5?=
 =?utf-8?B?NzlubWRLc2Rnd2JTQzZEWmowS2RqNW8xRjdkZEh1eHEwcWZDUDdUL0pQcUJh?=
 =?utf-8?B?eFhURk9KMGRYbE5VKzF0QnJGVjM3Mk5rYkgyZ005R1dUeW9EeHROUzlmVUJJ?=
 =?utf-8?B?a3RQRm00VDkvTGtRaWRFU054bFdFK0xsWFQ4aDBPSndzc2hSbDVlNWc0bVlY?=
 =?utf-8?B?WThnNnozUE9ybFd6MzZtdmlnUGhmdGlwd3B2ekVYU0RDdjAvSWdHMnJFRzZJ?=
 =?utf-8?B?eThjZkdJdkhvaDdXT2tWZWtNdzVjendoeXF3blNURkhvSDFvb0dYMXhsNDBj?=
 =?utf-8?B?S0hkNjNyU3pCTlJYZzBUcGRrbFpRY1IvZHVDOXMzMUpJajZQZTJ2elBybW1F?=
 =?utf-8?B?ZzNjb1R1ZjlWRlFyKzdYOW8wSUIxTkJuRnlKWlgzb2F3S0JwelpxMVJHSE92?=
 =?utf-8?B?d1hRakR4eHBMa1ZqeTF6ODI5SkhRSnRNWUwwRWlLMUYwbGl1SUNQTkVoaFFl?=
 =?utf-8?B?TGliN1FWS1JJVktPOERNZXBoUFJSVitSZ2t3T0FyYnJtTHdQb3I0RGRFdkFB?=
 =?utf-8?B?OFFGcHd6TDlPRkpWSVc4cWZsVDJNeDZuVUcxcHM3VG1MbWVSTzJwa2Z4NW9Z?=
 =?utf-8?B?Sk1WY3orMTdHN3o5NDl2ZmVwMG5WTkYraExhRUJuaTNRTlR5dVlTUjNwYnRB?=
 =?utf-8?B?NWhtQlNmR1h2emtWaWZadmxlMzRtZlpGU1ZraHBqU3NVSGc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?alE2dlhsTEdzbDBNb2wrZFF6bnBtSHdQT0s1dzlxaElxWk44MUg0TDFPRnY5?=
 =?utf-8?B?TVFISWdGb0VvNXZIN1dlclZiWncrOWdyUzVFSSs4dWFEeEZFditJbWNWbktS?=
 =?utf-8?B?cUdpK0I5VXZ5VzFmMGtwT2I0dG1uV2xGUi8zWmhaWkJveFl3U0JmNjBMTnZt?=
 =?utf-8?B?T0JBNGpwanpzV3VyZEVsV2F1QVM5ek15SGw2V1pWaE85Mm50Sm5EblVjNnUr?=
 =?utf-8?B?OUtYK2xFZytPeUY3NnNBSkY4THJiZUlROHVZcGFJUlcyV0ZzcVBaRk4rUHcz?=
 =?utf-8?B?MnQ4eDJoeUd2TXVYcXB4THpqUTBHMzVJdldRc1ZiRGhvcjhYd3Vkd1pUcFdx?=
 =?utf-8?B?SG9pdlhyTTRxbHZaWG5wWEViT1RFNUt0UlRHUk0wakxwaGpZQzFYMW9oMmkr?=
 =?utf-8?B?YW9NTnMybHVCRHBrWDhOT1hKTmwyWC9kYjRuU1RHejlzNUU4M2p6aDFtVmp3?=
 =?utf-8?B?bFlnT05BRUl4UnQxcDcreFgrNXJKY2ZFRFZNWng3RDZ1Z2tham1IK1VCVXZB?=
 =?utf-8?B?UkpPeTQ3VmhaS0xUSkI1YTBRNUtMbFA0NWk4d0RrN0RER1NzYnE2ZElRRXJj?=
 =?utf-8?B?ZDhSMGdWWWo3QXdDZ2xtRDQrdGc5Y3JzUDI3Q0NxNlNjT0V1V3JFN1ZwVXdw?=
 =?utf-8?B?S3h4cXlnS0lwaVpXeGZNV3FXblZHNUx0bFRUa1VwR1FCOCtKRG5qaDFWQ3NG?=
 =?utf-8?B?bFdoeUJ1VXYwekR0cWJNZzBwbkxCWVhFbnZJVFhnSTZtWmUxMkp1R0RDVzF2?=
 =?utf-8?B?d1lUbUdtZ1JvOW1BSmx3ZGsyQkVodE1ldEVPNHpDOTVKVjZudklZeXV1a0Jw?=
 =?utf-8?B?MFpCR0dOL2YwUjc0bllYSnpCVHBYb0ZaNDZJK1ZJY1kxc0Z1R24rLzYyTis4?=
 =?utf-8?B?VzJDNnVUbXB2ajlXeUZLNDRwUXN2blpJbVJvTVAyK3lJNHVYOHFTM0NIbWMz?=
 =?utf-8?B?RHBwZUZnU3NEUTJwTFQvVjQ4N2w3SGpDZDBzQXhHUSt3QnJWWnl6S29nZElv?=
 =?utf-8?B?SlRQbEJITWZQNVlCMitMSW5hckdYK3VxdnpzcDJlY1cycHU3bytoTUxBS0VC?=
 =?utf-8?B?Ly9UZnViNEF0TThsRk0wZk52TXFpcDFvZm1xV0FlaWt1eDhzL04wOWVRaVVL?=
 =?utf-8?B?YmJLVFlBVnpVWnFrOVAwUUtsdDBTSEhVQTU3L2JMWUludmZ3OWcvVjhNK3VK?=
 =?utf-8?B?MWpWZEY1R1NNQ0tOMDRIMmtDUGk1NVlneFZlc1doNWxCK3ZxQ3hNRlBHVU0v?=
 =?utf-8?B?UGhaRU5sazM0aHZjZHg3QXc0aStGdW8zaDh0RWNKVFR6eVZFSldCNzBVY0pM?=
 =?utf-8?B?ZTJmY080MEZTYUlMKzBPNzNBOG8xaHB4emZ3STJiaTB3R2Z3OW9kaUhjQkhy?=
 =?utf-8?B?WThoaTF4YUV1NSs0aGhrcTVoM3BMam9yY3JhYitKc3ZQUkVNNFcwUXlSam4y?=
 =?utf-8?B?K3RhOStuQlNkTHViVlF3T0t6aDRDSzJwYzFZNkhQVDJQY0ZudkluNXN5L1Jj?=
 =?utf-8?B?Ulp5UUVjUUkzcHI3bERDTzNna3dHMU9IOGpIMkF2bG5DWXE4KzZjSGluRG92?=
 =?utf-8?B?MTZmSDdVZzIzOHJyV2JlSmRnK2crQ3JaQUdPY3FoNS9mWTRWM0tXaW5QVTFF?=
 =?utf-8?B?VlpmeU41dnZrRnpGZ21pajlkQ0VnK0x3R0F2Kzc2T1hVY1NmQzBuQzJmZGJF?=
 =?utf-8?B?RVVTcGVMaW4waVFhVVE3YzdZeUY0RGZOSE9heXh2Y0E1dW5aUU00dFRQSmFo?=
 =?utf-8?B?SXN2TXlYUG1QN1VPYzFFNXpDWjJTWmIvTUY1d0NxaWx5UWliRzhvNTNsaCtm?=
 =?utf-8?B?UkVqK2hha05wWlZHT0xqdTZDS0ZlNkNaL21IanM4MFM5TXFpNG80cC9FNEh4?=
 =?utf-8?B?WW5wUnBSNk5kQ2dsSGpHOU1abGRwckhMRVJHTGxQODdOUDRQRmE1cWpHUWpv?=
 =?utf-8?B?NzFUSEdZK3dzczcxaTNWYkVjaXFHUzVSV2pFUGFBY3p4RVlucnpTQVBIVkxw?=
 =?utf-8?B?Rjh4YVlDWGlCUUoyVGxZYzJDa3VPRGdlVEZSSjZybGJJV0dSbk11Z1AxTGhl?=
 =?utf-8?B?TVNmdnhYb3dBUzhLTGNEM3pJeVdJTXB1bk1VWnJaZFZZTjlEK3piLzBBd1Qr?=
 =?utf-8?B?TUY1ZXdDMDRmNTNTUUpkYS9YMzJwb1VoOCs0T01JazRROEF3R3crTnJ6dGJT?=
 =?utf-8?Q?3SO5xf45gR5PPPi9AerN2lI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B651745EC077FE44B9E37E4CB638C8E0@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c476acb3-8e57-4bc7-d408-08dcbd44999d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2024 16:09:11.1881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eeFVY1B6LYm10l+PcMnepw7u0LOBDhuG4JJT/9NzddJmMVRDi/4MFcio+vFhSjRF64p21CwQ4Y9utx3lGTlZeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3771
X-Proofpoint-ORIG-GUID: JEMa32dPevK1Z8BYMihRDP6hqzgyXTQO
X-Proofpoint-GUID: JEMa32dPevK1Z8BYMihRDP6hqzgyXTQO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-15_08,2024-08-15_01,2024-05-17_01

SGkgS2VlcywNCg0KPiBPbiBBdWcgMTUsIDIwMjQsIGF0IDk6MDXigK9BTSwgS2VlcyBDb29rIDxr
ZWVzQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gTW9uLCBBdWcgMTIsIDIwMjQgYXQgMDY6
MTM6MjJQTSArMDAwMCwgU29uZyBMaXUgd3JvdGU6DQo+PiBIaSBMdWlzLA0KPj4gDQo+Pj4gT24g
QXVnIDEyLCAyMDI0LCBhdCA5OjU34oCvQU0sIEx1aXMgQ2hhbWJlcmxhaW4gPG1jZ3JvZkBrZXJu
ZWwub3JnPiB3cm90ZToNCj4+PiANCj4+PiBPbiBNb24sIEF1ZyAxMiwgMjAyNCBhdCAwOToyMTow
MkFNIC0wNzAwLCBTb25nIExpdSB3cm90ZToNCj4+Pj4gSGkgZm9sa3MsDQo+Pj4+IA0KPj4+PiBE
byB3ZSBoYXZlIG1vcmUgY29uY2VybnMgYW5kL29yIHN1Z2dlc3Rpb25zIHdpdGggdGhpcyBzZXQ/
IElmIG5vdCwNCj4+Pj4gd2hhdCB3b3VsZCBiZSB0aGUgbmV4dCBzdGVwIGZvciBpdD8NCj4+PiAN
Cj4+PiBJJ20gYWxsIGZvciBzaW1wbGlmeWluZyB0aGluZ3MsIGFuZCB0aGlzIGRvZXMganVzdCB0
aGF0LCBob3dldmVyLA0KPj4+IEknbSBub3QgdGhlIG9uZSB5b3UgbmVlZCB0byBjb252aW5jZSwg
dGhlIGZvbGtzIHdobyBhZGRlZCB0aGUgb3JpZ2luYWwNCj4+PiBoYWNrcyBzaG91bGQgcHJvdmlk
ZSB0aGVpciBSZXZpZXdlZC1ieSAvIFRlc3RlZC1ieSBub3QganVzdCBmb3IgQ09ORklHX0xUT19D
TEFORw0KPj4+IGJ1dCBhbHNvIGdpdmVuIHRoaXMgcHJvdmlkZXMgYW4gYWx0ZXJuYXRpdmUgZml4
LCBkb24ndCB3ZSB3YW50IHRvIGludmVydA0KPj4+IHRoZSBvcmRlciBzbyB3ZSBkb24ndCByZWdy
ZXNzIENPTkZJR19MVE9fQ0xBTkcgPyBBbmQgc2hvdWxkbid0IHRoZSBwYXRjaGVzDQo+Pj4gYWxz
byBoYXZlIHRoZWlyIHJlc3BlY3RpdmUgRml4ZXMgdGFnPw0KPj4gDQo+PiBrYWxsc3ltcyBoYXMg
Z290IHF1aXRlIGEgZmV3IGNoYW5nZXMvaW1wcm92ZW1lbnRzIGluIHRoZSBwYXN0IGZldyB5ZWFy
czoNCj4+IA0KPj4gMS4gU2FtaSBhZGRlZCBsb2dpYyB0byB0cmltIExUTyBoYXNoIGluIDIwMjEg
WzFdOw0KPj4gMi4gWmhlbiBhZGRlZCBsb2dpYyB0byBzb3J0IGthbGxzeW1zIGluIDIwMjIgWzJd
Ow0KPj4gMy4gWW9uZ2hvbmcgY2hhbmdlZCBjbGVhbnVwX3N5bWJvbF9uYW1lKCkgaW4gMjAyMyBb
M10uIA0KPj4gDQo+PiBJbiB0aGlzIHNldCwgd2UgYXJlIHVuZG9pbmcgMSBhbmQgMywgYnV0IHdl
IGtlZXAgMi4gU2hhbGwgd2UgcG9pbnQgRml4ZXMNCj4+IHRhZyB0byBbMV0gb3IgWzNdPyBUaGUg
cGF0Y2ggd29uJ3QgYXBwbHkgdG8gYSBrZXJuZWwgd2l0aCBvbmx5IFsxXSANCj4+ICh3aXRob3V0
IFsyXSBhbmQgWzNdKTsgd2hpbGUgdGhpcyBzZXQgaXMgbm90IGp1c3QgZml4aW5nIFszXS4gU28g
SSB0aGluaw0KPj4gaXQgaXMgbm90IGFjY3VyYXRlIGVpdGhlciB3YXkuIE9UT0gsIHRoZSBjb21i
aW5hdGlvbiBvZiBDT05GSUdfTFRPX0NMQU5HDQo+PiBhbmQgbGl2ZXBhdGNoaW5nIGlzIHByb2Jh
Ymx5IG5vdCB1c2VkIGJ5IGEgbG90IG9mIHVzZXJzLCBzbyBJIGd1ZXNzIHdlIA0KPj4gYXJlIE9L
IHdpdGhvdXQgRml4ZXMgdGFncz8gSSBwZXJzb25hbGx5IGRvbid0IGhhdmUgYSBzdHJvbmcgcHJl
ZmVyZW5jZSANCj4+IGVpdGhlciB3YXkuIA0KPj4gDQo+PiBJdCBpcyBub3QgbmVjZXNzYXJ5IHRv
IGludmVydCB0aGUgb3JkZXIgb2YgdGhlIHR3byBwYXRjaGVzLiBPbmx5IGFwcGx5aW5nDQo+PiBv
bmUgb2YgdGhlIHR3byBwYXRjaGVzIHdvbid0IGNhdXNlIG1vcmUgaXNzdWVzIHRoYW4gd2hhdCB3
ZSBoYXZlIHRvZGF5Lg0KPiANCj4gV2hpY2ggdHJlZSBzaG91bGQgY2FycnkgdGhpcyBzZXJpZXM/
DQoNCkkgYW0gbG9va2luZyB0aHJvdWdoIHRoZSBjb21taXQgbG9nIG9uIGtlcm5lbC9rYWxsc3lt
cy5jIF9qdXN0IG5vd18sIGFuZCAgDQpmb3VuZCB5b3UgdG9vayBtb3N0IG9mIHJlY2VudCBwYXRj
aGVzIGZvciBrYWxsc3ltcy4gQ291bGQgeW91IHBsZWFzZSB0YWtlDQp0aGlzIHNldCBhcyB3ZWxs
Pw0KDQpUaGFua3MsDQpTb25nDQoNCg==

