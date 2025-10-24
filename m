Return-Path: <live-patching+bounces-1799-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE12C0710D
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 17:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E41D35641B5
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 15:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD7E3324B32;
	Fri, 24 Oct 2025 15:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="dzKu/cNC"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A90C2F85B;
	Fri, 24 Oct 2025 15:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761320832; cv=fail; b=ruTL47KveP+kg0s5Noe1LnU2mGjh0/TNab6xLQKcOmUTy5AUBh/tOXJ7QcZPYsiaDX7Tv9w9xpyqTLF+kYo+3yymHZKZTM0hK0y6esGj2+1uNVi/QbjiuRKbBX2vUmtEL2PaaDUk8TOdGd5E1vpptcVWxR/MgtBvJUm+e1kL+uk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761320832; c=relaxed/simple;
	bh=1VyiRcofRd42IjAeoKbEJaNCaZNdGWXrtdK+QxtjnRI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kZENHn9jClVSW838iwHBJWP1V8vcxnjYvicSXzkbczDXBHC4aSFPFL1XoIslIKk5JkyW17RAE5yocaThU9buBuoB4DEwmn5je05MUyFKPSAu2LL8VNITKiiVxcDmmWzpC+70ifBiHkNa3y/kNbOMuXdzO6exGvsYplBu0sn+Nls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=dzKu/cNC; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59OBwenZ419477;
	Fri, 24 Oct 2025 08:47:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2025-q2; bh=1VyiRcofRd42IjAeoKbEJaNCaZNdGWXrtdK+QxtjnRI=; b=
	dzKu/cNCIXFmHFA+PTA1dA9ElrJMV22u/MxyWCq7NdYAc/eYNVxkEmgUGEfSo/zM
	JiYWn8CFA6MJfr5RQUN1Kk8mzQ6wsFAbhbIW2J8+RNDVaAbO8xAm+iC6YlRDAAGy
	MeJApKZUGCJWI6VLNfFQgOAi2MsnvYnsoJ/tOu4HuGvAdF1JakQYEWYG/3sB+P7J
	VmftVdrKYADgMmgmjQZTkrm1Ks1X/FpZEqOR4PggewDOCONjVX4sfIzzkTvIbmZW
	jWw4gjXb+mnJaXBwDwJ6mLxY6ISntgacxP3fzoHX5guKOQhdsh3VKkh7l3WY0mBO
	zdTcPuszwYqvP24Q41U7AQ==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a09289k5n-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Oct 2025 08:47:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=haHD9twU5sdGR3C5GW4n2bAWIdxV6qxzEbrIymmUEkYItZ1/YaXkptNQ84M3WBqEfNKQ04dpiLQsIoaHRvm/n3tqv442AqaxnxT3XkcoSBi55dMkSp0Um4+sjpwMXnxGRbXuiWekqbJ7J9c4C9R1UDW2QDXc7YcRbXfBOzoLLB7itSVKrHcslC2+24wKujtuCabVxg1TdUpU0dG1GxFG+NFWqZndOpPgzO8tYGtjOc2gl9qwSmJ1zVNCGDdEl0rUv+H+a6mr4CLX9ioT1NPOeGOEzX/gn4kdx0/gi1QSljGmdlmAJ5plUI5K+dEXNNO4vlGH754MeVzZNaoRdU71+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VyiRcofRd42IjAeoKbEJaNCaZNdGWXrtdK+QxtjnRI=;
 b=XLBfAxoM8h+5SfGzKfSyKkaiWcW9MdsqiBkvN0PP0VliB7Ikl8qkpNbE7cmSwcFgarf1Rl3KBepxmoykRdrwagTDSE3Snvv2jyoGw0QhVwhk4qK9+rgnBhU/tNlRVCAVzHyrAZO2zCgGoBNHt4gugczB7JslJIRWztBiuXlSK6kebzzKHSeQBMyHgUdlxPIpydWmllibyKMlFji55bYEKwjnlhUOUd91RUo6eh27zTVx7yNz5uUOJIWLlGB2wK3hdDkEvFOhIqxFbIk/TbYNFoXWoO7DL66KQrvc7sxXYWgT1VuETZqYSaosnh1LRCHUpiQLX+5fQqmOJjh1+p/1KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BLAPR15MB4066.namprd15.prod.outlook.com (2603:10b6:208:27e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 15:47:04 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 15:47:04 +0000
From: Song Liu <songliubraving@meta.com>
To: Jiri Olsa <olsajiri@gmail.com>
CC: Song Liu <song@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net"
	<daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "andrey.grodzovsky@crowdstrike.com" <andrey.grodzovsky@crowdstrike.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        Kernel Team
	<kernel-team@meta.com>
Subject: Re: [PATCH bpf-next 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in
 modify_ftrace_direct()
Thread-Topic: [PATCH bpf-next 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in
 modify_ftrace_direct()
Thread-Index: AQHcRLWvu/MNXqWzDkWynsjJ4JqJhLTRLVMAgABEGQA=
Date: Fri, 24 Oct 2025 15:47:04 +0000
Message-ID: <D4EEB2BC-E87F-4F85-B043-867D4E1ED573@meta.com>
References: <20251024071257.3956031-1-song@kernel.org>
 <20251024071257.3956031-3-song@kernel.org> <aPtmThVpiCrlKc0b@krava>
In-Reply-To: <aPtmThVpiCrlKc0b@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BLAPR15MB4066:EE_
x-ms-office365-filtering-correlation-id: 45fefad8-8915-446f-a602-08de131494b9
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ckMzTGEvekJpTGdDTFlkbld5R3YvdW45SWh2Vlc3T3M0c0MycytNamxNVUZk?=
 =?utf-8?B?NkRoY0ZibkFjY05ZSGIwb0UyVlI3UzN6ZkVCdklVQ2tpNkxlQ1ppZVBlbnFh?=
 =?utf-8?B?dVJGSkFraGY1cWw1eklLVHc0RkFzWWRtcnkyV0F1UEV3Uks4a2FuSWV6U3JP?=
 =?utf-8?B?d0h1a0xPRmFVM2FuaytiWmV2VHJLbjF0SlMzYTRsdXd3NjRxOTdWMHhuelBF?=
 =?utf-8?B?dHE4WEptOWlsL3UvV3B4eUczeTdDWVd0NE1MZmlMdUtwcDdUaTk0bGlKdWhK?=
 =?utf-8?B?VHAyck5lWWc1SmlxeDAwU3R1VkhlNGs4MThYUnVhMDdhSVdYVHFZcmR5clV4?=
 =?utf-8?B?V2I2SDIzUTRWVmV1bHdMUEhocHpHSkFkZTlUMU8wSTN1Mk1vU0FPWGNVT0E1?=
 =?utf-8?B?b0QwNnpvZlVDa1FLdWR4TjRlTDZNYzZHNHp5NnA4Y2ptby9qajUxZGNsWU9M?=
 =?utf-8?B?RWJLU29tS2F6NVVuQ3Q3cERBcWl5QmQrQnpTb2tkWno0dUZDU1M2am5lNTIz?=
 =?utf-8?B?dmhLOHozQW9pSlJpdktOUlV5bDRwUGk2a3dwdnFoTkRILzljWTNmYkdDb000?=
 =?utf-8?B?T1I5T3JpWitOdlNBdVZoQUNINnQwSUgrN1E2azNPMUZBUWxzeXhmdk1PWGdY?=
 =?utf-8?B?bUtvNGhIajJ6WVBUZUk4N1J6blpjc21uOGtMdXZ1TVo2Tnl1ek9TYjk0OVg5?=
 =?utf-8?B?U2FVMTJRekRkNzExUk1WbVU2b0U2Nko2cktLTUtoR2RDNGRwYUpEUlhOWWU4?=
 =?utf-8?B?L1I2VjEybC9IbEdidWExYWFvdUs5Ymc1eFNLYnd4NUljNWppZ2lNVnhsMGZC?=
 =?utf-8?B?RThjeC9yWHpINlVMWGR1K0NhNm4rbHB5S1dwb2gva1BnODVDeC9qVWlJRmpq?=
 =?utf-8?B?dVA0UkEwaHB0dTlGRzhqMGovYVdlbTZMT2hMNVFUMVVXQXc4eUtNSXhJVm80?=
 =?utf-8?B?VWpmbjZva2YvWUdvUXNod3MrWkdLY2QwMHNWZzdkWmdPUGE0S0xKNzNhQm1W?=
 =?utf-8?B?eDBSU3pVV3BlNmE5UHFjN3BXUlpMdHFzMWVaNHhENGVzSEJWcGpzZVpZMVZo?=
 =?utf-8?B?ZVp6TWVQQXlwNjRGU01ER1VLM0tydmJuTXBCSWhFSkJUdDh0SXFYZHZkcS9o?=
 =?utf-8?B?TkNEQkNjbDVKOW5Ba0NML1d6YW5YTTljMWtzSVZCcFZ1b0JSUUgxS3lOV29X?=
 =?utf-8?B?SThqK2swTG1JYnpVKyt5ZDdlMzZ5MlRpeUNaYWYvT1I0THFpU2ZVNzlrZkVZ?=
 =?utf-8?B?WW50WTFkVlJTWEE1cWszcW1zQ2VCNkpORkpKanFrUjV3azY3VVhodnk4VEc3?=
 =?utf-8?B?ZWNKT01QYzRzUDdvTG82TTdXZlR4dzJCZHdSMkZJaWVmYmhrakc4MXFDRVNq?=
 =?utf-8?B?WXRXYnBteWErcGF2UHZFdDlSaEs2Y0lwR3hqcTZ1WmMyNy8wTDVFNmNEV1hy?=
 =?utf-8?B?N2ExZG5qL3NFcFBjRXpXcEtCQnhkK2VBNjV4OUdOYUNqbXAyNTNYSW1aMEZC?=
 =?utf-8?B?bXlWZldmaW5ZTlJmV3lNd01zNGtldnYrSlpVSUNtYnpvWGRBQllnR1V0aHUx?=
 =?utf-8?B?ZlJiU29CM21YZzNrNk5TckhxZ04rU055emVUN3ZLaitZZHR1dWk3SWhsYmdT?=
 =?utf-8?B?dGljV1FyZXcrTlNVWXo4OHhpZytNRkVoaU5zTDFDUFltUkMyRGV5NzRJWEJF?=
 =?utf-8?B?M0U5elJZWEE1aW8zczJQVzFtdDVwMzdqVFVqUEQ1Y2hISkx6NTd2K2xwU2sr?=
 =?utf-8?B?NlRKZUhpc09pSm11dFZNTnFZUC9JOHRlYlZNV2UzRCs5VWlSNnNIZEtCbEd3?=
 =?utf-8?B?WnZHWUFKYWkyTnl0U1pnK3crRlVQSjNHMGpWSm5uMmJ5RzNZdk1rQkxDOTJw?=
 =?utf-8?B?Y2RLU2hrandrMU5BWEVVbjlJMmN1dmZGZUJCR2xVYml1OTVBTHA4Y29lKzVU?=
 =?utf-8?B?SCsrK3VrbU5ER0x5MW5HcG00TDdzSkxhRTE0TWtZc3VqbHRyMVdvU3hSem9a?=
 =?utf-8?B?VGtkcnNuK2dueFNkVERJRGpLb0NUQlF3dUc1K1FGcTRFY0oyUGRWaDNoNGpQ?=
 =?utf-8?Q?7tvzJ0?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cFlINnYwZWNScWVqQ3ZSbzRManBmNWhCY3hUamhFTGl5RU4zazhkditpZWdi?=
 =?utf-8?B?ZDRHUHY4N3BiVnpmaFhQM2EvcVVzQkQxTHVQWWxvSDZXRjZ5ZEtzQjh3RXU0?=
 =?utf-8?B?SWZVemZyZkJZL2c4bVlQMTV1ekJJQnJXa2NRRzZzNllkTVNxR3NqYVZ5OXd0?=
 =?utf-8?B?VXRVa0FmZjFqaGRJQ29uc21HNzByMjJ6S1RyZGRvd1dHODRhdjQ2N2JvK2Mx?=
 =?utf-8?B?enZqMHRid3pSTGNDNVM0SEdSYWFjUHVkSy94UEdUZGRSWm1RVGM3amg0Nzlk?=
 =?utf-8?B?eUF3bjduT2swc0dSK2FCRU1ZNUlXbGtwbEZSV1BqUnBralR0NUJtSDd3Znhj?=
 =?utf-8?B?NGY4bTJnUXBmYWs4ZkdRcmRLVkxrN3hqSWdidXBsMmFpWXFSU0NQaHY5Rmsw?=
 =?utf-8?B?YWpGbnQwK2Y3U1pTSWxzbHNUYWVsQVBBQU5yaExyZElkcG9FamF5QjNjTHBj?=
 =?utf-8?B?K3J0RVBHRXlYdU5CM056Mmh5d0tjNGFVV1l6aGMwckUzUm5TUHl6Skd0Y0tJ?=
 =?utf-8?B?U1FpV3d4QUVENElvRmVtcXJJS042S05OZy96am1sNkZIcC8xdTdDL2lJckdh?=
 =?utf-8?B?MmFSUTJyR25yUGZPcXJhOFhxdnRveXZLcW1mRnI5MTB2MFppYWZ6R3VxMXBp?=
 =?utf-8?B?RUZFd2JaT05vZTNqajlPdVJ6L3IvMTNZYjNOanhhdmFKMHVPa1AxMmJyM0Uz?=
 =?utf-8?B?YzZQVHl6cS9xbWdOVkhHZExybFc1N0F0OW4yYnBYbnNDWDlDcXo0T3BBUTFw?=
 =?utf-8?B?bVhwUUxwT216Vldya2RpMnVrYlV0Mk9CSmQycHJkcWRIK2VoSXUrcGs3cld5?=
 =?utf-8?B?RlhsM3Z0RUJEekRaYmkyQnBYZ2NoRE1QTE5xalBMUjJjZ1dZYnpRQVEyYldx?=
 =?utf-8?B?cXpRVTV6SkRUU1UwYStTUXdRVFp1MUREVFYzSzRydlVGQnFta0M4YlNzYUVX?=
 =?utf-8?B?dWppTjk1RWhzVytkZ2hDOERsekY4TU9OWkMzNG5FUnlEcWkweWgvQ1F6UDdQ?=
 =?utf-8?B?T3NvY2gxbkt5UDAyRWplNTM5N1pVeUU0bGpVMnZObXZ3NTFjeUlkeWlwTGZ3?=
 =?utf-8?B?Tk9mRDR4WlBCQ2cwUDNYRUp2dnpKZ2NGQ0h2SlNyQi9pUHFoc1FOT3RyTW9Y?=
 =?utf-8?B?NVNqbVhhMURMcDVPSWxiTHRjVzlzSWp6MjVPcFZObVQ4K2VlUjJLNDNRWFVx?=
 =?utf-8?B?czYwejVSMmgySzRMK2hGNkp3bkxLS3JXem42REY5YmF4WTNEL2R6cERSb1JK?=
 =?utf-8?B?dFZzb3VBMGVCd1k4cG5iZjB0dFVlN3FGdlpkTkZxZ0hQd0NWV0dQeHVmU1M1?=
 =?utf-8?B?WnZLWVNNTVQ0L3FuZXlzZnVjSUFvalAyLzd6OG5yeGZ4RDNZUTg5aE5PL0xQ?=
 =?utf-8?B?ZzdncE5vL3c0WFJKaFVYM3lVVmNNRUJ6b2g4Z2RaTUlzdlJzRS8yd1JHcVdV?=
 =?utf-8?B?OGlxdlREaUxDRGxjeXV1K1E2N09JVFdSbjRNUU9SOU91R2V1L2hBYThEWDZi?=
 =?utf-8?B?T3p1VFhlNlV4ZFVpL2N3WnVGUm1ZZFlIQ1ZFZGRsTjhZaDN0K3Rsb3dlV0tG?=
 =?utf-8?B?eVNKclROSXdnWVdFOGRBMHg5b2szVEo2czQzYkVyb25hVEd2ZytyR1hYTnZy?=
 =?utf-8?B?Q0lldk9tWUo2ejhKaTJmT1hlZ21nS3dMRzNITkZXaXZXREE3Z0tMZVBUWWRN?=
 =?utf-8?B?Sm9rN2x3TTUxYTZWaVdNVERXVWhPL3ovQXk2L0NvTzVsNmtRVDhFYTczYzJD?=
 =?utf-8?B?Nzl2ZlAyVHRtMlZacWwrTTBoOSt6NnZaVjEvdE1md1N0cmUxWnprR0RGR1hn?=
 =?utf-8?B?cGRGY3hwNGN3L2o4cjhpeGZSMHhkc2NVN2NmSm5DZ1gvblQ3WWwwMXQrWjNj?=
 =?utf-8?B?WTN0YzVvN1h0akYyUkNSZ2F1SkNPVzlsV3FyaHVGMUhKV3BQd25zZ25BK1F0?=
 =?utf-8?B?R2NUUU5adks1MlAvMTJTUzRWcGozWFZ0bWhUNThPZkx1Ry8rSFFHV0dJZ2R4?=
 =?utf-8?B?L3RpbHVOVmhmTjdoNERKVGkvU2VTOE80ZU01Rjd0L3NPRk9UNTNraGo2NUdj?=
 =?utf-8?B?S1M5KzNSYWxpbGhnekI5cng5dlhESDhYQlkvS1ZHczB6TXFMMlRQd0NOaXZq?=
 =?utf-8?B?djhXbFZ0QkZmcWpyb3lZemtCQ2dwS1EyRGRjMVBNZkk0cE1FZWJ5WElkMGN0?=
 =?utf-8?B?YnpjQUFLeWRNNzdlTnVuZ3BZV253Z1RtcE9xTjlYQy9DWDlTUnF3bVhrOFJq?=
 =?utf-8?B?TzYrN1BoWWI5QTd0UGlVR1VnNEFnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F550FE894146B42999C019D2C71410A@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 45fefad8-8915-446f-a602-08de131494b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 15:47:04.3513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mF88UfjORMyKgolEAC0xHwyzv8iOlMy3UNRKijVhYJF3lk4pUx/8ebL6GcWltdbuCVY0+QDpAPWRzG7MtkW4hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB4066
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI0MDE0MiBTYWx0ZWRfXxv3Oo3cVNWvJ
 07z485MPUYcNE3Ya3ZOh4y9k8kPh9F5BhFqNGmo7fGAUvBvCnT2CsVo5UoDydlAdKilTYtq3dCG
 SLCvBuQsth5d3zv8j1kEFDR/0rEi256xWF7Lc+5vmPLQ3lETv1lQLedoiNzKkII3Y54ADadao3+
 LNGbGN6SHDrd0MdGB7tSXtQBZ4GWpvSAwuQRlfMiD7guOW42SWqWBqtbX7hjjjEt/4oPQ9AHXYR
 DwNFdDp+67V4igtXg/uW+L5SkScnCkRLwJX5GwL1f/LBmkSeRkifklLpkOcfhato5OJbJICA9Lx
 QSSVkO0X3HEQE2KJbYhmE4RwEw6QyHOliAyKIOlWkqGFfmsaJvPMUCMg8+pMAFLZEMoM2YUxPO1
 g0Lpb2kEcGsDceE/pAAT6DlFH7uQMQ==
X-Proofpoint-GUID: cH7ylKUvxaFs83naNRDmzp-Uaciw0rzE
X-Authority-Analysis: v=2.4 cv=aK79aL9m c=1 sm=1 tr=0 ts=68fb9f7d cx=c_pps
 a=GRGg88i0IYp+MSRJKvRoYg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=-DxKYkhAi93pFy7U0J0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: cH7ylKUvxaFs83naNRDmzp-Uaciw0rzE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_03,2025-10-22_01,2025-03-28_01

DQoNCj4gT24gT2N0IDI0LCAyMDI1LCBhdCA0OjQz4oCvQU0sIEppcmkgT2xzYSA8b2xzYWppcmlA
Z21haWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIEZyaSwgT2N0IDI0LCAyMDI1IGF0IDEyOjEyOjU2
QU0gLTA3MDAsIFNvbmcgTGl1IHdyb3RlOg0KPj4gZnRyYWNlX2hhc2hfaXBtb2RpZnlfZW5hYmxl
KCkgY2hlY2tzIElQTU9ESUZZIGFuZCBESVJFQ1QgZnRyYWNlX29wcyBvbg0KPj4gdGhlIHNhbWUg
a2VybmVsIGZ1bmN0aW9uLiBXaGVuIG5lZWRlZCwgZnRyYWNlX2hhc2hfaXBtb2RpZnlfZW5hYmxl
KCkNCj4+IGNhbGxzIG9wcy0+b3BzX2Z1bmMoKSB0byBwcmVwYXJlIHRoZSBkaXJlY3QgZnRyYWNl
IChCUEYgdHJhbXBvbGluZSkgdG8NCj4+IHNoYXJlIHRoZSBzYW1lIGZ1bmN0aW9uIGFzIHRoZSBJ
UE1PRElGWSBmdHJhY2UgKGxpdmVwYXRjaCkuDQo+PiANCj4+IGZ0cmFjZV9oYXNoX2lwbW9kaWZ5
X2VuYWJsZSgpIGlzIGNhbGxlZCBpbiByZWdpc3Rlcl9mdHJhY2VfZGlyZWN0KCkgcGF0aCwNCj4+
IGJ1dCBub3QgY2FsbGVkIGluIG1vZGlmeV9mdHJhY2VfZGlyZWN0KCkgcGF0aC4gQXMgYSByZXN1
bHQsIHRoZSBmb2xsb3dpbmcNCj4+IG9wZXJhdGlvbnMgd2lsbCBicmVhayBsaXZlcGF0Y2g6DQo+
PiANCj4+IDEuIExvYWQgbGl2ZXBhdGNoIHRvIGEga2VybmVsIGZ1bmN0aW9uOw0KPj4gMi4gQXR0
YWNoIGZlbnRyeSBwcm9ncmFtIHRvIHRoZSBrZXJuZWwgZnVuY3Rpb247DQo+PiAzLiBBdHRhY2gg
ZmV4aXQgcHJvZ3JhbSB0byB0aGUga2VybmVsIGZ1bmN0aW9uLg0KPj4gDQo+PiBBZnRlciAzLCB0
aGUga2VybmVsIGZ1bmN0aW9uIGJlaW5nIHVzZWQgd2lsbCBub3QgYmUgdGhlIGxpdmVwYXRjaGVk
DQo+PiB2ZXJzaW9uLCBidXQgdGhlIG9yaWdpbmFsIHZlcnNpb24uDQo+PiANCj4+IEZpeCB0aGlz
IGJ5IGFkZGluZyBmdHJhY2VfaGFzaF9pcG1vZGlmeV9lbmFibGUoKSB0byBtb2RpZnlfZnRyYWNl
X2RpcmVjdCgpDQo+PiBhbmQgYWRqdXN0IHNvbWUgbG9naWMgYXJvdW5kIHRoZSBjYWxsLg0KPj4g
DQo+PiBTaWduZWQtb2ZmLWJ5OiBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPg0KPj4gLS0tDQo+
PiBrZXJuZWwvYnBmL3RyYW1wb2xpbmUuYyB8IDEyICsrKysrKystLS0tLQ0KPj4ga2VybmVsL3Ry
YWNlL2Z0cmFjZS5jICAgfCAxMiArKysrKysrKysrLS0NCj4+IDIgZmlsZXMgY2hhbmdlZCwgMTcg
aW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2tlcm5l
bC9icGYvdHJhbXBvbGluZS5jIGIva2VybmVsL2JwZi90cmFtcG9saW5lLmMNCj4+IGluZGV4IDU5
NDkwOTVlNTFjMy4uODAxNWY1ZGMzMTY5IDEwMDY0NA0KPj4gLS0tIGEva2VybmVsL2JwZi90cmFt
cG9saW5lLmMNCj4+ICsrKyBiL2tlcm5lbC9icGYvdHJhbXBvbGluZS5jDQo+PiBAQCAtMjIxLDYg
KzIyMSwxMyBAQCBzdGF0aWMgaW50IHJlZ2lzdGVyX2ZlbnRyeShzdHJ1Y3QgYnBmX3RyYW1wb2xp
bmUgKnRyLCB2b2lkICpuZXdfYWRkcikNCj4+IA0KPj4gaWYgKHRyLT5mdW5jLmZ0cmFjZV9tYW5h
Z2VkKSB7DQo+PiBmdHJhY2Vfc2V0X2ZpbHRlcl9pcCh0ci0+Zm9wcywgKHVuc2lnbmVkIGxvbmcp
aXAsIDAsIDEpOw0KPj4gKyAvKg0KPj4gKyAqIENsZWFyaW5nIGZvcHMtPnRyYW1wb2xpbmVfbXV0
ZXggYW5kIGZvcHMtPk5VTEwgaXMNCj4gDQo+IHMvdHJhbXBvbGluZV9tdXRleC90cmFtcG9saW5l
Lw0KDQpHb29kIGNhdGNoIQ0KDQo+IA0KPj4gKyAqIG5lZWRlZCBieSB0aGUgImdvdG8gYWdhaW4i
IGNhc2UgaW4NCj4+ICsgKiBicGZfdHJhbXBvbGluZV91cGRhdGUoKS4NCj4+ICsgKi8NCj4+ICsg
dHItPmZvcHMtPnRyYW1wb2xpbmUgPSAwOw0KPj4gKyB0ci0+Zm9wcy0+ZnVuYyA9IE5VTEw7DQo+
IA0KPiBJSVVDIHlvdSBtb3ZlIHRoaXMgYmVjYXVzZSBpZiBtb2RpZnlfZmVudHJ5IHJldHVybnMg
LUVBR0FJTg0KPiB3ZSBkb24ndCB3YW50IHRvIHJlc2V0IHRoZSB0cmFtcG9saW5lLCByaWdodD8N
Cg0KUmlnaHQsIHdlIGRvbuKAmXQgd2FudCB0byByZXNldCB0aGlzIGluIHRoZSBtb2RpZnlfZmVu
dHJ5IHBhdGguIA0KV2UgY2FuIGFkZCBhIGNoZWNrIGJlZm9yZSDigJxnb3RvIGFnYWlu4oCdIHNv
IHRoYXQgd2Ugb25seSBkbyB0aGUNCnJlc2V0IGZvciByZWdpc3Rlcl9mZW50cnksIGJ1dCBJIHRo
aW5rIGl0IGlzIGNsZWFuZXIgdGhpcyB3YXkuIA0KSSBjYW4gYmUgY29udmluY2VkIHRvIGNoYW5n
ZSBpdC4gDQoNCj4gDQo+PiByZXQgPSByZWdpc3Rlcl9mdHJhY2VfZGlyZWN0KHRyLT5mb3BzLCAo
bG9uZyluZXdfYWRkcik7DQo+PiB9IGVsc2Ugew0KPj4gcmV0ID0gYnBmX2FyY2hfdGV4dF9wb2tl
KGlwLCBCUEZfTU9EX0NBTEwsIE5VTEwsIG5ld19hZGRyKTsNCj4+IEBAIC00NzksMTEgKzQ4Niw2
IEBAIHN0YXRpYyBpbnQgYnBmX3RyYW1wb2xpbmVfdXBkYXRlKHN0cnVjdCBicGZfdHJhbXBvbGlu
ZSAqdHIsIGJvb2wgbG9ja19kaXJlY3RfbXV0DQo+PiAqIEJQRl9UUkFNUF9GX1NIQVJFX0lQTU9E
SUZZIGlzIHNldCwgd2UgY2FuIGdlbmVyYXRlIHRoZQ0KPj4gKiB0cmFtcG9saW5lIGFnYWluLCBh
bmQgcmV0cnkgcmVnaXN0ZXIuDQo+PiAqLw0KPj4gLSAvKiByZXNldCBmb3BzLT5mdW5jIGFuZCBm
b3BzLT50cmFtcG9saW5lIGZvciByZS1yZWdpc3RlciAqLw0KPj4gLSB0ci0+Zm9wcy0+ZnVuYyA9
IE5VTEw7DQo+PiAtIHRyLT5mb3BzLT50cmFtcG9saW5lID0gMDsNCj4+IC0NCj4+IC0gLyogZnJl
ZSBpbSBtZW1vcnkgYW5kIHJlYWxsb2NhdGUgbGF0ZXIgKi8NCj4+IGJwZl90cmFtcF9pbWFnZV9m
cmVlKGltKTsNCj4+IGdvdG8gYWdhaW47DQo+PiB9DQo+PiBkaWZmIC0tZ2l0IGEva2VybmVsL3Ry
YWNlL2Z0cmFjZS5jIGIva2VybmVsL3RyYWNlL2Z0cmFjZS5jDQo+PiBpbmRleCA3ZjQzMjc3NWE2
YjUuLjM3MGY2MjA3MzRjZiAxMDA2NDQNCj4+IC0tLSBhL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0K
Pj4gKysrIGIva2VybmVsL3RyYWNlL2Z0cmFjZS5jDQo+PiBAQCAtMjAyMCw4ICsyMDIwLDYgQEAg
c3RhdGljIGludCBfX2Z0cmFjZV9oYXNoX3VwZGF0ZV9pcG1vZGlmeShzdHJ1Y3QgZnRyYWNlX29w
cyAqb3BzLA0KPj4gaWYgKGlzX2lwbW9kaWZ5KQ0KPj4gZ290byByb2xsYmFjazsNCj4+IA0KPj4g
LSBGVFJBQ0VfV0FSTl9PTihyZWMtPmZsYWdzICYgRlRSQUNFX0ZMX0RJUkVDVCk7DQo+IA0KPiB3
aHkgaXMgdGhpcyBuZWVkZWQ/DQoNClRoaXMgaXMgbmVlZGVkIGZvciB0aGUgbW9kaWZ5X2Z0cmFj
ZV9kaXJlY3QgY2FzZSwgYmVjYXVzZSANCnRoZSByZWNvcmQgYWxyZWFkeSBoYXZlIGEgZGlyZWN0
IGZ1bmN0aW9uIChCUEYgdHJhbXBvbGluZSkNCmF0dGFjaGVkLiANCg0KVGhhbmtzLA0KU29uZw0K
DQoNCg==

