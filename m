Return-Path: <live-patching+bounces-1199-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 131E4A364D9
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 18:42:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AADB21894B4A
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 17:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA21E245030;
	Fri, 14 Feb 2025 17:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L+4AD0Qb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xQTvhHO4"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8014E269833;
	Fri, 14 Feb 2025 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739554813; cv=fail; b=nyW0kowgW/VLwmoHI2Le5Ut1UMkYMu3/vOGALrS4VpvXgUXa15NhVU64mLoaFHfJFRPBeHO5VACSiq0zGFB1Sdl6MaKBlkzsn6dsgudmDqQDY3kVElcodkpprOzx08SD+3cSbBFKGA7Bi8KDFxsHp/5Vvx1jjk5YFzak54pYTr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739554813; c=relaxed/simple;
	bh=BxeW5H56GLmkUrGovcRzto1fZY7IGHRTTn1y4se+9Zg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kba0XjjlKdd8LPYM/uZXnfroiTVvv8gf2vFdK4C9PrXNNVbDipdPsFZnrJLck1SzFE7NrXZhKJKGcKw+vt2Ud5gEK6xloSmQw/KnGffxaLK3BINdboqRMPp80sn9Ob2M/uTUujuZkMJxW4f3tcf5Eq0suKm6yqPIIsJFBo46DVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L+4AD0Qb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xQTvhHO4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51EGBcn7009995;
	Fri, 14 Feb 2025 17:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=jTdtdZb1B796mMQvU7lDk+kwFBojlE2K7G4nvwQAzHk=; b=
	L+4AD0QbK+yDmt5xyWewH7G2Iz/CQjwEynfJPTtYQxroEvYP3TpqRs7ThslH6CKg
	AEBc0IfjXjOqEclBq9KwskthP5//mIAP04+J+l2WRA+ZkTMPDuIWMW5FsLiZpN7B
	2JfQg35mZhGYLLjOOAq4FGSSfufCdEGFdVR3ouuABQY2h6RVjl6wWrcNDSlhuaCY
	d2gWlCoP9XkoQcu1IjutQIjvfyYcSqi3yooFY556qZ5Wb/QQixhscNKT5SpjXNiq
	DWX0zMoBvmvY+/3MyveGjp9/GOBo9IqHi0upeJhaOYTO998GsoyP0eNrcq3hcsXb
	6qdLGpfZVJ2bafp6Lvvomw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sqcbpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 17:39:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51EHUF6v014067;
	Fri, 14 Feb 2025 17:39:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqdh6df-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 17:39:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3HJooOUjL+wvfGoBqUVOMwC9lI0kTkYFyboB8eEzZA5V/9xnHQyuepGn8U3vRmffdZsZpHRsWGamuxGlHWkT3+UFSZemgA+8y4P/UlKxnfbr56/x4JI+9TsSkP8EkVp3rgeJlq8L5MWPRra0G+uChn+NIaCFXc8JlBt8jftuEKvKFSLMTza2E0Hl8+pEMVvJyNSmbI7+hIFoYZV3XLHBnvqJ5A/XN6om2j+1o5Z4yeUCx74xDf2s/uc5McuPWO3ws5adx2DRcn8rmMKppcDrq7Q4Q0X8ZKM5n941OYLry4X9uBM2CVHrfpvm+FWccCeXXKeewvL8PPHFNRvwP/FfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTdtdZb1B796mMQvU7lDk+kwFBojlE2K7G4nvwQAzHk=;
 b=Mu1laOGAxPyPHxQZJ8klOVYoLMhNMC6DGZxG66tEIqHaOHt4wBNczqYsIj+eNPYvYlr3JC5FVy81/0xbzMSUOLHXuafQK/3TQfpyvyxiKQkANeWhedAGEKaUoxt/1wXDSBkmZiLIaODY+eS6n65sQUesOQnbheX71E/E59tUc3V5cOe8WY9zSp2nSoPRtvvHa69zQR4osWRfdBM9UrtBtwFXF2hWc4DoQ6xU9B3Qpj5VB4SLDyxd6vKRJju6vW4tY0PcCijYdcCkadCFFmj3tIfkugF/BCORMw7UvMbtGXmxT3A2CEJB7TwA1XMhOxm2enxop2zKC+kSK5Jx4CCM0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTdtdZb1B796mMQvU7lDk+kwFBojlE2K7G4nvwQAzHk=;
 b=xQTvhHO4k9EysZLpUlo6izy7ZAbphcUfQOE+WgaU1v0LtDmX2Djnhhgia5s+kIM6J74lbLB2ZYSdzLpxomnl8OmasheEnhomOEGiKUuXaKv57zhunf6Ds4hiPgaE/HL9EeAj3GjAH3P6LIvw4MLm4Q0RldsQlxGP9ZPWTU4SZHI=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by SA2PR10MB4489.namprd10.prod.outlook.com (2603:10b6:806:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Fri, 14 Feb
 2025 17:39:40 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%5]) with mapi id 15.20.8445.015; Fri, 14 Feb 2025
 17:39:39 +0000
Message-ID: <f8d93a1b-3ad0-4e19-846f-c08d9cb19f48@oracle.com>
Date: Fri, 14 Feb 2025 09:39:35 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
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
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <mb61pa5apc610.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0263.namprd03.prod.outlook.com
 (2603:10b6:303:b4::28) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|SA2PR10MB4489:EE_
X-MS-Office365-Filtering-Correlation-Id: e57bc2af-1c41-4a9d-f8ab-08dd4d1e8eb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R25pMXVEN1pYVmFCdGcrc1B5S3E4VlROQUdrdWtwdEZLRHZrMUFTNmpuNHZx?=
 =?utf-8?B?Ykl0QzJGSnhCdWZPakF6VHVUNlZJdGtWaGxkdjlHbnJDbUNlWlBNQWNzSlJo?=
 =?utf-8?B?NFZOaVpJa0pUbDkra3FSdTR1eTB4R1NKMWlDZ2xWb0MxZ3R4TzZwajVjMmZN?=
 =?utf-8?B?SFkvNEl6ZG9zSmdBUlVFK1RUSUdLQ3hJckpjQ3BiREVtbVV3ckU3d3hoNFVy?=
 =?utf-8?B?S0lydWJVd0hETnYvQVE3UVcyUTZoajRicHFNR09CZGtpdHRhQlZkUHZwNnVn?=
 =?utf-8?B?clJHRklucnFyOU9nV3o3VEI2RE5TWEt1REJybm16cE9PWFdNNjdnY3pwdEds?=
 =?utf-8?B?M3FZZ2RicUlKUEU0eHdOeHFwOTFRcXYvVnd6VEtCN2M0T0hOek1xbmd3cVFa?=
 =?utf-8?B?K2t5bFdJNGlzTTNHSmFjbmZXcS9MajRLTWtqVW5mc3VnWkdFNytVc1lKR1h1?=
 =?utf-8?B?Nk1TT3dtNTNWQUNUNmNGOXJkODUxV0NmWjUxN2UyL2grSWR1d2gxdG8xNCtM?=
 =?utf-8?B?VlpFRmVKa0VWeUZqRmtkckdBK3FtWUloQldPOVNuVlVmZVgvQjRoSnBndHRL?=
 =?utf-8?B?V3dLbnoxQms2YzNYekZRbEZ5d2tyN3F4bmcvajhaQjIzSGVoNEJkU1ROTm9C?=
 =?utf-8?B?Ry9XY0VtMkc1Y2tvVjdWQmtuUW53cGJSV2ZZR0R0RC9va0xRalcvams1Tjd5?=
 =?utf-8?B?Ynk5QU5ZNDVHMWJFd1JBajRFTFIrd09EcmZZVCs0UHZlOElBQmwveG40QU9Z?=
 =?utf-8?B?MzkyYlZhRjc3ZS92aXlocUliaHlPR0llTUxYK1YrVWMzY3BnYzVCb2lWTEVB?=
 =?utf-8?B?SHc4MnlZaUhyQW1yWExOL0dzQThJM1pGZ1NDSnJEOWRweVU2VkJjdzhNdkxs?=
 =?utf-8?B?YU9mbXBNempaMDJNVHF5MVkzOENRTU1ZWXI5U0xaMldaREc1aFk5OEtBd1ls?=
 =?utf-8?B?cHc4WHQ4NldWNHNBQTVkOG9WaU55WVJ2RVlHM0Z5bHpVWkpvb3dCM3ppeTVt?=
 =?utf-8?B?aS8zV2R4QWtvVnRVTEJ1RG05OWsyNDFzcWRLV2NHV1dKbXhUNmhuSlBOd3Qy?=
 =?utf-8?B?eGV1RlR3MWF5VFJjOTgrMTN4N3laWTRoMU42VUQ0QWRWOWUxc242U3ZmU3pR?=
 =?utf-8?B?VUMxRjFiWHQ5dzV5TjRhNUoxck8yVFFFbTdDdmZrSFJPeXdUR0dHZmtUbGRv?=
 =?utf-8?B?VUI4d1FYemV6b2huNDZNUUxWOVVSeVE5a3dRZVNVczEvZzg4Z0lVdXNtbm5P?=
 =?utf-8?B?Q0tlSG43cUhEVyswTTFNQU5JWWNJQjBqTy9SWDhXTVo1NzBWVU81YXQzTG5R?=
 =?utf-8?B?OEYyY2JyN0hkMDU0dXp6WFA5QytkQTRZcDFPV2hpMmRjUDlUYUNsM2JXNjU5?=
 =?utf-8?B?K0tEakVNM3M3d0RSS0hPaUROUk5yV0dteUx2OXVFdCtwb3lJOGhtT1Y1Mkd3?=
 =?utf-8?B?enJrZ0pPalZjZ29nOXYzeVltcWRUVCswbGdUSXJlM2R3c0tyWmNUZ3REckNW?=
 =?utf-8?B?eVV4TmhHRzBKY1pMaFV4RHR4ZkxmUldaTG0yQ3VORDVZUU01OEpqQlk4K0Uv?=
 =?utf-8?B?cUFUMTREdWJwODBUQkY2Qk16MFc4dVg2eHpUY0FwaUFGREw2OVFaRTc0NnFE?=
 =?utf-8?B?Y2s4cnZTZFFscjZXdzc1Z00rRUd5T3pnd1cvSU1tT1BKK2VHTW00bit3Q3VG?=
 =?utf-8?B?ZW00YjJmUnJOYksxNThHbTFIVXU0NFQydHB6cjVFcUl2a1lMWGxKMWJnYk1H?=
 =?utf-8?B?NjA3SkNYazVsQkhaeFhFOC9mUWQ3Sm9leTZ5UEdlTTJuS0lMeFNkdmowWHYr?=
 =?utf-8?B?cld0Y1V2L2gva3RQdzhUeDdrV2d3NFJPOTAvdjYzUnBndmJPN1U0N0EwOGJB?=
 =?utf-8?Q?xzhMxu8un/Z6X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blRnTDRNVHJaVTg0cTlYdjVZeW5BY3p5VFQ0am82c1hTU1d5dHJWUkJhd0Fr?=
 =?utf-8?B?VU5RNzdCalpqVVk5R3JRQjlJWlU4SlpDVUV2QTJLam1xUXNvTFlkcHUvbWFD?=
 =?utf-8?B?SnluaC9XbnQ1TnZ5QlMrUVBnQ1BnUWFnU3R5TEdTS1ZqdzhyTHhCMDQ5YWNu?=
 =?utf-8?B?K1dxb3hsa05sTXdkem1kOHRZcDhjWlJlVVpxcVNNblMwOTQrZFpmbldFRUll?=
 =?utf-8?B?RWR0TDlNRlhjT2h3N0NSSHkzYmdvMTM2WGwvNWgzM0dKbS9Vd0lScTBoeXZ0?=
 =?utf-8?B?cURwSE1UM3pOZzZsMVpnUFVzazR0Qkg0bjdXUmp4V0l5RDJZcnpsRTAyZFJh?=
 =?utf-8?B?WmFXTG9MSWxPOEZDSUo4MHl1V1E0NnRPbVJKN2ZTZjNCN3pQdldaWWVCK0c5?=
 =?utf-8?B?Vjh0Zzk0YXFnUjdKMVdXTUFWMExuL3ZPN0x4N2RvdEhxTlRqRFZ4b1hhRW14?=
 =?utf-8?B?c0VqTkpjNzB1eXNORGx6UHJaWXkzaUQ3dXNRY3M2eElIMitkVFZPTVh5ZkVT?=
 =?utf-8?B?QzdXS3drNDYrR2ZoSEpSV3l3N0EwVkRlTkZtVGl6QXdLdHhlRkVGNk16R0xm?=
 =?utf-8?B?RVJ2TzVrbm1MeGI2YWJVd0RtNnUxNi9uUEFiMW9sYXB2OHVzZ1hCcDR5bGtI?=
 =?utf-8?B?ZDlUcFg5Njl4SjJPRG5oZzcrZlRMaHRBN1JSWVZXTjdFaENSUThRckJkRkkr?=
 =?utf-8?B?dkl5VHZaNi93MkNvb1Z5OTJtdUZZSjJIR2FBdkptcEtrK3psVDU3RXV3cHNs?=
 =?utf-8?B?WU1OQUlvQW5uUjFPVTZoeGE3SE1lWVBRVzJOQUduZ3ZkOTlIb0szSDNYemRy?=
 =?utf-8?B?OVVkZlltTUhjd2JRSUhXcGZTS2M0Q21uR1JQdy9aOUQwcWtoNEFHTlY0SkVr?=
 =?utf-8?B?UnZWRE5ldmp1VGsvSGZseGxHZUJDZUE5cFh5cEF1RWJFV1pJSWRFYWF3R1Zy?=
 =?utf-8?B?cGRodlpmWE1ocFFrNjBaYnlmQVhxZXE0bFdoV1FpYXlRTFRnaE13UGIydzQ1?=
 =?utf-8?B?WmJpUENKL1RkSmJGd3lpb0daenkrdGNZMGVlaUhORTRueVd5QlpDYWdPUm5I?=
 =?utf-8?B?N01FeDhyOUVoTmlqZ3l0TFE4azBTSUVrQVVvdGd3Y2ZDWmRIdU9wRXp2dHls?=
 =?utf-8?B?ODYzS2wzVHJuUFcxak5sbUJvK1BEaUZXN2dCWWQ2WDVieE5pL0VyZHJOVWpN?=
 =?utf-8?B?enN6OUREbjd6VU41SjVwR2F5V0pDNGNLMFZSMTVCd1FLSVgwVjgzRDMvcExt?=
 =?utf-8?B?ME9NWEplalZ5aG1xQVFSTHU2UytBcWVpZStzV2hNcHhvN1JyRTZHOGwvck9u?=
 =?utf-8?B?UzV5SGxobXN1M3F0S3JCUkVWeXdiZmovZnY5cU1VaEcrMys1N2UvdjAvbUtF?=
 =?utf-8?B?VnNOSkZ1b3hlbFFJZXVtUXdFMHYzallwSExTeUhCbnJWczRqRXpocFpCMGRC?=
 =?utf-8?B?cWxsek56Q0Q1cFpmMG9LYTh0TGJVb2VyUytKNkFWdGhVSzQxNkYrLytrK1NR?=
 =?utf-8?B?cmVnRXFzNEFZemdmNVVESHRsZG1Gb2FETFFMOS9IYkVaSGpqaFhKTE5YR0xq?=
 =?utf-8?B?cUEyaGFmZi9obFlVd01OY1lOZGlqa2o0ZzNvcEdUUXZnU2VBcmpyeWJQd3ZF?=
 =?utf-8?B?RlBGZ3JzWnV2YlY5Q0ZVbHZqTEdFYVJYKzlKOEo1RE5RWUpYTmFhVSszOXlD?=
 =?utf-8?B?aXN2Nzk1YVpiM3hFR2M4N0g4L2d1RDdqd0EyTmFnRkNBL3RGUzRrTndzMkND?=
 =?utf-8?B?dFQzQ0VCSE5XbVVmRVlJM1pNMDFEaDlrUlBuRFF0TGdDSW4vVWEvNUkybndS?=
 =?utf-8?B?VnpqaU1zNWdDbmp0MkpZeGpWVVo4bGlCRHZRcUcxL1M3RzNKTWg1dFAyWTdC?=
 =?utf-8?B?NGVhQ1RHVE5ZTlRKUTVHTFFqTVlSWjhoZ1RpYmtuMXpqYnBNdnJRUlVDZTJJ?=
 =?utf-8?B?a3ZtdTVsQTVKQlNndkJJdjNSbnFqZmp0TlU3ZG80OUlZQUZwRkVFQlBkM2Yw?=
 =?utf-8?B?TzljK2UxOXJpOUVZT1Q2czlUZlByRHhJQ0NkVW5VcmVDN0VjUWlrWmVXVmg3?=
 =?utf-8?B?V0NhVS94eVdkUzNvdHlqWGhjbDhIeUZUT1ZyUlYxVTVOejJKQmM4eVhmc2ZC?=
 =?utf-8?B?Tng4Qnh5WTZSTVhCSlBXdzZMdkhXZWFwNnc3TzJxdkVFL3dHVWRxSjRIelZ1?=
 =?utf-8?Q?Ffru+RFIc/E6yQ+V3/LY1oI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FHOUxo6a2ZrtQympNoDjgs4RptHwjP/F104mr3yWLjK1Sq9wfnQ1pnqy3juQcQiAkFRKn4DkGV6Ezx1RiCYGEZp/jMQ8oYFiqt1D7dVgaqf7TUuv3zV7CnKtWSS/xS0LbqQ9RsV61VwRlW2ZapLYJTvz/sTc4MuMx9PqehWMkP8RC8zTTqdsPa/MmqumrH1OKn969d1ArpMhVVlTMMA47KED6EBfXPE/4RsZ9+3ENP3dViDi2Jtz5mjvzOEvMaNFkbXwRnXZ/Bst1Rm+vmTymFlACscCA2FP+5lkVq6CsWlPz7P21d21/DWkhGx0NtlfXuUhXZ9gQBXWQmaaKqj5Hjfu2iOJsPJWiul2URQ+5FrG5H2oQNHBsM5tT0Gdd4PQvm5aH3TwBax5l7zj9vtmb5hLKz6qFjGCljAcDUJjhi5sjs93Czuc3wp2dHDpII7N8RXSsYNpkycgX3Wd5Q6KXFq+DjXm5/HGFGDlLcBc8ekxT4Oye43P9qx26Yn1kf64+rjb4ZaDtYD+9DDJzLC5s9lJSGs5ZxigkwE/VmkNeM4RZK0UuM3BkodLbyLD+k4HNpD5qUS+EyBZqdQppWyaEJeBMrB9zYKcXOmGxbI0/D8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e57bc2af-1c41-4a9d-f8ab-08dd4d1e8eb0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:39:39.7075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YiY0An8iuZr3n2rX8vNMbD62M84oJJKIPtpJVmoQrOE1EIHhbFKycBoTbbbKJ5vC3BRDHbHg6HlghCMOK4x0Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_07,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502140122
X-Proofpoint-ORIG-GUID: HVSuSmlpPuV94S6P5_gLZhATSnU2utmz
X-Proofpoint-GUID: HVSuSmlpPuV94S6P5_gLZhATSnU2utmz

On 2/13/25 11:57 PM, Puranjay Mohan wrote:
> Indu Bhagat <indu.bhagat@oracle.com> writes:
> 
>> On 2/12/25 11:25 PM, Song Liu wrote:
>>> On Wed, Feb 12, 2025 at 6:45 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>>>>
>>>> On Wed, Feb 12, 2025 at 06:36:04PM -0800, Song Liu wrote:
>>>>>>> [   81.261748]  copy_process+0xfdc/0xfd58 [livepatch_special_static]
>>>>>>
>>>>>> Does that copy_process+0xfdc/0xfd58 resolve to this line in
>>>>>> copy_process()?
>>>>>>
>>>>>>                           refcount_inc(&current->signal->sigcnt);
>>>>>>
>>>>>> Maybe the klp rela reference to 'current' is bogus, or resolving to the
>>>>>> wrong address somehow?
>>>>>
>>>>> It resolves the following line.
>>>>>
>>>>> p->signal->tty = tty_kref_get(current->signal->tty);
>>>>>
>>>>> I am not quite sure how 'current' should be resolved.
>>>>
>>>> Hm, on arm64 it looks like the value of 'current' is stored in the
>>>> SP_EL0 register.  So I guess that shouldn't need any relocations.
>>>>
>>>>> The size of copy_process (0xfd58) is wrong. It is only about
>>>>> 5.5kB in size. Also, the copy_process function in the .ko file
>>>>> looks very broken. I will try a few more things.
>>>
>>> When I try each step of kpatch-build, the copy_process function
>>> looks reasonable (according to gdb-disassemble) in fork.o and
>>> output.o. However, copy_process looks weird in livepatch-special-static.o,
>>> which is generated by ld:
>>>
>>> ld -EL  -maarch64linux -z norelro -z noexecstack
>>> --no-warn-rwx-segments -T ././kpatch.lds  -r -o
>>> livepatch-special-static.o ./patch-hook.o ./output.o
>>>
>>> I have attached these files to the email. I am not sure whether
>>> the email server will let them through.
>>>
>>> Indu, does this look like an issue with ld?
>>>
>>
>> Sorry for the delay.
>>
>> Looks like there has been progress since and issue may be elsewhere, but:
>>
>> FWIW, I looked at the .sframe and .rela.sframe sections here, the data
>> does look OK.  I noted that there is no .sframe for copy_process () in
>> output.o... I will take a look into it.
> 
> Hi Indu,
> 
> I saw another issue in my kernel build with sframes enabled (-Wa,--gsframe):
> 
> ld: warning: orphan section `.init.sframe' from `arch/arm64/kernel/pi/lib-fdt.pi.o' being placed in section `.init.sframe'
> [... Many more similar warnings (.init.sframe) ...]
> 
> So, this orphan sections is generated in the build process.
> 
> I am using GNU ld version 2.41-50 and gcc (GCC) 11.4.1
> 
> Is this section needed for sframes to work? or can we discard

No this should not be discarded.  This looks like a wrongly-named but 
valid SFrame section.

Once correctly named as .sframe, the linker should do the right thing. 
Let me check whats going on..

> .init.sframe section with a patch like following to the linker script:
> 
> -- 8< --
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 6a437bd08..8e704c0a6 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -1044,9 +1044,16 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>   # define SANITIZER_DISCARDS
>   #endif
> 
> +#if defined(CONFIG_SFRAME_UNWIND_TABLE)
> +#define DISCARD_INIT_SFRAME *(.init.sframe)
> +#else
> +#define DISCARD_INIT_SFRAME
> +#endif
> +
>   #define COMMON_DISCARDS                                                        \
>          SANITIZER_DISCARDS                                              \
>          PATCHABLE_DISCARDS                                              \
> +       DISCARD_INIT_SFRAME                                             \
>          *(.discard)                                                     \
>          *(.discard.*)                                                   \
>          *(.export_symbol)                                               \
> 
> -- >8 --
> 
> Thanks,
> Puranjay


