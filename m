Return-Path: <live-patching+bounces-446-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94C959498D6
	for <lists+live-patching@lfdr.de>; Tue,  6 Aug 2024 22:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A92291C210DD
	for <lists+live-patching@lfdr.de>; Tue,  6 Aug 2024 20:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CF9145B1C;
	Tue,  6 Aug 2024 20:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="DvvmfIeN"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367ED38DD8;
	Tue,  6 Aug 2024 20:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722975182; cv=fail; b=Sb36MHJD31usw4fqy4aZyv+KeapuijA58C+Bv5UFAEkIOU2EesVA63/wHh5WlhlAcCarZ8uYSHmfovQJWKWlCDBSnCOcIFLGH/4QbyoJ53heKNhzeMoc5ACXLecHmBf+HOMOp2lHaPoTDaRk5pjUpX9zJofEUr5b0UA0WtSU1XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722975182; c=relaxed/simple;
	bh=m/zIxg2ITmUJTuPINSgEp2q+6VjHqeiszMGLGnX7/v8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=itnPsDLBS7ip11aaxauy9Kza197uVTip0tGvCWRkSYrj6dhkpFQrqurGda3t/hdzpSdAGXNsoLTaoyLZhl8+AKsa68KzIGZNpIyAzwhxm6RqaF0ah/bzP0106aX/mnaKmaeqIdhAMIpClucnG3FLTFUW7EjYtNzPOisl0e5B1uo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=DvvmfIeN; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 476J5kub026050;
	Tue, 6 Aug 2024 13:12:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=m/zIxg2ITmUJTuPINSgEp2q+6VjHqeiszMGLGnX7/v8
	=; b=DvvmfIeNmNuoy2RSBg6u6jP5BurgOBlkFE5Di61+sNoxOAm16XpDqUYCeLF
	NX+fDVtYZX5JUk+uRlEiyXiXjzDSJrm6XEAA8vidXPp/Ki49y5+OjTSIlGUXejJb
	7+lj9CusTFjuQxNeVML1ax16Lko0knN/8pj9DsgC1rwsqs3vGYWS49Vrzeu6ErYr
	tD9liaLZh7Ig+1uV+8Is4GV9Hgl6wfGSDmKq0MV7PxKiAVVwt0EOHzoKiAWg2QgE
	O4Byahnqz/KCkz0B8WMutWZZy4pQK6a8Ael52+3iyyir5WkxQ2tT0DywJGr09bh3
	uV8lK25dMkU7BxffV0E2b+FEXbw==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by m0001303.ppops.net (PPS) with ESMTPS id 40usns8dsd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 13:12:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O08mOcwPphWDqMqIekMK3N1OHDKhhbZbxzb6ycZ0JMjgXybJZ6lno5xYztKC19AgtJMbyen3V0jUqdH5BZeyIKWkkDX5lZCSmPK4p1typPJvaveKZWHlt156OjE2fhQ0hhKYkT9hWpJzxY39r5rikLyBzGCUvP8ldpFGjzBWNAwegYAL/51R13PfDW9HImb65xdR3GKAxzEZ0jror+UZR5rsGpjnxcw9eChtvFy3LdXNC2326E/H+Ijbr+vyy9LKp1XWGJXEl2t3i7Ip+gYLlnYG7/R9TEF6CKq4Y7/yDH61945V1b6ulOSfgF6ww6Ev5Zz8tWwOgUZqbTNmkvvErA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/zIxg2ITmUJTuPINSgEp2q+6VjHqeiszMGLGnX7/v8=;
 b=simpWi/bleCZEe61Jo5o5I/2Cz9SxdWiZMP2kqVuxfbOeDDwCkxdmtivpxkgkqen3/25rwgFC9jTMccyFckm3n/sYkbrcVsW0/fnAT/4he5/9BWs9Ef6Fnm99sR5X8k3z1lHm3Vlm8spJm5APCz17ir7xU+LYfaavUj+3ARcVb3aLDo6cNAcFKf8BXWMJX4LpqLOMM9jWkNKi4eFF1aJkHhwV7AvWzH7n9NQxyYiZMws2lHpJTpalPAdQNc730mNTFwIoyf0Mr71zhewTOjo6axjbQyI0hfCG1w0MS2qeOnNTDmve5qnVj1gX8wgz6PLr/jFg0z38Na/5QBkFSQX+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DS0PR15MB5854.namprd15.prod.outlook.com (2603:10b6:8:f4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13; Tue, 6 Aug
 2024 20:12:55 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 20:12:55 +0000
From: Song Liu <songliubraving@meta.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Song Liu <songliubraving@meta.com>, Song Liu <song@kernel.org>,
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
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Topic: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Index: AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQA=
Date: Tue, 6 Aug 2024 20:12:55 +0000
Message-ID: <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
In-Reply-To: <20240806160149.48606a0b@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DS0PR15MB5854:EE_
x-ms-office365-filtering-correlation-id: 5fdf35eb-25ff-4684-4d19-08dcb65428b8
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Zlp0RkcvMG53aXp5QmlIQUhLSDJSTFZGakdMZFcyRytsZGFaNVJCYmtTdXJ5?=
 =?utf-8?B?cWV5WFJmSXRyVnJqVEdZQk4wTUF6cG9rQWNxUm1lYjlDbkEyWnNYVzQ4MFNX?=
 =?utf-8?B?SFdONWRJV2c3L2doM0RRMnIyM00velM3U3l4MkFYZTJFcUl3RVc1dVM4SHZK?=
 =?utf-8?B?bWNLZlo3WmErdUd2ZDlpbE5TZnI0TUZoY3VWcGVDNVZ2eXI0NW5INFVRQ3RP?=
 =?utf-8?B?bGtyYVluc0FIbkY2Nmg3NDY1clpzcVVPT1JTOFdiNWRnaHQyT3RUVGxVdnpG?=
 =?utf-8?B?S3IyaDEraER4TzB1R0ZOdCtMbFdQUjNaSmtSUVk4YkZqeEluejhCUEY1ejJk?=
 =?utf-8?B?L0VPUFNJaVNlV2Uzbnpibm9SZXd2VGZmZ0tjTGZ0UXV5MmhIdUU5K1h2d1Nw?=
 =?utf-8?B?RldJV0hGMHhzbk9kbmVKOHVVWUZzK2NHZlBMaytGNEtnQzZVMVZLNWxSYklZ?=
 =?utf-8?B?TVFPVk5sNVkrSnY0RjlwNUx4UER1ekRBL2VRdGdnOEVOL2VUdEpWMUQvU1R3?=
 =?utf-8?B?UTRhQ2xFaGZoT003NTBNL2plM0pQRXZVN2ZUV29MdWhRWUJkKzZacVRNWFFF?=
 =?utf-8?B?bDgwM09tS3RiQ1NjMGwySFNFSUdGMXhKenhYYjMzemYwTWRiMzZDTnpPbTI3?=
 =?utf-8?B?RXkvYkZGcTd2QWdKYmJNRHB0NUMwR1ZxQWtBeFBGLzEza3NLRjhqaHg3bDQ0?=
 =?utf-8?B?N2p5YTNwRG5Fc2NldnhEcjhha1hRWHlQNVQ3MmJITHBsTkNvdzFTb0NoWlBv?=
 =?utf-8?B?Tm5RcEdPMjhEYTNCTU1RYXNwcG1Zb2t3elhkZXl6R0Uxb0VxU0RRRWkrZVVq?=
 =?utf-8?B?V1pQcjYrdTV3TjVwcWNwM1FqdURZWDZqTWtaU0VETzFCU1l2dVV5ZTNFY1FY?=
 =?utf-8?B?YkJmQTc2TGdVd3FWaHhmQ2ZNWUZMMVFFMys0NExwSjZCZmo4UEZuc3lxazlR?=
 =?utf-8?B?TEpGUDhocG5vaEV0UWh5Q01XL1pXZWJXUmd5K3RoT2xsZzVLREUxWGwvQ1BU?=
 =?utf-8?B?QTFuQUl4L0ZRNkUranM4VitFNkdEcTRHQ0JpV3czdnhPOXUrOUZ1cEkyV3RY?=
 =?utf-8?B?UFNQK1MvMXJjaUltczgrQkJISk12NkZ0RTZLY2duK2U5TWM2ZnVOa2dZQjE5?=
 =?utf-8?B?RzBETFdLb1M1Y3FoMGltVHFXZUlNZGRIcDFlZzFreGtyRFM4TGQ0TjJkSEl4?=
 =?utf-8?B?UW5GcWozOGwxUFZXU052UGpkUWFPTnEzUVF2NEpWQm4vZ0V5SFNCM1dlNVdU?=
 =?utf-8?B?bG5XV05idmVCWmpVaWNObWtWUk5EMU91MEVSSXBybDFibGE3VkZKUmlVbWV3?=
 =?utf-8?B?My84a0NpYmFoaXdQbGVaY05OOVdRbEdpdllSTzNIcVh2VDNFbHF1RlZib3l3?=
 =?utf-8?B?SWZ0WENIYmhJcXppYm5NTUJUdmF0UjNabUcwSXFuRFVIbnBVUndiVlZ3cXcx?=
 =?utf-8?B?aWJlQU0vTWd0ZEc4b1B3b1JDcDZjVHJCeHc3N0p4bmczVmQrUmJSOXRRRGc2?=
 =?utf-8?B?N3JvZ2ZPZkhubWtVZUVOcGt4N1ExYTBvVXJmcXdUWGEyRlNKMEVobU1LZi8z?=
 =?utf-8?B?c043VDlJVkxHZjdxdldwRFBFaWZtL0NjQW1BZU84VjFTV0VKN0kxY2RrNDZM?=
 =?utf-8?B?YzZLQm9NRlU2cjRuVUNhcmVnZUwxVWVhYk9PWWE5VzFWcndLQjB0QjZKdHRY?=
 =?utf-8?B?SGs4UGFuMkpGK01UdFB4Y0xyYmpyM0hndm9aTEg1U21renZaMGRpTE03K2tK?=
 =?utf-8?B?VGVReC9NR3haY0VtWkJmdm9vSDd2RjhUQkt3Z0ZMRFNzWjdhaVZyVDRsd0Zy?=
 =?utf-8?B?VHIzRGRrQW0vTEh3SVkrNGltRncrTkZLWlpFK2F0RlhiN3pDaXoyaVhjR1lr?=
 =?utf-8?B?YmZ1QzlqSkNXWk0yNTRaZjBZa3MyTU5qdmdjdFNhQW1DZWc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?akljYzFjbm44d3lkM2QrcXRUakFOY1FmMGROWGROYWJiWXAzMUlDZzVIZU8y?=
 =?utf-8?B?M0t5TW12RHFJc3dBNE04SlhobnBBZk8rakJsREtFZDRTeEhNT3MrWFg1Wk1I?=
 =?utf-8?B?U1IycDh3L0tnMHpHc3hyU0pCdlZhaUdXOXc0SXdteDRrZDkvMDV4K2NRYzl3?=
 =?utf-8?B?MDdKUVJ0VTdQV01McmliTStKWC9oMFhTR3R2L1A5dlRnbHpHKzJITzhraWw0?=
 =?utf-8?B?RWYreWdoVU93SFVWUHRtNVB4WHZGbGhQZm15WTVkS0JWV0pWR1JEbmZyODhz?=
 =?utf-8?B?K2RJSmg0M1BmaU9QaUI3Y050SWs5RHNxaDQrMjZ4akxHTjhMc1dmNm13Q1dV?=
 =?utf-8?B?Q21OOW1XMnJTZFBCWGkxSFltY2dPRklZdWZnODZXWWZJZExrMy9kWk9qeTNl?=
 =?utf-8?B?RzNTMzlpZ25YcU03UFZzaXhtazlXV0VTaUg1WEo4ZTFETkVyS0x6andRZC90?=
 =?utf-8?B?aUdMYUd3MlZUUWdIVU1MZ1dMbzBIMWtJMzNJMEpHZWt0aVM0MmdabVp3U1Fs?=
 =?utf-8?B?dkg0aVFmS3JHOFVNc0tDUzJxTlYzTVRsZDNXTlRQUWozYnJyWWlKUmtsdmhK?=
 =?utf-8?B?bFNMNS9tUGMyTkVjNnlUQ1B4TmdDMmRsVnlacFpobU5LMjczbjh6Q3BoTkpq?=
 =?utf-8?B?T0xpbEhBMGFla2IzaUpkdmxQMklscEs4YTFiY2JrRUNBUWpGVGxJOXZtRUw3?=
 =?utf-8?B?QU96SzhuVE8wcW5uWlJkRHJKNVd5dDRNTi9GRzVXL3ZKYTRkSTRIV0lhVy9Z?=
 =?utf-8?B?c3lteWJOMnFERWVYRjVRWGhDN3NxT0F1cC9vZWJUREN3N3g4OUhqbG1CRzRl?=
 =?utf-8?B?MEtoVGJGSXBSZS9nVGl4N2RFR2hqVnJYMkZPRzdBU3BTWFdXU1RzeEZVeHc2?=
 =?utf-8?B?ZFI1bUU0RFNaRG0xcElWRTJlaGtZWkE3RlkrWExQcGZKS2NCTFBaTGV1d1Jl?=
 =?utf-8?B?TmZlMWpZSTVEdEF6YmZtV1hoSzVWVWRpcnFTSEtMOTFxNkpkcGNDaUl3ejBB?=
 =?utf-8?B?V21RSzdjcTNIUjlnRDYxcjZRTnlDNzM1Ujl4d2xDelM1K2VPd1hFU29SWkpz?=
 =?utf-8?B?SzBwbmhVY2lZWFpUZnNudWhRY0VBTGRwcTFPM0d2QlR4Q1U4YjdmTSsyS3Jh?=
 =?utf-8?B?MFprVFRsVVBuYnlONlRnMWRUSWYvUHlnU0pRYVA1cHhIQWpmbjlXcU9PUmNt?=
 =?utf-8?B?WkVuaVM0dWE1RzVpUmdpQ1BDWUZSWFp6clJPRTZHdW55VndMc2o2blNsRVg4?=
 =?utf-8?B?MmYxc205NjEwN3lOb2F5TTYxRHhhSjY0cmZUSGU2SXA4eTNzMTVXRUpwc0xU?=
 =?utf-8?B?aHQ5U0N6eUFiUWJMSFJHTEhkVUJubTh4bmJ2NkZVSXhZa0g2Zlc3UmtuVnBs?=
 =?utf-8?B?c0lDMWJJTEgwSGtzTzJ5bTBUMlVEcGU2Q01VSitweXVnbUVnYWZXOUFaM1lW?=
 =?utf-8?B?cURmbnIxVGptY1Fob24xQWxPem1OVGlYV3E3SmhTcFUxYmpFaDU5TVEzdzM5?=
 =?utf-8?B?c3VETVRraTBWUGxTZEZKVjZIdHpwb2RrYmx3Um11NEdlRVYvSE5WeDBSaGRt?=
 =?utf-8?B?Q2FIWnBPKzViUUJ4b0xDbDEvZUd6SE5jODYvSU5pZjlqY0RqdFpUOHpzdEpE?=
 =?utf-8?B?ZlZ5b3kvNWVjWXhndGhXSDUyVXVzRHBHcUJra05RTFV3SnBRNlNUUFIzVExy?=
 =?utf-8?B?c0JycVI2bk1LTDlhSlNOZ1Z2ZXM4elFLS3QwMG5rSkYxV2RlbHFGOTBrZ1lh?=
 =?utf-8?B?T1llMG04RFY2WW5NRDRURGtmUDRMSEp1OWNuREVhQW4wQU5RclIvRTA0bjdq?=
 =?utf-8?B?WU9PeEN5SjRmMUJqL052eFd5R0JGdWNVS1FoRndJY1Q1M2VNdHRTOXU0a1pu?=
 =?utf-8?B?dngvREIzbTJwOGVVdk9EYWJORUxiKzIwTHRRci81SzF0VjdDeTVFVlNhUEZk?=
 =?utf-8?B?dVp3ZitsbDlZcHZHc3orSnZBb1A1cTdEZ2k4aURYMmRzREYvTnN0N3JBaWta?=
 =?utf-8?B?cXdjc0NFSmF5czdzdndMYjNDKzlGRm5CbEVRcDdWSE9XN3VNY2NWZmN4MS9L?=
 =?utf-8?B?cm9WN2pyVUZUQjYwMmI2SWhuMTVkUEpxc1g0aG1zNU1ua0RqTDNEcUcyWVdH?=
 =?utf-8?B?ZTMrSVhNZHBxQTgvRFRKbitGNUQxcGZteDBsdk1LQWJ3Nkt2ZzhXUWQrR3Bs?=
 =?utf-8?Q?g2BZaPgtgwoFdbtOfcs+Y5WUH7pUW6YWZzkh8FxFUhPP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B01647CC674B684A9D2109FE002D6F12@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fdf35eb-25ff-4684-4d19-08dcb65428b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 20:12:55.5908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XRpWW8T1q74GnnCuR0sqQ5mu/TmQGwlw//tJNX7NkGNa6M+4XjJsVKzLOrL5la2GnaTdbjNt4T3pqjyhglGUUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB5854
X-Proofpoint-ORIG-GUID: CIguu-yHk5TpV-98SpBah9f1j-f6xxfM
X-Proofpoint-GUID: CIguu-yHk5TpV-98SpBah9f1j-f6xxfM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_16,2024-08-06_01,2024-05-17_01

DQoNCj4gT24gQXVnIDYsIDIwMjQsIGF0IDE6MDHigK9QTSwgU3RldmVuIFJvc3RlZHQgPHJvc3Rl
ZHRAZ29vZG1pcy5vcmc+IHdyb3RlOg0KPiANCj4gT24gVHVlLCA2IEF1ZyAyMDI0IDE2OjAwOjQ5
IC0wNDAwDQo+IFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPiB3cm90ZToNCj4g
DQo+Pj4+PiArIGlmIChJU19FTkFCTEVEKENPTkZJR19MVE9fQ0xBTkcpICYmICFhZGRyKQ0KPj4+
Pj4gKyBhZGRyID0ga2FsbHN5bXNfbG9va3VwX25hbWVfd2l0aG91dF9zdWZmaXgodHJhY2Vfa3By
b2JlX3N5bWJvbCh0aykpOw0KPj4+Pj4gKyAgICANCj4+Pj4gDQo+Pj4+IFNvIHlvdSBkbyB0aGUg
bG9va3VwIHR3aWNlIGlmIHRoaXMgaXMgZW5hYmxlZD8NCj4+Pj4gDQo+Pj4+IFdoeSBub3QganVz
dCB1c2UgImthbGxzeW1zX2xvb2t1cF9uYW1lX3dpdGhvdXRfc3VmZml4KCkiIHRoZSBlbnRpcmUg
dGltZSwNCj4+Pj4gYW5kIGl0IHNob3VsZCB3b3JrIGp1c3QgdGhlIHNhbWUgYXMgImthbGxzeW1z
X2xvb2t1cF9uYW1lKCkiIGlmIGl0J3Mgbm90DQo+Pj4+IG5lZWRlZD8gICAgDQo+Pj4gDQo+Pj4g
V2Ugc3RpbGwgd2FudCB0byBnaXZlIHByaW9yaXR5IHRvIGZ1bGwgbWF0Y2guIEZvciBleGFtcGxl
LCB3ZSBoYXZlOg0KPj4+IA0KPj4+IFtyb290QH5dIyBncmVwIGNfbmV4dCAvcHJvYy9rYWxsc3lt
cw0KPj4+IGZmZmZmZmZmODE0MTlkYzAgdCBjX25leHQubGx2bS43NTY3ODg4NDExNzMxMzEzMzQz
DQo+Pj4gZmZmZmZmZmY4MTY4MDYwMCB0IGNfbmV4dA0KPj4+IGZmZmZmZmZmODE4NTQzODAgdCBj
X25leHQubGx2bS4xNDMzNzg0NDgwMzc1MjEzOTQ2MQ0KPj4+IA0KPj4+IElmIHRoZSBnb2FsIGlz
IHRvIGV4cGxpY2l0bHkgdHJhY2UgY19uZXh0Lmxsdm0uNzU2Nzg4ODQxMTczMTMxMzM0MywgdGhl
DQo+Pj4gdXNlciBjYW4gcHJvdmlkZSB0aGUgZnVsbCBuYW1lLiBJZiB3ZSBhbHdheXMgbWF0Y2gg
X3dpdGhvdXRfc3VmZml4LCBhbGwNCj4+PiBvZiB0aGUgMyB3aWxsIG1hdGNoIHRvIHRoZSBmaXJz
dCBvbmUuIA0KPj4+IA0KPj4+IERvZXMgdGhpcyBtYWtlIHNlbnNlPyAgDQo+PiANCj4+IFllcy4g
U29ycnksIEkgbWlzc2VkIHRoZSAiJiYgIWFkZHIpIiBhZnRlciB0aGUgIklTX0VOQUJMRUQoKSIs
IHdoaWNoIGxvb2tlZA0KPj4gbGlrZSB5b3UgZGlkIHRoZSBjb21tYW5kIHR3aWNlLg0KPiANCj4g
QnV0IHRoYXQgc2FpZCwgZG9lcyB0aGlzIG9ubHkgaGF2ZSB0byBiZSBmb3IgbGx2bT8gT3Igc2hv
dWxkIHdlIGRvIHRoaXMgZm9yDQo+IGV2ZW4gZ2NjPyBBcyBJIGJlbGlldmUgZ2NjIGNhbiBnaXZl
IHN0cmFuZ2Ugc3ltYm9scyB0b28uDQoNCkkgdGhpbmsgbW9zdCBvZiB0aGUgaXNzdWUgY29tZXMg
d2l0aCBMVE8sIGFzIExUTyBwcm9tb3RlcyBsb2NhbCBzdGF0aWMNCmZ1bmN0aW9ucyB0byBnbG9i
YWwgZnVuY3Rpb25zLiBJSVVDLCB3ZSBkb24ndCBoYXZlIEdDQyBidWlsdCwgTFRPIGVuYWJsZWQN
Cmtlcm5lbCB5ZXQuDQoNCkluIG15IEdDQyBidWlsdCwgd2UgaGF2ZSBzdWZmaXhlcyBsaWtlICIu
Y29uc3Rwcm9wLjAiLCAiLnBhcnQuMCIsICIuaXNyYS4wIiwgDQphbmQgIi5pc3JhLjAuY29sZCIu
IFdlIGRpZG4ndCBkbyBhbnl0aGluZyBhYm91dCB0aGVzZSBiZWZvcmUgdGhpcyBzZXQuIFNvIEkg
DQp0aGluayB3ZSBhcmUgT0sgbm90IGhhbmRsaW5nIHRoZW0gbm93LiBXZSBzdXJlIGNhbiBlbmFi
bGUgaXQgZm9yIEdDQyBidWlsdA0Ka2VybmVsIGluIHRoZSBmdXR1cmUuIA0KDQpUaGFua3MsDQpT
b25nDQoNCg0KDQo=

