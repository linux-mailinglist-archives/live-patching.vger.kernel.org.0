Return-Path: <live-patching+bounces-1234-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC8DEA46844
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2025 18:41:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D98D33AE454
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2025 17:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8EA225403;
	Wed, 26 Feb 2025 17:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OEHnz9D7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NN9DFBtS"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92C42253FC;
	Wed, 26 Feb 2025 17:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740591695; cv=fail; b=Fb0Juqeig7pXJxVEEnMcPe8Bj8k4vGw/uneB9NptfDE8D2C2xuqIzAOm1AXf8GPNBoR9m0zQNGgsyvQ+d6c7ptf6PUftZOgT+5e1WMiqpY5e6M16wlt98oQz7jvba3pEB0F4GmReb2NmwHwgWqUZsAGoci1YYm1O/6Bj8g8sovI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740591695; c=relaxed/simple;
	bh=f04pBWRm9ADkY42tNsgh075j0YY7Eoj1TU6tN5iFFa4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YXecUh1AcJQm4yzrUGYgh42UdA7rFksrv14kseCKWAQgwWu51n9Fxuioex52BlFDmAWnIocWc+D+FTX8yXPOuhZDefct81iWfdSoCYHNYQxpyMzZzhn3i8rzuYr7PsRvlGTQme2kAjXlqYLhJgMRx9oA9O66EEepwYKUKkoQytw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OEHnz9D7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NN9DFBtS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QEtaZg005809;
	Wed, 26 Feb 2025 17:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=yafNpcL8aIYsgRBggH7NG+AFIEeMpPwkAoX/CLjf8l0=; b=
	OEHnz9D70W3NHCdemjDbob6MoTb2zUpRlpoZn9WBGkObw9rWuPlgvBybjUxdAj1u
	tGFsDQnWg/hkeeO4g6FkxY5+LgEJQDCIz5nZR5ApcvSsnKWhrKd+V1btNkDTnsBp
	pDmLbmlzavJK8QibcwO87rfEA+4cEDvNpwQ7IsBaQ8dKX50AaLQZHnP3x08C6VyP
	l625NZRRKqJsvrN8ugk0KpXVbF76BSJBehLBvdvcqyM12W+me8bUTX9J+o6bH0Si
	aenclQz+Ak1GrAgpuY8Scg4T20E2cvGS2GHGYNclkXerC5Jzpx0vtnvqp8LkhK0Z
	ZqnEX411jyvvcgRNIPYOsg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 451psf1nvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 17:41:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51QGAIgK002830;
	Wed, 26 Feb 2025 17:41:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44y51b7tvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Feb 2025 17:41:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c59ZmlSM9NpNip/rIjG8W3n2ny8YOZIn6krlsSOKoISxOX6AitEeMsIM8IVGggedC8rA2MpvXUueJ55BIRQG1KhVJpMtm2VtRYCbrYr3Am1B1TDxcjUdKdL+8j01tKNnJ6/e7hBhMDqo2obIgraxcDiPFC99HU5lSNAjfCXr8DNIBvzGitjLozwN+LxBMzqj6tfMgJoeEyLxtoBs1/lfVrxX9I7vTlegkP61I4W92JJysheOYlSW73aegNjucNBYVydn+ZJXP04yCNlkHiO9oxAn/ogLZLM73+8xy9FOi2ORYkMWZa/+bZRjmWXqdofePX7sByHg+9c8b43UN8H1MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yafNpcL8aIYsgRBggH7NG+AFIEeMpPwkAoX/CLjf8l0=;
 b=DCKYBGE40jYyqo1jFARf+v6japBgKyUNb6zUwI5tOT1AHCIIo/lpxYkugx1vJyL0RCqWKnIfkF9Xocbc3vsdmtSyMPGEdpWDTqens1VBt90T485cRyzz8mJK5vXAmC2BUW3iP4Nn3mAGMTQZZ/vN8/xFkSyOYExuon4wc51qoCuAgMM0jzjdS8BoVOfaT6rvkdF5dwwSha6cZcFH35gfZPsjECXkx4mnzLVFZWSRdkaPDRHzpv4KQotThW+ykGIf5NhlRxO/VFFfIbpNFvc1nbm19RG5/QfqdBQO0oNoKjm68qsZEYVeuXJIDrcsSo6wf55k+D6MVN+3X/C7egIDQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yafNpcL8aIYsgRBggH7NG+AFIEeMpPwkAoX/CLjf8l0=;
 b=NN9DFBtSZ4ITf7rYqKtHt3UT2uS6pD0AcjjCnKxC+pmwuLEXz/uAzOgFt83FN36i/vaVxbxvrzq6IUdLVGXln3QdsTHYwn8f8J+lVT6hAuP8veE3C9YkuSZZ2gPiGHnOJ0J+p6zK64Jf0aPhf9rCYmaFgOAQ5Le34U315FO2bb8=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by PH0PR10MB5756.namprd10.prod.outlook.com (2603:10b6:510:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.17; Wed, 26 Feb
 2025 17:40:59 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%5]) with mapi id 15.20.8489.018; Wed, 26 Feb 2025
 17:40:59 +0000
Message-ID: <91fae2dc-4f52-4f38-9135-66935a421322@oracle.com>
Date: Wed, 26 Feb 2025 09:40:53 -0800
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
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <mb61ph64h9f8m.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:303:8d::23) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|PH0PR10MB5756:EE_
X-MS-Office365-Filtering-Correlation-Id: fca89fdd-df4a-4e32-08f4-08dd568cbb02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVhCSjZSdzBXdExOTVZxdTdiWXFrU1pUOVl6UVltM3F2L1VLTU55YUg0M0xu?=
 =?utf-8?B?cXNsZkZURnltYlppRlZzZkZqdFNLdFBhNVBPRDgzQ1NKQmhBVjhNd2ViaC84?=
 =?utf-8?B?di90dnlxYy9jMG12eUdWc1RINlUyMmVBbHpkREFTTGxPR2ZoMHppZkpvaElu?=
 =?utf-8?B?VUQyTVZjMkJiWkJuNWRWcVVCMlVIRFlNd1diYTBJSmo2cUU1Rld0b1ZoOXJO?=
 =?utf-8?B?UTMyZUFlU25hYlFIR1Zhck54Y24vbStyNDVEcGZTSGxETmI0MXB0ajZPcDZQ?=
 =?utf-8?B?RTgyaVVpanZ2b05yOHE4VllnS0kreis1V0pEck4zV1ZGS0hQTGtXa2FVM2J6?=
 =?utf-8?B?Y3FjS1N1dmlOVnFmdkVPM3RTQ1ZUb3hLTVFkaEtDM2hyTUR2ZWtrUVUwbFFh?=
 =?utf-8?B?UHdaTkx4K0VsYmlObFZzZVA3YTcxMmtGdlZwaVEwUXI0Vi9QcmFzUTk4aFhx?=
 =?utf-8?B?YjNsVUxJY0tZOWJ2eWhzS3ZzSE5pNjN6WGZFcnBCV3RVMHA5Q0NwemNrMTJa?=
 =?utf-8?B?aUNNNTUwWGVSeW9ZWHJlcmhSdTM0bUpSRVpOL29wdmRwdm5OUDd1cGY5YTdX?=
 =?utf-8?B?K2d1UXFQd2MzWFA2UEJvR1pva3llaWdhSUNvSmRpVnROamUxQjREdjU5ckYx?=
 =?utf-8?B?Z2NiZFZQMXEvZS9tOStjZVlNUTI5Y0NLQUZBNElIRWh0SXFpdEFJWkhmb0E5?=
 =?utf-8?B?RGpubW50WWhVVU8wNFdYam1YdmlWN1lYNUhJYjBKYTIxZ3lsSnNPYnBOUXYw?=
 =?utf-8?B?RlBNVzNma05idWU1OGlidDliaFhXYUM1NDZ2R3c1ZnpLV0JVMFAwalRldFVP?=
 =?utf-8?B?L1JGNFRvNm1mNkpVd0ZRcnE0WTdtNjdoRGh4VnZYTWRiMnFQVWsrTDdsZW1E?=
 =?utf-8?B?ejFSdXdQSGR0T1ZsalpMU09sTlhuakZDcGpUYlJWd0dtVGl1bkNQOFpvRS8z?=
 =?utf-8?B?ZUxuQ3JZSWdzY2hrZmVjQWlXZUp1dnd1bkJaZCtlR0RuRDRzNGtpeGM4UTdm?=
 =?utf-8?B?VWhqN0RITEpKU1hBK2NKVnlibzV6TVZyWnpjTVFHaWtaWEdkaThDcE1JSWVp?=
 =?utf-8?B?YXcvSWUyaytoUEdlSlBVZG1hdmFIdzBuU0JHN09SRWJxcUR3NWxVbjZ3aVZL?=
 =?utf-8?B?dzJPWUZHMlFhV0g1OWo2VXNMbDcwcTMvbFNRUkJsK21lTjEzbGNmdGFZSVo4?=
 =?utf-8?B?TjJtWjk2SWE1b1I2UkVGM2J1Vlc5UlV2eUFndVMrcUprRlBKODM0bEVHeWgr?=
 =?utf-8?B?d1pPUTQrdmx0NitVbFpkeE0xMXh3SVREODhyQXVhUHc3TnFJUDd5OS9FbWR0?=
 =?utf-8?B?ZzBncEdmSmFWVkplcnovQ0k0ajV0aVlLSHVOTXUzSlRXaFl4SXlCOUZ1WEJ5?=
 =?utf-8?B?bXpqWXRpQ2ZvUERtRkRoL0w2UmsvV2NoNFVHSE15VklFbmY3UnBFbTR5ZGFL?=
 =?utf-8?B?NkVPWUhHWjVBVkFXNnpIb09aSllIWkdXWk9ld2VFMDlzUzJWWHhtSmV4eEhC?=
 =?utf-8?B?aXJsQ3hIcVM3T2Z6WUlVTHVxNmhQazcxNnA3K2FYeEdjT3FSMnJoM3NxVUh6?=
 =?utf-8?B?ZEdxNnhOQTF0TFNHNk41T0NCMjlaYXZPTElvV2xldjRkYzdGUTBVb2dMaWdr?=
 =?utf-8?B?dmFLVURIZkNNcFdzZW85bzVYMDlMa2JYbGpFSjBUbzYrSDdwaVgrSEtKUFNH?=
 =?utf-8?B?Zk5MdFBabG5OYU9BR2hQYzVDMGJpRVFQSldnYUt3bHc1VXFhS0xoNlVaM25U?=
 =?utf-8?B?dkdGMWttVHJnYTNudE03cmowaXhBQWhPTDdtOUwzVTRxK0hNbmxUTjVFdGFY?=
 =?utf-8?B?YTdRNHA1K2lTVzVsYno5dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHFYWFZSWGM0K2tqZEhGZGMxY080eTFQeWFNbHpGYkxoWm5ieExBRU9SS1dF?=
 =?utf-8?B?a1d6c0lVT1d3NHhFNVZZajY0ZDFheXFCUWxFYWVMOUpGUy91enovM1h2VVpM?=
 =?utf-8?B?UUZ0VWRHR3UxaFczT01WNi9UdVNFdTBML2Vtb2RVamtFVDBrRjNlWWpGaG05?=
 =?utf-8?B?cUhrWS9VUGlNSWo5aGc4NEZRSmIyM3p6MjlRTzY0NXd1ZDUzMmw4WkJmamtP?=
 =?utf-8?B?SXVOOXJTc0RzTzFPMm9OR3c1ZkJrMGdMYTdWUE1NOGlleWN0QkNBRjdsam5R?=
 =?utf-8?B?QUlVOTJ1b3RraU54Nm0xaDdNWnFKSEhDYy9nME9VTklOUDZJQTkwOG1nVWRi?=
 =?utf-8?B?MC8yeHJUbldYV01abk04VnNqVDRlQTRpajlrbUlUc2FsVEVoR3ZqYUtEL0pj?=
 =?utf-8?B?eUZwT01SQzFNWGc5aXJvY3R6b2NCaGsybTlxRm1JZEhyT05OS1VkTkNDSVQy?=
 =?utf-8?B?VzhmeFZramtVUEJnNE9yV3dUWVVHaVZ0ZWdtMllTZnJNSUdrTHQxTjlqaVVr?=
 =?utf-8?B?c2NEeXNkRHMvbmxoQktSM1VRc01TUGtsRUFiaFZIcHpCQWNaTjJhL29uOGx0?=
 =?utf-8?B?OHNIdUxBeWRiWnZ6VjQxZGR1MGM2ZCtlVXN0VGs2ZElVUTlRN284SzQvSGIx?=
 =?utf-8?B?bWRrNHE1Y0VueUl6Q295RlVqbXNaVkFBM2hSZEtJTGIvcUVJeVJEZ1RCS1hW?=
 =?utf-8?B?bHpZWjhQMUphaUt0ZWk3bFNVam8vcXhCZ3EramtZS2xXVFArZElMOGl3VHpG?=
 =?utf-8?B?MHZIbjFBTEh2YU55L0tmdTlKN0RiK1RXVkF6bmNJbHRUMVl4Q01za2VtVlVz?=
 =?utf-8?B?WktYSUJjOFJESmRNd1pKK3JYbnoyOUM5dEljTzJCK1ZNOHd3NWpqc1dYWkxy?=
 =?utf-8?B?SDFMZHhneXZkN1lFZFpVMitMYUpCUkI2elkyM0RpVmc1Z05rUEE0YkJtZ0Jr?=
 =?utf-8?B?aDNPcDdTQmQrcUZXM1loQnRsYmZIamtvOFlPYXJYNzhLUzlpODkwZXdjaUlh?=
 =?utf-8?B?YnQrRlhLR2lVbi9pM0lNQm9aU1NuQkJJVktTZDd4WjFaZERiY1hkLy9nMGpD?=
 =?utf-8?B?ZE1CY1RqTTZKVk5ndU90d0ZJaU9keVVOcVQ0S2lrTWw2TTYzVVFsSkFENXlW?=
 =?utf-8?B?TVhqUE85Ly9kR0RkL3BGZEdmbFZJKzliTFNCYjFnL3dVUUdGUWRVaG5PeXJl?=
 =?utf-8?B?L1A1Yk1PRlFkUzVsakQ1d05pV0c2eXZ0Z2l0UjB1cHBKNXZESVF6NWt5aW9S?=
 =?utf-8?B?VHp3RGkzK0tYTlNBc1RtZjBqSGQ5VjkwVXl0SDBnV0ZtdWwycW85UnU1Wk5U?=
 =?utf-8?B?SGxuQ1hBYjV5VEdIMUFpRURGdXRCVU0rS1gvakgzNkpBTklaTWF6K2hmdmcz?=
 =?utf-8?B?cHV6UGx3R3plOVRZVU1MWm85MEQ2RzlpVjN5SDNFbkMrSURmd1N2TzJsMVRp?=
 =?utf-8?B?L25hbU10Z3RrR1Y4YjJicEJJM1NzYTlsYTFaZjh2NGtPYnhEK2t2SE9HQnVa?=
 =?utf-8?B?ZGg5UnNCdklKVCtIQVUvUm4yNDhQN3FzTW5QdVFhd2pCNlNnWEh6bEkzcWFa?=
 =?utf-8?B?aFNjQWpBT3VaRHpWbk1kNC9SeXZhdFBmU09nNjdDam1CcGRtSFFPb2NiVENI?=
 =?utf-8?B?VG1zVkJCTEFISnR6NnJNeEFITUcxa2tmTXNlUDhET3NkTGFaRHE3WnI4QVJ2?=
 =?utf-8?B?OTd1eGl6NzRiZkpSZVc0NFp0L2drRDBydTZwWUk1bmFZdkl5QWE0LzlRbmhw?=
 =?utf-8?B?U1dJbEJkYzVpM2lRcjBRd3NyMmdXMnd2MWFIM205TkZra3M2WVRJTFVFaHVM?=
 =?utf-8?B?a3QrT1ZEZjRzYzFPUkJjZVExR2MxOHRkdFJXcms2elBKeVJLS3JPNXJmaGtX?=
 =?utf-8?B?WEZXc2Z1Tm90aXF5WU9UeVg3MUN0aVlzaG1VblB3QnBDRW03Wk5LczFObGNa?=
 =?utf-8?B?MFJPdjdJbW8zd3V3UUVreE92ZkJqSFN3eHk0YXJtTGF6MGZYdWMzQ1pNZDlI?=
 =?utf-8?B?OXFVSlVZTnQwTjV4RVhkMVhPSzQ4TXkwWnZPbmllanpWc1pxbTlKU3FwTmZl?=
 =?utf-8?B?UGZ5Y3c3N2h1RWVSWGNHNHRJYncvRUNzbWpRODN1S2lXOTQyT2c4UGJUdFNj?=
 =?utf-8?B?WVFkNzNyVmRTMSt2UlRSSnZFOHNjWExmeGRnZ1h1dGlwekZubm5KenNubVlK?=
 =?utf-8?Q?zVJswXpBIK1Of+K9mpT1oQ8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8/UmvsE4cpC+cGPOtv/ZwUtl9TqL/fJKH3WXnLiSSU3fVHdP40yA/9rflB3iwXu+K2uZDOaEaifbVDp8/NgOdovz8zXOvEzNMcqAlt8IctyEQWgnSbOjZLERGVhvDy6vS005khRGSa39Q57irYl2Xrz3Wrl3agV2hUcCl2KaUKxgDY3SGQ58Kf+AZfCCqTIWP+I2iJRfzinWOs3ai/r4zTrPrsGXcuYjyRl1V+QyD7yrGTiQDmuMAjHkDvUbOgTBNYhx0zhJOye7JXKMcTbetkNXrZU/hBUXeOwJdsltpdpBckuJxItVgHq4wDS03PGL5Do/BARpZ82ANZyQxhMokYodNQbFJFa68KNkFEEBcUKg8y/hLXpuNV0+cjLi2pY3YEzKQgUCi0i7COz+O/3gg4EBoFpL7j0OpqeeyUMZuXEm4bEeVLKjNBa3zrhZNkKWgs62T4xqm6JgqCAKXuorffrOYivYkDwVRCZ68budARUMECDJeQrJALOq4mGJpRQAaQq1hQGy6fcVHahfTb1hn6mKC5/Tx/2gKrKYJEpdVfhER2gRr/WfdoSUHLh4NdZ4z5xydDX6mqZq532mtnTmb5OzJofBzaNzi6pYOqdw1d0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca89fdd-df4a-4e32-08f4-08dd568cbb02
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 17:40:59.1375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DIy2SZ+KhSQnzzqTcIAdHGBXLQNkEks985a71rlOgKgzx82/cVi2R4f6BFIQ9jDH560LuFLj94dURDE9j4g0zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502260139
X-Proofpoint-ORIG-GUID: dM7HWmK4J0uiuQvPqKT6jih2r-0qlXlD
X-Proofpoint-GUID: dM7HWmK4J0uiuQvPqKT6jih2r-0qlXlD

On 2/26/25 2:23 AM, Puranjay Mohan wrote:
> Indu Bhagat <indu.bhagat@oracle.com> writes:
> 
>> On 2/25/25 3:54 PM, Weinan Liu wrote:
>>> On Tue, Feb 25, 2025 at 11:38 AM Indu Bhagat <indu.bhagat@oracle.com> wrote:
>>>>
>>>> On Mon, Feb 10, 2025 at 12:30 AM Weinan Liu <wnliu@google.com> wrote:
>>>>>> I already have a WIP patch to add sframe support to the kernel module.
>>>>>> However, it is not yet working. I had trouble unwinding frames for the
>>>>>> kernel module using the current algorithm.
>>>>>>
>>>>>> Indu has likely identified the issue and will be addressing it from the
>>>>>> toolchain side.
>>>>>>
>>>>>> https://sourceware.org/bugzilla/show_bug.cgi?id=32666
>>>>>
>>>>> I have a working in progress patch that adds sframe support for kernel
>>>>> module.
>>>>> https://github.com/heuza/linux/tree/sframe_unwinder.rfc
>>>>>
>>>>> According to the sframe table values I got during runtime testing, looks
>>>>> like the offsets are not correct .
>>>>>
>>>>
>>>> I hope to sanitize the fix for 32666 and post upstream soon (I had to
>>>> address other related issues).  Unless fixed, relocating .sframe
>>>> sections using the .rela.sframe is expected to generate incorrect output.
>>>>
>>>>> When unwind symbols init_module(0xffff80007b155048) from the kernel
>>>>> module(livepatch-sample.ko), the start_address of the FDE entries in the
>>>>> sframe table of the kernel modules appear incorrect.
>>>>
>>>> init_module will apply the relocations on the .sframe section, isnt it ?
>>>>
>>>>> For instance, the first FDE's start_addr is reported as -20564. Adding
>>>>> this offset to the module's sframe section address (0xffff80007b15a040)
>>>>> yields 0xffff80007b154fec, which is not within the livepatch-sample.ko
>>>>> memory region(It should be larger than 0xffff80007b155000).
>>>>>
>>>>
>>>> Hmm..something seems off here.  Having tested a potential fix for 32666
>>>> locally, I do not expect the first FDE to show this symptom.
>>>>
>>>
> 
> Hi,
> 
> Sorry for not responding in the past few days.  I was on PTO and was
> trying to improve my snowboarding technique, I am back now!!
> 
> I think what we are seeing is expected behaviour:
> 
>   | For instance, the first FDE's start_addr is reported as -20564. Adding
>   | this offset to the module's sframe section address (0xffff80007b15a040)
>   | yields 0xffff80007b154fec, which is not within the livepatch-sample.ko
>   | memory region(It should be larger than 0xffff80007b155000).
> 
> 
> Let me explain using a __dummy__ example.
> 
> Assume Memory layout before relocation:
> 
>   | Address | Element                                 | Relocation
>   |  ....   | ....                                    |
>   |   60    | init_module (start address)             |
>   |   72    | init_module (end address)               |
>   |  ....   | .....                                   |
>   |   100   | Sframe section header start address     |
>   |   128   | First FDE's start address               | RELOC_OP_PREL -> Put init_module address (60) - current address (128)
> 
> So, after relocation First FDE's start address has value 60 - 128 = -68
> 

For SFrame FDE function start address is :

"Signed 32-bit integral field denoting the virtual memory address of the 
described function, for which the SFrame FDE applies.  The value encoded 
in the ‘sfde_func_start_address’ field is the offset in bytes of the 
function’s start address, from the SFrame section."

So, in your case, after applying the relocations, you will get:
S + A - P = 60 - 128 = -68

This is the distance of the function start address (60) from the current 
location in SFrame section (128)

But what we intend to store is the distance of the function start 
address from the start of the SFrame section.  So we need to do an 
additional step for SFrame FDE:  Value += r_offset

-68 + 28 = -40
Where 28 is the r_offset in the RELA.

So we really expect a -40 in the relocated SFrame section instead of -68 
above.  IOW, the RELAs of SFrame section will need an additional step 
after relocation.

> Now, while doing unwinding we Try to add this value to the sframe
> section header's start address which is in this example 100,
> 
> so 100 + (-68) = 32
> 
> So, 32 is not within [60, 72], i.e. within init_module.
> 
> You can see that it is possible for this value to be less than the start
> address of the module's memory region when this function's address is
> very close to the start of the memory region.
> 
> The crux is that the offset in the FDE's start address is calculated
> based on the address of the FDE's start_address and not based on the
> address of the sframe section.
> 
> 
> Thanks,
> Puranjay


