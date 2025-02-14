Return-Path: <live-patching+bounces-1204-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1966A365D4
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 19:42:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 964D51683C6
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 18:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB2E190472;
	Fri, 14 Feb 2025 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZK5R6UQF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Oeh0xg3H"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D31F23A9;
	Fri, 14 Feb 2025 18:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739558516; cv=fail; b=G43RpX45eUAiCW3hW7CX7s527fo+cWDujofmwaQRgXR8fxLnJ6nQGyxjB5E7Ie4c2mfHz3kSL/hHFjezlKnoyna5KoJ/z84itVPLs2Wm5u8b1zl52CRsIDfGYzFuC8XwDQOWWV9uK87mbTN3dq3D0YZ4DDihDR3IY11L1QavEnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739558516; c=relaxed/simple;
	bh=XzswxVJCgHBFr9pPbLmpLgtRfvEAEc7qiv/Lup7dk6o=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W3+FGW9bhQeIE8LUfSVNb0jZGebbom376i4DF1zg1NAAMeSdHLPi55f8enYCACaZEyhsHbMMB8fusGQfxer8lLikgiQqkq6F3P4vy7uRr4/ENmk4cfnXOSiINuBjNJgpaxMTVXX7r90dwsMleN0RWU0fJuhOxaZeh1J6tHsSUc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZK5R6UQF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Oeh0xg3H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51EGBXpx026827;
	Fri, 14 Feb 2025 18:41:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=TS4ZVEtaxKsQvx8I/0jC7PvDCpnUku0Fkxir6IfLwEg=; b=
	ZK5R6UQFxCATfszHZ3GvmhQQdneVroAHcKhW469rj4I3dj4j4eAbrzZ4mPOaq479
	w/P3Wl003mgH6AJZjR6DLoDlZv/ykiymAxNyS6bO5ZCSd3YnH/OMnmuX9D6vyiuz
	wdlESwn8Gzv7rkuKqbEKBrtnPtg6WkCSCVK/K43Wt2IyK/AHF4H3VM3EGGh2XLe8
	B/96dozAdXv5XM5rZ6Qpn6itAx8WjDJjQeBxKYtbIKjNk4KR+pj4nwoPZZIIAmNa
	7/ldQLVVLySy3CUSZNwrnPfilUOIRFr/8D87X4LXRMXENAjmlTLMb0tPEW5hDaXS
	VUzCsidJFFzbGGWockDm/A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0q2mah2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 18:41:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51EHSv2D006696;
	Fri, 14 Feb 2025 18:41:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqdg2eb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 18:41:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lMWVymbDLLnqW5GHLmJyXIG2AkvU+BapCxwq4OYU9eCCMEFJjFRkgT67CpMxklURxcrJ0n+6E5CE8pgY4lBihVQe/hS+RPiXeWZClB6VL9yf9N8I58S1EPHpM4YByKGIdI8DAqnO4EKdEBaHNHeaIBMtpZ5zhmWqybvnTswQmG+X20A/Wj62VWDfSLcNw23RY7uU41TipmJxYwXRUFbFycJucSrZtJruH0uSIPnSnHr4LSRDCdSAaItOMq9DQhekCini/Omk3jigOvAYqduD2o9IiYkd75S1KahtHRMX82vhAQ7FO9T7uziWeaVCya3PcWxHVL34b3MsKvUsx2Ndnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TS4ZVEtaxKsQvx8I/0jC7PvDCpnUku0Fkxir6IfLwEg=;
 b=IJhoCwSop6lcpIQ5jzIsE1foFgm9NvRQbwSBmt5xVJxTDpFlQYZNCGiwvET2XP6wbs+YR7JVYYtZ/sPgCUE/EeYaWyEM/qgah4PclDE/xyyb7J8TV9IfZPv9eGaA5hs8XreA8/OFj+LNCLqwOgaBE8XZiulZl5WBbPyb+tFr9Wx/kSmm5P/tpYs9iNSPzBQIj37tpXRILJvA9IG5+5d406LuQpFQM0IuZ33cCjrHrHr7WFZk6jiJNhN3BNAe7EJF2iwRZL0dtxMjqeKcqkW2CaVTsVB7xAWKMImcqtGaT4JshVBd819AvVi9BXvwllbRi/EKS8n01Wl4LWCZsklvEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TS4ZVEtaxKsQvx8I/0jC7PvDCpnUku0Fkxir6IfLwEg=;
 b=Oeh0xg3HzcyHFvvBpUpkpmLF+rf8vaHPmpl5K8ev84LwwbDhVcYrt5puA08sbAsksbImX4YAgIq++LOnkHkBuO/ApsgHrQbGx+Pu6uN7gZHKMvIH5B2fWeeq/61tjVfZ3C17DXLtYl5DQqWgVyw7RtImcGdSaqTk6VADR2iDw10=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by DM4PR10MB7425.namprd10.prod.outlook.com (2603:10b6:8:180::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.14; Fri, 14 Feb
 2025 18:41:17 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%5]) with mapi id 15.20.8445.015; Fri, 14 Feb 2025
 18:41:16 +0000
Message-ID: <d91eba9a-dbd1-488f-8e1b-bc5121c30cd1@oracle.com>
Date: Fri, 14 Feb 2025 10:41:13 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
From: Indu Bhagat <indu.bhagat@oracle.com>
To: Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Weinan Liu <wnliu@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
        Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
        linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, joe.lawrence@redhat.com,
        linux-arm-kernel@lists.infradead.org
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
 <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe>
 <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <3069bb9c-6245-4754-a187-ac8253103d32@oracle.com>
 <mb61pa5apc610.fsf@kernel.org>
 <f8d93a1b-3ad0-4e19-846f-c08d9cb19f48@oracle.com>
Content-Language: en-US
In-Reply-To: <f8d93a1b-3ad0-4e19-846f-c08d9cb19f48@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:303:b6::13) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|DM4PR10MB7425:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e8166c8-9cdc-4078-079a-08dd4d272a60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHlwaWEreDBtd0w4MTAzcVNpdXNhZGhXemNERXZueWlhVndtSi9TZ1VXQVh5?=
 =?utf-8?B?eDRWNURWQlo3eE5LV1M1a3ZrUmdxMHpxOG4rcTA4VUFxakFkWFRIMFpsTURs?=
 =?utf-8?B?OW1mYmtZOVpzOXlXYUlHNVF1aWtNU3V0WmhBd3hGYTUrY052aWRMN2pMdkgr?=
 =?utf-8?B?ZTB4eGg4d2l5bndza2hXdzR2VFBGUUJjSFpDZmszVVN0cXhpZGFuVTVZSDc4?=
 =?utf-8?B?d0JnTU9jTEtubUFoeVRyandhUUVRZlhKMVd1a1d4aWVsaEczTzBaNWtvMnVW?=
 =?utf-8?B?ZjlaT3lnWC9lb3lwdklTd0U1bWdsUlRnSG1WT3hkaVM1aSszWGo3NTV0Tkgr?=
 =?utf-8?B?YXArcXgyL1hZVzNaSGl2NzFIdjlTdTQ3UE16d3Q0dHVZTUxLODZucmhtMTFM?=
 =?utf-8?B?cWc2cUorTCtnYVV3Ujh6VVNuelFYVFRONmFVTjJCb1gwY21MalRlLzhKVTJS?=
 =?utf-8?B?Q3JlRytPWGpPWW1uR1RFeUJsZTI5Z1U5MjhucG0yVDgyZW5pVjNKdlN3d09H?=
 =?utf-8?B?eU1TSWRCcTF1SWtNWXBsZ1lwZll5NVBxcENKR0FWanRUWGkvRXVVbWlLdHVL?=
 =?utf-8?B?ZEVUbGc4R0tJK3BKcGhXakJPd0hoY3ZOSmRqZEJTQWQ4QVAzdjV3UXJ4cUlu?=
 =?utf-8?B?Ung5SkhZWmEwcGIzcWYrMCtYTGw5OWFwOGdrVGp6NVVsSnlEeWwyUTc2MkF3?=
 =?utf-8?B?VC9mY0F2QXdzdmlDWmxGeHdhY3p6QjJLQlAwSnhWT0N2NitvWS9XdW1HNkJ1?=
 =?utf-8?B?bHdaOVNpQW9WWHB1RFlPVU1RczUrMUZQU0R5WUVFcmlDODhVa1BJcXRsdmF5?=
 =?utf-8?B?M0thUytMN3N0ZitkTTRVTG5YZzJxQkdrOVB5UXB0aXpQdW1Lc25zQ3pGRElH?=
 =?utf-8?B?cklXTnExY0Y3c2R0UkFBT0lVVDJSd2RaNEhQNWZxOCtKcUVNdmFBd0RTcWxt?=
 =?utf-8?B?ckdlSmVWUmw1dTQ3S3hBWnRzcHh4NU1XNDZHb0RSNHNmTnBJRldwNnBmMHYy?=
 =?utf-8?B?MXY4dkhXbzJtWkt3TW9hUXhQOUhscVlPL0tWSWloM3NVSlJuWjlYYTRmZGd5?=
 =?utf-8?B?L3c0MkdqVjhqRW40d2lIRm00ZEhmczBnK2ZST2g0V25qcFRkSFFIS24rV2VD?=
 =?utf-8?B?cExaUXRJNXNBNHdPb0RZRU5Bc2JwOWg5RHoxaWJEc0dlbmNLSGVRakdVMXlK?=
 =?utf-8?B?a1B4TGlUMXdHemE1RmVQRWdhM2lPN2liN0NqSHFMdzUvTzg5YzNQUVlwaGZp?=
 =?utf-8?B?YjMzcEJ2ZTh6YXB3Q1lEZ01NWU5TSExZREpFaUZYWUFGRVFCYWhOay9MdGNz?=
 =?utf-8?B?YU5iYjlkcFRZTzhUdWhTQmJDTnkzQThxSmcxN3IvdkpSYTlVZFFzZUw0ZCs0?=
 =?utf-8?B?bGdJeVhOaWNvajBVbHB6RHlpV2ErdHAraHp6TEVDWSsxdDZKK2pyYkU1L0lY?=
 =?utf-8?B?YUtFK3E0TGVIT1dPWHZMQzc4cERZdGxUSEJmWnJ4dndQUm5TdFgwQ1ZKelZv?=
 =?utf-8?B?aU9rTS9pMVJxL2JJa212SlhWRmZHcjFkUFpaWllmb1ZVMitBYjBQajNmQUw2?=
 =?utf-8?B?NjVKb3Fqd1JaeU9NSThUVUR1aWRyMStXZXFnOXJIMDBxMkdXVmFwUytJOS8v?=
 =?utf-8?B?TUgvdnQ3S3VSN3RTdXBacFNvRWlDcjN0cXRMNEdVd0UvSUd4dy92U0lnMUhy?=
 =?utf-8?B?ZXFySXZDNmh3cjVnc2ZCcmxxcUg2Sy9xNm9oU2o1YTY3REtZcE9XbjRpcGpa?=
 =?utf-8?B?TFY4eUhPeEpjS1N4Y0U5OXVZTW1oS2NJZ2VQZldUTEphMUtxbjY5UzViV0VY?=
 =?utf-8?B?LysvekRncWh0YmlWVm5JSWErSlVFQXkvMk1yZmdUNVh0Z2FYUi9vL1hrWVVz?=
 =?utf-8?Q?sO7zJ0B4wyDKH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QXZHRlEzcnhyMzNXbzBaTEJnMDh6dlBzVm9EaUtTL1pYK3Z6NXZiQ1JSeGwx?=
 =?utf-8?B?YksyVnI0bkQ5RVFNU21nQjBzZUJUOUk5R2hRc1c0TzhERVAvZDM0cFJxOEZp?=
 =?utf-8?B?VExOaCtYL3Z0NVY2T1UxcDRkY1E1VE1sTWFidk8vbUE2RldaSTkzRHdqS2ho?=
 =?utf-8?B?UUZTNjJ6V0Q2L2t6bTE2MkpMNkR3WEVDWXdWc3Q3UG9pRTNGcEZNWWJQVHpn?=
 =?utf-8?B?WlMxSnVZSVAycThmNEp3RXJyS1p2YjlLcHN1Q21mMW9rK050WEJCQVdWSitT?=
 =?utf-8?B?V2c3SFhWZzk3S1NMWUR0dGU4N0tYbWRHNjUvUnF6My83VzFhbU1rOXdiTjM1?=
 =?utf-8?B?UjlwbG52RDBabUhYUytHODc3dFY3Y092Z1VUeG1SUWsyRnE3eldQenFKcXla?=
 =?utf-8?B?SStBN29scjR1ZklNNld6U0hlTTRud3JNYXRQVFdXOEtkTnhmRWhjMlpnQW1X?=
 =?utf-8?B?S3dZM2pKS2J1RkFzTkpjQ2phVkJqd2RmUXo1eTlHNUVaM1ZydHpDNit1ZCtI?=
 =?utf-8?B?RG4vWWEvY3B3VVAwOFpiMVBSS3dIYmVJTG91ZGRDdzNOckhwMndIQm9OOUlT?=
 =?utf-8?B?empoenZMem94ZVZpVitOcFFsdzdmemtsNGduamxUcVpyVks4N29aaHQzM0wz?=
 =?utf-8?B?dXR1b1RycGU3Um9USndGcmNDN0l4L1BMMDE4UzVpTk12QmJuZ2hRaXc5Zno5?=
 =?utf-8?B?Y3VQeEVrZEwyaUt2NUJvVi9GWko2N094VEdFYXVsbTdpMmJHaENoRnpZRXNU?=
 =?utf-8?B?WTZqaWYrdWQxRTRQNnhOVFB0RnBMczdWSUxVRnNGTGIxazBtK2JJRGhWOU9R?=
 =?utf-8?B?TU4yT205WHdnUlU4VlVMbHkyN3lFRW5KangxZUNjZWRTQi9uK0tkYWZ1MFFy?=
 =?utf-8?B?OXg4YndsYmVvWEhKZEdQU2RhUnhLSWNnbUluYXg3b2RYcUw4NUdSWXB2d1RR?=
 =?utf-8?B?eVlWQm9RcE53UC92aEZjRzg1ZitlNFpBWHFiQWg5ZnoxZlpuRDNvWnh5ZVI0?=
 =?utf-8?B?TjRiOGFyalNtY3g2ME5WSWU1ckkyeElWNno3ZGIxa1RuZVlNVWxJakQzaVd2?=
 =?utf-8?B?TVAxWVg1eWtJQ2NRY2J0cVhvalFHUGt1OWErMDk0RDZWNjdYNUNTR1ZJZGxE?=
 =?utf-8?B?a3Q4TUhvUGhJK0hqeDkzZ0MxSjQ3VXJLQ2FCTWR4Y1Z5WWEzaklvb09jRWFK?=
 =?utf-8?B?U0o4YmlVbzhDdFFEb0Q2aDVVQVd6c0hkK2I0VHB2MG8zK1NST3R3QkVHbVND?=
 =?utf-8?B?ZW9MODZhRUYyZk5KRFJEV3l4aU9Na25ubmhyV1NOY2I1ZElvQlJkNnhTVUky?=
 =?utf-8?B?cDR3VU1jMkxTdXlLL2NLalgzcFYvZ0t0bGtMbXpiSVlMMWVBUHlsSDNpZEdq?=
 =?utf-8?B?dmN3MzBHaDQ2REMrR1VhZmVCbTBVbkdvQTdXL0hCaU5TcTJ0UkN2eEpLMExQ?=
 =?utf-8?B?dUUybjF5UW54TVB1a2JhRUR4ak1YRnRjOWZDZ1NibVZmZWhlZGNCSStHR0R2?=
 =?utf-8?B?ZzlCVGFldHR4dGZFS2plU2UxZ0xOa0N3VUNUcVBCOE9KL0FZeTdNVW5UVU5N?=
 =?utf-8?B?eExFcUE2QTFGaldNN20vVHhXOTVKNDlNU29EUEx1bU01bzBRYjliMURSSjZE?=
 =?utf-8?B?ZUZJYy9LUitHSnhhMm1CbDRpREtlY1p6ZEkycGJYV25kOTNLRGNSZmVycTF2?=
 =?utf-8?B?VTNXY1ZuVzgxMTlneWNneXdEN2hNL3JJblBDa25QU3lnRHNPakN6cUJVSjRO?=
 =?utf-8?B?SnpobGFEYWlLVDZIRjhMNXpjb1lObVI5aVFDUXg2RTJZRTJDSEdHMXk0VXdr?=
 =?utf-8?B?amZnTEZsT09Gb2lFK2JJVjhwUkNidjRaaTFwb045VGFyZ1ZEVUlDZkdyV0JF?=
 =?utf-8?B?NjBTTElqK0szdUFpbGhXVW1ITGtQUk16cVM2SFRGbVI0RzZmaHVwS290bUgv?=
 =?utf-8?B?aGlxUDN5VWdrWGJQRHJBVjRGNW9JWXlTNlNYNzdqbFFyYW9qd0pvUC9lZWYw?=
 =?utf-8?B?c29iaElmd2Nmakl2MkdVUXdJYktub0lWb3ZuU2FlMUdDKy80enp2OXJUY2FI?=
 =?utf-8?B?Tm80QnZOZ0ZYTm9DclJML0U5d3ZoQUdxcWtQQmhhN3NUVFBpMzUwV0FmNnhB?=
 =?utf-8?B?RWtsYnBhMWpOc0dFLzNKVWxpRy9KazJ1Y0ZsTVNGMEFVZGdWKzZvanlaeHlk?=
 =?utf-8?Q?L1s8iB9eNqNvns3/1NUzwSk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cGPpQtdktZmEWGdJyGwKSC82GZgZ6u43sgsKOpATUGc/+Drxb42vWOjlVMBsbtE1RNOVTgSEE6VQkZ5Vdf3oB/TG8vpRw4l3D+9eeyOK+8cVE8lkbEs8ChwwusJ2D0xCVIwM4VPV+6R4W90uvt+Jh70YlOlGcyK3m/z3bO7lOKjvkcodQhlXfnQZo/Y5LI6IY7YdY13xwenj7C1UMaNh6wOqGmByjDjlrTmA2WkQIe//fsNrJWXvtsMAmr+DsbWsTCFUfjjoYtbvnc9mqSrDkTAOYT6No6Zg5ht2ggrilF6QJvcFlVS8Z5C22eNc39drNT6i0RXUnuN5fKYRyF76/CwxyAv9tBQV+qF3rwtdnF8dhE4GMLnnbdoX+Ncx4wQyRdleO9Dd7pVKz025Anv2D5bA72IV8D4RgP/bQu+8muUw7ODYIavWG5vOhCX0uAjH0VlUOz6UF9KnuD9cFgyRx1mH+bYUZmRJb/IWA8w9BnhjD3q+GYMiiz7js9P3MWenVv10o1dbzTdwKhso2xlFhyxbxed7PvS3Ch9W11BG30g7Re8oiN806suvwfEs6gACzH+cYamEz0VWYfSfKUzfOQI48KgeKihWrffvIuMUNFw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8166c8-9cdc-4078-079a-08dd4d272a60
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 18:41:16.8285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qIpQvHztR3lYNgE9xy0UveOZo1UTMX8EyL//0ujMm7pqHRkkGrVZMYCf2SUiyR+2aGSqVzmXA87HXpEZqIAD9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7425
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_08,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502140128
X-Proofpoint-GUID: yp2wu8J-7dX38qncw2wHsGMHsR47jDEJ
X-Proofpoint-ORIG-GUID: yp2wu8J-7dX38qncw2wHsGMHsR47jDEJ

On 2/14/25 9:39 AM, Indu Bhagat wrote:
> On 2/13/25 11:57 PM, Puranjay Mohan wrote:
>> Indu Bhagat <indu.bhagat@oracle.com> writes:
>>
>>> On 2/12/25 11:25 PM, Song Liu wrote:
>>>> On Wed, Feb 12, 2025 at 6:45 PM Josh Poimboeuf <jpoimboe@kernel.org> 
>>>> wrote:
>>>>>
>>>>> On Wed, Feb 12, 2025 at 06:36:04PM -0800, Song Liu wrote:
>>>>>>>> [   81.261748]  copy_process+0xfdc/0xfd58 
>>>>>>>> [livepatch_special_static]
>>>>>>>
>>>>>>> Does that copy_process+0xfdc/0xfd58 resolve to this line in
>>>>>>> copy_process()?
>>>>>>>
>>>>>>>                           refcount_inc(&current->signal->sigcnt);
>>>>>>>
>>>>>>> Maybe the klp rela reference to 'current' is bogus, or resolving 
>>>>>>> to the
>>>>>>> wrong address somehow?
>>>>>>
>>>>>> It resolves the following line.
>>>>>>
>>>>>> p->signal->tty = tty_kref_get(current->signal->tty);
>>>>>>
>>>>>> I am not quite sure how 'current' should be resolved.
>>>>>
>>>>> Hm, on arm64 it looks like the value of 'current' is stored in the
>>>>> SP_EL0 register.  So I guess that shouldn't need any relocations.
>>>>>
>>>>>> The size of copy_process (0xfd58) is wrong. It is only about
>>>>>> 5.5kB in size. Also, the copy_process function in the .ko file
>>>>>> looks very broken. I will try a few more things.
>>>>
>>>> When I try each step of kpatch-build, the copy_process function
>>>> looks reasonable (according to gdb-disassemble) in fork.o and
>>>> output.o. However, copy_process looks weird in livepatch-special- 
>>>> static.o,
>>>> which is generated by ld:
>>>>
>>>> ld -EL  -maarch64linux -z norelro -z noexecstack
>>>> --no-warn-rwx-segments -T ././kpatch.lds  -r -o
>>>> livepatch-special-static.o ./patch-hook.o ./output.o
>>>>
>>>> I have attached these files to the email. I am not sure whether
>>>> the email server will let them through.
>>>>
>>>> Indu, does this look like an issue with ld?
>>>>
>>>
>>> Sorry for the delay.
>>>
>>> Looks like there has been progress since and issue may be elsewhere, 
>>> but:
>>>
>>> FWIW, I looked at the .sframe and .rela.sframe sections here, the data
>>> does look OK.  I noted that there is no .sframe for copy_process () in
>>> output.o... I will take a look into it.
>>
>> Hi Indu,
>>
>> I saw another issue in my kernel build with sframes enabled (-Wa,-- 
>> gsframe):
>>
>> ld: warning: orphan section `.init.sframe' from `arch/arm64/kernel/pi/ 
>> lib-fdt.pi.o' being placed in section `.init.sframe'
>> [... Many more similar warnings (.init.sframe) ...]
>>
>> So, this orphan sections is generated in the build process.
>>
>> I am using GNU ld version 2.41-50 and gcc (GCC) 11.4.1
>>
>> Is this section needed for sframes to work? or can we discard
> 
> No this should not be discarded.  This looks like a wrongly-named but 
> valid SFrame section.
> 

Not wrongly named. --prefix-alloc-sections=.init is expected to do that 
as .sframe is an allocated section.

> Once correctly named as .sframe, the linker should do the right thing. 
> Let me check whats going on..
> 
>> .init.sframe section with a patch like following to the linker script:
>>
>> -- 8< --
>>
>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/ 
>> vmlinux.lds.h
>> index 6a437bd08..8e704c0a6 100644
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -1044,9 +1044,16 @@ defined(CONFIG_AUTOFDO_CLANG) || 
>> defined(CONFIG_PROPELLER_CLANG)
>>   # define SANITIZER_DISCARDS
>>   #endif
>>
>> +#if defined(CONFIG_SFRAME_UNWIND_TABLE)
>> +#define DISCARD_INIT_SFRAME *(.init.sframe)
>> +#else
>> +#define DISCARD_INIT_SFRAME
>> +#endif
>> +
>>   #define 
>> COMMON_DISCARDS                                                        \
>>          
>> SANITIZER_DISCARDS                                              \
>>          
>> PATCHABLE_DISCARDS                                              \
>> +       DISCARD_INIT_SFRAME                                             \
>>          
>> *(.discard)                                                     \
>>          
>> *(.discard.*)                                                   \
>>          
>> *(.export_symbol)                                               \
>>
>> -- >8 --
>>
>> Thanks,
>> Puranjay
> 


