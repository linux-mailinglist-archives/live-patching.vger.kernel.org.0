Return-Path: <live-patching+bounces-1231-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3609A4515F
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2025 01:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC20D16D074
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2025 00:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6FF17BA6;
	Wed, 26 Feb 2025 00:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KhWfBuX3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aczcubp6"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2C529408;
	Wed, 26 Feb 2025 00:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740529357; cv=fail; b=VHNSacTFem+GpTZ+S3qrcZxhFt+kxpeSNQEMjl8tFqk/E65yN5n293m6u/WPQy8wkFUzWw08BEJifkxipRkpcUB62JB3esz5Z4Sw5GTL3YN1r0KrZR4vsh/H8hiy/DJ6b5jJhrxg+lRKlBXoiT7NgIRNQYEmRVrzAQHVOWAhDWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740529357; c=relaxed/simple;
	bh=5jNZzofMVZr/vmoVI4aLrHbXExjEQ8MjsSZaBhpLIdE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=svBH5+oI8Aa9mVO9acmLP1rDWrayDng+gFV5+AKCo5Ha6wL7c1URCemVQC9ICQCKnjxL3DggP5j9s2xDYyzLlaw95wvpXkT7XQh5ZSA/SsIc9DG5Cw38JRKVclLLJ9dfMb9/CF6Sq9me+V9yzZ5jTxd0hiEqNjxznnxMaks1CQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KhWfBuX3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aczcubp6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51PMZ2Sq009793;
	Wed, 26 Feb 2025 00:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Wkoun5WvmBdBAbgU7wQRv9pq5Y7qh6lYeLRA4dYDhr4=; b=
	KhWfBuX39nj8D7BBRnBwzCuaURiXn4ucBlUNyir1hShTTNp2Gu/EoCifjoSRAjdY
	3M84wdbYzMWmG8BnN5r6fEYkv0lWNsBTO1hFd28N1hgROf3LDzz9lp4kHhvvhnJU
	Sns04hTMCii4Xzc7osypq+0G7MyrqdfYYv0w6Hl6RF5jOn43nZwa2zjJTS6grTLJ
	lxz3nvz8SgHbmZ51nssNSIBzTFxRyUypYsMJjYCWDCUvPaIrZQXrd8uBeMvflC4u
	t6ls0U7cge0HxLLQlIqyxAcdEjevco7F4Cky94GL/3Oa4AcMZH/EcW+e5DhbZe0B
	yEC7dOEyRTWamwEmog7KlQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 451psf03qx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 00:22:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51PN5E4x010256;
	Wed, 26 Feb 2025 00:22:13 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y519qqta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 00:22:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M7GEd2wL2/YrhMKT135cSa53xyRBABluw49TjaAZdxMdQ+aoTb0EUUVEsXJ/UnpriGWDRceWFfswBk63oTqdw3ptlQNjO+NgvZplT1vQDL0wxlhhXCYJhx1SpuRHDFffI9rWOP/Zq/ui/lTsCj8rbBON0VheBfmtgkfJA6w6uiD+8vfaAcyK8nlESlCAWSYMHfS1eVf1pB67CMOnUcCWdhuzZ6vUf/Srth9lGzFvwMRXmzKYMBvKbsX8WwW21t62N46DfkzTKbh2D4jj+bY6uk8rPrC2o1yBqMbM2vmB73xYkbNhCGlt2DSgE+Sm763/1ndSerEWV/9A5VGA2ehudQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wkoun5WvmBdBAbgU7wQRv9pq5Y7qh6lYeLRA4dYDhr4=;
 b=I2NCPNt5W7aUKW5SuFwvJC9hWvCnhkW61aUkXmJYCuuKv+cDAkyPV8K9CdP2OIu4xXy6azoJqTBu0TCIl9Jp2S0PhylM15+owwUgM2bih8FlbEFo8580TC2TLtR29eOWjvvkb6zBPEmJuRqrZ+G3lZirf5qfuZi8tLMNKHFyzV0kGlSDAtNrnsMb4b4TpqQWa4+b/2fbdaV3+1U+cP6tVrrgmQK3KVplifpVcL6HWj4Otf1Yydkw+VABB5gzcqRtGQfdxsXZC0qXW1mkY2UtyPYzUY71l4ImM+FLEh3LmlV4vdLe5Wo8rKGW2tGwDusvOWc35TJAaOFsJX34GOUhqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wkoun5WvmBdBAbgU7wQRv9pq5Y7qh6lYeLRA4dYDhr4=;
 b=aczcubp6UShlejQKTfaZwByxpikxXbiz6hWpfW2/NHK7ArhrNK1mZWy/xjqcr4SpGCCevZi244tT03qJfsODRJ4NnupFr4H6nq+3OvfR2HAxMWUoERF/Lzokrir87K/1NJVsr/O6IiX1t+fDsbybWLVWcGW37D8MzAEOpClFev8=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by CH3PR10MB7284.namprd10.prod.outlook.com (2603:10b6:610:131::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Wed, 26 Feb
 2025 00:22:10 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%5]) with mapi id 15.20.8466.015; Wed, 26 Feb 2025
 00:22:10 +0000
Message-ID: <da6aad99-3461-47fd-b9d8-65f8bb446ae1@oracle.com>
Date: Tue, 25 Feb 2025 16:22:04 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Weinan Liu <wnliu@google.com>
Cc: irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org,
        mark.rutland@arm.com, peterz@infradead.org, puranjay@kernel.org,
        roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org
References: <4356c17a-8dba-4da0-86dd-f65afb8145e2@oracle.com>
 <20250225235455.655634-1-wnliu@google.com>
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <20250225235455.655634-1-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0153.namprd04.prod.outlook.com
 (2603:10b6:303:85::8) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|CH3PR10MB7284:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ac1b33b-b1ae-4056-6847-08dd55fb9bfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UjdDWDJKRndKSnVsZGtFOHAvbC9VSFBlT3BIZUp5SllaWlBnMk1rOVRERlJT?=
 =?utf-8?B?QXR6M2M5c1VXRnZxVVFoUE5YazhxZGMxbmdvOGFSWjlRT1lNYjB4alMxWHh6?=
 =?utf-8?B?SFJFVHRHeHpWOWlwam1ZRCtkTzNFcENoSkdmM1F2T3RnODlkWE11aFVzUzYv?=
 =?utf-8?B?QklKN1JWRTYwUDFhSm1zb1dwNDFFQ0oxWDU2YTZxRnJJeTBIUG9UMVJJZ21R?=
 =?utf-8?B?YlZmaDhNMDJRMU5MWi90bjFQR1FoOEdSTWRWOUZUSGh3V2dKSXpvWXNrZXo5?=
 =?utf-8?B?ay9UdWJITUtLaUZrNkF5WktxeTVvNXlOSXpKNUR1RDBnemVoeExCWmI3WUZj?=
 =?utf-8?B?bzJFTDg3RU9jb3ltSmFEWFlCU1dpcS9SQlVPem1UVTNjUENXMnRYdVJmaWpD?=
 =?utf-8?B?NlJFU0FMT3RFSVJVRzZuVWIxTStRTlE2enpjcXRrZ3RIUkI1dTdzWHMybHds?=
 =?utf-8?B?bXYwK200ck1QWEx6YmJURk55THFCc1l3STE1RGd6Sk9IYzlVNUt3MjZKS2l3?=
 =?utf-8?B?VGhOMDErc3poUzhCa0JWWWVldlcvZVZIb1l5Umo1YkF6aGE2L1FKZHlTcldx?=
 =?utf-8?B?ZHhiekEreFp1WlQrOWtZTWkweFFwWjUzL3l6TWlpcnRNalA5UW9yT3BKeUE0?=
 =?utf-8?B?NlYrWUh6bHAxS0JwNHA0djFUa0RVQ2JkOFJLeW1XWUZpQnNWdkFjcXRRUDl5?=
 =?utf-8?B?Zm1Gc1lTZ1QwWG9xcTRxNzBEQ2hURUdLUFUzZEFYVEp0UEZ2MFVyTGNlUTcz?=
 =?utf-8?B?N0U2cFhsWjlsQzhsWUhDZmMvcW9lUGVadWYwcGE3Mks1M3FDNjZJcVM0Vkxq?=
 =?utf-8?B?WEFtK0JJc09LV3o5aVFYOWdvL0RPUDJTZTMwdUY1YzJuakJncDFJVUhYODJs?=
 =?utf-8?B?VEVSVG5MLzFKZmtsbG9XLzR0a0tMblVjd2xpenplR0dxZjIyY0xDeVpKejFI?=
 =?utf-8?B?cFh2dFovRHFOeGNIdXIrU0RscUEzMHloMG9lT0grWXFRN3NpTVV0RGdpaklB?=
 =?utf-8?B?dVhqbDRab3dFdjI1eE5pR1NveUg1UFd4UGpNUktHc296dFp5aUpOY21yNjgr?=
 =?utf-8?B?clZ2ckgydHlySFdFNk11SEpLUFh6UUxFREtiQW5XQWNlUGFyMHQ3VkVqaUJt?=
 =?utf-8?B?UTFxblRhL0hPeFFHWTNoZXJzNXFPektjUUh0RmRDUkEraTRLQ3MycXFkQWNK?=
 =?utf-8?B?TGV2d0pMMURUZE5VRDFScmE3QnBRcXBtZXNDbVRiUythZ1M1MTd4ZWI2T1N6?=
 =?utf-8?B?R3Y0Wm42VDk4T1VaKzZQMGZpbWd6NVdEV28wakg2VDhKeVh1STVXN1NOUGxp?=
 =?utf-8?B?OUowa3YyclZBRzBnaXNsRENsTXc4YmZ4MDAzeXg3bHhxdkJUdU9oTnZpWnNo?=
 =?utf-8?B?bGEraG1uWTRxL2ZLQlhXUHE0cG1FYjEvUXorYnI5V0x5NTJrWFQvbUdvTG5w?=
 =?utf-8?B?aW5vRXh1Nm9uVWNSYVlVOXdYREtPcktzTEc2cGZuMmhySnB0TDhOaUF1emdt?=
 =?utf-8?B?RmpWSTR2UzRPZ3M4dVQrbVR5YWdKMW9KYmZKYVNidzcxa2xWSitydDFtcHFn?=
 =?utf-8?B?NURpeUZVQ05ka0NPNDV0ZXZaRGd6ZkhzcHhObG9WNFQ1eDNLeFBTQzNnMHdj?=
 =?utf-8?B?amRCcFVxTXRZdU5jTDNTWGUzWUVpaU5XcDg4NVlKOGt0M2srays4QzZqL1Fu?=
 =?utf-8?B?d2o5MDRzLy9SQ3pVYVVvL2pLeC8vbW9UODJGQU9LY0RCeXZCVDJ4WmlKdy9R?=
 =?utf-8?B?YWdrNVZ6Z3hzTEZLMFUxTjM1QjlvZ082ckNuQndIay9JZ1kyRHBCTFFDVWsw?=
 =?utf-8?B?RWdQWU55L2JTZ2Q0VVdGUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anpJZXVTSVNTRmhrbWJyS1dsVng5dnJnMTRlbUdHdkVaQkdSWUU3OXZhV0F1?=
 =?utf-8?B?NXpvSU9LSTFvbnUzSlFMMW41VkZ6eXZObnROQzJTMU5zTWxoMVNvYmVtdTlo?=
 =?utf-8?B?bDVNVDUwSE5YcGpDVXYwK1JwK0dFY29WWXZhT0pHOGhRbVJydGQ2dGw4VU5j?=
 =?utf-8?B?Nk9QSndEbTVlR2ROTEV5VEJ5SmF5bExjZkpWdFJMWkkzbWVlNjI4SGxnRkd6?=
 =?utf-8?B?RU5yMEpKeDBqNjNOOFZoMCtZeGluR2NoUHRJZ05xUlc0REJjZ0hzZU9aa0R5?=
 =?utf-8?B?MkRQWkVYT2x1RnIxMWlFYjQzd1MxdGt5VUE0bFlYWm84c2RxQkNyZmdCMzlN?=
 =?utf-8?B?b1YyRWNyY3hhazBPbUR5SDViM2VtQlFZc1ovSzJoTlFVdHA0cis3Q3VqMGdG?=
 =?utf-8?B?M3hqdmZKa3ZKTTl4S3NCYnNXV1VQUjNjcmtzeGkweS9LSlZ1T0dJYzMrQlNy?=
 =?utf-8?B?dWxlK0lFSjdxS0dYSzlXNE96MXlwM3BHK0JtNXd1c1VuV3dJUEk4N0JOMnJ4?=
 =?utf-8?B?U3lnY21Ta0dEeStUQ3FTN1gvamdTbEVSUWdxc29zZlRTU0ZuTmVJaEFGZGdK?=
 =?utf-8?B?NVgrdy9QTHFuMjFIQ2p1Ukhzdk5mdldsbW85RHg5M0VoUUFPQmI1dTVpNjJq?=
 =?utf-8?B?cktUSlFmL3lmMkFGT0pxdldTVFhNclFEM0Jkc1B2NVE3RkF1YXZmQWc5YXBp?=
 =?utf-8?B?K1AyVlNsOWdRazU2NFN2bTBhRVAyb2ZMWTRBUWZBcHpicEVmaHk5YzVoNW41?=
 =?utf-8?B?Q2M5cEg4MDN1ZDhnMGxNbm96YW1rZ2NsMXNYaHZRNXRjUTk0RGl5bkZoTEJy?=
 =?utf-8?B?L2VVQlZNL3hsUktRbXNPZ0FxTXAvT1dlbTQ4N3NYWjhxL0lqM2N5YW1uZjFS?=
 =?utf-8?B?S0hMZlNseUoxVHRHZXNtVGdnbW1PK005OUpQTXk0UmVCQjJuSCtocm1HSmor?=
 =?utf-8?B?aTBzaExhcWJEWUVORml1dW9vcndoYzJhVERuMU9VaGt0UXl2Mi91Z0Z1eGxp?=
 =?utf-8?B?TXZjTEFwN2RLbDJsRHlDLzhJYk9uak52VG9aM0tuYnlXQzVRYnhQemJwaFJ1?=
 =?utf-8?B?aUMvQ29CNnlwY2N3WFRXMlg3ekVPSE5qd0VSZjVPODQ2VGFacjIxb0RielhS?=
 =?utf-8?B?YWFKRkNCbVpnb3daZk1sOXhCVzhJMjQwY2NUTTlZTU5uN285cGEzNE9aUGxG?=
 =?utf-8?B?cUNCRlFYeCs4OXBnSHdMYk8rNGtrVTcxWnVGL29iMnZYbzZRK2prckUxcjdj?=
 =?utf-8?B?OEZpRDRBSnhhRnNheHlkVEF2eGJKaTlKVE5UNTNDcGw0dlNmN3FRMlZRTnM5?=
 =?utf-8?B?Nzh4WnRBSGVjb0w0MmxucFdlZjVHNjl6bjdIYnEwa1h5TG5WZHgrWTdEd3dl?=
 =?utf-8?B?WDdYNTltMWdiY0dvMExNaWtzeVkwVnpFeHBOOElrSUhvRzVUdEtnUS90UHdj?=
 =?utf-8?B?QXJzNnNGbTJXUU83dkhabUFhdWRuSW5meXBxMmpyMWk4cm9rQXUzVkRjTXly?=
 =?utf-8?B?b2hDM2lmaTJMYzdsd0piOFdhay9sdzI3S3FQNUsyZHZiRTdvRDFtVVNEOGhW?=
 =?utf-8?B?c0hpKzVSTjg1OVlQNDFTSFRnRDc1UmJiNkdMeWUrU09zdlArUkxyNnA3cHJP?=
 =?utf-8?B?VUtIMDB4NWNWaktMamJtNjV5QWN3c3p0R1RUeVdrTTZYT0xwd215OUZXYjdh?=
 =?utf-8?B?ZzFCd0x2RGR6YlBobk5vY0d1UHJWTENLbjVWMzJYcEk2eEw1eHcySkFzUkF5?=
 =?utf-8?B?NUFrWG8vZWFiMnVnOTM1ZDJRNitrM3ErQTVua2IxUmQ5T0hFRDcyODB2eGkw?=
 =?utf-8?B?TnJNMWlDekY1ZUNKWTQ4TnVPRkplWDdsYXc3K0NNQmlkSUxOcUQvdkllNXQ5?=
 =?utf-8?B?VmxmRW1UQjVPc2JvSi9SNmRoZWJ0MSt0NmJiN3B2TzUvbVgzY3dEK25YN3JL?=
 =?utf-8?B?ZFFnUjMxa2ZzSTZWTTQrbjc4Qk9hanE3by9LdFJGOVY5RnBJb1VxMTFkdDE4?=
 =?utf-8?B?NFUyN0RRdkhCRDlxYVZoUUtycXM2c3ZuYWx5ZFRUS1RvM0VqUTJSNWt5OTVm?=
 =?utf-8?B?MFJnQmlmNW1BQlhCVEJrVWhlUDc4VFBqNUtpVW1vWTlMaEd5Q3dGYnJHZEtO?=
 =?utf-8?B?dk8wUnVFMm5PRVdsK0lIWVdrVW9QMTU5WTd2MUFkVHMvOEZGdHJRQllxWGRN?=
 =?utf-8?Q?pgZYR+qMMPerO/45a3R/1Ec=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PPQHua5OkOfktZ3NLQusON+PSauyw+3E+tDg9Iq3QqU8grLZet+av896JT2yrDQML7inuq0Ysj8veCCEtTwlX/Klh7bt76FftMy5dAOK2H0bGgKlhp4M7Hu1Uaq0cFSyeUop7dXYdlo68rSwAjaderipUkaHj7DHsgnMe5eg7ADdl5VUyB6QuUidBCXcjhJca2DUJKDl989e+MZ67t4mQpp2pNH1q8o4aWmHNTtB1nKgXe65iMZxJNE8opEFpm1lNWar2W3BJHUK5WGx3w0yP2BdQRiL8wnZZTSGHTuBDc7hCHEtgG78qFpcY6GnHfjqohJy4HOVp4uK/0vn8/oGNr/O9xxG2M5USXx/oMns//aiwW73+9qRy5lCxd53PQQT2qykNkGhjOHx3xLAnvpiNRrEPK7ZY4YFlT9XWQtFYLkK7lE8OowLqx5FCdBjotSgd4xKO+/6LQ66UNkF8VHq9x7t8q+9h3Gkq82KEz0gVrK39bWaBOIZsY0H/r4w9FupdTbjRZOxOqe23f3lHnVkQ5xG6ZjQq5HVzIjPoNUoe9d6qliPNOQld4Ub0n67GIDtiqsbyA5f3iH/SAtIvymRCfSmWCy/vZ60Ltc3ppIm00M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ac1b33b-b1ae-4056-6847-08dd55fb9bfe
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 00:22:10.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUo6V6h7D4Y5tdVRI73Q7x3KijR6n/C/35QSNrArLUoOawQUgjpa+CxYMi3wTAFwyisyovmxmvPZ9dgP3k0vYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7284
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_08,2025-02-25_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502260000
X-Proofpoint-ORIG-GUID: b8RDPqPFByjgsoJS7aeUdrODFQ17uo4a
X-Proofpoint-GUID: b8RDPqPFByjgsoJS7aeUdrODFQ17uo4a

On 2/25/25 3:54 PM, Weinan Liu wrote:
> On Tue, Feb 25, 2025 at 11:38 AM Indu Bhagat <indu.bhagat@oracle.com> wrote:
>>
>> On Mon, Feb 10, 2025 at 12:30 AM Weinan Liu <wnliu@google.com> wrote:
>>>> I already have a WIP patch to add sframe support to the kernel module.
>>>> However, it is not yet working. I had trouble unwinding frames for the
>>>> kernel module using the current algorithm.
>>>>
>>>> Indu has likely identified the issue and will be addressing it from the
>>>> toolchain side.
>>>>
>>>> https://sourceware.org/bugzilla/show_bug.cgi?id=32666
>>>
>>> I have a working in progress patch that adds sframe support for kernel
>>> module.
>>> https://github.com/heuza/linux/tree/sframe_unwinder.rfc
>>>
>>> According to the sframe table values I got during runtime testing, looks
>>> like the offsets are not correct .
>>>
>>
>> I hope to sanitize the fix for 32666 and post upstream soon (I had to
>> address other related issues).  Unless fixed, relocating .sframe
>> sections using the .rela.sframe is expected to generate incorrect output.
>>
>>> When unwind symbols init_module(0xffff80007b155048) from the kernel
>>> module(livepatch-sample.ko), the start_address of the FDE entries in the
>>> sframe table of the kernel modules appear incorrect.
>>
>> init_module will apply the relocations on the .sframe section, isnt it ?
>>
>>> For instance, the first FDE's start_addr is reported as -20564. Adding
>>> this offset to the module's sframe section address (0xffff80007b15a040)
>>> yields 0xffff80007b154fec, which is not within the livepatch-sample.ko
>>> memory region(It should be larger than 0xffff80007b155000).
>>>
>>
>> Hmm..something seems off here.  Having tested a potential fix for 32666
>> locally, I do not expect the first FDE to show this symptom.
>>
> 
> Yes, I think init_module will apply the relocation as well.
> To further investigate, here's the relevant relocation and symbol table
> information for the kernel module:
> 
> Relocation section '.rela.sframe' at offset 0x28350 contains 3 entries:
>    Offset          Info           Type           Sym. Value    Sym. Name + Addend
> 00000000001c  000100000105 R_AARCH64_PREL32  0000000000000000 .text + 8
> 000000000030  000100000105 R_AARCH64_PREL32  0000000000000000 .text + 28
> 000000000044  000100000105 R_AARCH64_PREL32  0000000000000000 .text + 68
> 

The offsets look OK..

> Symbol table '.symtab' contains 68 entries:
>     Num:    Value          Size Type    Bind   Vis      Ndx Name
>       0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
>       1: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .text
> ...
>      32: 0000000000000008    12 FUNC    LOCAL  DEFAULT    1 livepatch_exit
>      33: 0000000000000008     0 NOTYPE  LOCAL  DEFAULT    3 $d
>      34: 0000000000000028    44 FUNC    LOCAL  DEFAULT    1 livepatch_init
>      35: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT    9 $d
>      36: 0000000000000010     0 NOTYPE  LOCAL  DEFAULT    3 $d
>      37: 0000000000000068    56 FUNC    LOCAL  DEFAULT    1 livepatch_cmdlin[...]
> ...
>      63: 0000000000000008    12 FUNC    GLOBAL DEFAULT    1 cleanup_module
>      64: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND klp_enable_patch
>      65: 0000000000000028    44 FUNC    GLOBAL DEFAULT    1 init_module


