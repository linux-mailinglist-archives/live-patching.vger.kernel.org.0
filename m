Return-Path: <live-patching+bounces-470-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C8694C0D0
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 17:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C1E8B26AA5
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 15:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B7118E776;
	Thu,  8 Aug 2024 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="c1PZRD35"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A63E18C906;
	Thu,  8 Aug 2024 15:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130295; cv=fail; b=NnTgnqslq7kVMH0TnKBnuXb/zDuKRYIyPIhvsBd8RlTE+59ZlWFA0+4ZPTrOA3NVam/hU/3Sj9+zJ9K+DYdlkb5K46xGR/ObnJcJ7kv5oRKhhaYtMlbew9lPc8HsQL1t8BxV6WhFiZlOkDqi+CPNehCu1cB0F+h+lnyLu3MMO9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130295; c=relaxed/simple;
	bh=FeNa0RufXNpLelPnL4EooKesYGqGdpvuJ/pble1alQY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cDgQnJmPBKQcJ3+cBGsYAcqjC8XnpSWhAjIPDGR1vt3repC6dJUg8W3iuUm6fVql3IV39S5gwBdqYdqWNQupuC5aQWPEwSemJayFb9DbEn2WhzhE9qc7rjwbEFK4Ttb7eOsfncdDLmWMfUGuGnWHgJRN511Ud5NOE19jYCslsIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=c1PZRD35; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 478Cq4Iq004882;
	Thu, 8 Aug 2024 08:18:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=FeNa0RufXNpLelPnL4EooKesYGqGdpvuJ/pble1alQY
	=; b=c1PZRD35PWmo5jM/LEx42qQ7f/CrAFVFVRtVuN80vRciuf028njitlqOSgJ
	3C1NFpNNCMwinDIFBUCUt7kom6wmUlWR3reIiMBf7pKWi7BPezlHWV5MYhdvHEnM
	vv6ovy9awVDP9J3dwLiHjxBEJTbkX7iryyrS7y3Lmn04zqcJhr4T0GskLcbbg9bJ
	AJpTM+zxjfbhIib1taDdDTI365CEvsFSLMcwHfB7Vj6oun8fupMuB7VR+N/5bLn9
	kWR0eispx/wMVt1BLNY+jfaxLmLMhVIv/AEF9ElNRt7VjiZM1fYvI5RnqAWp/fa2
	61zrsiI6aM0RqzqiA8txJR47/2Q==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40vjdr4maq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 08:18:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fckkKtMemYWyJ8mbRmdaN26Bi6cgmtVqYkn3oA5ymeYKOKPmDNZASKpCEQ/19k7nqz9A9E8L1Vp2jdxjpc86Z2eigNuUcpJQjCUgKzhWbksdLf7eVqt50pDOZ4ZsLmMd/1eOy4kCrOpxbhJyJVVDjKFEp0435DVM1CYgbvB9of1x/+Pa7Iq1PkS1XpAzuiIBO6Po+Wo9ytxloorcAJS3uciepDAzTRHDqg/DaqHwyiIMyUrfdBHIL3MXXhSzjbd3dyr+SH4BpSrFxPxzkTYF3hzU0q3LZxxGQ5cDWZiKsRLJfWfYzTpUmUeT6sEENC9+o3OdWazqAyncZnok0tvmtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FeNa0RufXNpLelPnL4EooKesYGqGdpvuJ/pble1alQY=;
 b=Pqh6R3xigz9cwMe3/d4fXGc23DjCrLhptkJVvnh2nm38vHAo7NZtBbad/US1Gjr7lX1dAhnHsF8/SYH76ZXE3iI0slBjVeDVnO698Dtspd0E5nJCWgqMLEQMXZtEpOBKBVrnBqKtP3828p1ULCkEEV5ts12r47Bk0j3zPum/UEmWgIB1X448IXzVIxIKUOhvG7wXo1qlzy5SvdT7dlE9n0NMAs/w0n1Ge9rN6AGIEUNu9z0y/A94FT9LHrwy8k2SOUeQXPoa7f5dDvXIVkZuDiK8yNgzTAbKa2WVwpBw5grd6poaX3cx0roxLXTx64KtQkRJ5Endv8xIsrv1hakx4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by LV3PR15MB6385.namprd15.prod.outlook.com (2603:10b6:408:1ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Thu, 8 Aug
 2024 15:17:51 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7849.013; Thu, 8 Aug 2024
 15:17:51 +0000
From: Song Liu <songliubraving@meta.com>
To: Petr Mladek <pmladek@suse.com>
CC: Song Liu <songliubraving@meta.com>, zhang warden <zhangwarden@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Song Liu <song@kernel.org>,
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
        Sami Tolvanen <samitolvanen@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Topic: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Index:
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAATqbgIAAUFkAgADrUICAAFv1AA==
Date: Thu, 8 Aug 2024 15:17:51 +0000
Message-ID: <5709F0A2-92BB-4919-BE0A-B1EC3B76E951@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <87F7024C-9049-4573-829B-79261FC87984@gmail.com>
 <22D3CE6E-945B-43C4-A3A2-C57588B12BD0@fb.com>
 <ZrSUcbOtNc18D8ax@pathway.suse.cz>
In-Reply-To: <ZrSUcbOtNc18D8ax@pathway.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|LV3PR15MB6385:EE_
x-ms-office365-filtering-correlation-id: d46a53af-7e5b-467d-c077-08dcb7bd44dc
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VTFaWFh3eExpa3VRV01ocE1aOXgyKy9ITVVxVmU3cnJWd2x2TExNdGJjWENs?=
 =?utf-8?B?YmR4Y1hBMTVNSEJnNXkybjJrWlpHRFU2bGgwVVFpUmM5YW5YQURRWHBIdVQ4?=
 =?utf-8?B?d3lhWW1BZ0xsdE0wT1RCT0dUK25reWVDK1dkcENFQmp1VUFqNkdCZ2I0M1VC?=
 =?utf-8?B?OGEyczc5MUMzZnl4WnQrYytwRUFKM056WUVKeDE4Yk5GcTdYd0JSaHBYTjRn?=
 =?utf-8?B?WGEzRG9yL0l1S3RTRndrUHBHc1VvdWErdkFvUWZZTEVITFJUbnpEZ04yT2F4?=
 =?utf-8?B?eXFiUXBwMVlwQ0hRYzVtZW1NbFRoSGFPUllmazl1RHNQaUx2TnBRV1ltNHNU?=
 =?utf-8?B?aUo3SXMwWnljak9jMDdwTlo2ZjU1OEk3WkdIMXlzelVrQ1J5OXFqc29rcWs3?=
 =?utf-8?B?cmMwVWRLSGJUQlRCVGhtY2pQSVZ6ajFPc29VKzBFaEZqVjJDSGtPdkxXRmdr?=
 =?utf-8?B?OWNiNUloNVYxaUJGT2ZkQmxQekN0VTBvVTRpTENtbzB1VkdOeS9aUVVZMzdT?=
 =?utf-8?B?MXZNMy80RWZoQmdHQThMaDhFWmVYQTkvYktlREkvczRVMDdoQXJXOTYwYjM3?=
 =?utf-8?B?amdhSkhCTVVoNmdCb3FkSURXNldBMk5HM3owRG00cW94OGVIdm10WkEyR05K?=
 =?utf-8?B?TGYwaUNqU3VGbmV1ejFlaWM4aUFFem00MThQRTd5aEhmSUdaSDB6ekJRL3I3?=
 =?utf-8?B?MHdkUFFPbDVWME9tSkIyck9MZzZmS08vMCtMZUVIVFdVRmpYenZKbVo1WlhN?=
 =?utf-8?B?U29MTG5CL3RZRkpYaEpHZGhpaG0vV2Q4STI0aTdleC9lVnlHU200VENQS1RY?=
 =?utf-8?B?dkJ3WklNS3NrcU5Vbm8yNEwwRzJidGU5M0dkYWxIQ2J1WmI3VHozSTRnc3ZE?=
 =?utf-8?B?SXhOUjVxQmdOanRCQWJmVHdpMHhUVU5mSms0YUxCYUw1S1hUd0E4UVNjSS9U?=
 =?utf-8?B?cGdNaEF5SXh3dHdOZzMva0JKaFBFTFpGM0FtSVAvK29UVmRTZzRxTWVBRVRa?=
 =?utf-8?B?b01Hb1VUSXV0bitvRVlJdVZocHE3ZkN6TU91UmhLYUtWakZMVGRlYldCcngv?=
 =?utf-8?B?M21YNkxzY2ZBNXdsUTFoRnkwa1oyajJZOFdjK2xBeC9oeldOUUdLQ01jQmxs?=
 =?utf-8?B?b2VpMUVKdG1sclUwTlh0NWZqWXhoUjE5blB4WHVoU2RYMVhiUGEyM2JHS01W?=
 =?utf-8?B?Wll5OEhEWmtlNWRwNmZZRGhFSm1kSVlHOEp4aDVBU2pUbzBGMGFuVm91S1BQ?=
 =?utf-8?B?aHNJbDlSWktlNWhmcmREdnRYNTRHamtBRWEvSGZrNkdQSncyY3pyS3BtS0oz?=
 =?utf-8?B?NTFjWWg4V3FoR0NRQW9aa3lCM2VDR1VMMGhOQ3ZTdU93dmhCcktvT3pCWjJz?=
 =?utf-8?B?c2lYMFVYb1haUHAxbGZDcGRYZmhtaU9ORUREMXY2SUZXenkwU3FrWGtoMVNi?=
 =?utf-8?B?anhLQlBNYXdjbWduTjhIeTI3MFdOMW95MGVXeXdKaVpmdEg5bWpaK2x2NjB6?=
 =?utf-8?B?c3BoaWtjTmxnQTZIU2dhMW9tQlY5Qmx2K091OFhnTXp3TnlhRlE3MFdSQWEy?=
 =?utf-8?B?TDlYRFczeWJqM3hERURuczlWZ2dnVXNrNzR2b3JpWEVXTXpjVTRCU2xCajFw?=
 =?utf-8?B?MmhWbFQ1eGJuWTNsamd0djIyMjIweWNRVTZmOThmaWk3aWFhTWNtNm9ZeFdw?=
 =?utf-8?B?S2Z5RlpySDFLSU1INy94ZUtUZFBPQWx5TUhiR05PQU9VVjdWaW1nMUR2Myt1?=
 =?utf-8?B?L2h3Z2VsK0RZcWZCTm9RUW91bWpxNFBmbXBpY3BsNWcvdVVNS2x3VTkrY1I1?=
 =?utf-8?B?eUw2M2tJb2tZL0h5YnJrSjJGazN5Q1o0Uk1tM1UwY0ZBbWdzMWN6Q0s3bnRN?=
 =?utf-8?B?S1hkS2NIYkVDajZsd1ZIVC9oeldjRG1lMVV1YlpudDE3ZUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eHhoaVh3ODQ5dU5mVDdWdXkzZ3poNk1Ea3JyZTR3N05pbDkxb2h6N3cxVThC?=
 =?utf-8?B?anVNSEVaRGNGNUNyYzI0QzVhZUNvckt0cGdzdXhYR1dXMW9LTUFTUW9EM0lF?=
 =?utf-8?B?OS9jMmcxVzJCa2k2MUpFSnhXMXpCaFYwS2s5akoySS9rbHk1Qk55WWlLUHBJ?=
 =?utf-8?B?NEE2eno5OFpHRnRzSWt1L3Y4dkdtZmxQK1BLaEdkOWpGK0JzS2x0S0FRcmk1?=
 =?utf-8?B?N1owZjBjbW0yL2UyaW51T2twY2RTclpubUJWRG0vWjd0S1UvZlQ4NGxOWUs0?=
 =?utf-8?B?ZHF1ZjlWaWdDQ3U0L2pSeHpkMzF0U2JjbTJCM0dJekNpNDkydWhBNVVBYVVV?=
 =?utf-8?B?aHlQTWxGc2hKcEZxcDFsMlBaa1B1VFpnVDFIODFzVG5Jb1h3dGNuOXpEOXJB?=
 =?utf-8?B?Uitoa2gvOW42aDRlYVREOWNXUG5DcU9lUjhSRHpGNTl3K1VJUm5tandFdHNT?=
 =?utf-8?B?NGtyZjNyL2pveEsrVm5nWHBoUHpoTkl0UmdiVVVtWlZOYnd1TXNZWHhrU1FB?=
 =?utf-8?B?MVlpNFZxZnU5eGJZOEhjRUFDS0czZzFVd29lUjFUSmFPZjdMdHBMbUQzaVFq?=
 =?utf-8?B?d3lJTStPeEh1NEg4dHIwVGZSMHcwNHF4TW9uL0I2QzJyY0dROXhGaGlhcmxT?=
 =?utf-8?B?MHd5TEU1UVg2YkRoUk04MW1KLzBETVFOcDQ4NW1SMzFXMnFGdVIwWWQybWcw?=
 =?utf-8?B?YUp6dEVtdHEyZFhCbmZybVYvQ3F0TkVNdjJYUURmUjZQTnJqdlEvVDhyOVRT?=
 =?utf-8?B?M2YwMGpwV05JUDA3dGZGSXJNTnVtemdIRGV5d2tiQnBiWEdVVDI0UlpnckZX?=
 =?utf-8?B?dHl3MFZHNERxTGVGdFh0LzlUbkFHRUNMREpBZ3Jyc1ZlTVEzM3QyNmJIV2k0?=
 =?utf-8?B?Ly9rdGwwVFdsZ2ZTUkdvbnkxcFpkWXF4TUxDYU5iTjM3WEdjY1VrZUdtMmJX?=
 =?utf-8?B?L2dHd2VVaFUxdHJLdFJFYU9nRW5nQVlNRkE5eDFKNUFFa21WVjN4K3d3SDJM?=
 =?utf-8?B?aWlWUEFaT2hldVFaUVBRcHRlc3dka250VFFFVGRUKzlZMTVwdThVZmJjUld6?=
 =?utf-8?B?TFMrRTRwakVMMUZxbjB2UWxyMTN0TTFZVFJkZ0tWS2dMQ2tjTzBybkhTbWI5?=
 =?utf-8?B?bmhJYXQzVm0yeWQwNWJoYUU3Rnp3RkR3SnB0ZmpTcE1QWlZJZkdhd1p2ZEF0?=
 =?utf-8?B?dWFQNFpoZEt0UzUvRjBLUmNCQjhUQkZUcERSSUo4ck0wTWpiSmpCVExNMk9R?=
 =?utf-8?B?N0trNW00SW9tT0duNnA1Ym15NXRDY3pzSWF0MDQrSTIrR29lVHNGVXBZa3ZH?=
 =?utf-8?B?OGdkWGw3YlQ2K3lVclpES0I5MnpETFJoRmJNbVVrRnprZkEvTE5oQ3VvWFNK?=
 =?utf-8?B?cktKcitIL2JvbzdJZmxPelFvOUYrNUwyWGtJWU5rQUQvZmpWNTJWZ2I5UzhN?=
 =?utf-8?B?dVRkZmRnQWFLbVcvQ3ZPV3M2TytIWVdOdUZ0OWMxQktEeDROVVZCcS95VXZP?=
 =?utf-8?B?RU1sOHJ6T3ZlSG9mcGtFdlkxbXg3cFBDc3VGVmIxdjJha0V3NjZGcVRzRHdI?=
 =?utf-8?B?ODBHSVMwSFZZSThpMmEvMXZod3l1NFNHK0hhZ25sL1RXekdDQ2hOM0ZVK2Jl?=
 =?utf-8?B?SEJEOXhXN0Y1THpKZVhBOHI3akErRm1TcHh4MXdxM0RqaDR1WFhlSVdlSExF?=
 =?utf-8?B?cnBIY3ZtMndhR2FWQk1XSHJSSThFeUhLRmpDVWVWWFJKTk9iQ3NQbkJHd3JE?=
 =?utf-8?B?WnFGaUFPSndvZzV3RXpXR1ZGb2NCcXBwYkJLMlhQOFJTazg0a09zQ0dRa3Fv?=
 =?utf-8?B?UnQ2YmJrdXk4aVErTkRsZnYzUnNlYWxCaTk1b2dyRldVSDVZS3lVRXl0MmtT?=
 =?utf-8?B?dzdEK3luMGp6aTZwKzZDcHpJWVA3elhxaVlXeGlpK1VzYXFOeEhRZ1NyMkYy?=
 =?utf-8?B?LzV3YnoxbjZicGZITmpLa2svRm5leGhZWWJaRmp6Z2FxRXdxV1NIcVFPWnF0?=
 =?utf-8?B?UjY5SE1vV2tNbS8rd2xjNGdoZW9GSTZTbENOL0VhQ2w4V1Y1bnREUUdxa0Nh?=
 =?utf-8?B?UlBQTmlqbTV2emRETGZqOGczam05QW5OaVFablFWTUJmcGEwUG5UaUZVWFli?=
 =?utf-8?B?eWx3SGhnQnNacW5HS05jQTdvc21sT2ZaRFdqaEY3bjY3QjRQZGNzRm9Va1Fz?=
 =?utf-8?B?U1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C113D038A6DF843B23EA4AD02342699@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d46a53af-7e5b-467d-c077-08dcb7bd44dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2024 15:17:51.1425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TovsJb3NSutQ7JNtkezRtP/RQskNu5id5Tbf/T+1lWd9yzb5DFE6EipsOpQ3/1TK5SQPDjAEQZ8/sRW2x2GzGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR15MB6385
X-Proofpoint-GUID: ZQWO9mAHk_OKA11YXep8rxREQjuUpWKE
X-Proofpoint-ORIG-GUID: ZQWO9mAHk_OKA11YXep8rxREQjuUpWKE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_15,2024-08-07_01,2024-05-17_01

DQoNCj4gT24gQXVnIDgsIDIwMjQsIGF0IDI6NDjigK9BTSwgUGV0ciBNbGFkZWsgPHBtbGFkZWtA
c3VzZS5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkIDIwMjQtMDgtMDcgMTk6NDY6MzEsIFNvbmcg
TGl1IHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBBdWcgNywgMjAyNCwgYXQgNzo1OOKAr0FNLCB6
aGFuZyB3YXJkZW4gPHpoYW5nd2FyZGVuQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gDQo+
Pj4+IEluIG15IEdDQyBidWlsdCwgd2UgaGF2ZSBzdWZmaXhlcyBsaWtlICIuY29uc3Rwcm9wLjAi
LCAiLnBhcnQuMCIsICIuaXNyYS4wIiwgDQo+Pj4+IGFuZCAiLmlzcmEuMC5jb2xkIi4NCj4+PiAN
Cj4+PiBBIGZyZXNoZXIncyBleWUsIEkgbWV0IHNvbWV0aW1lIHdoZW4gdHJ5IHRvIGJ1aWxkIGEg
bGl2ZXBhdGNoIG1vZHVsZSBhbmQgZm91bmQgc29tZSBtaXN0YWtlIGNhdXNlZCBieSAiLmNvbnN0
cHJvcC4wIiAiLnBhcnQuMCIgd2hpY2ggaXMgZ2VuZXJhdGVkIGJ5IEdDQy4NCj4+PiANCj4+PiBU
aGVzZSBzZWN0aW9uIHdpdGggc3VjaCBzdWZmaXhlcyBpcyBzcGVjaWFsIGFuZCBzb21ldGltZSB0
aGUgc3ltYm9sIHN0X3ZhbHVlIGlzIHF1aXRlIGRpZmZlcmVudC4gV2hhdCBpcyB0aGVzZSBraW5k
IG9mIHNlY3Rpb24gKG9yIHN5bWJvbCkgdXNlIGZvcj8NCj4+IA0KPj4gDQo+PiBJSVVDLCBjb25z
dHByb3AgbWVhbnMgY29uc3QgcHJvcGFnYXRpb24uIEZvciBleGFtcGxlLCBmdW5jdGlvbiANCj4+
ICJmb28oaW50IGEsIGludCBiKSIgdGhhdCBpcyBjYWxsZWQgYXMgImZvbyhhLCAxMCkiIHdpbGwg
YmUgY29tZSANCj4+ICJmb28oaW50IGEpIiB3aXRoIGEgaGFyZC1jb2RlZCBiID0gMTAgaW5zaWRl
LiANCj4+IA0KPj4gLnBhcnQuMCBpcyBwYXJ0IG9mIHRoZSBmdW5jdGlvbiwgYXMgdGhlIG90aGVy
IHBhcnQgaXMgaW5saW5lZCBpbiANCj4+IHRoZSBjYWxsZXIuDQo+IA0KPiBIbW0sIHdlIHNob3Vs
ZCBub3QgcmVtb3ZlIHRoZSBzdWZmaXhlcyBsaWtlIC5jb25zdHByb3AqLCAucGFydCosDQo+IC5p
c3JhKi4gVGhleSBpbXBsZW1lbnQgYSBzcGVjaWFsIG9wdGltaXplZCB2YXJpYW50IG9mIHRoZSBm
dW5jdGlvbi4NCj4gSXQgaXMgbm90IGxvbmdlciB0aGUgb3JpZ2luYWwgZnVsbC1mZWF0dXJlZCBv
bmUuDQo+IA0KPiBUaGlzIGlzIGEgZGlmZmVyZW5jZSBhZ2FpbnN0IGFkZGluZyBhIHN1ZmZpeCBm
b3IgYSBzdGF0aWMgZnVuY3Rpb24uDQo+IFN1Y2ggYSBzeW1ib2wgaW1wbGVtZW50cyB0aGUgb3Jp
Z2luYWwgZnVsbC1mZWF0dXJlZCBmdW5jdGlvbi4NCg0KQWxsb3cgdHJhY2luZyB3aXRob3V0IC5s
bHZtLjxoYXNoPiBzdWZmaXhlcyBtYXkgdGFyZ2V0IGEgZGlmZmVyZW50IA0KZnVuY3Rpb24gd2l0
aCBzYW1lIG5hbWUsIGkuZS4gZnVuY19hLmxsdm0uMSB2cy4gZnVuY19hLmxsdm0uMi4gV2UNCmNh
biBwcm9iYWJseSBkZXRlY3QgYW5kIHJlcG9ydCB0aGlzIGluIHRoZSBrZXJuZWwuIEhvd2V2ZXIs
IEkgd291bGQgDQpyYXRoZXIgd2UganVzdCBkaXNhbGxvdyB0cmFjaW5nIHdpdGhvdXQgc3VmZml4
ZXMuIEkgdGhpbmsgTWFzYW1pDQphbHNvIGFncmVlcyB3aXRoIHRoaXMuIA0KDQpUaGFua3MsDQpT
b25nIA==

