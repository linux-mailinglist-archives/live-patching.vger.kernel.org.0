Return-Path: <live-patching+bounces-1636-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB1DB5057D
	for <lists+live-patching@lfdr.de>; Tue,  9 Sep 2025 20:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D1B03AF1DE
	for <lists+live-patching@lfdr.de>; Tue,  9 Sep 2025 18:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCAB63009C3;
	Tue,  9 Sep 2025 18:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M28oxf0/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DwjpXcpB"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77A13002BD;
	Tue,  9 Sep 2025 18:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757443223; cv=fail; b=pzXeGQVhMrldhks1Pc4VFDKfAMm97sMqo7shx0AF9wAvMcXfObHdGXnazndnpI9ebEVNELUo/ejn31D5k3/39jWN4DO+7N+fjF7J9814x5SMMPipSM8Y5YyCcHX6xQDfkn34WBDIr/MzVBvnDMSKHObKG2VJgwgxqcXElMTAa8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757443223; c=relaxed/simple;
	bh=ka1MWecwUXvRK4kIDJtoSYQjOt8NW/txwtRAYpvtKns=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E2QnCYlFI8M9u86ey4oV2XZnwKVarhKom97gsuveRxlpwtbxKy1spfbHY2hk8sBkk93cUQhFnE+Y6xztbwu2iaCeTML8xJ09gGgQjKX4+Vr6ujfG3C3WG4hPWnHk47x5yGMhyiHDQZL2cZDZJsb5cq+Y5DbgRWwO7hykZrlqilM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M28oxf0/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DwjpXcpB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589Ftg2N003585;
	Tue, 9 Sep 2025 18:39:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2MQojGHUv1A4KKTl8tNqggosYwnmUUUHFNLS1OxpmJ4=; b=
	M28oxf0/YsSfHLU5K1eLwsiRAoMQtSOi35WIOb2k2svyCGxZ41a999qtstY/6wwt
	AtPL4R5zHNvPp41VoDCmFthBkGBu8nPljp3JAUZsDAdkuSpQDF38B3Rf3Q6KQn6A
	TfDoAb9GKBoYCJYgtIlPUq6EFdEhk7R5F9TJ+awy2MIbRqXNRZiQT6W9uVNq/q6v
	ptOJnUH5t7wMFljXByWF1B2PgBCAIYozO57woO5a07iVPCIlKVUiMs/AXs+fKy26
	vVkuwhhQiC4SCQQwphykmAlYndaFywcWsrL0OBMF3gNUzPBQxCh+TiYbrJwV/lQz
	WtRk8tK/TqVgvfUtMMspmw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922jgtk4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 18:39:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589HM7Ks038759;
	Tue, 9 Sep 2025 18:39:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bda0tqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 18:39:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bU2DyDX4K2cPt35FygqOYskixdJMqyHNl9v4iR+rd7MpVKIdTN0wVgTAgocAhwHU1k64yMZoVMOiYR42uOcfc4BVHsk7P8QXbZ9RhDwvD9o5Ej2uYotK53G4dZXnPYskkKa2Ym7s4m/p+fMiZEz47sfwEv35UXMO2b2+Emf4y7JS+pr4fDCcNVn85km0RA+jxLvCdhCre4CWPx/wXJLtKE65yQ50KHHQK4rehBYWo9tgLMfYd81PFO6RNWiXt5/YEfy2ItGjo6wRWzNIVqbySbwaNSuddQvp89XFr4GC1GjlCfKY1IpzcwvX5wC5xDUAdpzGyD7fKOlwGwP1ztZobA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MQojGHUv1A4KKTl8tNqggosYwnmUUUHFNLS1OxpmJ4=;
 b=O1YuWOm8GAJ1ncqzgm1wYm4EpE3S29/5Fpm2PzM15bng1vLBn16Y+r7bdkIK+PIxjgRTQG0F8JG7G+KZdvYFZQAYdlUsCk8nSWpqdpO/CKz3WkZuCQswMBKFixX6Z/6daHVwkBiWpPcqO+F/rKu93BgzkfaRM5I57WIciGQU7BglTrP2gd4nebqEF5xBiowxIM+MHvG991PGKBLjRSP9t6HhOjiGPuGgw00GVPYsQHyC7zJeRXS1xhgQTVB9AdFLUv3SuS1hYrtRDgQ6DOo0u5LEjs1uhJigaypCKs1QFLVZPRbhXFIslqm8HpugeC3wFXLNx5ASPoVluu3sijraXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MQojGHUv1A4KKTl8tNqggosYwnmUUUHFNLS1OxpmJ4=;
 b=DwjpXcpB3lSqPYyA8o1c0lpoVw7WZN/6NHhljcWK5WUhDdj2a1PU/CBTpsa0vH5Sbb6ZvTqlUrNiieasqULiH79ibqSWIKE9BUGJ3IbXseKGsy4K4PE3RWagYA4Bkli8NoGTtrvykqHwfH46LV33xjDoEH91swUsabQVSFHp2s4=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by BY5PR10MB4210.namprd10.prod.outlook.com (2603:10b6:a03:201::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 18:39:52 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 18:39:52 +0000
Message-ID: <e5f7b36d-b993-4d7c-aec9-3589bf91fd30@oracle.com>
Date: Tue, 9 Sep 2025 11:39:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] unwind: Implement generic sframe unwinder library
To: Puranjay Mohan <puranjay@kernel.org>,
        Dylan Hatch
 <dylanbhatch@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>,
        Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>,
        linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, joe.lawrence@redhat.com,
        Song Liu <song@kernel.org>,
        Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
        Jens Remus <jremus@linux.ibm.com>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <20250904223850.884188-5-dylanbhatch@google.com>
 <mb61p4itb4ltz.fsf@kernel.org>
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <mb61p4itb4ltz.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0028.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::33) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|BY5PR10MB4210:EE_
X-MS-Office365-Filtering-Correlation-Id: bf40f870-4bf1-4290-4296-08ddefd04365
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGpKY2l3cElYZElhTHFtMjVmWExxV2pTcXlsTzdLWGxGYlhpdU43YTc0S2Qr?=
 =?utf-8?B?cEd5RmIvWC9FdjdpQkpHbHFTNGVQdlc4N2dkK09Xb1hhaUhKOHZiaHFZMkI5?=
 =?utf-8?B?VWt3VFdhbElXTGJmQzZjVkpUY1pHbFJIQjNEa1g0dVRhbkVhajdVQTY0TjJZ?=
 =?utf-8?B?aU9lVDd0S0tObWpOK3I5Mm45bGovYVplcTdZQ3BwWjRvaGlTVHVUcDErWVky?=
 =?utf-8?B?WmNRMnorVEtBL2hZUVBGeEp6YzNpRjArKzRBVDRUMkxoWU1rYkFFeFQ4ZitB?=
 =?utf-8?B?MEY0U3NhOHRMa2RmK0RGK3Ixc1g0Tlh1d3FjaWJtMVN5NXJuaGdPSENTQUVm?=
 =?utf-8?B?a29KczU5VmJJT3FLcUh0NE5lUXlCMlZHekJIRnVNalJ1SzUvSlJ2NitIWmQz?=
 =?utf-8?B?M21zNWYva1l1K1h0cGZtQnhvaU5sK3JUYTJPQlZ1SVM5bWVzemsydmcwZlRX?=
 =?utf-8?B?Qk1XUXZZd2E4RW9ycmhmSVN1Q2ZtTXFvMjRKMVNBNmhYdjhIRkVQUit0OG1m?=
 =?utf-8?B?QXhkc2JtTnZMbEdtVVB2RnJNM2VsOTFMUXVlNnhWOEF5ckhmTGwrWkNoNnZE?=
 =?utf-8?B?U2Q0dnNVSHB0M21KQ0M2UFVhUjRmZWhqMXppRkdnNmlpSmYzd1E4cy9MQlcy?=
 =?utf-8?B?dEI3Y1MvRmtoQ3NNQ0JINzR5TlRZRXcwdEFGTDZlRGczUjJuMW1wUTI3WFY5?=
 =?utf-8?B?RVdzYnlPYXVIazg1NU5ocXZJR1F2R09FMnpZd1FQY2svY1JlbnRWQnFsQ0Nm?=
 =?utf-8?B?MEg3eGRvdmM2RjkwTkE1TklaaWVjcThhWURGL1N1Q2k5N21OZ0tSZWdlSGR6?=
 =?utf-8?B?RFpPSTVlWWJEMWF4UjNRMWxPaGFzblc3eVpiUGNnTmt1VGRZV1Q5UjU2Y1E3?=
 =?utf-8?B?SkhoaHJ2eW81U0FaSmRFQ2V2a3ZDd0g0bkxqYXM1bkU5S0VrN3FXUzc5SVR0?=
 =?utf-8?B?RTlKeHRaamVZWjNhVnRuZUNydnR0SUtQUU8wbTZGMnVxTWd3dldkNW8zZ2dh?=
 =?utf-8?B?dGx6a1BaVTFLa2xCMU1hRElHcHF1UHJxOU5WMmxnZzZCeFFNdXBHUmFYcjBI?=
 =?utf-8?B?Rm1UT1M2LzhlSGNmRGNXaFlBbnRsY2VYNEtIR1FFUDBLcnRFSEhOZ3lQZlJm?=
 =?utf-8?B?cTQ5YlVSa3hFeVhjL0lHOEY4Q2Naa3ZNVHJ3NXM2c1FjeTJQd0N5a05PYUx0?=
 =?utf-8?B?K3dvS001eStpcis2emFXNFhSTm5vL2VDZ01xSWUrYndhQVFJWThEUkxjaGFU?=
 =?utf-8?B?bDdWRkZBd1pYZkg3V1hza0hXSERoME1TWnF1VmFoUWJpTEpieHArWWVLN3Iw?=
 =?utf-8?B?WGpSQ2p4N1MwbU5qNlJkaytGeXZIVWRnY1JHVkM1cE5xcWFTbGQ3RmNuQkU4?=
 =?utf-8?B?WDF5UFJPSXFGTlhhdjhGenkwUXhqc2R2Ym5qRzg3dDlIdlliMzlvd1FybWNH?=
 =?utf-8?B?VGk2bHJLam1NTDlxaTNJQ2dlUm1xajlFVnJBaGNZb0pRT1dONlRIamRBN0JE?=
 =?utf-8?B?Z21WZjU3ZW9VT0RvSDBGY0REVnkzR0pVSWo3SzV4dlQxUnFTTjVXYUJlSkZN?=
 =?utf-8?B?L1lLS1VENzN2dnkrV28rQjVDa3lTWWZDVjNWdWRZbHd0M0JMV1VXWFRpSmxh?=
 =?utf-8?B?K2lpTFByTHkxZnZuVFRCeWI2RUd5VkpoRDAra082ejNoRWdnWUhMNFhNSlRM?=
 =?utf-8?B?V2I0Q1BTS2RDRUxodG9vTU9lbnhITVVYODlkNUthaEFvbEk3YUhid1RJODYw?=
 =?utf-8?B?OEJKYUVqMzYxL2Nsa29GdUZYR1lITWFHQXZud0VNM3hQTVV6TzEwV0Q5REkr?=
 =?utf-8?B?UDA4WUFtaWd0OFVzR0s2M2hlbmVXbWQvalk0VVVmODR3U3pNNjBBakhSQytl?=
 =?utf-8?Q?BhkvS49uZ61Ea?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFJLb1YzYVIxazFIaEpNWHYzbmhadHdrVVAvazNCY3VLLzFYeGprTFdPZ0VZ?=
 =?utf-8?B?RXE5eW1qZm5INStkZEZXbGVTbWkrVEo1bjlKT2lKY2loRzEwTzVBenM2Tkpl?=
 =?utf-8?B?ZkFsVks3Sy9qQU1ORWhSeUVVYmtWOXdNT3dJQmdUSTRPY3k4UzNUVS9TNG9S?=
 =?utf-8?B?T0NqUWpaWS9WY2hEa0lRbldhSlU0d3QvWnJCZTRqMjQ4M2dlZGg0eURpS05w?=
 =?utf-8?B?WUE0ZTZxMVJ4UXRxZ3dnTGt4UmZrVmREMFpMc2JlblhoUTNveG9hd3lESXFa?=
 =?utf-8?B?YTQvMFRtMXRyRW9aemlaSnJqVzd5OW1XbjA4dU5KLzVWL2xZbkc3ZlZmSFV1?=
 =?utf-8?B?YXE2MGRrRHdnS3Y0MDVnWjhURXVPUi9BRVdOY0VxS3VWd05kZ1dPbEFpRmIv?=
 =?utf-8?B?QlBDVU5CTXRzSUp0ellRVFNGaXE1MUdCU2dVdk52SWNyNXVUYmFPYUROQkxG?=
 =?utf-8?B?V2d0bWdhTkdmWU8ySEdOUVhLbnd4d2U4OEFrblE2dG1Wek5kYXlUUkhJbnhB?=
 =?utf-8?B?UmlyZDNneHo1c1BHS24xS3cwa1EramFjeVVnNlRyYTRzcUdXK3p0d0VtY1dN?=
 =?utf-8?B?YmFKZExPcjI5RlpsODcycU10V3dnUnk1eXlVN3JQeGpSUU9XZGZtL1BaNjJS?=
 =?utf-8?B?bmlRaU5TY09qNVBTbS9aQ1NqNU5GTzBsRTZ0OHlTRXhIWndZelkvRkxQQWtC?=
 =?utf-8?B?MURld0xpdjgxRkJJaUtWdE9mVFAzYU9teUtzeXZiWjJndlNDbW1yQXY2YXRX?=
 =?utf-8?B?dTJXeXJ3Q0piZW5jZWtCbHAyYVpYaTE5dTdPM0ZrRDA3VzNVWk9xT25mck9s?=
 =?utf-8?B?SWNhK0xCUHZjSk5nNXF2blkrNGN1WHpuSG5TVkt2bUJheS9zNUtaRk45cXJz?=
 =?utf-8?B?dUhRYlBKM0JMckdSOElHZFFJSnRhZ2lLdXhjMk1UOTVqNlkyMGZ0b05NLzh1?=
 =?utf-8?B?cmZmSmgrM0RiWmhYSW9Ga0QyL2hOZVhIb3Y2dTVpOHAya0VaTms4c3BYdnRJ?=
 =?utf-8?B?UTA0TzJmaTNpM0ZvckpTZzA4WTNIUUZGcVZoeEZ3UTI3aU56K21oak1PUWdp?=
 =?utf-8?B?VytFVklLL0VrK3UxMHhpb1hpdS80S0Y1citXbkFydk1ESzdZYnZTRUNQNzlY?=
 =?utf-8?B?MmZ0d0xwdHVVU2xrcStWbWxVdldMN3hvZXRSV0lnb2VBQ252UWIyK040TG5k?=
 =?utf-8?B?dVhYclNJT0M0Q2tRbHN1cmFRS1o2RUw2Q3lZajdXTVUyUHJrWFk0cXluUWdX?=
 =?utf-8?B?QzlCSGQxakZ0aG95bklicUNqUHVRaDBpemRyT29uTFZmVVJxQjB6TTdMbnh5?=
 =?utf-8?B?RXZkeW8zbDdVaHdHTXBWMk9IOVVpRHNTcEdBUVVlTVFRNmNtbUtOR2N4R1Fa?=
 =?utf-8?B?YmtJTVN1dEwrL3UzWmpsUmNtWk85ZVcwczhtQ1ZpV3pIaWRCbVEzOFJFaVN4?=
 =?utf-8?B?RE5XTzNLL0pCeVh5T0xYKytYYXF3Wk1xbjcrb0xhTHcvM29zWnFwY2RnZkpG?=
 =?utf-8?B?aHhhaU93N2dhV2RoZUF2bU5FcllFRWJ4VkNycmFyVzkrUnVxNXdDRDBIMnli?=
 =?utf-8?B?VDh0Mk5FMkdXV3RWZVNoZ05EdDdydFFuRXpINEgxY0hWY3ZiODJiSXphM2V1?=
 =?utf-8?B?ck5zRDJqaXBSWCtsekx6aXI5SWtlVnRXeUk3b0o0QkUrckthOHdtU3VRTHFH?=
 =?utf-8?B?SlV3LytRUUF1aDRaK3c1cHJnOUNNbDJYS3BHclo0TmY3TVlFU3JCMENrb2FE?=
 =?utf-8?B?bXliTjVLNXhVUmVReTlRN2s2REc4YTV4bHFHNGIybGt2WUtsekgwK1grMHhp?=
 =?utf-8?B?MTkrMGNMMEJ3RkVEWFBhUkpiVVJCSUVxRVMyQ3Q3WkF1Y1B0MFdaczdLazl5?=
 =?utf-8?B?MTBBcnhKNXdZaTg2Q1VIR3lwYWN0alY3d3VmUGJob2p5MVZPUk9Hcm1VV3FR?=
 =?utf-8?B?UDBCRTl3K3UvaXBNREdZY2ljZk9TdUc3ajY2bWE3WjJRd1BPK282WlNlRlFE?=
 =?utf-8?B?M3M2WnR2cmtjN0xCYjBPVStjT0JsK0JwWEhaZVpDTEpDd2JPV2JQWjBvNi9Y?=
 =?utf-8?B?ZDZBSGpCN0ZjdmhBMUpDS3QyS0RaTGNjTlk0ZmtvZW1SZGgyZDlZRkMrenBv?=
 =?utf-8?B?eGhuOERveXlSSExoYVRlQTlDNlBNeHdmaU1XcHVpdjk0SXBkZHFkeVVJbWJY?=
 =?utf-8?Q?8L3Ah1qdzAuYczrwpX9i7Uo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	54oJ7BnzmMCvF4lnjdh+UeIGiblSaFNVXJJwz8HPSBUVTeUgi+beStIapT8eCReJCq/ozfE/Y5twK04Evxdhs4TiHodClGgy1JBlW24OzA0aKRjPE6cHBQNGYLQtpQ2uII5j7dV0CZY/5rwKzGltAqfExebSorcTrCRkZeDoMwuNkHRNqtcXuauIgvNKQJvpd4yBOW4aJ9LjHyTkITBjg/gPQQO4hCMLgh1sFeMNmyS/ARxNFwrR+P7NJtW9sqCOF9gPc7lEneiXshjQY/5PTeJpI+uClgPuM0AHZ/e2I5xJCdkaEVwKryvbEZZ4B2A8RaZ18LRLEAAtA13cSSuHsYhxvDmpy83fSsbwkO6WroDR0mZK6vqU6v+W8tu+CwoClZOj3gbHT+clKsmM/8WPyny9I/rNGgEPdt+bryldXyfZMRNDZa1vLfo1egT766KKkQzEEe19hRIH9A0yq93Oty1Lkd+0uBpAJc9F8OaUjFpaENaJDr7QONezDAZPAg7C5X8wbdWCh7LyQaxoAK/aYAFufYOyXviw61TCOCYmSS0B6aqxUJvS5y5tHuWub0cKDSMfKfucs4uhbE1yWZj0XmFJHCgR0DSR83FbUCnjdYI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf40f870-4bf1-4290-4296-08ddefd04365
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 18:39:52.1291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGYmV3u1AasQbpY/M1qwa3WtcDyCLP/bZlat7AKvhszyChYZBnCtgWXtwR2tEqi7w0btf+2MLrs50+/iwBjGRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4210
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090183
X-Proofpoint-ORIG-GUID: -7uBmYolUT5oZGsKXG2H6pcX2INArxoH
X-Authority-Analysis: v=2.4 cv=PLMP+eqC c=1 sm=1 tr=0 ts=68c0747d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=CCpqsmhAAAAA:8
 a=1XWaLZrsAAAA:8 a=yMhMjlubAAAA:8 a=NA-VuorDvAzkmdkhVXkA:9 a=QEXdDO2ut3YA:10
 a=x3xD2gU-9FUA:10 a=KenSiUQOsRsA:10 a=ul9cdbp4aOFLsgKbc677:22 cc=ntf
 awl=host:12083
X-Proofpoint-GUID: -7uBmYolUT5oZGsKXG2H6pcX2INArxoH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MiBTYWx0ZWRfX/RbExrhMA0CQ
 6UXtklffwu34FPVtTpfFH1USopamTFqUHLXL1KRewOzBFKr9szTSWmOoqiFbOIWftehrMGE4wnZ
 mg2u3jrpa0q+OxNHMaYoMuQjeMRUrFu7JmbEjE5v8rdf+pYulHC7KnsvcT6O9vvxeIHel9ss9Oe
 R6P6RwrNAvqq6WvdXWDs3VqUr/Uqxhe3Rujmw0w1N8IU2rYt884HzeeanJjIvozBt+voiAwkCqI
 BFoQhhj3EQNukQTf/HJwau8o+PkRD8Ir5c6+c+0FGO07IHneVP5qSm05ez5vhnqky9JMY3sZD69
 5urQrGjSxvlo3MuKLCSEBbncGdP1QX4Y03SBOenLjbl39/1W5STqTrd2Zp/5jHTUPohtgamevbf
 Jfitdjc8NzrbknhGGI8QDcM9MSz+cQ==

On 9/9/25 9:44 AM, Puranjay Mohan wrote:
> Dylan Hatch <dylanbhatch@google.com> writes:
> 
>> From: Weinan Liu <wnliu@google.com>
>>
>> This change introduces a kernel space unwinder using sframe table for
>> architectures without ORC unwinder support.
>>
>> The implementation is adapted from Josh's userspace sframe unwinder
>> proposal[1] according to the sframe v2 spec[2].
>>
>> [1] https://lore.kernel.org/lkml/42c0a99236af65c09c8182e260af7bcf5aa1e158.1730150953.git.jpoimboe@kernel.org/
>> [2] https://sourceware.org/binutils/docs/sframe-spec.html
>>
>> Signed-off-by: Weinan Liu <wnliu@google.com>
>> Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
>> Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
>> ---
>>   include/linux/sframe_lookup.h |  43 ++++++++
>>   kernel/Makefile               |   1 +
>>   kernel/sframe_lookup.c        | 196 ++++++++++++++++++++++++++++++++++
>>   3 files changed, 240 insertions(+)
>>   create mode 100644 include/linux/sframe_lookup.h
>>   create mode 100644 kernel/sframe_lookup.c
>>
>> diff --git a/include/linux/sframe_lookup.h b/include/linux/sframe_lookup.h
>> new file mode 100644
>> index 000000000000..1c26cf1f38d4
>> --- /dev/null
>> +++ b/include/linux/sframe_lookup.h
>> @@ -0,0 +1,43 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_SFRAME_LOOKUP_H
>> +#define _LINUX_SFRAME_LOOKUP_H
>> +
>> +/**
>> + * struct sframe_ip_entry - sframe unwind info for given ip
>> + * @cfa_offset: Offset for the Canonical Frame Address(CFA) from Frame
>> + *              Pointer(FP) or Stack Pointer(SP)
>> + * @ra_offset: Offset for the Return Address from CFA.
>> + * @fp_offset: Offset for the Frame Pointer (FP) from CFA.
>> + * @use_fp: Use FP to get next CFA or not
>> + */
>> +struct sframe_ip_entry {
>> +	int32_t cfa_offset;
>> +	int32_t ra_offset;
>> +	int32_t fp_offset;
>> +	bool use_fp;
>> +};
>> +
>> +/**
>> + * struct sframe_table - sframe struct of a table
>> + * @sfhdr_p: Pointer to sframe header
>> + * @fde_p: Pointer to the first of sframe frame description entry(FDE).
>> + * @fre_p: Pointer to the first of sframe frame row entry(FRE).
>> + */
>> +struct sframe_table {
>> +	struct sframe_header *sfhdr_p;
>> +	struct sframe_fde *fde_p;
>> +	char *fre_p;
>> +};
>> +
>> +#ifdef CONFIG_SFRAME_UNWINDER
>> +void init_sframe_table(void);
>> +int sframe_find_pc(unsigned long pc, struct sframe_ip_entry *entry);
>> +#else
>> +static inline void init_sframe_table(void) {}
>> +static inline int sframe_find_pc(unsigned long pc, struct sframe_ip_entry *entry)
>> +{
>> +	return -EINVAL;
>> +}
>> +#endif
>> +
>> +#endif /* _LINUX_SFRAME_LOOKUP_H */
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index c60623448235..17e9cfe09dc0 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -138,6 +138,7 @@ obj-$(CONFIG_WATCH_QUEUE) += watch_queue.o
>>   
>>   obj-$(CONFIG_RESOURCE_KUNIT_TEST) += resource_kunit.o
>>   obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
>> +obj-$(CONFIG_SFRAME_UNWINDER) += sframe_lookup.o
>>   
>>   CFLAGS_kstack_erase.o += $(DISABLE_KSTACK_ERASE)
>>   CFLAGS_kstack_erase.o += $(call cc-option,-mgeneral-regs-only)
>> diff --git a/kernel/sframe_lookup.c b/kernel/sframe_lookup.c
>> new file mode 100644
>> index 000000000000..51cd24a75956
>> --- /dev/null
>> +++ b/kernel/sframe_lookup.c
>> @@ -0,0 +1,196 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +#define pr_fmt(fmt)	"sframe: " fmt
>> +
>> +#include <linux/module.h>
>> +#include <linux/sort.h>
>> +#include <linux/sframe_lookup.h>
>> +#include <linux/kallsyms.h>
>> +#include "sframe.h"
>> +
>> +extern char __start_sframe_header[];
>> +extern char __stop_sframe_header[];
>> +
>> +static bool sframe_init __ro_after_init;
>> +static struct sframe_table sftbl;
>> +
>> +#define SFRAME_READ_TYPE(in, out, type)					\
>> +({									\
>> +	type __tmp;							\
>> +	memcpy(&__tmp, in, sizeof(__tmp));				\
>> +	in += sizeof(__tmp);						\
>> +	out = __tmp;							\
>> +})
>> +
>> +#define SFRAME_READ_ROW_ADDR(in_addr, out_addr, type)			\
>> +({									\
>> +	switch (type) {							\
>> +	case SFRAME_FRE_TYPE_ADDR1:					\
>> +		SFRAME_READ_TYPE(in_addr, out_addr, u8);		\
>> +		break;							\
>> +	case SFRAME_FRE_TYPE_ADDR2:					\
>> +		SFRAME_READ_TYPE(in_addr, out_addr, u16);		\
>> +		break;							\
>> +	case SFRAME_FRE_TYPE_ADDR4:					\
>> +		SFRAME_READ_TYPE(in_addr, out_addr, u32);		\
>> +		break;							\
>> +	default:							\
>> +		break;							\
>> +	}								\
>> +})
>> +
>> +#define SFRAME_READ_ROW_OFFSETS(in_addr, out_addr, size)		\
>> +({									\
>> +	switch (size) {							\
>> +	case 1:								\
>> +		SFRAME_READ_TYPE(in_addr, out_addr, s8);		\
>> +		break;							\
>> +	case 2:								\
>> +		SFRAME_READ_TYPE(in_addr, out_addr, s16);		\
>> +		break;							\
>> +	case 4:								\
>> +		SFRAME_READ_TYPE(in_addr, out_addr, s32);		\
>> +		break;							\
>> +	default:							\
>> +		break;							\
>> +	}								\
>> +})
>> +
>> +static struct sframe_fde *find_fde(const struct sframe_table *tbl, unsigned long pc)
>> +{
>> +	int l, r, m, f;
>> +	int32_t ip;
>> +	struct sframe_fde *fdep;
>> +
>> +	if (!tbl || !tbl->sfhdr_p || !tbl->fde_p)
>> +		return NULL;
>> +
>> +	ip = (pc - (unsigned long)tbl->sfhdr_p);
>> +
>> +	/* Do a binary range search to find the rightmost FDE start_addr < ip */
>> +	l = m = f = 0;
>> +	r = tbl->sfhdr_p->num_fdes;
>> +	while (l < r) {
>> +		m = l + ((r - l) / 2);
>> +		fdep = tbl->fde_p + m;
>> +		if (fdep->start_addr > ip)
>> +			r = m;
>> +		else
>> +			l = m + 1;
>> +	}
> 
> The above logic doesn't correctly work for the new scheme with
> SFRAME_F_FDE_FUNC_START_PCREL, see [1]
> 
> If SFRAME_F_FDE_FUNC_START_PCREL is set in flags then function start
> address in SFrame FDE is encoded as the distance from the location of
> the sfde_func_start_address to the start PC of the function.
> 
> And for modules, sframes will only work if compiled with [1] with
> SFRAME_F_FDE_FUNC_START_PCREL flag set as ET_DYN, ET_EXEC, and ET_REL
> (relocatable links) generated by ld have sfde_func_start_address as
> offset from field itself. see [2] for more details.
> 

Yes.

The SFrame reader patches need to be refreshed with changes to do the 
right thing when SFRAME_F_FDE_FUNC_START_PCREL flag is set.

Jens had posted a patch sometime ago (patch to update the SFrame reader 
routines to work with Binutils 2.45) to serve as a starting point.

+CC: Jens Remus

> So, for the in kernel sframe unwinder that should support both normal
> links (kernel) and relocatable links (modules), we need to reject the
> sframe section if this flag is not set in init_sframe_table() and in
> sframe_module_init().
> 
> Then we can fix find_fde() like:
> 
> use pc in place of ip directly.
> 
> and the check will become
> 
> if (fdep->start_addr > (s32)(pc - fdep))
> 
> I hope I am not missing something,
> 
> Indu,
> Do you agree with my comments above?
> 
> Thanks,
> Puranjay
> 
> [1] https://sourceware.org/pipermail/binutils/2025-July/142222.html
> [2] https://sourceware.org/bugzilla/show_bug.cgi?id=32666
> 

