Return-Path: <live-patching+bounces-1112-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B922A28026
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 01:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09E993A535E
	for <lists+live-patching@lfdr.de>; Wed,  5 Feb 2025 00:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73C5D1FE44A;
	Wed,  5 Feb 2025 00:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WzbCP0QO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FDUrYjcK"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637A81FDE38;
	Wed,  5 Feb 2025 00:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738714979; cv=fail; b=eLrXIMUGINyEplk2FYUzBrvR8zXGpSSiYXk2FigkuDxM3HNf0MpLg0ItAKafWWJBQ6If5RkQvODGoSy6Hj5ZQnvotAkPZJwbjtZLg8sgh8U8CISxVauMA+JAIW0zXnroav6R+gUkJsXscWbfoxScmQL2DMe5thWUjwJVBW3C9DE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738714979; c=relaxed/simple;
	bh=xFE6pLrwVWOAyVdjpDeOeoXubv7H29LB4Vc/RGWetLU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EEmU7VtsUBsYB03Khv6LUHuiKozsN2auaLUX84cGwXAgNEuJvmbKRRe6rXux9xkwh4YPEDLmCMl+5LtY0PAELE9i2zdHo7MhOja8f4jVFmN9tWFEDaNlv3FzCIGOqQcvKErsDo1z4nqOwCK/ce4WePSTJ5/i6j3xfjcPUZ/ukpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WzbCP0QO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FDUrYjcK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBr2g003394;
	Wed, 5 Feb 2025 00:22:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=4FN+qRgY0n6uXppwZ7MN3VwyT+z7PW1HF0jP2pMgmn0=; b=
	WzbCP0QOxIvJz5r24N8eZl1HBeCUwt7lJOf2hTMGNFdB8sWVO01ZpSMHOf6oGy+X
	ETa5M4vb6eu4FzX2vQWjmiVF9vF8rK/0mMipYT52LCdNPtZyokFgRxB54+DWy3j0
	oWMUAoa4vucYvhW5hSNWIgke+uOfHgB4TUHuUOjjlsqe8LXprhMH7B9XdXiuU6EP
	USEf07agL72GbZzLi/vsf3Cqq5LD0XJuB9QiLvEh79swWFN9U6Y+lX+xdrBNqVNF
	muVPsDQ5gbucoih1E3eHQL/NGNUJUwXqpX9yb7MwN3mGzIVzaprhz44/OGMkK6xT
	C3AkXR3iL3tZEdnRGQHSlw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kku4s8em-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 00:22:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 514Nm4JQ039045;
	Wed, 5 Feb 2025 00:22:35 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e8e87j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 00:22:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j5jO92N4PSjJF0p8YcJt2wyo9HRwhl/3qNJ47GWvf6/qbhWerBrY0g+x+/sp5chQijEabNU4ziT6MSTcY2qEQ4RssoNUObsB/yK+V3N0QmH6N+MjOM+3FCxj8sjCwfHb71ClgJ995tU6qLdkG7nvDxn4Sw+NrV/siKR+8F1h0OFfV6jT/axSzj0NAGAQtZXU2/nJ4s60ori7doOlI041zHMFtjIc6Idvi7Jrkg0BsaaEJAKRPZyX+S5uPKfD3M8vMp5k9vmUnULCti+ZsrJoBLSX5Ukixs2O9HxTCaNisPoRX9HxDzWwEUzE2TNwelYIG3kj6GtVzEX7SrEOQT12FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FN+qRgY0n6uXppwZ7MN3VwyT+z7PW1HF0jP2pMgmn0=;
 b=p0y73z+e2k0GrjP4Vc14BbDBjfzocodGLknnzNxS6F+XZZ0TNfrWUAO/Wq7AeGtU7pqJMCzCVE0hvCfjfy9+sDKFm6bq8Uned9XrIGUqlUhYYjCrd77wq1IS5cLOFBDT6uxiWR/d6agj8uZ24QoHnXHFU7QRBjOynxcUa9iM85iQpr3tuqxyOaWlDDuFM4mrEBfhmFCq73IRN1cfV6L6lrnvh3UrF4cW2zTdh+FkiP/PRr4rec7tjF3yXneIUVlUvR7to83xUCRoGf+RVVCN5rNn6+a609kB+OmQvhUtPrI4g8GHp5AKwUGiRkAIuK0jbofSBe1hyczGQ22xmBYpRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FN+qRgY0n6uXppwZ7MN3VwyT+z7PW1HF0jP2pMgmn0=;
 b=FDUrYjcK1gj+EWyZBOtXYAa6dZSWDThzi4YTq4VQ0h8kuGJQQybSaPlOGDgaatuFcyI8fTM5OvUEfWRIb0dj1cBEPsAjbeMDneZX37NChJGhbvuhI6neEQROlG7t8FIuW7IfXG/bkS0vgd0g0k9JmrVKWHVN5b7PT7dD61l2PXY=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by BN0PR10MB4838.namprd10.prod.outlook.com (2603:10b6:408:127::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.26; Wed, 5 Feb
 2025 00:22:33 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%4]) with mapi id 15.20.8422.010; Wed, 5 Feb 2025
 00:22:32 +0000
Message-ID: <303e0c91-2351-4ccd-8948-b400ac5d2b7f@oracle.com>
Date: Tue, 4 Feb 2025 16:22:27 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] unwind: build kernel with sframe info
To: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
        Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
        linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, joe.lawrence@redhat.com,
        linux-arm-kernel@lists.infradead.org
References: <20250127213310.2496133-1-wnliu@google.com>
 <20250127213310.2496133-2-wnliu@google.com>
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <20250127213310.2496133-2-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:303:b9::7) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|BN0PR10MB4838:EE_
X-MS-Office365-Filtering-Correlation-Id: 75e9d1e6-64a4-4c94-c64f-08dd457b2ee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFhwV0t1ZDI3RVlaMzE5U1hNVmxlVk4yNkZ0c2dFUC9PQmFMV3BsU0ZDeDZS?=
 =?utf-8?B?Tm1UM3RSdnI0ZEVsTGM3ZndYSVlOemIxRkFDYnM5UzVQZFJGYy81dmxyS0tJ?=
 =?utf-8?B?aUdZMGpBRDNZTmhqNGc0TFNNbEJ4OEVPSjUrSFQzNUlYMmN2ZnpVeWVpUWta?=
 =?utf-8?B?QjRuRVVNN0JHa0x1MzdTTXV5MHVrdjNwZkc5OExpaktDTlZUeUdOZWxOSlEw?=
 =?utf-8?B?cHIzcHQ1cDZNbTRmbDAzVGM4UkhQUmtkNFV3a1g0M3NiS3FhL3RVTXA4aGND?=
 =?utf-8?B?c1UzNnFUdmo4dExBTHJNb1Z2ZjZNR3krS0RSNk9jVGxHdWIrSlBuaVhzd2sw?=
 =?utf-8?B?TzZsT1o1d0JLN2U0L05SSHZEZFVJNWo2WHlwelQyRzdGWTBrRWd0R242N3pw?=
 =?utf-8?B?dFBxaTFibkdQNzlJV3pCRklnSFhZRXJIYnlRZXM2b1BMNG9uRzY3VXJDZ2R1?=
 =?utf-8?B?bDBKNUJ4UlkvenJzc2tZZG9kUk16NWFleTUxS1VKSnF2UGFMeEFScS9DYktV?=
 =?utf-8?B?M0VjMFA1emNZLzc5a2ZFSE0rMkIwZmVieGpZVkswMGdZMXBVaXpqcksrMHNm?=
 =?utf-8?B?USs1ZEEwWG9ULytTSXNydEx5dnpSSzdYMjM5N3VXek9aSEFaOFBqcGx0V3hZ?=
 =?utf-8?B?d1U4emVDYVYvd1BwUko2cjdabUdOWnNXN3lUemxKbjVVbXF4UWxRY01UYytH?=
 =?utf-8?B?UzB1aUFZRXJ6NUcySW1jcHQ2T0EyVytJbXdJRUtOSXJwMkNYYXFOQmZDTFRC?=
 =?utf-8?B?ZG9NcWxwQUlEclZpaWdmRGIyelU4Uy9raFZzYmFqWjlXMjNlcUx6UjBTWWpN?=
 =?utf-8?B?aEQ2cHRZLzBsbzViUDE5TzJqa2d4MlNQQmhlU01Cb0N0UHVtVlFUeVdQWHc1?=
 =?utf-8?B?eHFWY1pTSGtMOVp0U3hDWVhwSkNZRzF1bnoxQnBlS0g1d2JoZkNhSE9ZS1k0?=
 =?utf-8?B?RUxFVTRiQnZvelFoK3FwSnRJTUs4UGNoT0ZTVHFBZk5BMFdML1o3aDMwK245?=
 =?utf-8?B?SmJUZzUvRTYyZlNKL1ltVXU0R2tuNWhmYmZhRUxyMXFkNm5Hd3lxSjFUR3JQ?=
 =?utf-8?B?RWtRUWdCNnRpaHBnUllQbGU3Ri90dkwvZlcxTzljSlIrdDR0cFZPV0JNK3hC?=
 =?utf-8?B?TndEZVM2YlllUGxORUVjTVJrY25GZmZWU2JicGlrYzJzYzhFdk5BOEI5NGs4?=
 =?utf-8?B?RlRneXhFWE1ic2JDcHc0OUpCWDJQak82c090UHZlUmliV0RSV0o5S2w2dVNC?=
 =?utf-8?B?RFFobFBXTVdjZ1BIQlJuTXJ6ekM1OUtwZG9uQk4zZG9WWXllNEdPTDRCTHJQ?=
 =?utf-8?B?YkNWTlo2cTAxd2NUTVlUYVZ1czRDdnhPd01zbWtpWVlGcFhoQ0ZUWTEzQ3N4?=
 =?utf-8?B?NnlYZW02TGEyN2dsMzJWbHpvdzdVclFjOXNoQ2NpakxEbVBqS0pTYTdWOHRM?=
 =?utf-8?B?ZVMxVjZpMU5QQVlwZDRLaytOWHR2cHhuR2oyenF0L25ob2hzMk1uWTQyWkZq?=
 =?utf-8?B?WlJ3NG16SXZ4V3J5QjBwV29MRmxONCtCRytLME52Z0s2dDlSRWljQ1UrbjNa?=
 =?utf-8?B?dTdzRFJ3dXBmUjJWTmZvVlI3WWhFbkp3MHJST1VQZHZpMC9CYVFuNHY1clhJ?=
 =?utf-8?B?amp2SStvVXFCZ29KdnI2WXZsMTJaVHFveldCbFJvZWdJY0NnT1B1eUxvTnpq?=
 =?utf-8?B?UHlCcG4yWXg5c2IxdGtEMEpmSElJYzBDay9QSE5RQURUSnhablBVWGQxN1Ja?=
 =?utf-8?B?d0NsSURSY1kvTmd1Z3BxR2VZUmpYRnVLcXE2MmNaRUF4dmxTRUY1Mll4RWt6?=
 =?utf-8?B?N0V4T2Rud2xtVTZoNTA1eVNPVFVrTVJ6SDdHditqelZMQ1BYaThGd0NCVG9p?=
 =?utf-8?Q?jkejAFlTwK2AA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1JScU5zY2U1TFJJclJESkZ4SERsM3JLZ0dPaS9IWFVOdWdnczJKQnFvYmNl?=
 =?utf-8?B?R3pOMC82bHVUSnh1bC9wWTdTQXBJQmdpcDU5bnMvd1EzVHlMTnlXbm5yNWpm?=
 =?utf-8?B?VEVvZTFNV3FMZ3FPWUJSdkhTeFJrRFRWelhRdXhDSEtwMnVUbFFmcDZ1S1Z5?=
 =?utf-8?B?b3J0Q05rSVRRZktGRmo2TEdaMk40Tnd4a3Z5SlJWT3I4TFYxZ0owalptSDJW?=
 =?utf-8?B?RitUZG1SRXJTR1NTWURNZ3paenROdVRCbSs1T1FuTElhOXlZR2w1ZWsrWm5Y?=
 =?utf-8?B?MlNPT1BZc3UwWHV1Uk80R0J0RGZVNDVMaCszaTR1cHhKYnJtdlB1QmpvbWhM?=
 =?utf-8?B?ejQyaXZBNFV6OEY3RUlaQ0pkOXUyWXJoUDYreWYybk1zYm9scTlCSmgzVTdq?=
 =?utf-8?B?TWZ5MFZaMTJ3RnFoTnc0MGJ4dkxrQ3d3SURyMVlkaDdpazFPUkRick0yampV?=
 =?utf-8?B?U1g4bCthWExEN3JTTnpDd1JCc2hpMGdRcWhVaTZNS0VEdnhVRXNIaGlLQVpY?=
 =?utf-8?B?UU56SXdxbkNGL09MQXRSdnJYVGpZaFJnTWZqNXNZNGwxNmFzZVBqYkFGcnN6?=
 =?utf-8?B?YkhKUHFGcUMrMUs3aWFvMDRiYTNFLzIydnVmakh0b01VWXA5UldneEYvNDZy?=
 =?utf-8?B?YnM0UmVhWHd1cEg0QVFPY20zb2xnbUlieUk5QTJzS0ZCajlTQm45WExHcDVx?=
 =?utf-8?B?MnRoN1R3SzEyUm1HOGNLUkd2VFRrTnM2aDVobWx2STFpd1ZVbjRuL1YwMFpo?=
 =?utf-8?B?a3BMblRBMitLaXBRTSt1bVNtWE82US83aVpuY29yT2NVcGJnSmRTcDdQQTdp?=
 =?utf-8?B?LzliM2pGMkZTVHdITGJYMWp6YVIwU2UrWEFmMlBFbEt1ZitZS1E4MTNTVktv?=
 =?utf-8?B?SFdqQ2FSd2JHNlk0TmxMSEtTWUhZb1I0T2F6RStxNmhQQ0xYSFA0L053VmJp?=
 =?utf-8?B?TEFScHJlUGVvdWlVWkRJOWpsamJlK3R1M2xTakJCdjdXbmFVc05SdkI3YXRp?=
 =?utf-8?B?dXVMSzVveGc4R0dPeTE3NldBNnlxODAzL3hiVHRRTi9SOW1rVVNlN1RwUXhu?=
 =?utf-8?B?REdmNHRNNWQyVGEwc2FJRnZKbytHNzFrU2F6R2xUUVo1WlQ1TGtLL2VlTGlk?=
 =?utf-8?B?cGZjOTJWSjEwejZBZ3ZNeERzNDRuMGY3VjZTSE45UHZ5eXR2RDhFM21lV3Y5?=
 =?utf-8?B?d1lEU29CbWFNNEhlQm56NStzMEpkUmlCb241Mmh5RFdBVlVMektPVzl2K1RO?=
 =?utf-8?B?eVpnZlpxQkZkSWJKK1FEL1dsVU1zU3BVR3RjRjhQSHh4bWJmRk15N2Q5T0RK?=
 =?utf-8?B?c2s4Q2V3eUJuUVBjam8zb29NeW5ZTjhiWno5QjZDaEdPeUZVMHNRMnBmVnl5?=
 =?utf-8?B?Rmw2OW9wWjg3U09xalpTLzBMRVdYNmlyYmZRZ0Q1Tml6dmxzSEppUU9TQXIy?=
 =?utf-8?B?dTR1UVRNc0t0NGtaWktobDU3NUJ0UFJMZ0EyQUZFNjFUbTJpTXpBYVgzaW02?=
 =?utf-8?B?ZjBDcjBGRncvY1ZnTTl6WDFzdXRyNlNNMm0zaHpSRi94Q1BSSWxlZERjMDVp?=
 =?utf-8?B?MTNuSldLMWhmbU1FNDFSeTV6Y2tVTDg5WHV6Uklvcm5hYXNjVzlaYjllSFls?=
 =?utf-8?B?TUpLSVFPVENNK3BNQ0dRZm9RUDRKdENWRTNweUYvZnhiQThuNGhRQTlHbTEy?=
 =?utf-8?B?SGdPM05kLzRFSFBSWGkxYllxbGNqL0xiSmVxRy9sM0ZjNzNNalFYYXB4QU1s?=
 =?utf-8?B?Y2FWalVESkE3dmR3N2xDN0hYMEl6ZUQ1VytPclZXZktCMVNPOFZYN2s4RG94?=
 =?utf-8?B?RE5tNytYblhPQlVEbUtXeVlVc3ZYT0JjVWUrZzJXbGVleTd3MTI4WU1tdW04?=
 =?utf-8?B?NzkvdnluQXR1Rnd1WHdEeHgzRmR2TjNDZm9yVXlnT1RUbERrYjVwOG9RNzEr?=
 =?utf-8?B?eW54alJqcE1KQXpxdXRYWGFrZ2FiTlZPTStHdkk4VFNkOE5oM0l2MnJwK2Jh?=
 =?utf-8?B?Vk83b1ZWN3ZIUzdEOExRVVRoNHpaenJGaE9PdUh4alhXQU4zZGV4ZExCb2R2?=
 =?utf-8?B?RFhwRkdiRUZNT1BxYVdLMnBBNWs2d2VwaWtkTGxnU2FVZm1SYiszdG1mRlNy?=
 =?utf-8?B?b29mZ0I3WU96bEJjTUZ3b0hlRGt0blZybWtVaHBqUkdvRGU1c2NmRHg5NzFK?=
 =?utf-8?Q?xNrO9xUj0N4VYjDwV0CkA4o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ImNtNp6q5ixJ+BIjFuzNZl77Eew14u6+iOgxSfr/peZk2Kar78RQ8DUM0RiQFns+vAmNvrmR2DsGcQOxpQq9xF7CXiVWBPlMkhgdYgVTU+B7q5qm2xrCEnC05FGjPH13GXI5t6y9G+HwSA9W1SMb0Quznnkdugcqugya2YGvppOc5YvpTuTpvqXMW2dFMTqfucJh5eb+V9VpvSwLTPp2WnTuBVYh53TtwK5MXhuiWxy4w8obPpF216k3mO7hysQkthh+g5hDXv2x/HTWixa4Y67Gmqn8TEFAgWz/5G7ODlyjBYpXmW0HOQ7c52Y6YWNI8+OVNlSrU2QGoOIEyrsexwxv+W+d/MjoyZ3qQFxqs8hBGDKzdA44P9urkXL+vx9IWbPGnDhvISpiHy3n2VrLjcOHGRgqqhIonjZRvpLWPa84AG8vPV6ufdtu6bVEwphGyZLTA0DXkkmwHepHBEy6mt+W2PyGkTJ7sBkCXgs7f8Tak5fUJaL5GQ8bjc73rqL5SkrLNhIKRMJl3ET3BcMI7zrIMA+d4Hti+dNkqvPnwpxq3ARxssV0JkVs6ENkzOnig9LIX8xB0xfaSFWZ78UpV+Paz5PqJcC9wl+/lFtqSic=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e9d1e6-64a4-4c94-c64f-08dd457b2ee5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 00:22:32.8714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMN0UxjIqfZEjl+A7IQ0i/pLSbevq9Hl82uDVAGZ++Bh0NYsy1WDdyGvOQyPYwDf+URvO6Wh6/Pr/qf5ZeXnDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4838
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_10,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=903
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502050000
X-Proofpoint-GUID: BuT0aPXo1O-Ur8Ekh77TGDEqpOwz1GWY
X-Proofpoint-ORIG-GUID: BuT0aPXo1O-Ur8Ekh77TGDEqpOwz1GWY

On 1/27/25 1:33 PM, Weinan Liu wrote:
> Use the -Wa,--gsframe flags to build the code, so GAS will generate
> a new .sframe section for the stack trace information.
> Currently, the sframe format only supports arm64 and x86_64
> architectures. Add this configuration on arm64 to enable sframe
> unwinder in the future.
> 
> Signed-off-by: Weinan Liu <wnliu@google.com>
> ---
>   Makefile                          |  6 ++++++
>   arch/Kconfig                      |  8 ++++++++
>   arch/arm64/Kconfig.debug          | 10 ++++++++++
>   include/asm-generic/vmlinux.lds.h | 12 ++++++++++++
>   4 files changed, 36 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index b9464c88ac72..35200c39b98d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1064,6 +1064,12 @@ ifdef CONFIG_CC_IS_GCC
>   KBUILD_CFLAGS   += -fconserve-stack
>   endif
>   
> +# build with sframe table
> +ifdef CONFIG_SFRAME_UNWIND_TABLE
> +KBUILD_CFLAGS	+= -Wa,--gsframe
> +KBUILD_AFLAGS	+= -Wa,--gsframe
> +endif
> +
>   # change __FILE__ to the relative path to the source directory
>   ifdef building_out_of_srctree
>   KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srcroot)/=)
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 6682b2a53e34..ae70f7dbe326 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -1736,4 +1736,12 @@ config ARCH_WANTS_PRE_LINK_VMLINUX
>   	  An architecture can select this if it provides arch/<arch>/tools/Makefile
>   	  with .arch.vmlinux.o target to be linked into vmlinux.
>   
> +config AS_HAS_SFRAME_SUPPORT
> +	# Detect availability of the AS option -Wa,--gsframe for generating
> +	# sframe unwind table.
> +	def_bool $(cc-option,-Wa$(comma)--gsframe)
> +

Since the version of an admissible SFrame section needs to be atleast 
SFRAME_VERSION_2, it will make sense to include SFrame version check 
when detecting compatible toolchain.

> +config SFRAME_UNWIND_TABLE
> +	bool
> +
>   endmenu
> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index 265c4461031f..ed619fcb18b3 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -20,4 +20,14 @@ config ARM64_RELOC_TEST
>   	depends on m
>   	tristate "Relocation testing module"
>   
> +config SFRAME_UNWINDER
> +	bool "Sframe unwinder"
> +	depends on AS_HAS_SFRAME_SUPPORT
> +	depends on 64BIT
> +	select SFRAME_UNWIND_TABLE
> +	help
> +	  This option enables the sframe (Simple Frame) unwinder for unwinding
> +	  kernel stack traces. It uses unwind table that is direclty generated
> +	  by toolchain based on DWARF CFI information
> +
>   source "drivers/hwtracing/coresight/Kconfig"
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 54504013c749..6a437bd084c7 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -469,6 +469,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>   		*(.rodata1)						\
>   	}								\
>   									\
> +	SFRAME								\
> +									\
>   	/* PCI quirks */						\
>   	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
>   		BOUNDED_SECTION_PRE_LABEL(.pci_fixup_early,  _pci_fixups_early,  __start, __end) \
> @@ -886,6 +888,16 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
>   #define TRACEDATA
>   #endif
>   
> +#ifdef CONFIG_SFRAME_UNWIND_TABLE
> +#define SFRAME							\
> +	/* sframe */						\
> +	.sframe        : AT(ADDR(.sframe) - LOAD_OFFSET) {	\
> +		BOUNDED_SECTION_BY(.sframe, _sframe_header)	\
> +	}
> +#else
> +#define SFRAME
> +#endif
> +
>   #ifdef CONFIG_PRINTK_INDEX
>   #define PRINTK_INDEX							\
>   	.printk_index : AT(ADDR(.printk_index) - LOAD_OFFSET) {		\


