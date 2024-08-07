Return-Path: <live-patching+bounces-459-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E224994B1C4
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 23:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11FC91C20E2E
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 21:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C761494BF;
	Wed,  7 Aug 2024 21:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="OhPLNIgU"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF7C148FF5;
	Wed,  7 Aug 2024 21:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723064833; cv=fail; b=JYlLiD6oqq2rG/MuVK1zb9CTHXwwFNJ/GQlGt1GISoo0MxlNssr2X72H43Pfdjy1K1cF1jbG2VEeEk5wbbHkE6C1ElxPyHuamHS5q6yfJU7fott9KEcZiPF0H+g17UiqFae9wpUAXHqXstUv4oBiepTQJQKoaPplxcUgUdYbq/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723064833; c=relaxed/simple;
	bh=RRZTpMcex0aCLgG6NcPPqUIUY1s8S1uCjL8/RfPAskU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XRN2iNpkEOWD5ZDTm+kc8Lz7WJxL66B+1YS8X69XdlpD3Mk2F+ZcOy7upWTDV41LEoI6Eg0YjiXfT9Xxq6JduDAqROo2nTFz+L5wwitVYMxz4gKSMkkIl7iIh4jyyFnMtCe1Z5nGrYN6RntM/ZBeuHXSn2ek7hoDuGku/vfiz+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=OhPLNIgU; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 477JKQoT030909;
	Wed, 7 Aug 2024 14:07:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=RRZTpMcex0aCLgG6NcPPqUIUY1s8S1uCjL8/RfPAskU
	=; b=OhPLNIgUM4X2sINU52JdZ+D0gxn/wkAPpUWDBoPYBK1ueflPfWBPluycG3W
	SMlinDxJHad0jTo9FsjRG8YIswLTn/YzfDoHvxCBjEouST1OEOxKtLDymcQPUM2Q
	qvYwpr+DYVlkFJFZqytPpNO8MT+mME7fS2NLX1JTOVvEYPm1AwGlGhFM+aUlP/fz
	ZtNGRT7ytHFJD0kOMYQvB7g7WsZ1Q+nKGtuqQnKtRB483DaWU4EovT6MeAJ2JHPa
	yytrvLcquMyVRXAgziUJDAlmw9nGJLpGtT0GUtIar9PnxDqiFRaEq2tqi6DcQ+EY
	Y5bEUMjUt201oAbw7btUxu7TDpQ==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40v8spunee-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Aug 2024 14:07:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FyQF/xP2h2/+PaxCIcRzYgKMfFfSH8wHmM5wC3z4hOKeZuh+ZBJz9okDpg/2REow1oID8TvTHgaEG2Qj/iIbQSfM0LhNmFPdENjF/VdwVMcWe/jP+TGAZUcqJfB++uCX6x51eDot/LMpXNaTpS8sT1CEjrCW2mWG1soO9YeDMHbPEs24ULsgoxN0Gi5haAqfTPCdtakuyi2BApSdWdmXdbENoxxM1o/ImurTDQHaJsTVTiAjb52AEs2p5qEll8cPE3RBhdMt1DdZY8Lq1ach2fvSy0lBuYE+3kWzhUCp/RdnA1OVHC55WH644Oyu8mKyqWy1vqE92Fg8Ft2LgsUiFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRZTpMcex0aCLgG6NcPPqUIUY1s8S1uCjL8/RfPAskU=;
 b=xn61tffwhEuQJynu3NtXm9725tkj2QNoAswGLz+4jkwTLBi85snhxPwe/tSIsN4WMiNOuNkhk9mDvSLUlkcwneUULp3ZYh2acvJXlBaTg0ubH7vRWMLA1dS27VCEUGF09uUR6E56OKBos1tkT7qn1rVtqAlUJors5Of1LGpVca/ldGyA/OZtTIhb+lBOLmENwjrKp5GjHmNjhYh7QynP/AHQorLgOZxyw4bLJ3vFzqm+fCoTlePabyBwPRTYi1uDOoy2juAU8qrkPH3+R4ao/BpC3tEkZ8ItSshyYdXJ80Wgm6Yt+iAv/dMch1F01KRm2YwAeOXzrDnsD6cxlIIF+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BLAPR15MB3937.namprd15.prod.outlook.com (2603:10b6:208:270::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Wed, 7 Aug
 2024 21:07:06 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 21:07:06 +0000
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
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAAD/9AIAABNyAgAFZgQCAAAMegA==
Date: Wed, 7 Aug 2024 21:07:06 +0000
Message-ID: <D8A77DBD-5CB9-4FB6-986C-5B9C09FDA83B@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
 <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
 <20240808055546.9b7f8089a10713d83ba29a75@kernel.org>
In-Reply-To: <20240808055546.9b7f8089a10713d83ba29a75@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BLAPR15MB3937:EE_
x-ms-office365-filtering-correlation-id: 51a7063b-ccd7-489e-07c9-08dcb724e4cf
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dFAyS0hmYTNqMDhHc0tZRStEaDg4UWpoOUdPTWZpam1saEJLd3JDTW1DT1Ix?=
 =?utf-8?B?U0Npb0xlanp4REFmUC9mSDVDdkJoVGs0TEMvc1N2NzZSNGw1c2UzNXBlS3RB?=
 =?utf-8?B?ZlVadHFFWjFaSVd2VG1iZ3oyeDZQaUhDTTZybjJxS2hOQTNWeDJzUlNXaVd4?=
 =?utf-8?B?NlJWLys0cmgwNURyTkkwZ1R0NkxZVGZsTHZUTVBZVUJuWnBmNmV5RkpaSysx?=
 =?utf-8?B?YVFYaFMrN3hMT0k5WTVzam12a090UmNzNk9pbklvYnhxby9FOXgxcjlFc0Fx?=
 =?utf-8?B?RmNoSjh5SkdDd2Nqb2NqbUxHNHNUN3cvaUZtcUJmZDVqanJsNW1ta1NMd0Np?=
 =?utf-8?B?eU15Y2xZdXRVOGYrVTlBZTFyMnh3TmtOaTU1UFBSTHorNHNnZm1YQkNYamUy?=
 =?utf-8?B?QU9JOUUrUWJPaWNoOS80QXVIQk1ISVNza0x2aEZER2w3Q0J5NWZLaU9iU3Y1?=
 =?utf-8?B?TWhaU25hRVIzSVE2QlVpdHp3Zk1qck40WThpQ1I1OVRmcWhMbHlFL3pQN1Ra?=
 =?utf-8?B?ZWkvNFFNcUpvQW5KRGUxVFV4NXpxTlFoWERXb0liMjlOdS9wUE1hVytsLzJk?=
 =?utf-8?B?QVBQT3hYYXJQWEovMTZra0pLS09pcVF0ZFd4UHRPcmdOQUkwZHIxeHZlVDhq?=
 =?utf-8?B?NmdoZy9QdWF1Rm9nVzJzREFqOXFTZ1pnUUJPWjZzeVAxUGNtYlVjTGV6TW1s?=
 =?utf-8?B?ZVNvcGRtWlVTMkFWVUlxdWc3QU5DdDZvaXRFNkRVNFFSK0pEWWZWeTJRMEFw?=
 =?utf-8?B?U2c0bjZwb1hEMTBpMk1Ja2xwamJiREh6aEtPSTBQTHFjMU50VkRWN0VGdTJs?=
 =?utf-8?B?cXFYamJmeXR2Ym1BWmFmcTQxK0huKzV6eWdyalNMRFhpR1hhOEErSGV3eHpL?=
 =?utf-8?B?dW90VnpNZGMrUFpFZWZVMjN2TTY1aGVtUXFpY1JBV0liS0tpZmUzUm5BNCtI?=
 =?utf-8?B?dElycVo3VWhDWFdmM0ZRZVVRcmx3NkZRdkNIVVFraVRzNndkMUQza2cyWStl?=
 =?utf-8?B?anlZSnVURkNXa29BZzhLdWxqV0tnaUI1TFRFUUZJZFZGcUdyMnFIbnM4dlZp?=
 =?utf-8?B?ZlEzcHNsWTNsT21xWlo1ZmswTzdDTm1VZlJhUXU0Rk4wanJHTU9SVjlSejM0?=
 =?utf-8?B?NXBBWVNFcWRxeE00M3lyK1ZUQ25XWmtqWnNQQjBDck5ROURYYVg0WFA3WDlv?=
 =?utf-8?B?NzBSOHNRTTdJUzJNMFB2bFlkWUsrYUpvME4rSjJWTU1yVTAxRW9VSEtRZlRi?=
 =?utf-8?B?MWtOaEZ3TWl3NmdUeUpiVWUyTThFQVRWQlZUVkpLMjA0V0hCY2JTakl6WFZi?=
 =?utf-8?B?aDZYbEJ2Z0JtdGtTQkNicHRmcDdOQ1hWdktGazhSVGhhQ01xZ2ZPcmVqc0xu?=
 =?utf-8?B?bDVveWYrU1hyU3FoYzMvSXNwS1FkMEZhTHdka2FWRFUrczlUVloxNGxrY0Nz?=
 =?utf-8?B?MThJTEN1VktpczBUbTd3alVwZnZ4QURMN0ZZRHNkNmRyOGtFZDJVZXloUVB6?=
 =?utf-8?B?bG5XdmhSOWM1dU9pN1V6QTJ4K3V2akZoanBHTnhXdnNLdWdPbzN1V05OZEVX?=
 =?utf-8?B?Tm9ka2taRDl0aFFydUpsbFZLTWZWOFA0c2VhTFdUVTVreVVlWjRlNVN6bzRI?=
 =?utf-8?B?aWRaL2RpMHF2T2NoOWR0eHkxbU10V003SCtxRGRDTk9BT01zd2VyNnYrZjJD?=
 =?utf-8?B?TndYVWh3MU11RHduUjM4UWdsQVlYVTd1OFdUN1F1TzZiWFJHdncvNGRjc0sz?=
 =?utf-8?B?aWROTXRjTXczSGZYVFZKeEpWN29LNEF0UFpQYkFaU2ovTTFrZDdidk5HNHBE?=
 =?utf-8?B?anN5K1czTHB0MWJrNTlRamI5a1NmMjZ2cTUxZHFpQlI5eWl3Nys5WjVyd2lE?=
 =?utf-8?B?V0EyVFNnUTZ4bk56WnVZODJoK2d3MVlDeGlaQmFnZjNtTmc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ako4TkdUNmRDQUtYcHU5MWd5WGJGczNMZXY3TU5JdllGK2xuQ1BMZmhxazgy?=
 =?utf-8?B?cXRmUmN0T2VkV0dUeDRoWFJadnBjNUdXbEtJNjA4dUg3NzNQbVVkaUk2YjRY?=
 =?utf-8?B?bzgwRFBLZDBQcHR0Z0cxSXZ3R010M2V1b3JORDdFVTBBaGt3cHNxRW1KeHRi?=
 =?utf-8?B?RTlHZ1JVWXpxTFM3bXpXdWszODJZeG5JRlY3UXFSMXY3NDBXK2lKQ1I0VHF3?=
 =?utf-8?B?VkFlcFZGRmtid1FwSmhzU1krNWVjdzQxN0ZOL2JsbFV6eGowV2dKMHYyYnlx?=
 =?utf-8?B?VEZoelZHY3ZDT1pHdmJoNHdNa01qZEFNUGRiTDZRcS8xdGhvN0JUR2V4RkZ3?=
 =?utf-8?B?U0NML3c1MW4xQ0RaUERmRDNxa0VTNkQ3b2JkSGFjU0ppOXBHSmdKRDNCNU05?=
 =?utf-8?B?NHBKeHQyU2Y3bS9sTFVOZ0ZpeHhDVUtURWpXakhHbnFLOUo2Tm4yS1NFUlEx?=
 =?utf-8?B?R3RoTmd1NzhIQjl0YS9hcXY1dTkxeXMxRXRiNFY4SDdkV09FNnBvcTV3M2VS?=
 =?utf-8?B?bS9tajZ1Q2lkZjRNaG1UbVBqRkhNeTNCeXNrc0c1djNjN05NQTFVV0dVTlRq?=
 =?utf-8?B?cHlsZk93eUxhZi9tQ3NuU2JPMmZkQ2xCb3IvUGp4bUlMcE5Dc1FuRHpoREI4?=
 =?utf-8?B?T3lEVCtWQnVTb0RuRmtTSEc1dS9oM1YybkpRbWlnejhkTDlrOFVmaVhKZ3Fz?=
 =?utf-8?B?VDFEaWxGUFdvQ2RDd0lKV3M0QmhVdFQ3WllvTWl0V3Q1WkNPOWRERVBXRlU5?=
 =?utf-8?B?V1pPcWVtb1NFT2ttQnhPSXMxdmR4eXJnS1EzVGcxRjMwcEt4cHNXNnFROU9V?=
 =?utf-8?B?Vm5yUmEzTGh3QnRodGFEdmd4Z2FUa29VZGZQMXNkK2ZnVW9HQk9lS1NnSlV6?=
 =?utf-8?B?dkVSN1d3NEhHanFveHpoMFQra3pBcElrZ2JXMUJBRHZ3YzFDU3o4d204Mk1u?=
 =?utf-8?B?VUVOblVHOWsrZERuTEttSStFTjhkVzVyQWEyNlpLeGJHemVpM1BDclROMkh0?=
 =?utf-8?B?SGpMVjNBd1kyNmRVOVNCdGtqUVRiZEMvMkYxMHhZOG9pbUd2N3FLSVM2b3dX?=
 =?utf-8?B?RDlqemVDMkEzdm0xS0VPYmxSa1d5UWxqU25YdFVVRnYvZ01maXNQeCt4c3dE?=
 =?utf-8?B?dmdBZTBSTUNjVlJjZ0ozVjVIWndoMkI1SytXSUlZK1JGQzVWdHlxeTFDdjJT?=
 =?utf-8?B?WU9HTTNoMUlNRllNc2lBcERSaXJ5ZklkU3k3b3RvdE93ZWpYT2pGZ2N0YVNG?=
 =?utf-8?B?amlmVHFycmtMcWJ5ZzhVTGgrRWV4Yk15OWxsdWZDVTQwUVQraWYrR3R2Nzk4?=
 =?utf-8?B?SkpSY3R0MHpzQ0l5MW1EamJwZGhiOHBraTlYY2pEUUpSQ3djK0NFU1dIVzVE?=
 =?utf-8?B?TVBSL0hpeG9nWGF6YTkvcHJ4SUF0NExTRzFMMXRabzFWRkdLVTBMWjltKzBF?=
 =?utf-8?B?bngvMEppc3pCdFFMUVhxa2NUaHhwTHVhZmFSaG5sYSt3T2ErNmV0TXUyQmdy?=
 =?utf-8?B?MmdML24zanF3ZGlYU3hqZHBpNFZhTEFTRVNZZy9kK0dYb2Z2RTAwUzVqb0Rx?=
 =?utf-8?B?TDhuTUM1L3d6UUI5SmhaWEdxaDhBV0N0QzVwWThYQXFva3ZKNGZSY1NYcUU0?=
 =?utf-8?B?Y0t0Sm5IVnJ2enlUMGxMaVpraXNwVU1Hc0ZPdW1uRzNPbTgzc3E5Z3FkV3dq?=
 =?utf-8?B?MFNSNmRkWEVLR3hzdDhwaWpUemcrUDd5d3lOQnJmdjFxaEM0NS9vRWJSM0RK?=
 =?utf-8?B?OVI3ZE5ldENkN3ZodnI4aXVQcHF6NGhxbXBaRnVGb29ZVkpIVTc0V3ZYdUpk?=
 =?utf-8?B?cUxQWmZOcGNLWWRaVk95VjY5d1FPNGR1R0xHTU12RGVwTW1GMEVwcitlcmZl?=
 =?utf-8?B?ZDVVR0xyRG9sRUx3R08wNXU2ZzM0VXNpQjFwV0theXM0ZHRWc0hJK2pGU1Y5?=
 =?utf-8?B?UXBqb2owTGd2MjNwNjJ6QXlQbHNMQzlrQlQxYWRWd2Y4L2l6UHdyVkFlVENl?=
 =?utf-8?B?Ym0vSkJoQnRmMUx5VzlkSFI2NDIwZE00cEZNOGIvejdIbVFVSnpRL054eXFG?=
 =?utf-8?B?ODgrazN3dHVSRHhpNS9PdDE0dlE4K3RIVzkzZFhWaDZwVlZRYnYrNkEvQ0w4?=
 =?utf-8?B?NzB5VVMzclQzNjRLNTlqendJVUJwbERDMU4xVlhZU01NNkJGNXd5SGN4SFMr?=
 =?utf-8?Q?TUE7hriUIQaeGkMfYek7hjs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0931BE42D13BB4C9E7C73FAE69A92FF@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a7063b-ccd7-489e-07c9-08dcb724e4cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 21:07:06.5014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dMKQ+/5y8cV0LimK7TIt2gcsEN58E9YmbTa9BOxFMHdZBo5SLF9NE8KWI8EFZzX09ZpJ64gnZJJ9rJZ8otSD2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3937
X-Proofpoint-GUID: g7Ubxq57OBiM-HPBgB6SD5N3fyk8nk6c
X-Proofpoint-ORIG-GUID: g7Ubxq57OBiM-HPBgB6SD5N3fyk8nk6c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-07_11,2024-08-07_01,2024-05-17_01

DQoNCj4gT24gQXVnIDcsIDIwMjQsIGF0IDE6NTXigK9QTSwgTWFzYW1pIEhpcmFtYXRzdSA8bWhp
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
b29scy4NCj4gDQo+IEJUVywgSSBjb25maXJtZWQgdGhhdCB0aGUgUEFUQ0ggMS8zIGFuZCAyLzMg
Zml4ZXMga3Byb2JlcyB0byBwcm9iZSBvbiBzdWZmaXhlZA0KPiBzeW1ib2xzIGNvcnJlY3RseS4g
KGJlY2F1c2UgMS8zIGFsbG93cyB0byBzZWFyY2ggc3VmZml4ZWQgc3ltYm9scykgDQo+IA0KPiAv
c3lzL2tlcm5lbC90cmFjaW5nICMgY2F0IGR5bmFtaWNfZXZlbnRzIA0KPiBwOmtwcm9iZXMvcF9j
X3N0b3BfbGx2bV8xNzEzMjY3NDA5NTQzMTI3NTg1Ml8wIGNfc3RvcC5sbHZtLjE3MTMyNjc0MDk1
NDMxMjc1ODUyDQo+IHA6a3Byb2Jlcy9wX2Nfc3RvcF9sbHZtXzgwMTE1Mzg2MjgyMTY3MTMzNTdf
MCBjX3N0b3AubGx2bS44MDExNTM4NjI4MjE2NzEzMzU3DQo+IHA6a3Byb2Jlcy9wX2Nfc3RvcF8w
IGNfc3RvcA0KDQpUaGFua3MgZm9yIGNvbmZpcm1pbmcgdGhpcyB3b3Jrcy4gDQoNCkkgd2lsbCBj
bGVhbiB1cCB0aGUgY29kZSBhbmQgc2VuZCB2My4gSSBwbGFuIHRvIHJlbW92ZSB0aGUgX3dpdGhv
dXRfc3VmZml4IEFQSXMNCmluIHYzLiBXZSBjYW4gYWRkIHRoZW0gYmFjayBpZiB3ZSBuZWVkIHRo
ZW0gdG8gZ2V0IHN5c3RyYWNlIHdvcmtpbmcuIA0KDQpTb25nDQoNCg==

