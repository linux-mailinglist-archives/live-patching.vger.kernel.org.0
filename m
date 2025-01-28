Return-Path: <live-patching+bounces-1078-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 813C9A20D21
	for <lists+live-patching@lfdr.de>; Tue, 28 Jan 2025 16:35:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FFCF7A2A4B
	for <lists+live-patching@lfdr.de>; Tue, 28 Jan 2025 15:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFEE1C3C07;
	Tue, 28 Jan 2025 15:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JYvFYpA0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qIkG1ihK"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F212F9F8;
	Tue, 28 Jan 2025 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738078545; cv=fail; b=uvlcnAgMNTWGAGvrLInGZ8ZJLXXM+c9CEqZysOfcsmN+eIvChmTmAyPopzf7yu4fiO6gXncXhxsJSGoTqw6VBRMNxS6OZ7h/iJnFTv8SAvQd9VVJxrS3B8j7BNoRTwcvycrWstYm1Zh78bwEWN34wOrpkpSwr01UuHPfDON3PUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738078545; c=relaxed/simple;
	bh=YSDEAN0SX9QKtQcViFpRpFHQKs/EcfD+ehwqHvVyT/8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SR9uiJItF7/+2fZMpwpg2h6VFi+fQ9SLs2mA/XLBslR/qmiDqA3XEjYK87jkjwIfB6/bDjOEQ+xQsqcEla8CFrOi5rlWO7Ln8DIpQmf9zE5zArUfyJ7U56pVV1jDibPj9VBdujVXmaXIIWxsRMMrOvSLi+UilnKS7/aGZmaYE0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JYvFYpA0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qIkG1ihK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50SCvUTL021230;
	Tue, 28 Jan 2025 15:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=QpxSELHAQxGh0kCnCXaAPNJADQh2y/HJuSP81SYBt68=; b=
	JYvFYpA0COjlzbuFhzkL8DA50UMFwq8DyQCZ58wMy975klsZS0O4cP3aIj3NsiWU
	ZAVeNNoonEPXKPv0JslO3Z/sO1f2aTOAYxQ5llCN2OpiamhOER+TBc68xIL4ziQc
	AOL1dUTVNCAIunN+8kCD25N4mvwXaNLiDRSjPdsBIGRnnPyatLBdkLoxpci/qHFJ
	xFu5pFmN2xhYy7OoL7fHVBJAgDGFzecYSLO3kVkcMLIXGMFFHimU1tsbnBFIGwSH
	iyOZfEXofOYB65CSB4VtnFgeMvlnpgR4OlGyUjbRn1E3cXf6Ks275xcTm+Co/7OS
	bpkmFal8K46pPLpCAuNRqw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44eypj0ch8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 15:35:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50SEZTl7023939;
	Tue, 28 Jan 2025 15:35:15 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd8hbdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 15:35:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2ueFPdaA70VXFhYh5HYfljrA+8iy5qDbObZjF1G9TysYCBY4to0t8xuraCurGJmnKyJaV0Ftx64cuAglc5p8ED9xLFqQNTtjW8fH2zxIVYEuNAj/c2cV4Xm6DivFIaPwOAbIYJpfCUYAaC4EENj3bqOUZplmpwE9xjsqYBHv/VBDmPU0orU+Gyn8ukkultek2vTZncXYcbsb0O1MDVlHGOPhRqAiYNmdGibzARMG93AHuBVoGILsii/4NcvV3A27jxwo0pkvb+QenL3tjoNFHPPyJE/tiT811HrLf1KKmQkCwf6vza3+aOp0tugM+pUuzAWEsvDnYHocqIERoby6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QpxSELHAQxGh0kCnCXaAPNJADQh2y/HJuSP81SYBt68=;
 b=BDVgmqtmPWz4TgPO6z4ZmCoP7V4jWi5K1EJChNUqXQhrcJOOUnRMDd8o6tUwb490zg27WIMauV0XJvl/Wyk9QARyuaA+3bqnU6wAC1tNWCM6av5B0mo3UirPogY8WHhDrFYUqnF4VZW0+4DBc3EEgANOcEQXwvENqDd1nzs9PBqd4FA1jZOLTcDpTyX0upLTYP8EpeNm2eif6WR7ZzT/FAoKPY4Dy979ThbMwTyha6YQEG+94fuC0ttXnjKV9iXt2ba2UDxTYwUNVnftfZ59av+HSpDHXuJKE/zhkWshztUWLm2CmV5e9t+7CaVfqjVHzdWSSW7znGAIBRrJx0ZaLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpxSELHAQxGh0kCnCXaAPNJADQh2y/HJuSP81SYBt68=;
 b=qIkG1ihKdTbEFbwdjVTv+kcNptNKcCe5eKdRc+OzrFwzxBueul21Eskzn2nXqgAXZk7CvQZ/ytYwjh830erbpbjThKPbfp6kZVBMz054WSGEUJeyJvUc1ABz/EumxQlzhky3OD79CgcFgju3F1JawKHrTDzzWeIAgVTpW8nDbx0=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by LV3PR10MB8131.namprd10.prod.outlook.com (2603:10b6:408:27f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Tue, 28 Jan
 2025 15:35:12 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%6]) with mapi id 15.20.8377.021; Tue, 28 Jan 2025
 15:35:12 +0000
Message-ID: <29b94227-8861-4011-b83f-2e0c59dd1f73@oracle.com>
Date: Tue, 28 Jan 2025 07:35:08 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
        Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
        linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, joe.lawrence@redhat.com,
        linux-arm-kernel@lists.infradead.org
References: <20250127213310.2496133-1-wnliu@google.com>
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <20250127213310.2496133-1-wnliu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0134.namprd04.prod.outlook.com
 (2603:10b6:303:84::19) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|LV3PR10MB8131:EE_
X-MS-Office365-Filtering-Correlation-Id: 67791df8-9a96-409c-1384-08dd3fb15ae2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDdTV3JNcDdCZGJmd2VaYzEzdEdyb3A0amFLV0ZFQVQzb3RwcEx4UHJvTnh5?=
 =?utf-8?B?dXF0SGNqNXFhSmJjRXRVVTU1WEFNNXRoQ1pNNExTWllIN0VUYThCZDFGaVMy?=
 =?utf-8?B?ZEFLUERYVUdJSG05MnVqWEZTQ1NFb25zYlVSaldRTDM5eGpWZUc5bE13RzZX?=
 =?utf-8?B?Y3lhb3RhZWMycWxVS3c4aFZ3TkZHbzNlekRORHV3ZXFQOEhlYi9qZnlNSDM1?=
 =?utf-8?B?eGpPM0xiKytoY1I2K1hFSy9lTldRWGFaaG44YXN5cUZmN1dDNmkwTEdJdlJn?=
 =?utf-8?B?ZVFkZjVnSE1FdFZqcVErNERmbFRWem5VSWk5WktackhPSVVsVjYyTTV2NjB4?=
 =?utf-8?B?VVNxNmtsY1JjVkhJSmp3YzdOc2pZUi85aHFZZWRYNVJBNFU3UUNWZ0Evb0ky?=
 =?utf-8?B?LzYvY0FLdm1NQXpYZkRIYjJlSGdkVFlOSUVkdndTcnVkZVRQUitDOUUrR2Ru?=
 =?utf-8?B?dDlQcndINjBSRHl1RWF3SnBZcnBMVlpUZk5FUjBDL2lpWUNvbTBQNFUrSGJN?=
 =?utf-8?B?enl6ZkFTZlJOOWgwaFhHdFkxVnlzM0pUN1h6am53MWdTZE12N2w0cmV6aHls?=
 =?utf-8?B?eFVFSHhOaVZMS0FhZElNZnhLZUtuZnN2WHlDNDhYVmg1VWl4WHBONk5Jcllq?=
 =?utf-8?B?K2JlQkpkWkdnUnlyTVFpZ2M0ZHBpVlo3aHk4NDVEcEJWbGU0Wi9ncllYQ1Js?=
 =?utf-8?B?amNDajV2ZTFrZlhtRTYybzFEdEVmOHR0eDVnNllPUzFmTThOdmZuSG1uRUFa?=
 =?utf-8?B?QWxvK1RjamZhMUpNMTNqYkNFZDUzTmdsVXN2VDNJelhhaXlDN3IxV0xGYm1F?=
 =?utf-8?B?R2xLOWFMeldmd1gxWlhIa1I1NGplQjhBZzFudFMyYXFCd0hvZVI4SmRQK1l4?=
 =?utf-8?B?Q2c4cGxmbVNkS0MraHJzNm00RndSSStRK3Z2Z0ZFdERXK0dPNGd1M1llZkc0?=
 =?utf-8?B?NGIxM1loeExQamRpQzFHcnpKUEl1TjZQZGxKRnBGR1R0ZUY2T2hLd1FYRlRs?=
 =?utf-8?B?OHpCQ0N2eEZ5cEt0UXp3Z2pRWmM1TkpjQWpNVGluOE92SHBvRGNZMWZVRlFW?=
 =?utf-8?B?dDlaUHlJeFVTbVhnY2k1emt4OU1DZU5BVEwvUFgwSENmbk9ZM1NhU3JsOEJh?=
 =?utf-8?B?TFAzNTZhbkpQSmVQc1o2aThPWEEvckpVTlJnUHFSeGtNa1E0RHFRcVFsRUxU?=
 =?utf-8?B?V2ZaMWFEQVRJcUZUcXdjMEpqTHZyZUxqQ0l0Y1IvNVR1aUIwMFRSVVpGYTI2?=
 =?utf-8?B?UDNrYkViMG5USXNyYkJIbWt0Nm9pSUltb2NMbEdsN1hkSVdqSTZjUFF5V0wx?=
 =?utf-8?B?SHV4dGxOWkxGUUNpUS82aFFwNTI5RS8rM1ZvbCtqbk4rWDFMWVZzblNNQzI1?=
 =?utf-8?B?aTZmZmhBd2x2bEx0REJ4WW9NVzZvZlVQZVQvdjlXRElRM0JzSEZqQlkxQ3Zq?=
 =?utf-8?B?cDNqNGU5QkRJWlM4WFpNWldXRk9hUHUzcXRQakRGc0RaQjdiVnM2ekNoWGdY?=
 =?utf-8?B?b29yUmt3R21FM1NHdFMzZldlU2wwY0tDQUF4Y1FBNXJ2Q20xS0VyMmNJUkpL?=
 =?utf-8?B?UEp1UnhuZ2JZUWVjRWNzUVRRTVJkM3VEVjd2c1NWbHM4cjkxOUpEdmpGMEpN?=
 =?utf-8?B?Q0l4V2lXSkhYL1lZZklseHduclFMVGlBTlhFdXVYbVZkZFF3akVDUndKSHRU?=
 =?utf-8?B?ODN2RS8vaHBqT1hpSGtackp1YWkvdFZoNWFrSGlqRlEzT0RXRUltQ1Qxb1JO?=
 =?utf-8?B?MTlQNDluS2psMFYrSEUyditnYllqU2pmZFdEUUI2akF5cFJMR1Bta1ZYTFdQ?=
 =?utf-8?B?MVY2K3BlN05ZVmRNbEdvZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjFyTUpVNVpUa3NHcWxXL1c4TEhRMDBvRkxDbGFsNFc5UGtPdCtjS0JMR3p6?=
 =?utf-8?B?T2IwcDdlMWNPTHhCYjVseWlLUm5IbmV6U2pET3NRQjE2Y2haSFl5RnNZZXdD?=
 =?utf-8?B?ZFR5Y1h1Vk9sYnNkdkVITlVuMHdESldrSW5XbnZDbGV6VkdxUU1ycmppMEhJ?=
 =?utf-8?B?YXdadjNlTDlibzFkMHg4WEF3SEVHeU5QQWNubDlaU1JnTS82QzBDUE1WNDZ6?=
 =?utf-8?B?RHE0YmFPeGplZFo2SFVZV2lLREw4cTluT1U1UTdZK1ZhdkdlRGlHbXZHdnZR?=
 =?utf-8?B?RzZ4K1JtU0pZWm1nTEVTWVZlS2NIbndLWlE1dm5SZE10RWQ1NjgzU2FrWHRH?=
 =?utf-8?B?bGRDSm1UYTc4bFR2ajk1aGJ4WXJTOWdoWlVOV3dzSHU4bFB4LzlMMnA1bGtG?=
 =?utf-8?B?NFZGWmcvQkpXNzFKNG9mdDgxY3RRemtWK0xFRlI4aHQxc01rQVNxaTVSa3B4?=
 =?utf-8?B?QWdyU20xVlB6ZE9CTC9YUHNyY21FMUNLMzFzaU1zeGNmejBUSG9lVDJ5YXIr?=
 =?utf-8?B?SWZwUE0xb3dqaUxCY2JObS9XdVRDMGttcVN1amR3MDIrbGp2Slk3UDhLR1lx?=
 =?utf-8?B?WitMTWxJNExkc2NBK0NiRWthbGhYQzhiUitXdTJuK3hJRFVjZGpLNmdtNWhG?=
 =?utf-8?B?ZGNWTzRqcjZDV2tWUFdPR09RS2NLZ0VSeE02dlFaR0sxVzlaMmZDVFBVZVhL?=
 =?utf-8?B?ckR1Z0lMMWxhZ0FOS01iUTU5N1dqNTJGZTJRVHVOTWNDMkdjTXIzbUdZZUt2?=
 =?utf-8?B?TGNzbmpBd2xCQ2pmYkxHR0NISDkvZVNVOEk2Z1RuQ3R1WnY0MGV6R01NWnFN?=
 =?utf-8?B?T0JhdXByTC92YVplKzh1dmwrOVdsOU5aUXNaeEtabkRLZ1JpUEpoRlBhZjJv?=
 =?utf-8?B?eWljTkFLb0NCUmE0YlNOSkxOT2hPRlFGQmxJTUh3c1pYcU8rbGxMSWp4ZW9W?=
 =?utf-8?B?cnZmVFFDTHAyUVd1YmZtWXhLOWxSbzEzVjF3N2tkUHZ3elQyMWZBdmN2bkpI?=
 =?utf-8?B?NngxVURVbmltWTVRQVA2aUlwODd3SDZqNU40VnFaUWphZFNObFpldlIyZk4y?=
 =?utf-8?B?Rk5ialVKZDVZNXFtSDcvZjB5T3dMSGRsYW4yL0NEakF5U0ZPVmtCd1FPN0tw?=
 =?utf-8?B?UXJXNzNnNEc5dDk2dnl3YkVpQS9kOWZBV0o5QzJhZG5GTmc4VjJKZzBsakJS?=
 =?utf-8?B?UCtIU2ZBMHhVOU5EUVF5RE1OcHZFNUNqOTFnTy9MbGFNb2x1d0dyQVZtY0ta?=
 =?utf-8?B?QjlOMk9rVnZ3S0daK2lZM2t1b3VsbE1lOFVhWW9YaUY3MTRib1psRy9nOXFh?=
 =?utf-8?B?V2lMZGlwc3N3OXUxbXVwWElITkF2NlVCRFd5NmM4S1BYOVNUdkRpa3lZWFc3?=
 =?utf-8?B?YitRak10UWUrbXRLQTNoa3FrYkFPSkIrSGtFaWhuV05BQlJWSDZKK1U2cFlU?=
 =?utf-8?B?WGxxT0tZeTgrSVZaM0VhSGpWdlN6N3BuZWliQkNtY1B5TURsM3RudzhFMWNZ?=
 =?utf-8?B?UXgxUVBKd2trazhXT2JBcTcvblBnMXFyUDJNNmRvUG1Wakt5bW5ML01JRnQ0?=
 =?utf-8?B?Q0N5M0I2M1d1d1Z2WUJrV2JnWTJWSUEwN3huaWJJbXJERUREUzZaVWJDQTQv?=
 =?utf-8?B?MUlZeTI1bVViN0FsWUp6SldWMS8yZy9qOTlaQkY4U3ZTOXZ4WUNPcmlyaElm?=
 =?utf-8?B?bzZiVmpYYUNlY0JoSHBwSWZ4dWZCT2ZMaVR2TmIybjFySlZlc1REMEdsZFZh?=
 =?utf-8?B?L2FlK1lXY09qenRYSGNkMHAzdFQ2MFUvUWl2bzBpS1B6OFN6QlBqdUppWVI4?=
 =?utf-8?B?RVozQVhWY1BrcW1VTjdQTU9qOVppaVlaNTgyQ0dzMnBnRkpwTnphb0hkNkk0?=
 =?utf-8?B?TncvOFZPbnBPRnk2NklOWFVXUEQwdWV1K3VId3AyUThiWTNkeW5nVTg2bzJI?=
 =?utf-8?B?blBjVm4rVzAzcWNZd2x2WUJOa2NCa3JYU09zWjdYZ2k1RjNvdEhOL2dHZTVa?=
 =?utf-8?B?L21NVnlzMjdlWFg3YXBwWXVna3lvWW1hRUcvSGJXOEMxMU9GUS8vdjVpbU1l?=
 =?utf-8?B?czlXdnBWdEtYKzlxZVY1T01HK0gvNjRUY2tRMWJ2MkFvNzFnQXdUNlgwcDRH?=
 =?utf-8?B?TlJ1ZVFNUGFZdE9ZK3dleWlQRkMrbHQwTWFuNFBPZlpzL1poaERQZTJQUllq?=
 =?utf-8?Q?HWTR0UvnOy9P8UL+XPTasGA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BhBvfS6Jv1ONuvGER6FQwXaVTQJ/OTFjUmm56c/YV1jIhbW2kEC88hyUDD/mpJCIhvyVWpgThj2nZIiZWyLxPqCoooJWEfkRf0SWL+SSMo0PYNnh+7akIP5NNQixqN2ZCuXM3IxskKSPTeLpeWTRCQtIIibN4R0zNV2ieV44qhlqokMTJET0lLCmdKq/OLQKOYSsr3jkss3G4tUAdlSz79pwy5xuNh23XaLsXWcIqs30HlrvHqF49Izp30ttIKHSpTU+Tc3smepwGiY+pb5tzbNb/70wpLF8LE4lZY1QEbWxd4t4PASg+e9+ogIpyYvkaT3RcX69Zq3mCWx/BwflG2eKRWR8GjnZkqR7jnseQqiTQ/gqlvRcCGO99xQ8yckKK78zQWKah6D2L4Z96fu6u6zoxZdRBB934EpJXVNmofUqfQJi23zdV5q4l5eC7G+Wlwhh+Qsf3HT4L4NYt7DZs0vcL9HfjKgMJs0SyNnSGhiauH6kbCcSmuWob3cM1PndMpJps2Ynymy0I8J3DXdbbz/PKDS2ryD4wuuejaCOXoyHcclg4VAwA+hTMPTkViFeyYcQW1ZP9nbo6y8KltmbvaSLoB2ZpkGhEM0NPQadsKs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67791df8-9a96-409c-1384-08dd3fb15ae2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2025 15:35:12.5007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3i9NLhA3LSJI4/WrDQUMm750wHjyONtlPeS1DTpBsMvWEQt5AQQ1NyB9Av9j//7FK/A68+QlUkbQbfvTBNtxvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8131
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-28_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501280115
X-Proofpoint-ORIG-GUID: J-MeQHzLCv8mzsZYFpDARsEtlUnyN_b2
X-Proofpoint-GUID: J-MeQHzLCv8mzsZYFpDARsEtlUnyN_b2

On 1/27/25 1:33 PM, Weinan Liu wrote:
> This patchset implements a generic kernel sframe-based [1] unwinder.
> The main goal is to support reliable stacktraces on arm64.
> 
> On x86 orc unwinder provides reliable stacktraces. But arm64 misses the
> required support from objtool: it cannot generate orc unwind tables for
> arm64.
> 
> Currently, there's already a sframe unwinder proposed for userspace: [2].
> Since the sframe unwind table algorithm is similar, these two proposal
> could integrate common functionality in the future.
> 
> There are some incomplete features or challenges:
>    - The unwinder doesn't yet work with kernel modules. The `start_addr` of
>      FRE from kernel modules doesn't appear correct, preventing us from
>      unwinding functions from kernel modules.

I did file https://sourceware.org/bugzilla/show_bug.cgi?id=32589 
earlier.  It is misleading (and inconvenient) to see all 0s in the dump 
of non-relocated SFrame section.

I get the sense that while issue 32589 may be causing confusion that the 
SFrame data is not correct, the problem is elsewhere ?

I can share a fix for 32589 so atleast we can verify that the starting 
point is sane.

>    - Currently, only GCC supports sframe.
> 
> Ref:
> [1]: https://sourceware.org/binutils/docs/sframe-spec.html
> [2]: https://lore.kernel.org/lkml/cover.1730150953.git.jpoimboe@kernel.org/
> 
> Madhavan T. Venkataraman (1):
>    arm64: Define TIF_PATCH_PENDING for livepatch
> 
> Weinan Liu (7):
>    unwind: build kernel with sframe info
>    arm64: entry: add unwind info for various kernel entries
>    unwind: add sframe v2 header
>    unwind: Implement generic sframe unwinder library
>    unwind: arm64: Add sframe unwinder on arm64
>    unwind: arm64: add reliable stacktrace support for arm64
>    arm64: Enable livepatch for ARM64
> 
>   Makefile                                   |   6 +
>   arch/Kconfig                               |   8 +
>   arch/arm64/Kconfig                         |   3 +
>   arch/arm64/Kconfig.debug                   |  10 +
>   arch/arm64/include/asm/stacktrace/common.h |   6 +
>   arch/arm64/include/asm/thread_info.h       |   4 +-
>   arch/arm64/kernel/entry-common.c           |   4 +
>   arch/arm64/kernel/entry.S                  |  10 +
>   arch/arm64/kernel/setup.c                  |   2 +
>   arch/arm64/kernel/stacktrace.c             | 102 ++++++++++
>   include/asm-generic/vmlinux.lds.h          |  12 ++
>   include/linux/sframe_lookup.h              |  43 +++++
>   kernel/Makefile                            |   1 +
>   kernel/sframe.h                            | 215 +++++++++++++++++++++
>   kernel/sframe_lookup.c                     | 196 +++++++++++++++++++
>   15 files changed, 621 insertions(+), 1 deletion(-)
>   create mode 100644 include/linux/sframe_lookup.h
>   create mode 100644 kernel/sframe.h
>   create mode 100644 kernel/sframe_lookup.c
> 


