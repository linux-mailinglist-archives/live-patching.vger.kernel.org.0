Return-Path: <live-patching+bounces-1871-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A32EC6D0B3
	for <lists+live-patching@lfdr.de>; Wed, 19 Nov 2025 08:13:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D7EB14E41AF
	for <lists+live-patching@lfdr.de>; Wed, 19 Nov 2025 07:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02D7313297;
	Wed, 19 Nov 2025 07:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qW9yJB/3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w9k1k/d0"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025E32F5322;
	Wed, 19 Nov 2025 07:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763536380; cv=fail; b=d81Y1t9dDSyLNlqw/WAnT2wGfdg2nhbLnMMWFUHWWyqqD/qvSeFa87lsZCCAynUkddT669gkH4UqtE5/0U2OqKG1J0Z63t59ay1h8HdxZDtP6ReA4DFWuLxy25Wxjdabsr0V94/9aIxAw6ZvJi4wlL88BVB+G/RsDFGeG8gB5Vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763536380; c=relaxed/simple;
	bh=Id99r38W8SwWD7/XjKd46QJPVBte16nWZP+BD2UoEmU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ncmiwsvXittASwCya0bMvvWvAcSmiZ219WOjGPX4SSHgAc48t9VCpsc+46+Caoz3mXvLXtOaPDz9AUQXkav4RI/ufWAqw1g2lGQQAjTimz6LBt2SQQ/dfCcMeeG0DE8FBZj3OvhxgnNT0N45ziAJUFRUrUoJEiGKw60HSCNwX+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qW9yJB/3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w9k1k/d0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ7C4To007303;
	Wed, 19 Nov 2025 07:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BdQ/mdnhWJnTnSfmKWYeAO+HXrGm7yrclFXQbqDhcI0=; b=
	qW9yJB/3yTW407mDYq135WVl3Ryr8Qg0RW6EkMOskgkaPGUSId/9vKLQNqvJzggV
	gDmbT9kvnr5iCesWep95AYAJFWxI3d3EQyNNTqpYu0jZnvEq763O1GWIRRmcUo2n
	OrMH+5LKukHtYAg4qAwurDXbNPFGb2TfSgVpQhkHh6hk4etsMKdiOP5gXG7grYlh
	XRRAE9Zf8DpZQfu5+Wdv4vR/SWAWELWlfgTTXNRjZL9MTJ+rFDPSfCaIvIJqSpr4
	jgVedb1FGOrTN0ONR2nlsRZM2jT8UGMH0khCKpyf/bOpwzURQ0oE2h3/pGKLQ6l4
	LddgIQ+CM9IhxiLdw61k+w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej8j6gh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 07:12:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ5we7x039834;
	Wed, 19 Nov 2025 07:12:21 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012013.outbound.protection.outlook.com [40.107.200.13])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefymh069-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 07:12:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ianlek8rBjx3ORwa+Vcx8exMD0rstbehUeYhjDR0KrFCrM9QIILJlR5/9y6lqlJ5PI1r1yfcfQBKTp+yA5BA0wKTmhLUWX+zHsOHM/YAEpQpm+7Zob8mWVsxcBFjF41nwj7g5OlzCkOWRnR49taP7FltHWyOjMDw3YHNbK7tYEMgS/4pJW2DVt1elimn7LCCWa8BHJ2OPbfJeClOXJX/etoDGWfybuFqveaFMwAmKFCGMs3/8IsVsbX0kvsXHxG/NmtCOcOTkB4lMO3En3B3xFnSDQEHA8NGQ+XMAtGxB1K8Vl2DVSHv6DLPHvJCMBV+ri0hGg4NOiGt4ckmUF4DYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BdQ/mdnhWJnTnSfmKWYeAO+HXrGm7yrclFXQbqDhcI0=;
 b=lqaprRDwQCHs8R03yQmcSkGHgWmwuyV4DL7CjkU5z2bascw/mQNQRkocNIv5eucOX3NFWQHLZye/Nr6q/mxKIyMweN28+wkBv9X6KZci+Q4mQKJC4n0f4wIq6ehJPfqcPGOdQ2KmP0Mcw901N930dvqcdeWq9NrERRKzJffCXdLIszpPkjeXCB8UaZZpRLZvJSataQFcumeW7zUMKAOk/J9vsLNkTPUDt05IVJwzQPLPlaBZJ1Hi0JDSN8w7mh8FGIdAtkuSN9iuiA1VzfjnGCQL3H6dCZlTJYLNPat1AVQEv3pjJHycXSsyD2KejGjcgV5a2FqILFado++LAF6L3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdQ/mdnhWJnTnSfmKWYeAO+HXrGm7yrclFXQbqDhcI0=;
 b=w9k1k/d08L4Aa7/4DWlZb7opztO8QcnCtR2CIqcsQEAsN9diOEylt3TzSMiIs+uBg8EedcIvxOE6cft9oId6I+jDc2L7+lsPKbos4hfY+dbP6HkU7nUvlr5kr4KYAJuVBUg0wGy7H4f2wFDXSAIX7xlJ0wkFfP8TDSSvEY1sY8M=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.10; Wed, 19 Nov 2025 07:12:04 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%5]) with mapi id 15.20.9320.018; Wed, 19 Nov 2025
 07:12:04 +0000
Message-ID: <03540be1-7687-4bdc-bf38-dfd713ea09db@oracle.com>
Date: Tue, 18 Nov 2025 23:12:01 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] unwind: arm64: Add reliable stacktrace with sframe
 unwinder.
To: Dylan Hatch <dylanbhatch@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        joe.lawrence@redhat.com, Puranjay Mohan <puranjay@kernel.org>,
        Song Liu <song@kernel.org>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <20250904223850.884188-7-dylanbhatch@google.com>
 <xo2ro446awhsd7i55shx6tlz6s2azuown4xk6zfm7ie4zz2nqc@244onpurkvy3>
 <CADBMgpyVis+fRHLOv6BRPrT+0r8846MOutkmOgMbqytLVXh9Ag@mail.gmail.com>
 <eo5fod6csuininieur2lm6bxunmpbk6n3wtxajamrwqqpae3ja@o3eqwfp3u6su>
 <CADBMgpzmzyQgs4K3XoYf5h=C7vv-FDfNb5wharucyeoxUKo4bg@mail.gmail.com>
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <CADBMgpzmzyQgs4K3XoYf5h=C7vv-FDfNb5wharucyeoxUKo4bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0132.namprd04.prod.outlook.com
 (2603:10b6:303:84::17) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|DS7PR10MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: 0154b0f2-378a-4726-4bdc-08de273af11b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aUFBMmhXKzRibTFvWFVzMEdYTTZWeitpKzBqTnV6NXN3L2J0REh2T0libHgr?=
 =?utf-8?B?aGxlUWtjSzF5OHd0b0JXTFVyWGhQSmJSUW1xbXdXRVpiRk14R1NpZG1Ldmgw?=
 =?utf-8?B?TGtJYUlmajlaT0V6ZUIzV01DUmRJb013MXpXa2Y4TjdyZ1ZRMHY4bWhzV1Aw?=
 =?utf-8?B?UUx3b2dKd2M5NS91bjVaeUZ6MjgwNjhCYWxvNExLTFZmSnFYQ1FxblZXNkta?=
 =?utf-8?B?dEUxY1B5VElmQnBJUUVLSFFnbnpVNU5DcVZ6VEN2Rm8xQmRCQjhQU25DUGJ1?=
 =?utf-8?B?SG5XaFkvYVdybDd6QWtTSWNUSTREaWc3ak1hRVZSMEd3YlRwdVVpZWdzbEs5?=
 =?utf-8?B?SHJXdG1FdVZIaXNoVmJZQmlwb2JNQTBmTnV1bCtEV3QvblFub1JVVlU1SUNk?=
 =?utf-8?B?Q3RuNkloMzhTWWVNZXJxcWlZL2RHaVIraXhjMDRaNWsxN3VOU2V5d1RLczFL?=
 =?utf-8?B?a2lJSjhHekY5VVdueHVjczVZUkRPbE8zZ2RkSG5hTkRYd0FLWkhlQlJnMlZo?=
 =?utf-8?B?VWVDa0FiTFVnZTNOR095ZGVLUlVYN2d6R01VS1pnUWwwVTZpT3NHQXp1R3hX?=
 =?utf-8?B?TmMwRWFsZnVrbVFTbjdBQzdkQ2srQ0EvOUZ5UVFRTk9WZkt4MG9hVkR4VkJ3?=
 =?utf-8?B?RC9LRFVNaE0yUmpHTG5Va2ljRWRiVGZjeDVIQ3pFTFFETDlBbjhpbXJ5dy9P?=
 =?utf-8?B?dnJRVmh1emNRWEg1SUxuMlRIZFNPbFJrZm5LWkZla3hTNE1jemFhWC82dEhm?=
 =?utf-8?B?R0NmY0RBSkVORXk2MGVVR0dzNHFIcUhNc21RZlQweVdpYytCUHhUcGp3dUhi?=
 =?utf-8?B?M1dIOFBjcitzV0l3cmNDL1NyZjRHRWloZVN1TlR5N0tvbnphSm5XSm4yTVZ6?=
 =?utf-8?B?OThaNW5DTzg5SGI2UlpYZTlVRE5WK2JYbVNCL3Q4MG5mZi9FeTRQaFNXZER5?=
 =?utf-8?B?TjRRUWJkdXltOXhVV3NZTnMvNEZod1F6MVc4dFYrL1htMTBpYW0vSTBYMTEr?=
 =?utf-8?B?UVA1OUNEVEFVUVRnYTJKRlhxQ2VFZDVKcWhNMU1oTnVGNFdLVExteU5LNWoy?=
 =?utf-8?B?YXdYd3MxbDVTNzM2amxiYVdrMllsKzBDdTh3L0VFdUoyOFpQb2pNenFwbEky?=
 =?utf-8?B?SktNZlNKa0NvSlpTMW9GZ2V0QUlHUUlYRC9JZVhCa2xscFpnbGVmQmFFaWE3?=
 =?utf-8?B?WXlvMUhVelN5Q05ISmJQb0pRb3dtL0ZpQjUxWmljOVZBRmJNWWtNUmR6b2FP?=
 =?utf-8?B?aUVUOVl5WmszQzY4N3JFSmxBQzRudHpsUW5oSG5WenMvbngzWjg5b2dhaFll?=
 =?utf-8?B?V0FhdDNrOVBCZWtQcGx4V3JoVUlsLzRkWnN3WXlqT3dJN3dKSWk3cEVtSkY1?=
 =?utf-8?B?L2xoMGF1VUlNbzBRR1AzNkc5dlRwTGk0OHRUNWRKZkd0Z1RTQXZXaE5tOW5Q?=
 =?utf-8?B?U1dZL2xRRUNKNk1vS21BeVBIRHFoWVNISUlvN1JFWW9oc1JsdWxTM3BibFk2?=
 =?utf-8?B?RDhwYlJYK0xHWlZ6MGtNRldKYThqNHduRVRBRngyUW5hTFY2bWJnVXBUeGVa?=
 =?utf-8?B?dFZPeG95U3FoNXZjM0N4V3dXQWRHOHpoNHUyazR1OERRZjM3L1dDR0RnVmtP?=
 =?utf-8?B?NjBtTGlCVGVKRFUxU2NGdjBmdEZsZDdkTDl1UVVIbmdFQXpNK0VkR3MzTWly?=
 =?utf-8?B?QXFUSEZtTjIzeXJqSEsyZktmYmU3UDRPQkZSTVp1WDdJNXRLU3Bxci9rdW1J?=
 =?utf-8?B?TzQ2ZmJHZDA3Z2J5RHlkbEthdkkwbjd5cVpYTW83ekt3VHAyNzdmWW1BMzZl?=
 =?utf-8?B?REduWGw3UDg1OTRUbmorRnRsclNCYXA4UWZVTm9Hb3FWd0x0OGJhbCtRMFRH?=
 =?utf-8?B?OXQ4TlYzU0pSMWgxRVJDU29sNW1oLzIwQ2RIVDBsZzJBZjZZa29GZU56Ykx6?=
 =?utf-8?Q?l/In3MaJnpuqWZET7HoiOtGuv41dcuHO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OURHQXZtZkJEWkZ0L1hNeTJnUXQ2Y291dklUR1BKdms4Ti9DQUM0SnVTM09W?=
 =?utf-8?B?UDNTRCtFc0pmZzU4NXFRbU9zOFl3MzJucWJwQzJ5SjNPUmVqR3VMNHRMd1F4?=
 =?utf-8?B?REQ1VVVEOUVQNDBxY044M0dSVmlDTll2cjFGekVWTFJGN2VhekdVWkpMNy9I?=
 =?utf-8?B?RVRtMkZEWjV2UXlJU090QnNwRmUxeER0Y3k1TCs0elF2dGRuMHRPa2tnaStq?=
 =?utf-8?B?SXkwMDNSd2lZVjZ2MFRvbmRGc3hFY3lJeDlxeExGWWFFMDEyNE85bmZndWp2?=
 =?utf-8?B?VDNSRm1sNTZJM29iK2oyU2IyM2sweGs3bnBqMGxNMVNTUm9hdWFsbmZjYmRu?=
 =?utf-8?B?eEVDa1h1VlZSa0NtSmtGV3dsWVJmUnZJMXV3c29Pd1dMWmR6bFhJK3VlRE51?=
 =?utf-8?B?b3YrYUNwZ1NtQzQ3N0x5SFBkbi9WKzcza0RnTkljSGxKS0RUc09lYklxdmFo?=
 =?utf-8?B?U0MvNC8vUWQrWEpNNEJheTA2eC9sTkNHM1FoeFBLcFUrWmVRam05UG50eEtn?=
 =?utf-8?B?TjNOaDhQc20wbGZBSGdXdmQrOXVLK0Q3M2MzSnVMc3k4MnNsSmZ2MlJwTEo0?=
 =?utf-8?B?TFVxR0Zrd2hHQnVnOERYaFhZYSszVUJ3Z0puZ1RycWlsQjJZR0hCQ1MwZWl5?=
 =?utf-8?B?VDNDclNtK2VRSnp3Zmt3OTN2WTdNTzJoNWJHSmtEZnlIeE0wY0ErM05ITHVS?=
 =?utf-8?B?dXlZanhhSVpzVmRWcFQ0b3IvNUlYMEpyOEFOVnQ4K0VNbzNZMk1iVHdPMkNh?=
 =?utf-8?B?bDJpeUEyMDBXZUpuTmV5dzVkbmlxTGd3eG85ZTNGR2hhNnpydlJ3OExyYmx5?=
 =?utf-8?B?MGhhc05nNmZaa3F2U0duM3M2YUhPWUJQUHhKcXpmOWlYcUhXblZFd2NPZXIw?=
 =?utf-8?B?RVdPdmJDdjBZNFg0WHkxMkEybFdHS1NYQ3JZSHdxT0ltclBlRlArL1VjMWFi?=
 =?utf-8?B?RzNRMGhhM2hYTk1WeWRhYjBNOWRRdVVON3IxYjZHOVh0U3laaTU3M3lRcC8x?=
 =?utf-8?B?L0pqS2hIUXA1Zit4U2swdkJJL2JrYzZpQk4vWW9wUmpqdnFQTGZiVVNlNk82?=
 =?utf-8?B?VldHeWNpNy9pM3dnT1dSanUyT05kRk5qbFJNK2tIMUtwVDVOQTJYNHJHTEhr?=
 =?utf-8?B?TGRSTWl1OTFoWlVyRTdhSEpZRDNMdWhucnpQQWY0T2xJRTY0c0xNZ1pyaEhU?=
 =?utf-8?B?NXB6TEpUbHg1OVkyV0JvU3QyNXRYYlZ3Z0ViMVFoMk9MaTM5WGtJWE1TcUxM?=
 =?utf-8?B?UjdvYU5FaFlvUjUrSGN4UFhoWStlYmdZUjYzYmlkenVJQ0R3SEtpczZYN2Jx?=
 =?utf-8?B?Sm5EYmVsSkI3bFhmOFZnc3g3b1hUUGtQMjBPenpjcHZ2QXlnVkpaaTRoUFF6?=
 =?utf-8?B?Tng4cVJwejVZZC80NnJNSG9pb0NKTFRMb3E2cHNXYXJWWU9sdWJxNFkreTNy?=
 =?utf-8?B?RGpqTVhNMFVQV1FRMGVsNWNsRHJCdTNLSGlwMmphSjFBU2V5TlR6UjRxcWx2?=
 =?utf-8?B?dkJ5ZkxyK2FDa0tFMlkveVhIRkZ4cnhoZmtqMTgybGRZblVVd1UxVlVuM3ZJ?=
 =?utf-8?B?cGVNSmpwL0Q2cUxLVHdGaldOa29UTS9KTi83T3BzeGVRTCtqMFB4WXlVbWlK?=
 =?utf-8?B?RUNweDV3T1JvWkRYR0xEejVlbnZadXhqTDR1eGlKZGxXYUxLcHNUQmFxMWdZ?=
 =?utf-8?B?TUxOYTYwQUJ3THFTRzFvbDNqY1NtNjBrdzdDZGxVSU1DM2JMMmdRcVhucGxj?=
 =?utf-8?B?ZkJDVlZ3L0twTW5MSEl5bjlyT1M5aWsxWEgyYUNXYWc5cllCcFJaSXVqSENq?=
 =?utf-8?B?QmpKdmIrMGdMb1JjK3VQOUR5VE8ySkJ6VE96VWgyRDdZWU5hMDVnZUtXN1pO?=
 =?utf-8?B?WmEyc3NlVmtCeGhRMFErWkxXTnl6N3ZBem5VSXJDYTZaMUE0YzBsSmt5Tlp6?=
 =?utf-8?B?dGJ3NWlHR1pocjJjdGk1eFZURG1EV1lIRldENUdWazNsMWcvR2ZzZnpKUDVD?=
 =?utf-8?B?MzdjU1hBbUlocFl6MVRmNjNQaTF2VmFHNk1lSitNQTZmTFF6WFdLMFJObU4v?=
 =?utf-8?B?S1prREpTcnpYQ21pMXR3RVdGaFFzRU84Q3lJZGNZVGFvejJxWVJKa1RZVDA4?=
 =?utf-8?B?dXM1UnZRTXNTYjMwL3R2SEYxYkkwNFNLRjJYOXg0U0JINU5aZWxqSXdoRzFM?=
 =?utf-8?Q?6PwKnofZHT9Iws7GmHXn5h0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uviAbGEzGEeqvhPhoZQpJ7jof8fOE2LRBnmGlXIRJEgU//6zzSEYhc81UcCN45bOA19+tQ6sHA40J62sQoNTl/0cC5S6Bv6je8c4JDJfbziwobir1c2/Qn4C5OHqr5q7mNwFQ7eM7/SgYpgvDVp9o0zntwUpC8n5NtqOgGVzPsJYrjOgSU31tAiP7d68O0W7mczC1uYmRhd33S7UMpWgb9vNb04crqFjVvLiNgOxpSlpE33UxviOy+TO5wYsjTOVwfLKOA5zD6+PDyM/wJ/y2S8wexT5VsVh15Xs/Ouz8ObEMV3w+wXoC/RLWBkxsVA/ZoI5RRM0zTGX2nBhLbBg1G8D2xW2WyVmO7edsTazOJnxTBOnLAAb2GGwZjdMSm9KrCf/zWcnFHYMagT3kfmYhBBw/wLrhfvB664d8Hc3GuJeEbFURh9jjZcTPpdj/z6CzqR31dg0rHQcyWSJoA7mvhd4RNLgemhgqV2aRt7wzg0BuBzTyJbKeAnFnkoLz7lZJKG97uV/EkUxXAeZx2XqfqJlBNDyKxZjwgH/DksNA6iPjOYTy52ZiTYssseDfEioUu9g/baXKzLQxg6DX9GXRpIwYvNePHEXEZdJsj/CcwU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0154b0f2-378a-4726-4bdc-08de273af11b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 07:12:04.0871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OqvI6fffyGyeRXcL1em/XXFjfznloyBVjlL0QdnpX5O5mywkMD2wWJv9QSAPyVKxKXBbptUX2JXpj8ZaYWADiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190054
X-Proofpoint-ORIG-GUID: h7ngDQw7YN09rscazZlWSe9fMFc_LGzA
X-Proofpoint-GUID: h7ngDQw7YN09rscazZlWSe9fMFc_LGzA
X-Authority-Analysis: v=2.4 cv=I7xohdgg c=1 sm=1 tr=0 ts=691d6dd6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=nQh6tRYwcYEvip77_LEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX08lOrfyJsK/a
 +SwFln1236XW2fg1r0lgWugLGYE5YTHWP5YCufNSoR84n4pSnKz65lpVG88cLiJ1/5gF50KNpcb
 7yigmeWt0j8daF6WVAPezUh8ns4nsbX4q/tSyu5RDlF0LbHufN7JJZAjUW1Lw6z6jDJHoNJPkyP
 ZultCV9byxYw1M0mQncrUcVhpNGVEWFFBeakRZaXN6HbZ9QXTO981jlFieVafFsWqz25i+qcdlg
 A5AOiUmhRMTjq1LWZr0QGaZWsrpKVZ4BmvQcrRDu5WBSptHRxPgUJ0OYnMFs2/9Gkcc7hKDjcft
 3N43yXiJSuMToYcOys52a+0koLTtQdPpJPnb3Baa1ZZrjIjUhkXBU/vKK3nX5aVvO370RwTgp7M
 MEuxnQVVJF0DKo2oOi2HRYtBDWrfnBMa1guDjP6Ba13KciKIn8w=

On 11/18/25 7:17 PM, Dylan Hatch wrote:
>> For sframe v3, I believe Indu is planning to add support for marking the
>> outermost frame.  That would be one definitive way to know that the
>> stack trace made it to the end.
> How would this work? Is there a way of determining at compile time
> which functions would end up being the outermost frame?

No, the compiler does not emit such a marker.

SFrame information is generated by assembler using the .cfi_* 
directives.  For the outermost functions, they need to be marked with a:
    .cfi_undefined RA
where RA is the default return address register for the ABI.

This mechanism is formalised in the DWARF standard:
"If a Return Address register is defined in the virtual unwind table, 
and its rule is undefined (for example, by DW_CFA_undefined), then there 
is no return address and no call address, and the virtual unwind of 
stack activations is complete."

SFrame relies on this to emit a marker for identifying outermost frame.

