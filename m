Return-Path: <live-patching+bounces-481-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 008C794F673
	for <lists+live-patching@lfdr.de>; Mon, 12 Aug 2024 20:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AD5D1C20DAD
	for <lists+live-patching@lfdr.de>; Mon, 12 Aug 2024 18:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6DD18A6CF;
	Mon, 12 Aug 2024 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ZLPV8/mY"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E493189BA2;
	Mon, 12 Aug 2024 18:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723486410; cv=fail; b=lSO2hrDzSrRikHHB/A2HX2jik4SpYTQWUqg75+mi/FLvhiKs0DT/E1w1Bku4rpxu4NLdcjcqGtH3WBEiWOpWc69iE75EA1Tr07V8Dr72KajK37p/IKluHu0jzrisRUpZNj4QgINYtjiUmL+gIxV1ecbC3Z9WDAPaTh33KQWUXK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723486410; c=relaxed/simple;
	bh=UqF7zI360E1BQF6lf+i5AFOnCEWJgHsgQowNKQ6oaIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SndhbGNmNYqBh3XEAYjnC58NWQTULtZY9jTqi6bRJE1lhJ9QoJVVIN8XY+TCmDTxN+8NnZuOBZ7XkIfFIY4JxrtaW9BvcfuiuKsj1k4+iDORUeStBb+6RxXZY5fUl1yVojX9wc2j7Rl4nfMRVAkEPwGNXrN1rp20fg5WTWj8JPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ZLPV8/mY; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 47CI4xpD028954;
	Mon, 12 Aug 2024 11:13:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=UqF7zI360E1BQF6lf+i5AFOnCEWJgHsgQowNKQ6oaIk
	=; b=ZLPV8/mYFoccLdKaIUWDktizbViLDcRrEJcGEWz1UarK85LgAtE6v3SF2c4
	nO62BCSJkdkKwiHpc/R49oW9uAuAtEl6Jq7bXPhpUyYE5ICD6ZJTEZwMFIz3sIsH
	KAwfAFoXfWjkGO64hR2K7ve5n8kCcLKacwrqE0mKREl3GG4KJZOwj+RlqOWYJl37
	DxnNNCckqunHW5zta9+hkleA9RndmTY1zcIKqM3yE7/F8I5P5mYNEsmrZs+S6N6G
	GvPeCREV2RWdPsnvCaQY+tmDYDqlelHbK7k/tS0AIuKm1qi4Oy3n29GYjcxb93lw
	Q4j0dTWuOgqYNNoJG+n1R+gAvEQ==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
	by m0001303.ppops.net (PPS) with ESMTPS id 40x3vs2mc8-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Aug 2024 11:13:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fOnn4KRIv+0qDvWOQ3SBvvK9Tr4Ve11VYEewLcnPhwxSEmvyQ04cWC/20J/5qoANzmXPyj9IFIZO/QMLrAR3yaHmZQnPTVVnzH5gJHkjfG/r6/WyCCil83K+ThBCym4Xd6Yf2eRGNGO9NP0VKb/CiEfJLaelkeXSGyBRY0twOCEuJSJoxEdMPRkljrLcV4kVj5+QvStDVRZZcom7Gh5VOHGugCFcH2+E06ki3KuBXcnytTt1TcRD5JhLKR/BAGVoTGLh1lqKC3dRYgdp+59KT2iXw3VKGdgDRdyDJV6Y7wL+3lVABpKyaM4IGIEeOgrJ2i1PYkPKisBoaccXXZesPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UqF7zI360E1BQF6lf+i5AFOnCEWJgHsgQowNKQ6oaIk=;
 b=vcwnbLCEieaiCRnhbNCJi9RZHJhGTkJ1plfuUvCW7tjvFlp52lxGI8Gpq2VVXdPXj5pUiHJ7apTr97a7OJQG3oGv4YWUToDS0m3N24X4qFLdX1XNSnghCcg1NHQT1+zqTq7XcJNWaEgzPirHrliAh/aFXMA37qMWuISlpRD/CWlbgE94Xx6ArtrtISynazRUEryAvBzKbuWshN3tQnzmHjx3IccpDOk2kqkarD7B0pRr1hgvVP7GX/DtbldTiKIsNCSC/mQW5Aw+FZ7Nx5dF+Fae0OW175AUxAGUq8V2tFzYGdHxV1kSV0J8KRArBSxW/ehfTpl0Lkjv/pVHDvnKeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MN6PR15MB6344.namprd15.prod.outlook.com (2603:10b6:208:476::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Mon, 12 Aug
 2024 18:13:23 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7849.019; Mon, 12 Aug 2024
 18:13:22 +0000
From: Song Liu <songliubraving@meta.com>
To: Luis Chamberlain <mcgrof@kernel.org>
CC: Song Liu <song@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
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
        "kees@kernel.org" <kees@kernel.org>,
        Kernel Team <kernel-team@meta.com>,
        Matthew Maurer <mmaurer@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Thread-Topic: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Thread-Index: AQHa6RXv/gSdKg0smE2fR+VNyjAMObIj1RMAgAAKOICAABUdgA==
Date: Mon, 12 Aug 2024 18:13:22 +0000
Message-ID: <5D28C926-467B-4032-A31F-06DBA50A1970@fb.com>
References: <20240807220513.3100483-1-song@kernel.org>
 <CAPhsuW64RyYhHsFeJSj7=+4uHBo7LucWtWY5xOxN20aujxadGg@mail.gmail.com>
 <Zro_AeCacGaLL3jq@bombadil.infradead.org>
In-Reply-To: <Zro_AeCacGaLL3jq@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MN6PR15MB6344:EE_
x-ms-office365-filtering-correlation-id: a062a836-4261-428b-7b01-08dcbafa73cc
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZGNyU0pDUlVIcHhBdDh0VDJOcTJyay9lSUpMSjA2cEgxWGt2bnY1VHRRZzFR?=
 =?utf-8?B?aFcrdVFRRFY0Q3RROC9mOVJWY0FqTzNOU21KMHhuNjhPbVhvekZKL3BiUGxn?=
 =?utf-8?B?bnhmSERWYjZmSkZqaVVvbHlqNzlFY05WVFY1OVY4NTZiVFhaSkJYSXBOSUZ0?=
 =?utf-8?B?dlI2RWRYNGZ2S3Y4NEFaK3hVdnJZbjZGa2tGM1AyRnRDM1BneVo1RTYrSjF4?=
 =?utf-8?B?UUx0MXVlOUJFZ1ZpZCtUSnRKeEY0cmFEUUdtMGsyekc1N2toZEYwRHRsSkxz?=
 =?utf-8?B?UWgwa2Z1ZGVaaUdqUmMzMkJLOVRlQkFQWlVtTmlkaG5Zak5zQ0I4Wmgrazk5?=
 =?utf-8?B?bkRNak93di9DSCtKRGw0ZlRnYzM2YXE0bWpCZnNxNzdZekVGUjl3UFZKTS9E?=
 =?utf-8?B?ZGhFV0xobEpKTzNpNUR4dzNqU2dhSnZKeHhxaFhaR1grQW0vL25hSGpuRjA5?=
 =?utf-8?B?dXB0MmNMTmNNcDlyb0o3REJXSGhWb3pVRkMzbktQdFp1Z2g3Mm5DejUzMGZk?=
 =?utf-8?B?SFpEWjRiWDJra0VLUFArQ1FzNUJEb21iYkJKbTlVQ21qMDZtTzNLUDROeERZ?=
 =?utf-8?B?MW8reDRGWTJkOHZ2WWJSWi9VT2RUUnJtenh6Tm85NjNCUVd6ZlJtaWI0V3Ny?=
 =?utf-8?B?S1pMTXhOenN3dnlLaHh6NSsySXgzc045aHBoZ0piYlh2UFRZOEJmYWFmb3Fj?=
 =?utf-8?B?WVBLN0l4WEg5Z1RtRUxuK0MraWFNOXlLcno3MWVyVEZwQWRIRVRYQW5zaWpR?=
 =?utf-8?B?TW1oQXQyVHZiU1QxWGpnM3lTTzFYNmV4M2RkT2FIVlNsRmVrcHVtendud3lT?=
 =?utf-8?B?L2FobTRLd2lmZXNmRnFSenNhU0RxMXIzZkZ3cmFta2dlaE5OSGNyWkdNUU1U?=
 =?utf-8?B?RU51ZFlPM3kreUlqQ0JydmZrV0RLYkEweE5QNDltdE5tSERSRjcyei90eHRB?=
 =?utf-8?B?cE9xbUEybUJjYmdLZysxYzYxQTZkQzVnMVJTV0hMQkpJazlISEdhNHNta1Q4?=
 =?utf-8?B?TGVkY24wK2IyTGJMcnJsOVdJRjBoc2NsQW4xcEtReUdVd2VYNkZYQnBDeWpH?=
 =?utf-8?B?b0w2QWgvNGJXYVdHZTIzUk1nSU1vUU5QRFkvVWV2K2c4UjlBbEdWRTZiUzY5?=
 =?utf-8?B?cFk5bmVNSEVsYmhnSzJWT29iZEZUOVVKN05KRUJ6VTFUa3hjbGpQc3JyTEk2?=
 =?utf-8?B?eWNkZERwanZBQkIvSW5wSE1KRXV5VytaVzNmcUgwa3VaYVpuZllKWVRLTnVa?=
 =?utf-8?B?ZCs3TTlNb0l2Mzc4dlhucmlJaU5XRXlDYlFiV3Y2aWF4WjVNcy9qenBSRFRo?=
 =?utf-8?B?S0ZvekN6a1l4QmdnbWZLYlFOVm5pa2Y0RnFiRTh4NTNGYTR2NDBVZ0VSSHVG?=
 =?utf-8?B?WFFGTTJkWXd2R0dmaVNKSzExS1hQMDBYQXd5MDFrbjFsbDJYY3hPOEkreHhh?=
 =?utf-8?B?MlhWL01OY0thZ1UrL3pzZUloY2JuRFNDSXU3dlU4Uzc3dnNnL09hRmxHWmVR?=
 =?utf-8?B?Rldsc1ZSU0V1K3FWOW5DZERTNFJXMHBTMFkzQkxlVHVIL25wV0lSQm5yR1lL?=
 =?utf-8?B?ODZkd3V5eEhDRlo4bEJpclhtN2QwU3d4OVhpSnZmVWZKNkV4bDRBbXVtSHpE?=
 =?utf-8?B?MFBrZkx6ZmYyRlBqRU1EQm96dEIzSXFsQUptN21pVUs2NGg1UXJyZmFBeEpF?=
 =?utf-8?B?YWJxK3V0K3hCaUFQaUZGRjFYenY1ait4UUZqN3FsZm1YdS91aENBMy9aaTdI?=
 =?utf-8?B?YzhjM3U5K20xSTFmd21NQ04zZ2xPOFg2cWdvanFuZDR3RDNLNVRjL0dwSHJX?=
 =?utf-8?B?UUZMSUxWdmRtMjhENkszajFWL3NmYkoweVd5MndtcVB4dWdsaXo5bXZtYU1T?=
 =?utf-8?B?eWpGNGRaSnVFck56TTRpMjBYSEFLcDB4YktYTThVS1N0RGc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QzdLZitId283Qm50YnVMTjExRVZxOUZPSzVCY2hqN1loSHRnSzJEUCtaMUJL?=
 =?utf-8?B?b3E2MFhPbGQyZmF3a3B2QUZldE5WVnVzcTNyc3o1Wm1Cbkx3cEJrSFZ2cUtD?=
 =?utf-8?B?ZCtRM2ZQV0M5UGVzbGRyQ2VDU2VJZVVLY1F6bFFEVnJoRm0vZEFCa3pRVmlF?=
 =?utf-8?B?OFlnT28zZVdkeDJKMTRJc0VBWmFNTncvQnNqOTdhcVd3TGx4TStGYlFMekVN?=
 =?utf-8?B?LzBNa0krWGMrd0VOVXJXUUwrd0lGYUovRjlYWld6TWpBbGlNVGlST2pWcGht?=
 =?utf-8?B?S1ZYeWZTUUlkc3NWVEhoUzNqcVRaV2lNNFUzSFNkRnJjWWEzNUUyVUN3NmhY?=
 =?utf-8?B?bEF5WitiTFpCdGtUeS9BMHhIK3RoT2VQbEpTWXlqVDQwUWhvUGhkOXQ5WUgx?=
 =?utf-8?B?WW9iUTE3QkhNenNzWUVDc2twSVg2L2xKOENsTTg5Y2pHTUhkZitkczhFeWVp?=
 =?utf-8?B?aVQ1bVFoUTE0S3lEUDVxYTFvQ1R1NFJCcEZYeUtFZVVnSStMRS9CZjBmYmdO?=
 =?utf-8?B?VFdERUtxaXpHMlkzdHY1OVljc3hUT0FUWlQrOW8xKzZMM0RyeGxzTUJ3RUZR?=
 =?utf-8?B?NTR3VWdSbXUwcG51T2twQTdDLzJnWHFDcEI2RE9wQUlHQ3FHUDNwY1laREw3?=
 =?utf-8?B?MFF2d2tJZ2ZPbnFNc3oyVC9SSEd2UE82TkM1b3hGVnJ0V1dWc09GREZwNnNH?=
 =?utf-8?B?anlTbk1IbkJud2gwU0Y3Y0RDTGIxdjZpYVhGN0JLcVgvRklmM1ByMUxYdnFr?=
 =?utf-8?B?T2ZKRVlqTGxPcTFQTzUxcnd5aDJqU2xCR2NJRzc4ekF3QjB0REpXZUthSkRi?=
 =?utf-8?B?Slp1bklEQ2g2dFlXMjE5cDk4SGdoREEwb2dueStVR01zdGFZS042WG5qd1g0?=
 =?utf-8?B?ZnNtVG0ra3lNcHFVR3BZZHE1OXdBTVg3Y2ROL3QyOExya2lkRFpMejRPN09k?=
 =?utf-8?B?VW9hTjlOMjlDSk9FRlMrQVpKK3ByOHBTZm55b2d5QmNKdzFCRG8xQ01CV1lj?=
 =?utf-8?B?SzZuK1JLL0N1bHdYTTlFSWdpQzQwaE9Vd0J0ZkZSVUl4bHNMMTBjRkN5SzlG?=
 =?utf-8?B?aGh2R3N1U3dlY1dLNGpJT1QrTXhydXFHNktGQ0VhalMyQ1VWVWNXUmpuWTJh?=
 =?utf-8?B?eWtadFhlWmJNVEpkdmo3YnR0RmI1QlJSNlJOUGQ5OGQ0YkhJNStJQW54RFNV?=
 =?utf-8?B?aE1VaS8rWDdFb2w4K1krQllJcWJYSkR0OTFNU1RnbGpsdXdXaEdZWVFEMjZm?=
 =?utf-8?B?T0F1NkdRZkVDK0NNSW1tdzNkWkpqYjRjdUwyK1AvRXpLanJOWElsdU9UbWRC?=
 =?utf-8?B?R0JXSGdYZ3FvVWx2ZVF6ZTFhaXp2WDZSQi80dnZaS1VNTmRVOUdyQ0ZPYUJl?=
 =?utf-8?B?a2JQb2J6UXA0UmcwaHRYMkpBbTdNa054SDZabmUzQ3IzVlpOY01xVUxRSWVz?=
 =?utf-8?B?SENuQnhzaHk3SmI2UVhOdTZ5TVJGbWxONkVhQ2g3bkhFNW54MnpXQ3Z0QTQx?=
 =?utf-8?B?TXVmSVUxTllBWjN4MWEwTHJoeVljSnR5dzBPcTVYeUNGUGowVEplb0tTMlZN?=
 =?utf-8?B?SjdiVTJzZlRlVkljS0x6YkZZbXpOdlZoc1I2NkFyc2ZNQmlibDZoNHZOeTdn?=
 =?utf-8?B?Z3pkL01XbFBTdnc2aGpST29YK1ZEQW4rOThhMzdIV29seXQzT2MvaEI2M1Nx?=
 =?utf-8?B?Y2lTaFY3ekQ0TDNiQ055N0FuMnV2MmV1Ykp1R2k0ZUFMeGRvVFJSYkNha0Vv?=
 =?utf-8?B?MXRFOUdVaTNoRHVGbjAzNnJjWW5yT0RGdzVjL3JUTXRJV1lJU3FzWGZIV1Rm?=
 =?utf-8?B?SG5sbStmNWF0WFA2azBmL1FpM3hxODJIdmhuOStUL0FlK2hvMHg0bUlaMVBq?=
 =?utf-8?B?MjVhVXlqd1hMVkg2dGU3enBZNjVmOHZqTE1RMXdnN2hCOFhTaUJNSFJWZDBD?=
 =?utf-8?B?NHIwOFpKU0sxOWlrMlZ0WnNIKzM1VWwxb2d4ZysvOTRRUXhWb3ZjNWpBc2xN?=
 =?utf-8?B?VnVzd1RzL0lVeGV4SVRmMUwvOUI3akV6eHZZMGxvMUVTN1REM1R5N2U1dnpq?=
 =?utf-8?B?SGtYb2psT3U0cHBheHpVaVk1RTZyUEZGUkExM2x5cGYrRml4UmlMaS9XZ2Va?=
 =?utf-8?B?ZGZ6U1RzQU9nRDJTVDArWXo4b3ZmRWdQYmZLQTB6eElrZllramhjSlpPS3h3?=
 =?utf-8?B?OGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BAA4E4EE87DFC44A859E15631A325C1@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a062a836-4261-428b-7b01-08dcbafa73cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2024 18:13:22.6628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +TV9eBql62AJyLeWGa7kxyqPp+oFTdWVOIDqOcg2P5plcrmDTc2Hkcdf6Kts6PoGJMLYzM15eRN8PaLnxWKgMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR15MB6344
X-Proofpoint-GUID: 68JTCMOrPu7cFfbZJUSb-ZcvpvhUnECC
X-Proofpoint-ORIG-GUID: 68JTCMOrPu7cFfbZJUSb-ZcvpvhUnECC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_11,2024-08-12_02,2024-05-17_01

SGkgTHVpcywNCg0KPiBPbiBBdWcgMTIsIDIwMjQsIGF0IDk6NTfigK9BTSwgTHVpcyBDaGFtYmVy
bGFpbiA8bWNncm9mQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gTW9uLCBBdWcgMTIsIDIw
MjQgYXQgMDk6MjE6MDJBTSAtMDcwMCwgU29uZyBMaXUgd3JvdGU6DQo+PiBIaSBmb2xrcywNCj4+
IA0KPj4gRG8gd2UgaGF2ZSBtb3JlIGNvbmNlcm5zIGFuZC9vciBzdWdnZXN0aW9ucyB3aXRoIHRo
aXMgc2V0PyBJZiBub3QsDQo+PiB3aGF0IHdvdWxkIGJlIHRoZSBuZXh0IHN0ZXAgZm9yIGl0Pw0K
PiANCj4gSSdtIGFsbCBmb3Igc2ltcGxpZnlpbmcgdGhpbmdzLCBhbmQgdGhpcyBkb2VzIGp1c3Qg
dGhhdCwgaG93ZXZlciwNCj4gSSdtIG5vdCB0aGUgb25lIHlvdSBuZWVkIHRvIGNvbnZpbmNlLCB0
aGUgZm9sa3Mgd2hvIGFkZGVkIHRoZSBvcmlnaW5hbA0KPiBoYWNrcyBzaG91bGQgcHJvdmlkZSB0
aGVpciBSZXZpZXdlZC1ieSAvIFRlc3RlZC1ieSBub3QganVzdCBmb3IgQ09ORklHX0xUT19DTEFO
Rw0KPiBidXQgYWxzbyBnaXZlbiB0aGlzIHByb3ZpZGVzIGFuIGFsdGVybmF0aXZlIGZpeCwgZG9u
J3Qgd2Ugd2FudCB0byBpbnZlcnQNCj4gdGhlIG9yZGVyIHNvIHdlIGRvbid0IHJlZ3Jlc3MgQ09O
RklHX0xUT19DTEFORyA/IEFuZCBzaG91bGRuJ3QgdGhlIHBhdGNoZXMNCj4gYWxzbyBoYXZlIHRo
ZWlyIHJlc3BlY3RpdmUgRml4ZXMgdGFnPw0KDQprYWxsc3ltcyBoYXMgZ290IHF1aXRlIGEgZmV3
IGNoYW5nZXMvaW1wcm92ZW1lbnRzIGluIHRoZSBwYXN0IGZldyB5ZWFyczoNCg0KMS4gU2FtaSBh
ZGRlZCBsb2dpYyB0byB0cmltIExUTyBoYXNoIGluIDIwMjEgWzFdOw0KMi4gWmhlbiBhZGRlZCBs
b2dpYyB0byBzb3J0IGthbGxzeW1zIGluIDIwMjIgWzJdOw0KMy4gWW9uZ2hvbmcgY2hhbmdlZCBj
bGVhbnVwX3N5bWJvbF9uYW1lKCkgaW4gMjAyMyBbM10uIA0KDQpJbiB0aGlzIHNldCwgd2UgYXJl
IHVuZG9pbmcgMSBhbmQgMywgYnV0IHdlIGtlZXAgMi4gU2hhbGwgd2UgcG9pbnQgRml4ZXMNCnRh
ZyB0byBbMV0gb3IgWzNdPyBUaGUgcGF0Y2ggd29uJ3QgYXBwbHkgdG8gYSBrZXJuZWwgd2l0aCBv
bmx5IFsxXSANCih3aXRob3V0IFsyXSBhbmQgWzNdKTsgd2hpbGUgdGhpcyBzZXQgaXMgbm90IGp1
c3QgZml4aW5nIFszXS4gU28gSSB0aGluaw0KaXQgaXMgbm90IGFjY3VyYXRlIGVpdGhlciB3YXku
IE9UT0gsIHRoZSBjb21iaW5hdGlvbiBvZiBDT05GSUdfTFRPX0NMQU5HDQphbmQgbGl2ZXBhdGNo
aW5nIGlzIHByb2JhYmx5IG5vdCB1c2VkIGJ5IGEgbG90IG9mIHVzZXJzLCBzbyBJIGd1ZXNzIHdl
IA0KYXJlIE9LIHdpdGhvdXQgRml4ZXMgdGFncz8gSSBwZXJzb25hbGx5IGRvbid0IGhhdmUgYSBz
dHJvbmcgcHJlZmVyZW5jZSANCmVpdGhlciB3YXkuIA0KDQpJdCBpcyBub3QgbmVjZXNzYXJ5IHRv
IGludmVydCB0aGUgb3JkZXIgb2YgdGhlIHR3byBwYXRjaGVzLiBPbmx5IGFwcGx5aW5nDQpvbmUg
b2YgdGhlIHR3byBwYXRjaGVzIHdvbid0IGNhdXNlIG1vcmUgaXNzdWVzIHRoYW4gd2hhdCB3ZSBo
YXZlIHRvZGF5LiANCg0KVGhhbmtzLA0KU29uZw0KDQoNCj4gDQo+IFByb3ZpZGVkIHRoZSBjb21t
aXQgbG9ncyBhcmUgZXh0ZW5kZWQgd2l0aCBGaXhlcyBhbmQgb3JkZXIgaXMgbWFpbnRhaW5lZA0K
PiB0byBiZSBhYmxlIHRvIGJpc2VjdCBjb3JyZWN0bHk6DQo+IA0KPiBSZXZpZXdlZC1ieTogTHVp
cyBDaGFtYmVybGFpbiA8bWNncm9mQGtlcm5lbC5vcmc+DQo+IA0KPiAgTHVpcw0KDQoNClsxXSA4
YjhlNmI1ZDNiMDEgKCJrYWxsc3ltczogc3RyaXAgVGhpbkxUTyBoYXNoZXMgZnJvbSBzdGF0aWMg
ZnVuY3Rpb25zIikNClsyXSA2MDQ0M2M4OGYzYTggKCJrYWxsc3ltczogSW1wcm92ZSB0aGUgcGVy
Zm9ybWFuY2Ugb2Yga2FsbHN5bXNfbG9va3VwX25hbWUoKSIpDQpbM10gOGNjMzJhOWJiZjI5ICgi
a2FsbHN5bXM6IHN0cmlwIExUTy1vbmx5IHN1ZmZpeGVzIGZyb20gcHJvbW90ZWQgZ2xvYmFsIGZ1
bmN0aW9ucyIp

