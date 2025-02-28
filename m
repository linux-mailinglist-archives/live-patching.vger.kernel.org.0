Return-Path: <live-patching+bounces-1249-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 953B6A491C3
	for <lists+live-patching@lfdr.de>; Fri, 28 Feb 2025 07:47:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9384716F8B2
	for <lists+live-patching@lfdr.de>; Fri, 28 Feb 2025 06:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939F21C5D70;
	Fri, 28 Feb 2025 06:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HETmlCbn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="neGBQ7jU"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2C01C3BE3;
	Fri, 28 Feb 2025 06:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740725259; cv=fail; b=g32Ur3h8WC2zBQcrE3BfCKUnDUrflVTc7cMyLILEeRtGM0l4SmO4jJWdveh1X4yuN8v1XtsZJXU4EY6U7K5WRPZP/Te3iemeQBIBc69cxMl9IYebD8DeAHDWD37Bht4dRZw5Tfr5BOtOA3DklNBlqwVFupNIoRrFUeuNvRGLrsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740725259; c=relaxed/simple;
	bh=qwwrVQFvubVjwnyh1OCRBpD9UIY4lAEHubNA8IBM4x0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Iedorp6n4rrz8OCMZtSidT2fwZDCj27m9sXNjyliranFB+gZGJNnxHH+B52+NrGuHqkReeTeQDqkyn9UZWpEg3qSEXSYhd472ur8WQWGo06MRciQlr/zPxrG2WLbDMiS7PL77HKiMRC1A6oi3RM9XTbyup86WHWVt9ybG9u9myc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HETmlCbn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=neGBQ7jU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51S1BnUs032609;
	Fri, 28 Feb 2025 06:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hnSLWz8u7sbxjuDINzr2uMs5bN07MJhfJ0PE7h3r/rM=; b=
	HETmlCbncs0oJ0ZCyjvIl3vThKWRqMu8Gf9lg5dtXcDEivYH/bMocrtKysNglLJf
	7GDp6ik4RxpmxKY6cCUh8GvnBCtNxGE8frIkT63YL47iXqIi60WpJSkpNzUZXzeN
	1ZbK0wKRbot7Nds/i5BC9HaF/7GlT9+cNy3X38zRVgQQ5dmYTzLvruPymzV/6j0f
	UoYfYOv6XkyhX9Pq7udWE0n897Fu8+vRJQAy9SSrlrWViVzbAibGi4aZa5iBPnK4
	EQQQrYUs7YXOpmjfwAIZBMlkXUkLnLPnU8itjONFttB8Tzj9soSZ8xoEr7YW7LHy
	yYY14cJutm4OmVAqWe9kLw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 451psfvx30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Feb 2025 06:47:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51S6IXgX007597;
	Fri, 28 Feb 2025 06:47:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51kan9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Feb 2025 06:47:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yg/TvyEnp2RKn3Cf5ziDOa+9vlszPa6lM/o6B8LISNU8x+b7Q1c2C0PBB4sWd1C1fyS+pjO1pQZJawXJlCN4L0tLgU3Aez3/sK2H1NanrLJ2fOCqPp/RCVVeAPd/f6KJggK5Ap39eVzu6+MxhyIuzqxYaI9s1C3EikOy9mkgMhe6COJnei6U043OlILFbwYFWuj6cvAxUiUwIV7jcz/FQLJq3LVi4u/5/teh+Gvfjs8OYOSkGl3Lele5s8rcPZrSvh32T1hojnqh54wGwCM2gwTzbjZvkp+COes6MW3ncoytJudxGUohteHshm4DwJf4fAtBwzhA0Ek+sz6cOJLtIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hnSLWz8u7sbxjuDINzr2uMs5bN07MJhfJ0PE7h3r/rM=;
 b=tkJ4Zaf95L7/pnKW9DPcEMUlYLOr4F8WTBZ+DlJtNyTPUsQnN2owpQNBZifv89UphSH+5YqI476uJc2GAy12/1RUt/AxbgtVpjFQjPly4X6dW2i8VGHODwxqLWHzHX4n+rOhwggsH2cfMCn7H1yWxj1MOIt9LJJoDRjGfaBEKY24r4rdB1mxiJqy7MjVuJeLItsMBrxHD7ruyOnE6QKFBwsv1WIH6zPp5Vh/2YakBEJn76G1cIBlrpbOdaBz3nUK1nkzmbQkPqS7ZXdsFF7u5lbwb39K0M0oaMrc32xXIv8JP0cXdGxUrsyBAO0FYCO1tqil9GLe1K0/662MMX+Bgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnSLWz8u7sbxjuDINzr2uMs5bN07MJhfJ0PE7h3r/rM=;
 b=neGBQ7jUqJKpRWkcQjLRR9q0fQbLnvfqCZVTaEBUTHY/BgFfzuAiAtbe4yjV0y3LleAvY/G1Luh+sG2U/QIDuQzfDQklj+XehigvRpz21YowFCmwu6R1pNZIwJx3m5IZMZbOc6rhhLdiNuQNexknjh70AeiY0wwTTYCI2Uyy8Tc=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by BLAPR10MB5188.namprd10.prod.outlook.com (2603:10b6:208:30d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Fri, 28 Feb
 2025 06:47:07 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%5]) with mapi id 15.20.8489.018; Fri, 28 Feb 2025
 06:47:07 +0000
Message-ID: <9debc20e-1460-4400-a9ca-50b407948976@oracle.com>
Date: Thu, 27 Feb 2025 22:47:04 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Puranjay Mohan <puranjay@kernel.org>, Weinan Liu <wnliu@google.com>
Cc: irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org,
        mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev,
        rostedt@goodmis.org, will@kernel.org
References: <4356c17a-8dba-4da0-86dd-f65afb8145e2@oracle.com>
 <20250225235455.655634-1-wnliu@google.com>
 <da6aad99-3461-47fd-b9d8-65f8bb446ae1@oracle.com>
 <mb61ph64h9f8m.fsf@kernel.org>
 <91fae2dc-4f52-4f38-9135-66935a421322@oracle.com>
 <mb61peczjybg7.fsf@kernel.org>
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <mb61peczjybg7.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:303:6a::6) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|BLAPR10MB5188:EE_
X-MS-Office365-Filtering-Correlation-Id: 983c0704-33f6-4468-a69d-08dd57c3b7c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3I3VGF5OVRpQW5DWjZRMGZtVXBoVmZQK2JpanloMVhKSTlkVEtVUGZDTG5t?=
 =?utf-8?B?MWlxTXdiM09zOTRhSERjcjNXTSt0bkUzTTUzaEVGLyt0VEh0N0crMEpVMWl5?=
 =?utf-8?B?Ukx6cjBOZkxnaXVRNW9xQ296ZmlxeEo5Mmd5RHVuZVZJaGlqc0hLZ3JqSWZw?=
 =?utf-8?B?QnFXRnQwZTdENmJOb3o1cmxJUkdvYk1tQnJYZmh5RG1xaTZKVXBDTjUreXJ4?=
 =?utf-8?B?T0lsazc2SjBBR0xGa29wekg3bGhxQ0RYZjAvcU4vRmU4aW12aHZjUk9FeTR1?=
 =?utf-8?B?REF4cUxPRzhVRDA2RjJiNzlJOGdxRHl1dzdpRzNvOW5GelRpVTRITDdHbFRh?=
 =?utf-8?B?U3NTQ1o3Z0pmSUo3UXRuRHhaTFNCT3JXYm9uQjJkOFNUdklwcGMxSi9uSEth?=
 =?utf-8?B?SXhlY0lGNmQ3T1FYaDJiVHVHUDJaMGlmZmFLYmxkKzN6UWV5Yko5MDl2TXFB?=
 =?utf-8?B?QW1XL3lPVTZ1OWhxVDF6NHRZQ3lDcHlCZEVpTEt5L2pQL3V0VmRuSFQweW1G?=
 =?utf-8?B?empiSDJWeExTUTJ2MldvK01LaG83UldURnAzV1o0OHdWRnMvWHhkNUFNcEU5?=
 =?utf-8?B?aXZwY3hHNE1QMWJMamNmL01Zd1lnekwvRW16S1VjaHBIeFA5ZVlvRDhvMzdV?=
 =?utf-8?B?cHZkN1BQR1QrZnhZOWN1T09KL21NYnNTMEEvVFJSK3NxcURScDVLK0VUK1Y0?=
 =?utf-8?B?aUZpM0lVRHlTWEw3VWpTNk5ZbzVBcWVjT09BREMwV2JJRGp5QmJFREsxdHBP?=
 =?utf-8?B?MDZNSHpQMUtXU2pPT1VZdUFXNDNtNzJCOGxkams1c2tIbVhyUHpTNFRXWTQ5?=
 =?utf-8?B?RGxtcTBHR0VxcE5jdjFOVExqUHYyYXJLMmlPQkU3Q1VVdHE2MDlvYzFNTVdZ?=
 =?utf-8?B?ckxuOE1EWXJsOUNVZ29NYStFa1RKTUdqODMyTzdrY3V1RXVEMW9RSjY0Y2NO?=
 =?utf-8?B?R3l0dnNodTBXVnRRc3ZpbHNMZTAxckVoSFBsNVZQdmwvSElnbExnMGtjcVoz?=
 =?utf-8?B?L3RpUTdrbU9qYXhvbE9qaElLSUErMXk1SkhHQ1pOKzl1WEdIQTNHZVFLbkg4?=
 =?utf-8?B?T3pxOG1XZlVMWGFiYlpOWXI1SWlNWkFkbDFFVWt5cCtuNjRWb1VpZTQ4bGNy?=
 =?utf-8?B?SHZ3b21Fa3dxNDRzUEN0aGNGNWM0OG5JK2s4ODJtK1Z4YTg3SWJKTk54SEJ0?=
 =?utf-8?B?SXFhT3k5dWNudW02cU1XTVArcWMxdmkycWszbjBWUkJrOVRmVVl2SmdObEkz?=
 =?utf-8?B?akNLSWxvMTNxb3FCd0ZhSW9VdXdwUnpDNktQQk4rYkxTZ2M0eHA1VzJ1bXZh?=
 =?utf-8?B?MW1aaElWZ0hhWHN3d0ZjTndSMXdmTnlJbENjeEwvMVNIOGxFZ3NRV1p2aUtr?=
 =?utf-8?B?MnN5c0tZNDNoTU1ZNlgwSUhZRmczTmR3clBwRmtMcUxRRE5VQ0tVRXlhYW1W?=
 =?utf-8?B?Q3dqVjFQbEFublVxcWtsbDVzbWV4OTBZZkpaNGhEOFRKT3kyVExtYlowancw?=
 =?utf-8?B?VEE5OEpsSTM2NFhKaWVFYi9ZTjJLeWp1VFFyN3VxdlduMk8rcUFvbnlNRGtZ?=
 =?utf-8?B?VFBSRmFxeldXdWJpcEF6SGpWc2hEaTZ3ZmZzWFB2WW1QTzdWK25MaXNoakJ0?=
 =?utf-8?B?K3VMRVdQUjlwbzBhNjczNjFLZ0IyOWEvQU5FZnZWUnRpcmQzNUp3bjBUMzRK?=
 =?utf-8?B?RFBibEhkSnFQWVIvLzhpSlJIZG5HOXBUZnpCYVJOVFdwV2lKZ296OGdObzdS?=
 =?utf-8?B?WVZmZDZsdzhzczBvdU9IS2RERnhJQndaSk9FaEErRU5XQWtXU0N1YXp2QlFa?=
 =?utf-8?B?NHAyTHN6bEVrbjliV3QvQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzMxb2pHRHg1NHJ1aEcwangwcm9pQStXVHZnMk9TRGZtcHN3a3VVWUVsZW9j?=
 =?utf-8?B?RnBmS21KV0Z0cHN4WEhmcE9vcjFQbXFDRVk2emhsZHZiQUxvRzIxVTdlK1dm?=
 =?utf-8?B?TVhWc0xxMDQrdGVqOUpuL0hBWVpsVHVqVGJkRWQxcnB1Mnh6b1plV0lqWjlX?=
 =?utf-8?B?YzB4U1RLakFpNmdHSm5wMW5RcVdRQW9JS1BpUm13cFZ0ZGNuZ1JYNC9sNnhs?=
 =?utf-8?B?NlBBTWdjbitvUzU4OTdTMlhsVGRSeG13OUJITTBEc3BUL0ltUWd0cjQ0UHN4?=
 =?utf-8?B?ZWJ6dENzUVNRaHdWNnR4Y1J4eHVUR25uTDlTeko4Q0NwU0x4OFhQanJzM3pL?=
 =?utf-8?B?Y3hiYUFhRncvYWVHU1dBNktoenVMa24xUEJqR1VyY09sU0ovTGRrTFdoV091?=
 =?utf-8?B?SE93Wmlubno2M0dNdjIzekdHYzdOcWpYdUxlOTBGR2k4M0gyS3dRdlNSV010?=
 =?utf-8?B?VGhRU2c5NGt5YW9UMjFoa0x6VXRFejFNdndXamw5dG40UGJYR3JMMG9Cb3Nx?=
 =?utf-8?B?NlB0eHlSb0cyUzJBR1dzeFF0UzJaTlpWa3Bpc3dDUEkyMnJQNWg3S2I0ekU1?=
 =?utf-8?B?VnNZSUdhMHFkRkZJbVBJMnJGbUtBMThQTTZSbUNmS3FpdUpVbi9YTzRXZGIx?=
 =?utf-8?B?SFNMNTlXYnMyd3hCaW5yUUtESGhnWDZtWEwwdThNS3JoVEdEb2NKL3BZaTZx?=
 =?utf-8?B?aEpIaHVSYW1PeW9vMXpnSkJ2TVA1WnhlRGNiMzhTQzY3YnRBZDVmbyt6eFN3?=
 =?utf-8?B?TmE0em41VEFMMkZ2aVR4anF6UDdkcTBiSUk2L3NlWE1aTHB5RkYzZ3MvMUxm?=
 =?utf-8?B?aEYvWjhOZlRHNWxOYkVRWThIdTNvOEdScnNXVXZ4ZFlzSWZLSjRKRHdMelBB?=
 =?utf-8?B?a1lOODZvMGtHVnJjSmdoQnI2WmhHTzVuaU52UzNNNHdGelQwS0xaSEZlcnlU?=
 =?utf-8?B?Y2hMajVSejNGRUl4ZEFKTGQ1S2tFWFVGVGJpZmVoOUdobEhLTnBvdjd6dUNK?=
 =?utf-8?B?YUROVGw3SW8xeFFXQmVScXZyZXNvQ29iMmwveTUxY05DbHZKTUxGWjBmTXpW?=
 =?utf-8?B?Z3U1SHFid2NiS21JQ1p3MXFtdWRpcDJXNzYxTkswOGtvQllyejEwRVVscFZZ?=
 =?utf-8?B?SzMrZm9NWTJDTCtWRUl6VHVCWmpoWS9VK2NQOGlYZCt4aXFIY0hQdWZHbnBH?=
 =?utf-8?B?aUZXWGsxSHhkWDNFeWtscTg4aU92SFFsOGdpVEVSb0l0U1NJNjNGM3lIUTZ3?=
 =?utf-8?B?Tkt1M3lqU2tPbkt2Qm93eVpWL3RGdTZJQnJRMmpaejFvVWliOTlBMzVER2xw?=
 =?utf-8?B?Ui9pL1J4anJnb3dueDN0TnlibC9CdFJJMnNTRTRVY2w4Z0FEOFhKSHZJMVRL?=
 =?utf-8?B?UEtzclRFSUpEMHdBWWZ1WUxndFFsZDJGRHdUbmNHTDZzY2hXZ2N2Q2tQeEtK?=
 =?utf-8?B?cENYODRFazRST3ZBZlpCVExZdU1iMklJT200cEVWWGszVlE4Tm51WFBLMTZh?=
 =?utf-8?B?dGcrZTNHZk5PbTNKdUdMU1VEem9MaUozUVdvRTRCcGplMXNmT0pjcTZUVzRC?=
 =?utf-8?B?a2kzdFRnWGlUYmYyOUpBMEpJTk5vNzlUOFRiVlVSaWFGQWs0RTlPa2hrU3Aw?=
 =?utf-8?B?eStlcDlhRHpsQXBRTTJBVzA4TVNRRDlVakd4VCtoWURubEFKT0xDSkJqUTJL?=
 =?utf-8?B?bXRwMUNTS0Yza3RYZVp4Z0t4bTQrS0lTeWcrVXJPa3JuKzh2ODVnb1pkS3hn?=
 =?utf-8?B?Vy9BKzFUUFhPdFpkRWtXVTFEK0huNzNRVUIvaUJkUFE0Y3lIaHlBWStndWhs?=
 =?utf-8?B?MHhTOStndGQxNFFFUk9wVTEvU1lhNzZ5NHEvQUJCODJGYWxGVnJyY1hWYlBy?=
 =?utf-8?B?WGdWYlhkTmhwNGthNit3ODZxZW1GR2ZRZ2JQMDB2OXZkS3dTcW9jci9IZ0tu?=
 =?utf-8?B?NGhBVmRLdXkrQ1RqZGQ5Rll6eDdwV3VhZDVtTFZKZzAxTWx5VVcrMHU2N2wr?=
 =?utf-8?B?a0h3Z2tYQnZ2YUlZMmlXN2QyemRGTEdRSGRGVzdzNDRXSVNhL1lNS3ZzWnN1?=
 =?utf-8?B?RTlyUEI5bFpGQlVETUhweStDa2d1OEtqY0taRUU3em94bWFjcW9pMmJNUmVi?=
 =?utf-8?B?aVoyMDVBRkxVZDVmNFNPZ1gvcXVVOWFyTVQ4MDQrN2cwMmt2aEFnN3lxTWRx?=
 =?utf-8?Q?jTIxGrifHTDq9/Q/bTEQsd8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LiGtwjDGB4CIeGA/iNlNzFiCGu3uHHHdsWl5Rl0EJ2mxzZdpL6L9zbx0QGf5mSiz5gFB19SttKHDTFUrwprZ4TPppOxwoXvkrbZEIjgtoi7mf4EnWLpuycG7XN+4VtqH3zc2+9eH7ML7DXY5J08m10iURZuKSNeP6zIP9edZgV/QaeHLOuEMllswy2e17qm0vCIQAssx2OCYdqTA5W9aiRhGJCeQKS4IZS7lqs3VSNLEom+mwQZlg6znntTxNW4sl00Bt0MT8EvumL4HL856ysFyAeI7UJFeqjUsdwrwyGAnxuk+PdykR1zFc2jq66FgetqQFa1KnCVjldk+bGw5UMbshPOViA+MzIcWByAVMTsPRTe9StmNDAyaAp9pGLG9q2jAOb/VOBSIvZcH8GJ5CcfFi2zjs6LYRBMmlSod5Ud9qw2+mcqR+O4PsGD1iS6KMtpx5TOe8SXyfuq9zHh1dSPBWujQIRCnGW0xBTsQUG6nEc19a3U//N7vZePSAoFr2GjD6U83HVN2ZNyD/T1cd2lYGyYEhxN5KAH2s9Zc6qwzha2C1Mv7X18Go9998IalIdvolBsQzdcZ9Nn9gUjL1CSIAZOjv+ACY+PxyFoQJLE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 983c0704-33f6-4468-a69d-08dd57c3b7c3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 06:47:07.1752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eXcWE1utq3fE4Wf55Ll+5rNGJKZWRDLGv+hBzZ8z7f73M9VAEHiqI4J3el7YRhSXPXIVrMgXqbldY9AAW2R2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-28_01,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502280046
X-Proofpoint-ORIG-GUID: TmIMBhPhzbG8sCuvlGYrgwDrR3Y6qeTJ
X-Proofpoint-GUID: TmIMBhPhzbG8sCuvlGYrgwDrR3Y6qeTJ

On 2/27/25 1:38 AM, Puranjay Mohan wrote:
> Indu Bhagat <indu.bhagat@oracle.com> writes:
> 
>> On 2/26/25 2:23 AM, Puranjay Mohan wrote:
>>> Indu Bhagat <indu.bhagat@oracle.com> writes:
>>>
>>>> On 2/25/25 3:54 PM, Weinan Liu wrote:
>>>>> On Tue, Feb 25, 2025 at 11:38 AM Indu Bhagat <indu.bhagat@oracle.com> wrote:
>>>>>>
>>>>>> On Mon, Feb 10, 2025 at 12:30 AM Weinan Liu <wnliu@google.com> wrote:
>>>>>>>> I already have a WIP patch to add sframe support to the kernel module.
>>>>>>>> However, it is not yet working. I had trouble unwinding frames for the
>>>>>>>> kernel module using the current algorithm.
>>>>>>>>
>>>>>>>> Indu has likely identified the issue and will be addressing it from the
>>>>>>>> toolchain side.
>>>>>>>>
>>>>>>>> https://sourceware.org/bugzilla/show_bug.cgi?id=32666
>>>>>>>
>>>>>>> I have a working in progress patch that adds sframe support for kernel
>>>>>>> module.
>>>>>>> https://github.com/heuza/linux/tree/sframe_unwinder.rfc
>>>>>>>
>>>>>>> According to the sframe table values I got during runtime testing, looks
>>>>>>> like the offsets are not correct .
>>>>>>>
>>>>>>
>>>>>> I hope to sanitize the fix for 32666 and post upstream soon (I had to
>>>>>> address other related issues).  Unless fixed, relocating .sframe
>>>>>> sections using the .rela.sframe is expected to generate incorrect output.
>>>>>>
>>>>>>> When unwind symbols init_module(0xffff80007b155048) from the kernel
>>>>>>> module(livepatch-sample.ko), the start_address of the FDE entries in the
>>>>>>> sframe table of the kernel modules appear incorrect.
>>>>>>
>>>>>> init_module will apply the relocations on the .sframe section, isnt it ?
>>>>>>
>>>>>>> For instance, the first FDE's start_addr is reported as -20564. Adding
>>>>>>> this offset to the module's sframe section address (0xffff80007b15a040)
>>>>>>> yields 0xffff80007b154fec, which is not within the livepatch-sample.ko
>>>>>>> memory region(It should be larger than 0xffff80007b155000).
>>>>>>>
>>>>>>
>>>>>> Hmm..something seems off here.  Having tested a potential fix for 32666
>>>>>> locally, I do not expect the first FDE to show this symptom.
>>>>>>
>>>>>
>>>
>>> Hi,
>>>
>>> Sorry for not responding in the past few days.  I was on PTO and was
>>> trying to improve my snowboarding technique, I am back now!!
>>>
>>> I think what we are seeing is expected behaviour:
>>>
>>>    | For instance, the first FDE's start_addr is reported as -20564. Adding
>>>    | this offset to the module's sframe section address (0xffff80007b15a040)
>>>    | yields 0xffff80007b154fec, which is not within the livepatch-sample.ko
>>>    | memory region(It should be larger than 0xffff80007b155000).
>>>
>>>
>>> Let me explain using a __dummy__ example.
>>>
>>> Assume Memory layout before relocation:
>>>
>>>    | Address | Element                                 | Relocation
>>>    |  ....   | ....                                    |
>>>    |   60    | init_module (start address)             |
>>>    |   72    | init_module (end address)               |
>>>    |  ....   | .....                                   |
>>>    |   100   | Sframe section header start address     |
>>>    |   128   | First FDE's start address               | RELOC_OP_PREL -> Put init_module address (60) - current address (128)
>>>
>>> So, after relocation First FDE's start address has value 60 - 128 = -68
>>>
>>
>> For SFrame FDE function start address is :
>>
>> "Signed 32-bit integral field denoting the virtual memory address of the
>> described function, for which the SFrame FDE applies.  The value encoded
>> in the ‘sfde_func_start_address’ field is the offset in bytes of the
>> function’s start address, from the SFrame section."
>>
>> So, in your case, after applying the relocations, you will get:
>> S + A - P = 60 - 128 = -68
>>
>> This is the distance of the function start address (60) from the current
>> location in SFrame section (128)
>>
>> But what we intend to store is the distance of the function start
>> address from the start of the SFrame section.  So we need to do an
>> additional step for SFrame FDE:  Value += r_offset
> 
> Thanks for the explaination, now it makes sense.
> 
> But I couldn't find a relocation type in AARCH64 that does this extra +=
> r_offset along with PREL32.
> 
> The kernel's module loader is only doing the R_AARCH64_PREL32 which is
> why we see this issue.
> 
> How is this working even for the kernel itself? or for that matter, any
> other binary compiled with sframe?
> 

For the usual executables or shared objects, the calculations are 
applied by ld.bfd at this time.  Hence, the issue manifests in 
relocatable files.

>  From my limited undestanding, the way to fix this would be to hack the
> relocator to do this additional step while relocating .sframe sections.
> Or the 'addend' values in .rela.sframe should already have the +r_offset
> added to it, then no change to the relocator would be needed.
> 

Of the two, adjusting the addend values in .rela.sframe may be a 
reasonable way to go about it.  Let me try it out in GAS and ld.bfd.

>> -68 + 28 = -40
>> Where 28 is the r_offset in the RELA.
>>
>> So we really expect a -40 in the relocated SFrame section instead of -68
>> above.  IOW, the RELAs of SFrame section will need an additional step
>> after relocation.
>>
> 
> Thanks,
> Puranjay


