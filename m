Return-Path: <live-patching+bounces-1228-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42861A44B72
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2025 20:39:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64E2B3AF010
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2025 19:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2FA1D5ABF;
	Tue, 25 Feb 2025 19:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IGz+MjpG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sa2OZDRi"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9200542A8C;
	Tue, 25 Feb 2025 19:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512337; cv=fail; b=lPWrkknq8VWCg9Q2cObEkIbL2mmQ5X29OLv5hP0MjmlieL/lcerznGerXPUP3eInoeqcJGbnn9jlJlONRSerNEpxc7EMnOVmP8XVE5UygF3EdQSOgL2/bz2p9WuxjVNl9oqsWY8ZnstuOp6M93iMWkG95mFG6AtFHybBTnHhPzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512337; c=relaxed/simple;
	bh=ZQCjTHPG80HHvFZpFdKrTmSuz4mMWdi+C8ac8xeGOgM=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YPraquFtzu1FcvjwWN5rnRSMMjqDb0FM308L7ZO34IHVryRjYqAUOh51wQZAH9D7ZB7uXGP/Cvqj2XvEVkE3iT/41Qpet2gweVnXY4Wov4ZavJLRdbQtgcvpJoX6sXuTAU2L4G6nFz72Hdk0l+ae7EOX97NGjVDu8uZ9v90G5Og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IGz+MjpG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sa2OZDRi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PIXf3e007501;
	Tue, 25 Feb 2025 19:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=fMmeLm0df8qMuozLxLA5Sb8aOdicU1v4GjmyFZRsju0=; b=
	IGz+MjpGOD1g4qWC1g4lB0B6zosqHXcG+nkWzUeqqfrTrlhvVJMXtw99/Q/+SDxH
	ZwgsdGdA3WNUuXF+zK5GkCYKVOPiqor8wL7INrH2Cxsa9JSBt25dtgqkW4M+JDcB
	7ciXNjzbdF1fCSmE49rKy0DFXwTvXnLJOo/ohmdAulUnWDu8v8pUP6MqyGERY5OC
	GkwHr1Z4RK5W45c91GTsedS1jQIn8yqZH3jBW4bycil+nmXrpBJxYcTP4pf4ZaKZ
	QwHEFxz+8uUUfKe0XRBMqjUw2ncvZOlaDl3aHCoG50lVMqaWfMbWmA3PyRXF21zc
	nKyCfiYd1pO2FfsvGQ+bWQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y6f9e2bg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 19:38:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51PHvCvG025641;
	Tue, 25 Feb 2025 19:38:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51g8ueh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 19:38:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PIJgUTGA7TVJvySzxJ/MWDDASe2WKWFPGKoaQD6R25eEKHmDSQGWtl6rIsLrDHhfCqq487c7mk1REaRaJm9kkKkNgJ/Ya7oUSeNjPE+Ey2Decyd4s4r05rseJ3MK360ZfZ3X/s2Bzwn5pbgKFWz1Hs3urayJXSKq11gv0Ss48a+yZvPxWBHPEC5m3GOj/HdNjYhdptQdovtP637xqL37XDsnQRwAZox3tFwVumrDhNs4O1T4r3pz5rVpRCqZ2YDrb02b51YLWAG3hLnoJ5oTRMtImy3dD2ye+tjrxCXq7T5Gu9KjWk9xDDQaeZVyY3paiBVNZd2zp9UG5z/qH0JwSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMmeLm0df8qMuozLxLA5Sb8aOdicU1v4GjmyFZRsju0=;
 b=BF2RtHENPvjjEg3qHFUgfBud2pb485uQTLoAvkEyojMtzvCNwIAhH/+rsdxh9+3Knp+L+PrulP1CGusuNQe2mr/Kg+XeySax62SFIpJ6BaMIrlrpeVcK/mpKwb+RVyDnqoPyMpPKngGcyjM1BZzingeI7eoyjHZlCJRobyKGw/G4c6SGK6BE8mj+SE5ifdLyZ7Yw3kbWyukGQy7ueHnkCNhtFFEWDhF4v5WIHrlJKGL0YW6X+TrQ8EBUxzQ0Rdz9qMSMepf3PSxOQb0hL/ci8irOYx+OuoVSKzfZLfm5BWC64fcjQxI+RjEQv5cdehfIX+rC9aYT+SI4iSJsCuXUGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMmeLm0df8qMuozLxLA5Sb8aOdicU1v4GjmyFZRsju0=;
 b=sa2OZDRivq//Fgq6/JxjSrUg+Tnyr1EVOCVNi2iv4BoHT6jL1qtcrT94XRQrkuhR71DOLGliTCct3yfJL1YYxYMoE5YN/foIpC6g1jPssSZ5Zth5UbPwha8vmFQ1ZuFHs/xJHP1p9D3/jpkZ9Vi6WnZS12t+x49XWcFZrTXumIk=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by PH0PR10MB4535.namprd10.prod.outlook.com (2603:10b6:510:31::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 19:38:28 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%5]) with mapi id 15.20.8466.015; Tue, 25 Feb 2025
 19:38:27 +0000
Message-ID: <4356c17a-8dba-4da0-86dd-f65afb8145e2@oracle.com>
Date: Tue, 25 Feb 2025 11:38:21 -0800
User-Agent: Mozilla Thunderbird
From: Indu Bhagat <indu.bhagat@oracle.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Weinan Liu <wnliu@google.com>
Cc: "irogers@google.com" <irogers@google.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-toolchains@vger.kernel.org" <linux-toolchains@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "puranjay@kernel.org" <puranjay@kernel.org>,
        "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "will@kernel.org" <will@kernel.org>
References: <20250210083017.280937-1-wnliu@google.com>
 <20250225010228.223482-1-wnliu@google.com>
Content-Language: en-US
In-Reply-To: <20250225010228.223482-1-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0262.namprd04.prod.outlook.com
 (2603:10b6:303:88::27) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|PH0PR10MB4535:EE_
X-MS-Office365-Filtering-Correlation-Id: 585afb8e-9d87-49a6-256d-08dd55d3f9f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWxPTWdtYWV3Tm9zY0VzUUJiOTVtWm9BVGlzbnYwNjhEY25jVmo0QXEwc05C?=
 =?utf-8?B?ZmY5NVQ5emkxT090SWllWm9GV000Y09ycGhDbDZMUHBycjdRbnRHVWZnR3Fp?=
 =?utf-8?B?T1NWQmtwSWxGbzFFcHlvTWF0QnY0cStWMnhaZWZCblMwMWdJV2xoVkhESDk2?=
 =?utf-8?B?RjN4SGFCRk1td0h1Vi9SenRZR0JUU1ZWVmZPcWNGcDJYa0VBbjRJM3B1TnF1?=
 =?utf-8?B?ajI0RTJZUzNnT1pUVStuQlZTT2FjRDduZVIyNkEzY2RnK08xSmFrZnV1SUpy?=
 =?utf-8?B?NEw1MVVkdURqb2w3c3BWdG1XMU9lY0FUZjNxTjVFOGhtSUhiM3UwbXk4S0hB?=
 =?utf-8?B?T0kzVDBVQm1JY3kzbU00aHZUd3dyUmRBMFFzaTd6S3RnV2kyVmFaN3hzQW9U?=
 =?utf-8?B?WEtnY3ViZHArTHUwSWlFTUNZcEkxYmpjbnRacE9mUzAzTVNhZ2ZuMHVJT293?=
 =?utf-8?B?ZG1zMFo1QXNhZlFLMEZuUzN6bHdLelF5cTVYM2RiRUV3b2s3UmtWMXdwY3J1?=
 =?utf-8?B?S0EvN0JOQ0FuOUZFdWZQUWh1aDl0UDJCTUtoclltRXFjNlVUdk81WjlaZ25x?=
 =?utf-8?B?aytuVXRlRTlWZGsyTVh4L3M1Q3J6bzdIbEZiZ2hQNU83alcyeVNEbklMZEVr?=
 =?utf-8?B?ZEs3bC95aGIvcXVQSkxDbzMwT1N0VXRnWUZEa2JWekM4MCt5SmhNOXZXaCtt?=
 =?utf-8?B?K1ZQTlpNZXpxQzZJaGgxc0ZPRDJ3K0lzWXJrRXdsQmFwbkcybkRKVGNBYlR3?=
 =?utf-8?B?WmNaaTcwYUROVjk0QlVEekFuYk1EWHVxUDRzTlFQZ1pNcHpZMEpTMWhMT1or?=
 =?utf-8?B?dEt1S2p6MzF0Q1hCV0Vkd0dFM0U5bEhkMHlnTnBTd2oyRjNQcURldG9kQTJ2?=
 =?utf-8?B?aWVUenJtNUt0Rlc5Q2N4RTJiQUdwdnd6MXB5SEh3dmpkS2E1ZWFvNC9NN1Ro?=
 =?utf-8?B?eXUwbDFOM0R1bVRPdWx3VFNtZ3NJVnozbDZIa0o3RDI0aGJEdDlEcEQ0TVA3?=
 =?utf-8?B?ZURDYXNTdGVrZHVNSHhGd0xkeE9aNXBSdnl3WFRaYTk3QVdYNmFUOHZIQmtX?=
 =?utf-8?B?VWRiZHV2ZWJjV1ZUSDYxNzRwc01lN3NPOTNTQ2Y3WmNrMCsvZUZaSmREQm90?=
 =?utf-8?B?bDlLL0FybFNrOU1QWkJROU5oRW9Cb0R6UnlrV3dPSmNkN1E4c0VjZ1dsWG56?=
 =?utf-8?B?NzZWUUxKb3ZrRDdjTm5oaHUwVkhEVFk4bWtXcFN5QmcvcDA0SXBzWkxZc0I5?=
 =?utf-8?B?NFpuQ3ZqWGZNTHBya04yNjhudExYYjRZWWdBVUNEUEhBQmRjTHJLT0pPZHFC?=
 =?utf-8?B?VzFBK1B5MzZyYXo1ODBLQ3hyZ1VYVjl6aXR3a3pUWDBuenlpajF4UWJPdFJX?=
 =?utf-8?B?TGo4TXVjSE1vRTk5QjFuNWhCKzBvL3lWeHRlMXJKcnU0elRXTU9MMDNiRnZy?=
 =?utf-8?B?aktrY2M0VEpsTENKVTlxYmVGejh5REMvZGNQUmR6MmhobUhFQ0k1SmtDWXND?=
 =?utf-8?B?VG1iYUhDZE9Rd3gxQlpGcHAwOU9FUjVsZmViKzJwR1Z1NkNoSzNoZjhGd3g0?=
 =?utf-8?B?OXRYb2dZbERLVkluS3VIQVlEUGhqMENpT09JSG5HalR5VkxKYmF0WlN3emdX?=
 =?utf-8?B?WENNV3prOU1wOFIyS21wRXU2SXA5MXF0bkFoSGxMRDBZNVlMVVR5YnZQcmh1?=
 =?utf-8?B?R0FHYXlVZ29JOEtNSFZaT2l4UmR3QnIwdGVKNlZkenB2K2RZRG9wVlpKUDNQ?=
 =?utf-8?B?b1BhWTZoWkkvNGJyZXRzSVBFUXY2OXdTQkk5cUVha0RMY1B1TytzYkpPWWZX?=
 =?utf-8?B?ZG4wbmdwTUhnbWV1dkFHdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STlPY3JSMTNCL3RCeGpvY2hON1c2NCtGQ2pGajZRYWljakxTbkRFVGFNMmQx?=
 =?utf-8?B?S1MvWWtIbk1ocFdkWGRNZ1FKalZWalhFQWMxZ1orTU1jUWk5RlFBSVFvQk9s?=
 =?utf-8?B?KzE4VlVPT0hNWU9DSjJKYUFZMDBsWlJ5VUF1NG9kZHIzVHFBUlNNTGRZZ1R5?=
 =?utf-8?B?V3ptWVc4Q29LSnZJaFJSYjhyYUs3T1pZL0dEcjNmeFlLUk95SDE3R3ROU0s5?=
 =?utf-8?B?aHgrZTNtK1VMaEMwR0NkZHdVb0p2bmhRbnJJQ0pHaVQ3czhtWXgvU09GREVM?=
 =?utf-8?B?VjBCdGZjblIvSVdOOUpJTGZieU02QkNzRnh3SW5IRU52L0pxYmxpb1F2M1BQ?=
 =?utf-8?B?d1R5SUVtU0xSZVFXaThIWlNRaUdWdE50TTZubW1KME5nSE00Uzc2YzJPVkc3?=
 =?utf-8?B?b2NVaGVIOFpvdUZRS3ZHTEd3MTI1WlZta21md0gydnRNSk95cDFHV0ZsME9E?=
 =?utf-8?B?Y0MrQ3h2V09tMjBFeUgyQUJuTmZyckZHbVZaZERUbm1CRHIxc3EyZUpEUllH?=
 =?utf-8?B?ZHRBN0tKcU9EYTlOeUI3Z2tuVnlIN3NLa2xYa3JWY2o3cWFiUDVWckE1YkRu?=
 =?utf-8?B?ZHhYam13MCsvUzRwRWhFeW1hMHBsSFkzM1B2bDRzWFVqS3BoNWZVZy9pWnFT?=
 =?utf-8?B?TmpJTGt4UkZEaDhERVJza1JzUThKeldtQ1Rkc0F6ZFRQYWVuQjJEQ0ZDT3dS?=
 =?utf-8?B?YVdjTUM2bFU0TnBLMkt5Ri9qSEFPVzRibENIOFB3dHdSRzEva0dLdTI5bExX?=
 =?utf-8?B?cFRvRnRjb2R4RDVDMGFXMEY3T2FoSVZqSm4vcGdQTGRndWx3M0x0dmpFbXBu?=
 =?utf-8?B?U3RBTVR3M0NFMk52TGhlUnJVZktPVWs2OGh6ZjRXNnpyRGJGYnhvUlpHbk92?=
 =?utf-8?B?ZGVtVHdVZUV5eDF3cXRRSy9YKzZ1MXJjelZvckFNT0hPV3hVb01tUDlUVVBE?=
 =?utf-8?B?cDhySVc3Zk9JZXhwdHRGRDh0bUFOdXRpZTNlNjgxRDRFYkU5WFE4RmZ6WmU2?=
 =?utf-8?B?YlBzMFRHdC8xaFlwL3VIN2N3YVlJT3FpV1JSdU53cVFwUDlUOU5ZTTkvUFFx?=
 =?utf-8?B?Q0cwbEN0WXA0Z2ZPTGZhZmpWNldjMkRoWWpmSFU0b1Y3WFBKSmg2Y21Dc1Nt?=
 =?utf-8?B?Z0JRZ2RzRGdrNUZZQnpjSTIzTmlmSkxKZmFQVnZMNDZrU3hiL0JwYjR0NnN1?=
 =?utf-8?B?N2tOR0MvRzgyM3ZDbzRLTkxRV1pHS1RSNW1CaDd0cmJBb0pLemtWOEtVL1Ry?=
 =?utf-8?B?d3pCeWpHMUx2bTNWQktpWDVoT1UwMmxucWdzeVdQc1lqb0FqTG9nbmlVRWor?=
 =?utf-8?B?dmxjbFJobUcrR2t3emZtTzhOd20vTFZKUTRZVXI1eFRvRDB3Z3FPYXFER0JI?=
 =?utf-8?B?VjhFNEFhbElITnVBVzhlT2ZSWktFZ042ODJRaUtNTSswZXdZTDR3Wm9Ga3lS?=
 =?utf-8?B?eEs4V0RqRWU2SGdUcFFraEJuUmlKd2RRWlpiUEJDOVg1UG5QNzA1dkZtQ0pI?=
 =?utf-8?B?Sy95WENMYTE0V1pwU0oxcTZQdGs4cFJINjVyWTZSVWdDU25ib3czRzVUczEy?=
 =?utf-8?B?akxpakNmZlMrWTR0S1lVdWZMckt5cWpQTGRrMUtMbk5Xbzk0WEo3UFhMYVl4?=
 =?utf-8?B?WUJzUHNzOVFWNXFObVBydmtwYm1vZWozb0MrbWRpcjU4WGlJSUxNVjAyZ1FF?=
 =?utf-8?B?TTllKzhnVmFtVE1qUG8xcThKcjYxT1NvT2kyQWptNktHWXF2azlsMklsZUZk?=
 =?utf-8?B?Y2pydzZHY05qK3R0UHg5N2FWY1ZDNnhsT0kzUGEzZjV5V1lENTR3QXlLUlVh?=
 =?utf-8?B?QmovWFozbXVpN1J2M3k0RHJzc3VlQ0hsc3Y0QzR6eXA0bWVzZ0NEN0k2bGdu?=
 =?utf-8?B?eFlOaHdFM0l4OGNkRGRmdnpQM3JXc3lhaEU2REZ6UGZCSmlxd0tJYkpiUDFU?=
 =?utf-8?B?dnljTWZJc1hNbmdXSmE1OTNEMlpFN3ZPVjVIWXZSRC9hRmZYeGhna0dhSUF6?=
 =?utf-8?B?cTdaRC9vZWlrbFNUTWxaQmsreHNNWXNsaHBMYlZvN01JOVNOU2lNREpveE1Z?=
 =?utf-8?B?L1c4dHBnNlYrZCtxeTVOWXEzaTdyTDZpUjYwNTg1b3dRWXpMNm5MRzdpVmhT?=
 =?utf-8?B?VjdNRnB1akFXU2ZLM3FtZ1lzWFVqcGlkeHJVM2pPTWRWTTc1d2xnWDdjd2Nz?=
 =?utf-8?Q?YZgQGpGsJZG87hzGyKAW8w4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FC0vd63oDWUkJb2N0O7+mp3RHd4Tlpl0kSQ/dmwSmGV80Inyr7AvCd73i/BI6VFC87ilvsUGCW22V/OMK3loYwP+rUU23lJsxAlKnHFLwne3n7DkqyBmTdynbGYMeKA57sYW7aKSAHxsqbzLfdMahpgkfZVxUHkEDUUe48VxqZnloqy9rm6O/a5eCZ4IHDQUwB6LCbsmZMS4mLg86e1wYQuAey/1fa1pmavL3j9fLDfxCX1VAZOI30IcRVctUxhH6iFU9gebPfH3i3miE7zb2TnbdPKFUl+rMBtcMKKCI7S4n9YoQgK6QEjEWqN2CCyduSp6LyxnY9LmQtnqtAfrRj0fONtL+cEenUlZMOONUh2rS1kQ4ULUoRRrOWU2h+HOVIZ0UveNA4/yr7c3Kg+11XNz8hGQVDxN4hOoqAFJFTSDu/IORDYUdCv7EpNEtxUOGr9GTLf9E2x9vKZ3iItx6vwBp8BlUmeOdbPxeOOC0IXivmt/764qsoFvkCIxZrMY+G50hqjHLO3StkHDnU1S8dMW2dSD7ihL5o+rfoJFlGamkVkObY4e8GUNblUCv8zkD/OeUQNNdXrn6z2DleduoOpYvzRYHEIk4RJJQmzs6Mw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585afb8e-9d87-49a6-256d-08dd55d3f9f6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:38:27.8866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CsQXKpPKeGDpJe/GBRndKqomtC7ubHDS+qTrNUeBCyUGy2vF2ujDI0T1M3RW+I3d0SesKGGvS5twBeKmuVvZqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_06,2025-02-25_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502250120
X-Proofpoint-GUID: G5XvcfosplJo-ktON56L17Pzr1LpsRpW
X-Proofpoint-ORIG-GUID: G5XvcfosplJo-ktON56L17Pzr1LpsRpW

On Mon, Feb 10, 2025 at 12:30 AM Weinan Liu <wnliu@google.com> wrote:
>> I already have a WIP patch to add sframe support to the kernel module.
>> However, it is not yet working. I had trouble unwinding frames for the
>> kernel module using the current algorithm.
>>
>> Indu has likely identified the issue and will be addressing it from the
>> toolchain side.
>>
>> https://sourceware.org/bugzilla/show_bug.cgi?id=32666
> 
> I have a working in progress patch that adds sframe support for kernel
> module.
> https://github.com/heuza/linux/tree/sframe_unwinder.rfc
> 
> According to the sframe table values I got during runtime testing, looks
> like the offsets are not correct .
> 

I hope to sanitize the fix for 32666 and post upstream soon (I had to 
address other related issues).  Unless fixed, relocating .sframe 
sections using the .rela.sframe is expected to generate incorrect output.

> When unwind symbols init_module(0xffff80007b155048) from the kernel
> module(livepatch-sample.ko), the start_address of the FDE entries in the
> sframe table of the kernel modules appear incorrect.

init_module will apply the relocations on the .sframe section, isnt it ?

> For instance, the first FDE's start_addr is reported as -20564. Adding
> this offset to the module's sframe section address (0xffff80007b15a040)
> yields 0xffff80007b154fec, which is not within the livepatch-sample.ko
> memory region(It should be larger than 0xffff80007b155000).
> 

Hmm..something seems off here.  Having tested a potential fix for 32666 
locally, I do not expect the first FDE to show this symptom.

> Here are the sframe table values of the livepatch-samples.ko that I print
> by qemu + gdb.
> 
> ```
> $ /usr/bin/aarch64-linux-gnu-objdump -L --sframe=.sframe ./samples/livepatch/livepatch-sample.ko
> ./samples/livepatch/livepatch-sample.ko:     file format elf64-littleaarch64
> 
> Contents of the SFrame section .sframe:
>   Header :
> 
>     Version: SFRAME_VERSION_2
>     Flags: SFRAME_F_FDE_SORTED
>     Num FDEs: 3
>     Num FREs: 11
> 
>   Function Index :
> 
>     func idx [0]: pc = 0x0, size = 12 bytes
>     STARTPC         CFA       FP        RA
>     0000000000000000  sp+0      u         u
> 
>     func idx [1]: pc = 0x0, size = 44 bytes
>     STARTPC         CFA       FP        RA
>     0000000000000000  sp+0      u         u
>     000000000000000c  sp+0      u         u[s]
>     0000000000000010  sp+16     c-16      c-8[s]
>     0000000000000024  sp+0      u         u[s]
>     0000000000000028  sp+0      u         u
> 
>     func idx [2]: pc = 0x0, size = 56 bytes
>     STARTPC         CFA       FP        RA
>     0000000000000000  sp+0      u         u
>     000000000000000c  sp+0      u         u[s]
>     0000000000000010  sp+16     c-16      c-8[s]
>     0000000000000030  sp+0      u         u[s]
>     0000000000000034  sp+0      u         u
> 
> 
> 
> (gdb) bt
> #0  find_fde (tbl=0xffff80007b157708, pc=18446603338286190664) at kernel/sframe_lookup.c:75
> #1  0xffff80008031e260 in sframe_find_pc (pc=18446603338286190664, entry=0xffff800086f83800) at kernel/sframe_lookup.c:175
> #2  0xffff800080035a48 in unwind_next_frame_sframe (state=0xffff800086f83828) at arch/arm64/kernel/stacktrace.c:270
> #3  kunwind_next (state=0xffff800086f83828) at arch/arm64/kernel/stacktrace.c:332
> ...
> 
> (gdb) lx-symbols
> loading vmlinux
> scanning for modules in /home/wnliu/kernel
> loading @0xffff80007b155000: /home/wnliu/kernel/samples/livepatch/livepatch-sample.ko
> loading @0xffff80007b14d000: /home/wnliu/kernel/fs/fat/vfat.ko
> loading @0xffff80007b130000: /home/wnliu/kernel/fs/fat/fat.ko
> 
> (gdb) p/x *tbl->sfhdr_p
> $5 = {preamble = {magic = 0xdee2, version = 0x2, flags = 0x1}, abi_arch = 0x2, cfa_fixed_fp_offset = 0x0, cfa_fixed_ra_offset = 0x0, auxhdr_len = 0x0, num_fdes = 0x3, num_fres = 0xb, fre_len = 0x25, fdes_off = 0x0, fres_off = 0x3c}
> 
> (gdb) p/x tbl->sfhdr_p
> $6 = 0xffff80007b15a040
> 
> (gdb) p *tbl->fde_p
> $7 = {start_addr = -20564, size = 12, fres_off = 0, fres_num = 1, info = 0 '\000', rep_size = 0 '\000', padding = 0}
> 
> (gdb) p *(tbl->fde_p + 1)
> $11 = {start_addr = -20552, size = 44, fres_off = 3, fres_num = 5, info = 0 '\000', rep_size = 0 '\000', padding = 0}
> 
> (gdb) p *(tbl->fde_p + 2)
> $12 = {start_addr = -20508, size = 56, fres_off = 20, fres_num = 5, info = 0 '\000', rep_size = 0 '\000', padding = 0}
> 
> /* -20564 + 0xffff80007b15a040 = 0xffff80007b154fec */
> (gdb) info symbol 0xffff80007b154fec
> No symbol matches 0xffff80007b154fec
> ```

