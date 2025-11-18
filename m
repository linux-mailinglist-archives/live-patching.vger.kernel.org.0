Return-Path: <live-patching+bounces-1869-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A528EC6B363
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 19:30:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id 1F97828F7A
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 18:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A281F463E;
	Tue, 18 Nov 2025 18:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NPpTQjHX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b7HFFXme"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA9F36C0C6;
	Tue, 18 Nov 2025 18:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763490645; cv=fail; b=DjhtDrYR5S8fJmCHGm83EUvl8sB/oQ8/Ti0xtAKbIAvOIF4NTrTEhY/savwKGaCO4ZciQtD+jbWuqOFwQzEzTSxe+a+FlxvnbappM7MTb9WG7fWVT/oSJ8gHWoUkZPU5LLE4K+zOAVMDQ0rwnfJCP/yZAvDsu26j/tVGKSOjQoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763490645; c=relaxed/simple;
	bh=46giOc1Ux55+Gd55EyIDSEBEvkEM0SbRhFYHsxuTVZs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ukA/rgkcBu+xpXDD10BLNt7qYHXTjVtFR3QWkoj34EfwYRGECI0LLdfQJ3awzW3VcqzefG8RDHqsZckikzNbVvt+44mnQgXbvEYtdEePizpvDRoRc1Qfg+H+jEQlyavZrnj+0AR1KQBKE+vCBmJ4yQnAF/HrtlAwMJnFY5ZnhCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NPpTQjHX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b7HFFXme; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIHNIYW031943;
	Tue, 18 Nov 2025 18:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dAEFhlzXw2FPnuwllTQITXCCh3sgPZtyIQ4LRJ4NFWk=; b=
	NPpTQjHXS8UQj9R7+cUCAgLa4n6qx/KQK+kqoic+NUcovjL+dEOKqvl1ioyQU52j
	oHVFv/wWwC15c9hTLZkVBt7LEXsY7tLrGBbSAvlu43FVYQnq+QZscJidWwoNAdIH
	wkOV166rWHuKYu5uqpA2iVTVcD9bniEBdhPUx8jEvBVa0E3jyCRhz9o5Gbs95gcN
	bMADIjJe/o8Rc93ggdj4OgaUxjECjAXfW7X6N9g3V/PJMgVHhlluHY7zmnxHhTpo
	DbOMUwi20C2nq/uiKP4DtMSVcXFPiUzvHIvtgpx/jQ3JuhKTA107AZkAuZvvK3BG
	T/4cRvBQJhe6ALBATGeOAA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej8j5ft9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 18:30:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AIHLKKW039894;
	Tue, 18 Nov 2025 18:30:05 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012010.outbound.protection.outlook.com [52.101.48.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyku1gt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 18:30:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+pTOKp85+Qv+V37PmTq9g1mvBbe1lSsbYH5VGbN22hlTHaBx8YDUj7ageouiPTdeOBF/EUq6ltFR80RPWbfCzyl/0GAyTKiVa9XxZeo+14or6bORx16ZHSKpq1NgUeq2SQCNGrpE6QgncZ02mMklLH9niA7nPEQnaxLLZIM9RIKBGE650gzrN8LtmvXBVtUlrM/x7uzqJ1NNZdrRFHrs/lUpUwlkGGnyRmXYFnANj0eUlvm4zPSsxVUbGINverKO5EBUsZ1FB8ZG5pTLiBLeJOjmlVDiQ72RHXGBZHlKq6AO/LFK+ApaC9zoQ5rkJtf9Pqw0dxdoPKa5lSaEo+Brw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAEFhlzXw2FPnuwllTQITXCCh3sgPZtyIQ4LRJ4NFWk=;
 b=DmU8i8ELyqNaAc9hDC3AaFEVRbrgkDBs0sf5GyDbNv+Qn9WlI4Q8RcPjX4aeVsNmZux98Btx4QC0e1V4qW1rYlpOUsID2vp9lPOleX/IFsC+s7AsmVBhK790+9xjj1RZasPsOyEekkbevVKGC8bomWMDHlYpG/pZHbwWlv4e4my3wA5eZbePOB7po3zSEiW716I6++l3m+aCv9DOtNB+urJlSBl8OYsbqQZk+6VmH3h0QVWfAX5ui92zp2ccfEXiWxTAoAm+1TiwUw8PKUzdCi3U/WEtaefZYAtTiHgspqZu3iWEH5+pST1bwqVz7pNWC873KC9wcrxWe0C/XPJUuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAEFhlzXw2FPnuwllTQITXCCh3sgPZtyIQ4LRJ4NFWk=;
 b=b7HFFXmeGera7W1GucWJJOkyaKaewMrvczCRV+5Y7sl5/lPeqrqekdeMHb9urHKhgzZDgy1u9Ue/CAE0d8U/LuJakb20FBiHnpyraN8DF7cH3sNR7Wc6KDoh/8QBGNVDGc3e0zMtoal7POXSRIUVQml+gI0ZHgjMY5ZpsVFSQMU=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by SJ5PPF9A77B6E1F.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7bc) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Tue, 18 Nov
 2025 18:29:54 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%5]) with mapi id 15.20.9320.018; Tue, 18 Nov 2025
 18:29:50 +0000
Message-ID: <f24ae67c-b4f1-4c31-992b-d414cb793f7d@oracle.com>
Date: Tue, 18 Nov 2025 10:29:46 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
To: Puranjay Mohan <puranjay12@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Dylan Hatch
 <dylanbhatch@google.com>, Song Liu <song@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        joe.lawrence@redhat.com, Puranjay Mohan <puranjay@kernel.org>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
 <CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
 <CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com>
 <nzmtsafrx5vjitgfpducjaa7kq747a3sler2vvyvfbxecutn3v@7ffl2ycnaoo2>
 <20251117184223.3c03fe92@gandalf.local.home>
 <cxxj6lzs226ost6js5vslm52bxblknjwd6llmu24h3bk742zjh@7iwwi5bafysq>
 <CANk7y0hKH6vvWf3Lyc678uvF9YWStMzO-Sj8yb3sbS4=4dxC6Q@mail.gmail.com>
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <CANk7y0hKH6vvWf3Lyc678uvF9YWStMzO-Sj8yb3sbS4=4dxC6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW3PR06CA0014.namprd06.prod.outlook.com
 (2603:10b6:303:2a::19) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|SJ5PPF9A77B6E1F:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d587705-6f08-4847-98dc-08de26d075ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S05Yb2lHd1RsbTBlK0doMXltZ1NiS29QYmFCRkhBbjc3NG1landSbHBqUnl1?=
 =?utf-8?B?MGVDVWJ4NmZ1a3N2d2xnUlJ4a201UEdMWmZHcHJ3bmh4QnRmSit6cXZwdFlE?=
 =?utf-8?B?eDVSL2xpeUhzYlQwZVZ6SGdvNTRWVTBQQXBwNVkxRlJtOUJMS01LNnRMM09P?=
 =?utf-8?B?em1vMHJNMEcrMGJjRVVpVGN6KzVLN0hDTDdXNkxEaytxMDRsTmdEZWxBWk5n?=
 =?utf-8?B?QmZmYXZZekMzVFE2MGRaTEpYblh2VjhQdVgzOWgrMlh0bzJTTFpJZW51T29D?=
 =?utf-8?B?bWd4K3JwN29ZTlNrWEhWQTdPOE9kdTUxbkdEOEZjZXhaNDZzdEM3MkVLd2xv?=
 =?utf-8?B?VklsUnZXWWVXemJvSmFFZWhmK2x2eWtqRGd2Qm5SOCtpZWpoRS9RMVBQRUk1?=
 =?utf-8?B?V0RRZXhjWUphMUY0Z2xoZ3VwWnZIeHB3cW1WZCtLZmVwalNjUkY0U0JUcGhM?=
 =?utf-8?B?NlZxNXhwcWU0ZEJ4UERGV0ZqM3dmYkc5ZUZUNHJKcG1kZ09rankwVm5Haml4?=
 =?utf-8?B?WXF3L2Q5RUdGa3YwbzE5OEtGZVpHMTFoaEFqSVNldTFrUVpWOUQrWnZzSExk?=
 =?utf-8?B?SXZmdGJ0NVdnbCtjREV0Umx0VzZpbG1qbHZRWE5VZHgrd0JYcE1oRUl1bC9l?=
 =?utf-8?B?cU02ZUd3SXI0Z21pTlRuVlJ0OFVXT2FjZjJWOVc3YUFSeFgrT3ZwU21OeENY?=
 =?utf-8?B?bGNKUDQxcVRGL2xnUzRWQTVjWWMrQTNwbTZvSG1vNXVBNVAwNWJHNDhYRmpa?=
 =?utf-8?B?UlZyTTNzeXRMRm9ZSTdSQ2pLS1Yxd08rZ25pRDdrT09FbHZ4dGxvSGFDVzZj?=
 =?utf-8?B?dWtXYmhldDhGRTVXSG9JeU9xU1JvNXNDRVplMHh0S1BzZjN6a0E3SU9VY3Jx?=
 =?utf-8?B?d2Q1aVBZRHBPWWp4bEpKR0J2NUVQanRsL0c4b3ZGY1BVYzdCVldqMGNVdGVr?=
 =?utf-8?B?ZkxKOTA2cjlLVVBrUktzRjB0YjBJOWxEU2FoNlB5Z0lLMzc3RTZxdEhsSlpj?=
 =?utf-8?B?QldPRmd6WG9Xb3FlaHVuZyt0RDJSeHo3alRkbjdCWGZoN2dxMFRkbm5CcU9u?=
 =?utf-8?B?Z0ZQMWV3eDNwam5pMmZ6cE40ZFlDaENIUUZqRzdWMFdrQ0dZZWlYWXQ2N0pm?=
 =?utf-8?B?cWJoYUVEUE8xRUc0L0lGNlFleWtNOENGV2p3dEJOMVBiZVlLQzl3Q1cxRHRv?=
 =?utf-8?B?a3hzSktnSE4vUHhLaU1NTjRWL0piZU5POHlPbmpuUFE0d1lLY01iRnBxQXhO?=
 =?utf-8?B?YlllWHJ3UElQNnZMWlkzZEtjSHdyS1lOWXhxTFZNV3NlVVBtMWdXSnRCVXlO?=
 =?utf-8?B?VEZuWE93UkpxTkUzTHNLMURDbTR1TnpjU3ZyNnFkU2R1K0ZGcGEzd3E3SE5S?=
 =?utf-8?B?dUdVNVZPZE5zZFVmalZ6MGVncHBzRDkrblNRY1VUOFRwQ015VzFuZEtidlZJ?=
 =?utf-8?B?OCtBazl5bHlxQlpPWjBVM1pZSk05TDZPVldIbnpPcURBVWoxR3drMGd6WUNU?=
 =?utf-8?B?QStJRS8rUG5nQS9IR3dYUkdqOGpSREw3eVBxVVhyWnhxeHVNTjB5cjMrWUR0?=
 =?utf-8?B?QmRMcE85amh5bUV2UXBBQVlVWWtpbXpqcUdvaXlWTE9wZjgzdEJvSzJoaXpu?=
 =?utf-8?B?SDdTMjZmQjQ2NGQ4aDJnSE5yKzIvTDlmY2t4dWhLVzBFUUs1THNmVWtaWnhY?=
 =?utf-8?B?VFNnVjJpM2tLNmsvNksxSTFLSzlyMGRpa1VJbjcrZGpRYkd0MGo5aGt2b3Qx?=
 =?utf-8?B?VmIxV2tKUmM1MjFjMW40cWxrVGpUTGlDRFFyK1FMTVNSdkI5Q01sM25tUjR1?=
 =?utf-8?B?S2FuZndtYVZIY3BwZFFlNkNuSTI5NkM2KzNtaDdDVVIxYmpMcksvSnlkUXlj?=
 =?utf-8?B?M2RSSE9ZbjlqYWFUU1pYbUUwTS83eW1rNmNsWXpGVGNYaktWWTVQOEc4WTZk?=
 =?utf-8?Q?WdzEamR5WUOrIv+vAVIWmTinRi9w8m+f?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXphajhUMmhVKzRSWEtXWkhhM0N4RFB3QVpJdE5jNFc5THA3RklBb2YyZ25O?=
 =?utf-8?B?NFd6YWhOWUlKRlA3TWgrUm5RZE5SMk9pRlFUREk0WUp6YnZyQzdzTnJ0U2Yw?=
 =?utf-8?B?dm5zU1ZFeEJrNktXQ1p4eVVQWnNLcDMzdk45ekk5cDIxZXN0Y0Rqb1JHWUM0?=
 =?utf-8?B?NGg3akt6VG9JaUdwTlJLa2UxLzNhVWZCVnpTcGxmL3lBZTZoV3JKcGxBVC96?=
 =?utf-8?B?OTJOU0RxZ05IUGd0VUJKc3dUM1RiMkxGS2M4bG1tYnA1c0N6Y2MwZUsrQjZT?=
 =?utf-8?B?c0ZQY0NrTzV5UjBaWElzU01nQVJGUVlvaHJQS3ltQ0ZXaEZoblR4dk5Va0dv?=
 =?utf-8?B?ZjE4VWNZd3R0U3dRc3Fmb1ovUFJWdmlKaGtDQ3JKQnJCM1NzSmtFdHJPbi8w?=
 =?utf-8?B?c1VGV1BNTjAzNUk4bmZHN0Z2UFBJUCtlSWZTWVB1RjJOWHJHaEwrU2JBY2Nw?=
 =?utf-8?B?RkkyK1FYQnFxbEJWc0JvdlNqdmwyVjB2eXVUSkIwekZNNnNWZlZMSEFKQTJZ?=
 =?utf-8?B?RFRiR1B3L2pNRDBhRVBxWnpmQUcvV0NFdGwrYUtpMCtDT1VJL2hhNFZQYWdi?=
 =?utf-8?B?WXBNa1EwUlBEeXVjd1ZIMXRmcmxPdERhVGpVTTdaNnc4QkR5aUpBUjgybzlV?=
 =?utf-8?B?TjJITFNoL29ySDZXd3NoaGVFd1pXSVQwam9IcnVBd0RpUUFaeGdpZ3J1VWRF?=
 =?utf-8?B?RitQVXJmTjdxayt6Z3F6R0xyRkZ4Y29VaWhDMWR1QTdGUTZRVzZrMHQ4ajZ0?=
 =?utf-8?B?bmQxZjNZZDJNV1IzVUJYSFlCZ3RqTm05dWJFc3BYTk9kMFcrai93eXFBS2tn?=
 =?utf-8?B?VFhsV0UvYnM2YU1laUEzdWd4VjBWTENjaDFpVmRQUXI2YTNjaG9EamFWdWUr?=
 =?utf-8?B?bUhnNjdHQUhOT1JDTFVPcWgycHE4NGN3Q2FFRitJckxiM09XWjQ0NmZqV3cz?=
 =?utf-8?B?UnlmR0lqK2hHUXd0QmVNa2VaQ2hzL2M1RG5JcFRlNzU1ZWRNSG1KNzJhMFV4?=
 =?utf-8?B?L1Brem1GVFNzNHdUOUxwM09FaURCZGpET2FlME1zM1hTZ3FwbjBzUkJQbTVM?=
 =?utf-8?B?amw5RG4walZhMXpuVmxLN2g4enVpQjk4OWEyZ2dsd3F6MjJFc3dkcjN3bXBW?=
 =?utf-8?B?aklOYXZPY2U5c1N5b3VJKzc3ZlY3UUxMYkI5K0wyM1BBTWVvcWhmOThyYjBZ?=
 =?utf-8?B?N1VHQmt3NHZsMUQrdFhqdFdvd1R0WVlsckpkdjdCRTZpZmJIN0JkQ1RYa2tO?=
 =?utf-8?B?VUd6ZEZBZmJnZTdCMk44ckdJUUxsZVJaei9RSHRVMUk5UmVnQlRqTnhJNEQx?=
 =?utf-8?B?WFh2Wm1HMHMySFFleFdYSHVjbW5BekxFUmhCRnJuTlZBc3NvZUJzT1k5bEJH?=
 =?utf-8?B?S1RhK1M0V3M1TW8vQ2ptVWpYTHdleFBXamIxM3JJS1pPenFSMTlTOUExbk5Y?=
 =?utf-8?B?enVmRHk2cERWR2ZQbXA3ZENmK3Fkay9EWVdWWFFXQ3RtM1Q0K2o5NmVSc3hM?=
 =?utf-8?B?eXZMbUpaaFVDZWFRT05aT2hmdzVYRFVtUmZ3eHF3Y3ZxdlJoRDNOSncrMzZH?=
 =?utf-8?B?bm1BSzV0V2MvaklxR2JQRkZ0eWJ4ckdVdUZzbnNIUHNPbXA0OXUxR2MzaUcv?=
 =?utf-8?B?TXdyWUJTa2tLQVpBYWoyQk40Zkk2UWh2RktZTEExMzk5QWpXZHZqa2ZVWEEy?=
 =?utf-8?B?R3czcmNKN2toQThHbGFhLytMVVdFSXRRTlplNis1R2IwUSs4aGFzdUt2bkwx?=
 =?utf-8?B?VUk3MjkwYlFNdG96dExrOTlrT3FGUWtwM3lwTnVTbkhFTkNTNnVRN2J3OTdt?=
 =?utf-8?B?VVc5U0ZqSFVjS0dUWHFPVmhVbWpiQUtmQWdaam02Wk1mUHdvdDczOTJLblI4?=
 =?utf-8?B?bmdxY24vd0Z5c1RKa3lKVnhUK0Jwb1EyR2VZOUV4d25kSnlpY3BwRHVjNFZW?=
 =?utf-8?B?bXNmRVRJWTdiWDJUeU5NcVlwT29qcnlzb3l4ZVJlUSt2NUdDNkdiWHV6VVR4?=
 =?utf-8?B?ZTMxSFNtUlE0RDVOMlRtN2ZuK3NzbEErdUZkVW9nUXc5SDVMK0p3THhUS1o0?=
 =?utf-8?B?U3pCeWcwa1Y2ejdNWXpFQzNrWTg4QTg2QVlrNU5mMGtlQWx4bVNPSjBxNHF3?=
 =?utf-8?B?dUtvd3VYN3lkem55TWRPRGFhYXlBbDlFeEd2azhSeXgxeXdSR1E2ZzNaZnJW?=
 =?utf-8?Q?yF4Y72wSXzC3p73xKhU2/eE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zxwGVa8wAWeey2vOqAgpJU5sESl7aqXbHCGPCGyTZuE/zlknRsnwlphOX5BfFE6kXyRS1c3kGZ1n6ssWCYDbKASa2h0FtOKpRLN4G1c0+dDJBIZQ6iStWOSp/bZfnDycPsGBkbOXPTCBs2IaNB9CBfmNsibM33Sv/lbGwwzEeSCyyUDlrwncTW6NW/j+m4uHmsC3kckqh+R7flFORO1z1Zro30gdiC3IVoZc6i543fQJp2EMzO/1IdLjw4ZOTrj7xc4D8vVrO4mBZo8yVspx7Qte+ZMdu3QQbdXMLwn20dxxeGo2uRBUvroT0CNKuVhxAFBM1DGkqwxi6wCUHZG4XbXxpA2VBf/rsOyJJD3gmqgu2iqhzzZWWItfOOLCRicHxzISlm42sIlyKg5X9zvD8mKGPm+9Rh19zS5xd2WATMUXFclx6+cSAkj+LVTVG735ngjl5gxb71/CwIojBnC4LK0PwMpJIt8XNGFDcHbQYrUD1lE4l5r8ufJVrP1Uflnmjis2+NYMuL2yvwhpoSQ3MGtBIR0WqlI6aDpCbrKqkV6RpGfPTZIf94CTJB8WZwDca+qFppLWVLiQc8DIV+Q/ypSBJdVs/GfZsXPEzGb6pVY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d587705-6f08-4847-98dc-08de26d075ab
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 18:29:50.4213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bj6Ad3K6dQE7AdxWMxfkMZKMpKzCdiYULjujTNWZTyuUuih9ApYpufd/MeN8ZSjN6+m0hzEh7LJLEyQRzsqSuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF9A77B6E1F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_02,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=799 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511180148
X-Proofpoint-ORIG-GUID: ByIpBNk-j9t7E5XTnFstbJYuJD0ZeFm0
X-Proofpoint-GUID: ByIpBNk-j9t7E5XTnFstbJYuJD0ZeFm0
X-Authority-Analysis: v=2.4 cv=I7xohdgg c=1 sm=1 tr=0 ts=691cbb2d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=OPC_c1hGrdcbYSRWtHAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX7GHAbEzpGmRQ
 /K/8Oe35f8X0VvEGRNxrfqp0S3joI2qD/2LCLXYH2/U2+O1NQsTrAa7z2EIkmTMYo56qShDYmPV
 n0WTaSk3f/OkxkVbXsNgYBbBWHNgb1hFTUmoSn5WS+6S6P7I+wg45siMx31UqENDWgAQz39Hu24
 zaKflBzz8yV1U5yXKn74R/5U62H19TvSoOen8yJZVMQ/q67DSVNm4At5egdS1Lz3hueojq8Xwis
 LMMTSnzb8XyM/yCdPZJF+1v6qsQig7iW0ItVv9LfcE5R1z3kQVBueaGEFDeXwENPW1Qgo48o1BJ
 NmTNtqoHPo/05Ve5Y/jb9s33cWqeh8o/PliSTTh4U7Z2yhK23LNosmCMuI5gzYX4N5MaqEOYr//
 jZ0AvUIvX+I6FkYog3PIJK3B9GxlEAkfUesH6F2+BmIKhExiKH8=

On 11/17/25 4:49 PM, Puranjay Mohan wrote:
> On Tue, Nov 18, 2025 at 1:10 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>>
>> On Mon, Nov 17, 2025 at 06:42:23PM -0500, Steven Rostedt wrote:
>>> On Mon, 17 Nov 2025 15:06:32 -0800
>>> Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>>>
>>>> The ORC unwinder marks the unwind "unreliable" if it has to fall back to
>>>> frame pointers.
>>>>
>>>> But that's not a problem for livepatch because it only[*] unwinds
>>>> blocked/sleeping tasks, which shouldn't have BPF on their stack anyway.
>>>>
>>>> [*] with one exception: the task calling into livepatch
>>>
>>> It may be a problem with preempted tasks right? I believe with PREEMPT_LAZY
>>> (and definitely with PREEMPT_RT) BPF programs can be preempted.
>>
>> In that case, then yes, that stack would be marked unreliable and
>> livepatch would have to go try and patch the task later.
>>
>> If it were an isolated case, that would be fine, but if BPF were
>> consistently on the same task's stack, it could stall the completion of
>> the livepatch indefinitely.
>>
>> I haven't (yet?) heard of BPF-induced livepatch stalls happening in
>> reality, but maybe it's only a matter of time :-/
>>
>> To fix that, I suppose we would need some kind of dynamic ORC
>> registration interface.  Similar to what has been discussed with
>> sframe+JIT.
> 
> I work with the BPF JITs and would be interested in exploring this further,
> can you point me to this discussion if it happened on the list.
> 

We discussed SFrame/JIT topic earlier this year in our monthly SFrame 
meetings.  I can point you to the meeting notes in a separate email.  We 
had some discussion around:

   - SFrame specification: Allow efficient addition, removal and update 
of data in SFrame sections.  A part of the challenge is in representing 
the variety of frames a JIT may use.
   - SFrame APIs with JIT: Efficient SFrame stack trace data 
manipulation by JIT.
   - Interface with Linux kernel: Efficient SFrame stack trace data 
registration and update stack trace data.

It will be great to have more collaboration and brainstorming, and to 
include BPF/JIT in the discussions.

>>
>> If BPF were to always use frame pointers then there would be only a very
>> limited set of ORC entries (either "frame pointer" or "undefined") for a
>> given BPF function and it shouldn't be too complicated.
>>
>> --
>> Josh


