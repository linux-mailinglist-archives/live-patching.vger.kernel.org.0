Return-Path: <live-patching+bounces-426-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 441B09456B8
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 05:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6E372829BA
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 03:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CDB2EAC5;
	Fri,  2 Aug 2024 03:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="aj9JF4dF"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620421EB4A8;
	Fri,  2 Aug 2024 03:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722570349; cv=fail; b=fsU8MuYDu+mtiPlgwDEJ8QfJR514HvIr1MCbi/7ebTZ9wi4H2gqzEYpaJz3WqAzzov6KnvBy+CkwTbiWGApIRVGsCgpRH7m0gy/IBD3+dCbdo1Nrx9wrn0550sOoNj8kOXkGTzbU3/x2Da8/9AkeJbABvf7pAc+cgJYZTkG6zPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722570349; c=relaxed/simple;
	bh=pwV05QzdbGooT4An5zpq2ihGNjsqsMc6j63QMe15ix0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pe3Tut/gkLg+oeSOvi8eK4vxE4o6/pfom29CtnjXBH8hnABfYLzCwP3LwcwuofJ8m6qyf4RhicRpMiRa6X7oSJSSFU/fg0QjKfxuYZqx5EoegTZZEXsoi0+nXmTRqGTFM0TzzzYbJhDnGH1c9l8eJd0C19W7huokbMFjsrC0NZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=aj9JF4dF; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 471MERSs002456;
	Thu, 1 Aug 2024 20:45:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=pwV05QzdbGooT4An5zpq2ihGNjsqsMc6j63QMe15ix0
	=; b=aj9JF4dFco1KLNxTf2n8qyLe+TtXLpQPx7RjehrXN2jeXnREol9VM7cXGbv
	bTeYq0fIPD1NdzpTw5lr5NDkH8eEOzF3vrtpjbja7qqb/50qE0bq+H0/kn2tOU9G
	WbCyrSwyA6Ppj7w57j96oG6Vg1ScWH4i8lLIvotB2Nk0khdxxF9SoKwizvIvywuy
	GN2jcVtGTOx2FyO+BT0gIYlBPJeEtsh/Oo7jqg1Bbog13Vpj4XheP4Dspgk7p34J
	KimP8LjvDMGCEWvBirm8J366DbU++brSzVaSKx8HSKVqq2LOCpsQgENEdmKm2Qzt
	bjZLDpliHgmpq+vUidjAn+T5OMA==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40rjey1jjg-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Aug 2024 20:45:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mf8gTHNeP4LgePyCLXNmwXUsOrNzvsHhwUYW+1CYk4jDh34fPvCH2hvMcQoab4bvhdUwn6Q5cq4ykjYHuu2qTB23YY+HFhE6E4n4aJpwb3Y/csCBD3CfImBg2R6iGStNWZoAgIadydnIg3urLe0m2LcGMqCf1/TTiO2DOxESu/OJUlZggeG6CtIx08+1r/dHrdoHdGAOBc6sJnJdQMo8W0R9vP0rl8yfTfAaCQSs3MfTjZy2LqgvWZnZ63HzdVgrnEApRpLyNt7K68glLqK5HDkYFQlcj7GovesSWFFErNeRQmjO2EKGmacaKAtJGDQXGYDVSDnekST/loY0kyGFFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwV05QzdbGooT4An5zpq2ihGNjsqsMc6j63QMe15ix0=;
 b=C0MolJ5Q+ErhGIXLN7C52gRSwUqp2pk/ijxviySeZzGxYqbrijal8MiHhaI0LAfhjBqbWQRMfqDRrDqVXECdGW6ewQDT5ZGrskqYE+LDyoCeTK1y6DcdYrHxrRvW7gWsfQyl7g5m8+FCp8basurwsuvqeX0/p1wlyFNNurcZcikLnUUkwkxIjaAGl+IApb8joJ2XC3aQeWr/srahgb3gOD5WwezF+t9ONbSiVg0EJIDZ4UgaAmt0HLZV7rPJfyr2C8SLVFJWXf6hR75ebOOqssQtPGL4uqJw+m/mCg8ZZ0MBDQ/fbMZ7N1J4464VvLqgmk7J62SWaxhYUQVjHCnlVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BLAPR15MB3921.namprd15.prod.outlook.com (2603:10b6:208:27f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Fri, 2 Aug
 2024 03:45:42 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Fri, 2 Aug 2024
 03:45:42 +0000
From: Song Liu <songliubraving@meta.com>
To: "Leizhen (ThunderTown)" <thunder.leizhen@huaweicloud.com>
CC: Song Liu <songliubraving@meta.com>,
        Masami Hiramatsu
	<mhiramat@kernel.org>, Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
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
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Thread-Topic: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Thread-Index: AQHa4hsdZBHaq1mnRkygDON43y0YhLIPPWoAgADIbACAAynDgIAAKQiA
Date: Fri, 2 Aug 2024 03:45:42 +0000
Message-ID: <FE4F231A-5D24-4337-AE00-9B251733EC53@fb.com>
References: <20240730005433.3559731-1-song@kernel.org>
 <20240730005433.3559731-3-song@kernel.org>
 <20240730220304.558355ff215d0ee74b56a04b@kernel.org>
 <5E9D7211-5902-47D3-9F4D-8DEFD8365B57@fb.com>
 <9f6c6c81-c8d1-adaf-2570-7e40a10ee0b8@huaweicloud.com>
In-Reply-To: <9f6c6c81-c8d1-adaf-2570-7e40a10ee0b8@huaweicloud.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BLAPR15MB3921:EE_
x-ms-office365-filtering-correlation-id: 21b6f527-a2b7-4852-806f-08dcb2a59548
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Ym1IcmF3ckZUU2xxdzlkYjZCeWNKSElraWZTanY4NlNLUm9OZ1ZmRE5NM2Vy?=
 =?utf-8?B?UGc5VThOYnFudzRhQ3RWVzJ5amVmNzBFR1pudFV0cGh5ajhCdHFleHFUVmtt?=
 =?utf-8?B?QmxmL2FCRDhlTklnbzVjZ2lLcy8wcEpDU0o2TmFHZVdTZlRYTXlqMFBNbGRy?=
 =?utf-8?B?K3pucE5BeHptaFNHRjZDZnIrUUF1N1I5NE9RZWdSQmVucldiT3AzWFpaNlJX?=
 =?utf-8?B?aVRwV2FRb0NQNUtyUkxyOTRXRWpXZm0vWkRaQjhqais1VVkzMkFzdHMzMloz?=
 =?utf-8?B?Q0Zzb0pQRU53eHlpZUJyM1BRZ1lLUHFIM0JqZmRnU1dSamh4aGU5eDl6bEMw?=
 =?utf-8?B?N1psL21sSGFCc1ZHblpEbUhiYmgrdWJHZnMwaFVueVY3TURWdy9LMDUva3BF?=
 =?utf-8?B?M0EzYStmNUdBdzNqN3RuK1VHV0dMVWZ3cjh3UStmcUZsUzRqTGNqWmRocWhl?=
 =?utf-8?B?aVpYbytNczloeWdVb3Zkdmx6c3VhcWlpRGx4aGQwTS9iRUFjSUhTdFYyVGZ2?=
 =?utf-8?B?WkFoMlora3h3NXNObE9IQjdWdEhWRFFXd3VHTVJUbjY5Q2k4NEY3Mmt4anh3?=
 =?utf-8?B?TlhYVEpIQ3J2dTc0RzVLZVhBYmVFSXdvZ0N1NXBPcWU2VStwdVR0Mk5aZHNx?=
 =?utf-8?B?dUlrVXAyNVRLUmRBNm1oZG1qL08zcVljYmxvb2V3Wk5Tdi9GaG9qamhnZE5J?=
 =?utf-8?B?OE1WVWZiTTY4M1ZnVU5FV3o5NE9qK1JXU1IrdXF6RTJMdHdYR2swdzI1T1F4?=
 =?utf-8?B?SDMxTS91czJSMFpGM2h1ZWpGR1p2MDExWWlxYmsyemsxeHErT0QvS0d3bDYv?=
 =?utf-8?B?M2M5K0F6d1VZQ2hueTdUVWtwek1vR1NnZEJEL2ZhSmVQMkcrNEZkRzY2NDVK?=
 =?utf-8?B?WGg0TkNZOUp2cnIveXR6bU5NL01IdXZ6ekhEMHVWcU0zWTdWTzJ2OE1vWXhY?=
 =?utf-8?B?Smk0bmgrbUpFZnlhRkR4elhna0RSUGlxSUE1eWRFZU56NVBaZzdxZXV5YVdG?=
 =?utf-8?B?aUhLRExGOUFLS2ZKRXU4MGZsd2Fnc01zM0RpZ1ZHRmJyZXY2dEdERWZ0SFpS?=
 =?utf-8?B?Nk91V1N1WHgzZkdwZ0JoTG1QWkxNVkx3Y05GZmtuMGxGTTNwRVQ5dUNGVm9G?=
 =?utf-8?B?VWd6WXZYSGVRM0d2bTMwcWxuaS9FVjBuL044Y00zR2wyM3E4aElrSDQwQWgr?=
 =?utf-8?B?RkdBanZ0QmlnSThNZWVyeGFhS0IxRjJORUxOK0RtYmdWZ21RRU5pczNIaEhZ?=
 =?utf-8?B?aWludlRlMGVsaG9vV1FmSmVIaXVMaDladkpEVnpPMTdEMFdid3NEQm9ZWWZH?=
 =?utf-8?B?YjN2aWpkVU4wTTFNSFA2RmhOQ2xKTC9sK1JaQ1pRcXd1SnMrSFVvUFF3WTJI?=
 =?utf-8?B?SXNpS0ZIY1hFeXBRY2ttbmdUWVduaXRLenI1OTBuNmpLRXIxc2o5bVlpWVVR?=
 =?utf-8?B?Umszajh0S0g4NVdXeDRlajVodmtKTGE2YnFxSGU2MVY5cWFsQk1LaGgxRFRK?=
 =?utf-8?B?UlFid1oxV3J1Z0hWUm9LdEdFU25iVjR6eFpuSFhyWnZnVERJRlJJWWtVSDRN?=
 =?utf-8?B?bUhqTURORkI1dzhKWEdlcVRKN0ppK2VhaGRxNGRwb1p3VDk2REg5SkRHcXVl?=
 =?utf-8?B?eG5WNFcreVpGcmhTODNNcEF3N1M3K3NkU2VSREpKOUgvK2pBUmh0dTRVSlhM?=
 =?utf-8?B?UGZVSVJJOEtlNHo2REpxL2NiUS9hRFNvSlUrVVAxSmlCRmJ4RFd0bFgrSTc0?=
 =?utf-8?B?eXBXTWI3M3RpWEVYWUprMlc2OWhTMGhvOFlBSTRvLzFYSjgwWVJoeFo5bktq?=
 =?utf-8?B?NzdFclZjKzdLeGJ0MWd0Y1VkVUYvMTk2cXVPNk1GbkJKZG5hSGZqMENpSCtp?=
 =?utf-8?B?RVY4VGh6d1hxZVkyZm9HSmRvazYvWTYvNUI0ZFNKcHYvTFE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SVRvZDEycjg5RXRrWUtJQy9NeGxBSUtnWXkrUkg0cUh5TWpPdDB5amhVVXlH?=
 =?utf-8?B?dHVscjQ4OUZhV1ZoeXYzc09RQlVDWG40REFYSUJKOVUvZWNFNEM0OElFanhr?=
 =?utf-8?B?cTg4MWI5L1dLbnVFMGlvRWFqQm5XL3AwSWJaTUdGR1E3Z1R4S012WWIrQjR3?=
 =?utf-8?B?TmdSSjdLd0ZBREE0QlJWUldWMzkzdFRLTDJmSmlBak1NU1V3NE5uVkpGY3Q0?=
 =?utf-8?B?cDVDeTMrRm1QYlpVQi9HZEZReTlzZFJ2T25rbHFPd3k3VTFPTW01NnNQNFF3?=
 =?utf-8?B?ZklkNDdmYTkyeGlqeGh2SnRTY2Rrcm1SaGVOWjNya3RRR3lOTW1ZeHZnTlNj?=
 =?utf-8?B?WDdwWEpSTkV1Uys1TFUrSVR3aXcwQ21Rd0xDMGhFMUk3V2RuOGhOb2tUTjVm?=
 =?utf-8?B?VXNrVHFqUkQ1WHUyWDNqK210bDNFYkNVTThNcXhENTZEZ3ovd3ZuSGhhZ01G?=
 =?utf-8?B?MDRsRnh6OUJGUE42bXBhUzB5amVNc2FySG9jNGRad2NDMlJIOEFKMlJhbXc4?=
 =?utf-8?B?VXlBc2RrWTJ0K0Rkc0kwbzY4TXpzRTZqcjd2WE80MUhCZ0hMeUpGNzFBQVQv?=
 =?utf-8?B?MTR0eVNyWklFTFNaOWVZQ3ZsblFSUXFNdndhZzIvbStZVVNPSE41bk41UmRs?=
 =?utf-8?B?WFFIclFsdWc3V01KSVErOUpZanVwb053T0xFeHZ5cWRrQ2Q4YVc1dDNURDkw?=
 =?utf-8?B?TTBoK1AxSCtWeFFHSGk0QnF0S3RWODV4dmNnOGNVblkvTGY5WHN5UmF2MzRq?=
 =?utf-8?B?RU9KTjM4ZDZaRFgyMStsOHdRa3JkQ0JaaFpDb1RmL1hQdjdCZHhZRDNGWmhR?=
 =?utf-8?B?dXJ6YXBJNmdNelR2RXhacWFmc0dhRnNHZ1dqTUtRM0p1RDYyTUJDdzlSY3pU?=
 =?utf-8?B?aUhIdER1TVppOStyTGVZNHZMQ1U1b2xlTTgzWE5XYTFqTk5jT0FSRmJyWlds?=
 =?utf-8?B?VzdEUTBJVkphRXZSWFJPNmxUSnNZcG5OQjhzamxYSlNXd3VtNVAxUUFGMjBB?=
 =?utf-8?B?SDlSSG1KdHQ4K3dFMm5PMjQ4dlA2d0wrTkJBaG81K3lTZDVRSEphYktDcGZB?=
 =?utf-8?B?eURzOERHbWxSbzVnTkFlMzZTUThsQm1WTWlVbzlEYk9WakptZWZEVnU2alF5?=
 =?utf-8?B?SUg1T05oQS9ydUJXYWVwVGRoTUljRys1bTFTVytpS3loYUhSVW1BVTZncm4z?=
 =?utf-8?B?cjJhRHc2bTFIMW1OY0hzRDBFSlVYcWhETDcraEdJZ212LzNjTTg1UEZyWkhJ?=
 =?utf-8?B?TElIQ0hyYlhJTUkvVzlOT1p5QnVXZmxLMVQ0MEJKdDRCU1NMQXRqTmFjMlkx?=
 =?utf-8?B?WnkrOVpLR001Mm1NVUJHS1p0TVl4RGxFbGE0a3JPRmZDeHROWHFxSU5RNTZz?=
 =?utf-8?B?Yyt5cVZhRkdzK2d6by9JeGNJM04wTDc5eXoyZmNNWUtwZzFuZytLNTh4UFdU?=
 =?utf-8?B?OFRKaGc5ZklaWkR4cmR0cDl5NG1JcWVOUXB3QWNER2ZFMGwxZHdSZWI3d3FI?=
 =?utf-8?B?NS9WTVlVSEFPOWt2L1pvdnRjWnZFZzhyOXlyb0QvWjZIdjdEM05hTVA2WG40?=
 =?utf-8?B?QjFCTUhNUlpLL28vczhzbDBUeGl2ZWQ3aDBxK0RBWUN2R2J2U21oVGFVaC9E?=
 =?utf-8?B?UDF3b3RVWDBNMFd5UVQvQnpLVkJTTXp0NUJBcVR6SDdxWXRSWkR2VmNnd2U3?=
 =?utf-8?B?WmVQajRvNGZxc1kwSCtLQVo0VUdDcEhTNk9vS1FYZWF2TFZQeGNmczYxclEw?=
 =?utf-8?B?bmwzSmdCTDJ6VmowOW80MTUzRUZpMmZVT2pMWEsySDJoL0NvZHQ0ZG85UXkr?=
 =?utf-8?B?UGFkRitrdVNRSklXemt6VGN3Z0trN3ArYWhhS3BWQ3ZqQ2ZMMG9qeEF0SFIw?=
 =?utf-8?B?RDNudExZVUdUMCtlbTV6enNmU2xlcFlHVC93bEJZNUswWmZiYUV1ZjgrNUZD?=
 =?utf-8?B?ZTFlUzd1dzQzSFJDQjVzRFRJbXRMdFQ0WmhNRDF5Y0k3L3lVam1lMUZnUnNN?=
 =?utf-8?B?eEVaVXNWQ2tTbS9rd0lrSzhBL1JMZEEyeFhDTm1WeVl0VFhRUHgzMHBWLzhp?=
 =?utf-8?B?RXl1VVNSOE5PRmNobFQ2OXRiSE5ScWpMVEErQXBLYjhWSURKUU9aMXRnODFC?=
 =?utf-8?B?Qm43WXUyZThPdmkwR28xWCt1MnFZNVU4Q0FEZE5CWUNmTzFLT3VVSld5WTBy?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F4C2A88DA54684CA98203E088E55BB2@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b6f527-a2b7-4852-806f-08dcb2a59548
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2024 03:45:42.2999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8+fHqv5ALcZyq7+iJCfQpRxBlxDLGW9iHzUtB9pDXYKwRwEn6iC9wDXY8SXXdP15q52eQPb0Veu6ORxoOLEx9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3921
X-Proofpoint-GUID: wUxjIR8kyPbaHPthCWkEdbO2975qm06W
X-Proofpoint-ORIG-GUID: wUxjIR8kyPbaHPthCWkEdbO2975qm06W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-01_23,2024-08-01_01,2024-05-17_01

DQoNCj4gT24gQXVnIDEsIDIwMjQsIGF0IDY6MTjigK9QTSwgTGVpemhlbiAoVGh1bmRlclRvd24p
IDx0aHVuZGVyLmxlaXpoZW5AaHVhd2VpY2xvdWQuY29tPiB3cm90ZToNCj4gDQo+IE9uIDIwMjQv
Ny8zMSA5OjAwLCBTb25nIExpdSB3cm90ZToNCj4+IEhpIE1hc2FtaSwgDQo+PiANCj4+PiBPbiBK
dWwgMzAsIDIwMjQsIGF0IDY6MDPigK9BTSwgTWFzYW1pIEhpcmFtYXRzdSA8bWhpcmFtYXRAa2Vy
bmVsLm9yZz4gd3JvdGU6DQo+Pj4gDQo+Pj4gT24gTW9uLCAyOSBKdWwgMjAyNCAxNzo1NDozMiAt
MDcwMA0KPj4+IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+IHdyb3RlOg0KPj4+IA0KPj4+PiBX
aXRoIENPTkZJR19MVE9fQ0xBTkc9eSwgdGhlIGNvbXBpbGVyIG1heSBhZGQgc3VmZml4IHRvIGZ1
bmN0aW9uIG5hbWVzDQo+Pj4+IHRvIGF2b2lkIGR1cGxpY2F0aW9uLiBUaGlzIGNhdXNlcyBjb25m
dXNpb24gd2l0aCB1c2VycyBvZiBrYWxsc3ltcy4NCj4+Pj4gT24gb25lIGhhbmQsIHVzZXJzIGxp
a2UgbGl2ZXBhdGNoIGFyZSByZXF1aXJlZCB0byBtYXRjaCB0aGUgc3ltYm9scw0KPj4+PiBleGFj
dGx5LiBPbiB0aGUgb3RoZXIgaGFuZCwgdXNlcnMgbGlrZSBrcHJvYmUgd291bGQgbGlrZSB0byBt
YXRjaCB0bw0KPj4+PiBvcmlnaW5hbCBmdW5jdGlvbiBuYW1lcy4NCj4+Pj4gDQo+Pj4+IFNvbHZl
IHRoaXMgYnkgc3BsaXR0aW5nIGthbGxzeW1zIEFQSXMuIFNwZWNpZmljYWxseSwgZXhpc3Rpbmcg
QVBJcyBub3cNCj4+Pj4gc2hvdWxkIG1hdGNoIHRoZSBzeW1ib2xzIGV4YWN0bHkuIEFkZCB0d28g
QVBJcyB0aGF0IG1hdGNoZXMgdGhlIGZ1bGwNCj4+Pj4gc3ltYm9sLCBvciBvbmx5IHRoZSBwYXJ0
IHdpdGhvdXQgLmxsdm0uc3VmZml4LiBTcGVjaWZpY2FsbHksIHRoZSBmb2xsb3dpbmcNCj4+Pj4g
dHdvIEFQSXMgYXJlIGFkZGVkOg0KPj4+PiANCj4+Pj4gMS4ga2FsbHN5bXNfbG9va3VwX25hbWVf
b3JfcHJlZml4KCkNCj4+Pj4gMi4ga2FsbHN5bXNfb25fZWFjaF9tYXRjaF9zeW1ib2xfb3JfcHJl
Zml4KCkNCj4+PiANCj4+PiBTaW5jZSB0aGlzIEFQSSBvbmx5IHJlbW92ZXMgdGhlIHN1ZmZpeCwg
Im1hdGNoIHByZWZpeCIgaXMgYSBiaXQgY29uZnVzaW5nLg0KPj4+ICh0aGlzIHNvdW5kcyBsaWtl
IG1hdGNoaW5nICJmb28iIHdpdGggImZvbyIgYW5kICJmb29fYmFyIiwgYnV0IGluIHJlYWxpdHks
DQo+Pj4gaXQgb25seSBtYXRjaGVzICJmb28iIGFuZCAiZm9vLmxsdm0uKiIpDQo+Pj4gV2hhdCBh
Ym91dCB0aGUgbmFtZSBiZWxvdz8NCj4+PiANCj4+PiBrYWxsc3ltc19sb29rdXBfbmFtZV93aXRo
b3V0X3N1ZmZpeCgpDQo+Pj4ga2FsbHN5bXNfb25fZWFjaF9tYXRjaF9zeW1ib2xfd2l0aG91dF9z
dWZmaXgoKQ0KPj4gDQo+PiBJIGFtIG9wZW4gdG8gbmFtZSBzdWdnZXN0aW9ucy4gSSBuYW1lZCBp
dCBhcyB4eCBvciBwcmVmaXggdG8gaGlnaGxpZ2h0DQo+PiB0aGF0IHRoZXNlIHR3byBBUElzIHdp
bGwgdHJ5IG1hdGNoIGZ1bGwgbmFtZSBmaXJzdCwgYW5kIHRoZXkgb25seSBtYXRjaA0KPj4gdGhl
IHN5bWJvbCB3aXRob3V0IHN1ZmZpeCB3aGVuIHRoZXJlIGlzIG5vIGZ1bGwgbmFtZSBtYXRjaC4g
DQo+PiANCj4+IE1heWJlIHdlIGNhbiBjYWxsIHRoZW06IA0KPj4gLSBrYWxsc3ltc19sb29rdXBf
bmFtZV9vcl93aXRob3V0X3N1ZmZpeCgpDQo+PiAtIGthbGxzeW1zX29uX2VhY2hfbWF0Y2hfc3lt
Ym9sX29yX3dpdGhvdXRfc3VmZml4KCkNCj4+IA0KPj4gQWdhaW4sIEkgYW0gb3BlbiB0byBhbnkg
bmFtZSBzZWxlY3Rpb25zIGhlcmUuDQo+IA0KPiBPbmx5IHN0YXRpYyBmdW5jdGlvbnMgaGF2ZSBz
dWZmaXhlcy4gSW4gbXkgb3BpbmlvbiwgZXhwbGljaXRseSBtYXJraW5nIHN0YXRpYw0KPiBtaWdo
dCBiZSBhIGxpdHRsZSBjbGVhcmVyLg0KPiBrYWxsc3ltc19sb29rdXBfc3RhdGljX25hbWUoKQ0K
PiBrYWxsc3ltc19vbl9lYWNoX21hdGNoX3N0YXRpY19zeW1ib2woKQ0KDQpXaGlsZSB0aGVzZSBu
YW1lcyBhcmUgc2hvcnRlciwgSSB0aGluayB0aGV5IGFyZSBtb3JlIGNvbmZ1c2luZy4gTm90IGFs
bA0KZm9sa3Mga25vdyB0aGF0IG9ubHkgc3RhdGljIGZ1bmN0aW9ucyBjYW4gaGF2ZSBzdWZmaXhl
cy4gDQoNCk1heWJlIHdlIHNob3VsZCBub3QgaGlkZSB0aGUgInRyeSBtYXRjaCBmdWxsIG5hbWUg
Zmlyc3QgZmlyc3QiIGluIHRoZQ0KQVBJLCBhbmQgbGV0IHRoZSB1c2VycyBoYW5kbGUgaXQuIFRo
ZW4sIHdlIGNhbiBzYWZlbHkgY2FsbCB0aGUgbmV3IEFQSXMNCipfd2l0aG91dF9zdWZmaXgoKSwg
YXMgTWFzYW1pIHN1Z2dlc3RlZC4gDQoNCklmIHRoZXJlIGlzIG5vIG9iamVjdGlvbnMsIEkgd2ls
bCBzZW5kIHYyIGJhc2VkIG9uIHRoaXMgZGlyZWN0aW9uLiANCg0KVGhhbmtzLA0KU29uZw0KDQo=

