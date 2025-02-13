Return-Path: <live-patching+bounces-1160-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F95DA333D7
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 01:10:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02CE4188A199
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 00:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F351372;
	Thu, 13 Feb 2025 00:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CHXMfVTQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rbkc+1+m"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD53CEC4;
	Thu, 13 Feb 2025 00:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739405435; cv=fail; b=O6fG9SW5LKLHxFWPRbWptUk1j61qX2f90gzGdIkbBNDCREgNsGnBZ0TQ1xzmdgA+Exot3HS+9pEAXataRdqzNBXf11rEiA0TGebw2TFJYFq+5JLCq1F7F2PV4N7i8HGzL+KXItMW8m3E4R/pwlF9b+TXmMAibbY3AlEJWbS3Wsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739405435; c=relaxed/simple;
	bh=A84y52V7hMWikffj+Q2lnR2d8iktJRvt9knkw7223eI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KLU2nI1YZCqvkM9gvYVueZoBohcRMR3yPX4x6n8XGmizFPxmeNosL35vYY6BUHXtw8yKBaOv7sgr7Jzl+l276nl9nbCKF5YVUZzEQs8nK9DJuCa49KUxLCAI5lVINciu7SVC6ipE83UnSUxHYgaOa/l11q3u9aq6t6ync3jsQTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CHXMfVTQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rbkc+1+m; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51CLq7tX026988;
	Thu, 13 Feb 2025 00:09:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=7HsMhSRw67BhX+fU5qlrUX8dyaEUTadd0Rkw3Vf4Um4=; b=
	CHXMfVTQzhfhM8z2ZzJtY4KkO/BeiJre5jEBZmYfABvwpwnEEhBBGTl1sY5/VvEA
	/5c16tXLMyKFEDKpGfPn1SnwUjP3Cghm1R+HeRntbQCx55PDXftsrE3XiJv8tpzO
	I3LndDWKhOF+67ttDopcqDCGQrPalaZHooEXkOGD9aoJondXC/BfnclDKlJXqvPR
	wHHmWy9sRwAqwwE8q1nRnLkmQJr2HTGkqiWpALxKCiMaKvXGU49j+NFZThdzLnZg
	zGjIR+wdMVB1LDGQhpiT1I6jjp1ntGHdUdd/Ibg4jzYiHFWIzND0DhWqUB0EIf/R
	f2NbiuNZkA2EI48bAGGDlg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sq8qs1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 00:09:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51CMSXXd002656;
	Thu, 13 Feb 2025 00:09:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqb24q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 00:09:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RC1CusUFHpkHSTw9VhGxsCygv6F2vyqNtW7jGkus3X6CTsfbdv5avPYgHAc4Cc1WpzH+I5ftZw+FBMhA3jyNBfJPdpxeCeNHr4iJvaGmAZTNAjnM+wrTReHbNE+9k7m+VVqhNLhXznUn0C7+5cC0hOA1B2ZjFJI7Vc0vX8A6jjBblj6zwbY4PuFXMkNzKUEXPYwtMjHwkz5jYAqdAoFpMIE5SZaDtU2yGJE/A8wm8ae0XRCXbNVbAtuK4oetVzMWBAdUcwrRKhG7fqpokuny8QJymRtfvmni7WK3/alrC8/hDKqhngdZQ7My0GLOIBQ6sROtFrSG3WfQ2pHzL0eKSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7HsMhSRw67BhX+fU5qlrUX8dyaEUTadd0Rkw3Vf4Um4=;
 b=loaENHulVkgPEN/w3lzKgVc4VlHwbJwoBwLXhRnjC37tuhFebEwF4NA2Plrmpg6DIPU0r6zRqhsMSEHpUaeDhQeCrXVunWcXW3/p2ke7IfNRw5m5UFWh5YiGxWiCRSu636vsvVttyH1x7EwvgJfc19MRIjUsMx33AV72cdaMO5hsAds6VsEE1IqaTdP2/0yGVGwAECGzHZ1+Bg0himFKWOIaklBwQSxQExREWr5/gtpElpJuXa7aApvWeI09izaOe1MdKEukk61Je+CF2qixG6XD2LNl/UHDRxjtTrSoDgrD4aUqF0fQ/VW7SHr022LOftlKvj54/IVORgdrMnNTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HsMhSRw67BhX+fU5qlrUX8dyaEUTadd0Rkw3Vf4Um4=;
 b=rbkc+1+mqqx3hOdN6yItXDMQdJjL4NMPkFPALc3QN6QCJZq6+T6NEyddYlatmPAwW03DeEEWXChoj5Y0Yw/V9VcAAA5bGnlzv/qDcovrPCNy8PiU/FdItcsYahNhFrIMXPglYOX71NpAKwCfU5qSzcgBom0fTb8CBUxj517m8kE=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by BLAPR10MB5092.namprd10.prod.outlook.com (2603:10b6:208:326::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Thu, 13 Feb
 2025 00:09:38 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%4]) with mapi id 15.20.8422.015; Thu, 13 Feb 2025
 00:09:38 +0000
Message-ID: <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com>
Date: Wed, 12 Feb 2025 16:09:34 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Song Liu <song@kernel.org>, Weinan Liu <wnliu@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
        Steven Rostedt
 <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
        Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
        linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, joe.lawrence@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        Puranjay Mohan <puranjay@kernel.org>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P223CA0003.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::8) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|BLAPR10MB5092:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a452b5b-646b-437d-c2c1-08dd4bc2b4b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0t5QURreGhaanBqWmdER2Y1cGU1NU1Sd0RYblJQNXZUTFlGbnpmMHFPcnd1?=
 =?utf-8?B?ME5tMnMrSEYwU1lxVHBLQWVMcGdVTHNQS01kQVVXR2pYZklLQ2FiZUw3VTNy?=
 =?utf-8?B?Vkc5OTlZUCtQRXM2MVZ6ZGswOXZ1SGJFbWZUSmFRZU9WNEx1ZlAraE16UVVU?=
 =?utf-8?B?V0JrZVlhUldRNmtrdnJmNzN3d0N4aEhkNTFRcUtmQ050UDc5MmNjcXBreFRx?=
 =?utf-8?B?S3ZUUkZ5RERxK0V2eHNJV1VHelBtaHYvdC9LTkJkTjMzZ2UvTFpJWjExanRX?=
 =?utf-8?B?SllNU0JHQ0wvV2VtLzEzVWp2Z3ZUVTJLVFhqSk1DQVFXTlhaQWdML2hFNXFL?=
 =?utf-8?B?ejVYNnBLTmNNU0MwZTltNndncERwaGY4TXJWalU4aHhQWlhTaC8vYzU5TGk4?=
 =?utf-8?B?L3FqalM4MnBMSHc4SUs3OWJsMzV3TDdnN1RJcEo5ZC9SQkYzRHhvWjg3NmxR?=
 =?utf-8?B?QVAyOEdJeFZqVi8vaG1zVjNGU1NIeUs0am96UEIzaXFBVmJHV1A2dVVXZ3Ru?=
 =?utf-8?B?K1MxQ3crMDhQV3hzcDdxaEpEeXVIUGVwRGx3a0FhWUNoN2FUcjNQdVlOUytI?=
 =?utf-8?B?d3dqOVozaFRpTGNocGMwdUNyMlJtcU1id3dTRkd6QW5GUE1Lc202dy9nSlpn?=
 =?utf-8?B?RzNTY1RKTlpXdWFwMGJ0dXFVNEVBdHAwUi9pZngvWXREWVJzOXN4c282aUI4?=
 =?utf-8?B?eUF3eWYvNGYrR2lYVGdMT1R0WjRoaG5Cc09TUTIyN2xUSStKSTFHMmU4QS9E?=
 =?utf-8?B?Sm1tUDJ4aDYxRCtjdDI4cGxVazh6T3M2QW14RzM4Q0tEZkY0NXV3VW5pWEha?=
 =?utf-8?B?SHNRaDIyRnVwaFlrSXRURG9MN3p0THRsMkFZMXBpaHR1RDVKa1JmYURVcUp5?=
 =?utf-8?B?RU1VYlRsaEo4L2JHMEJTMTlVNFBvak9pbFgrbXN3dXhHdEZ5UkJZd3YvNG01?=
 =?utf-8?B?UDR3Q2dUMzdUVVFUb2QvWDZ5Q0VwaWdTazhhYld1ZmdRdEJxb2dSSWovL2pU?=
 =?utf-8?B?cElJR0VGSmYyQjAvajBPQ3E5ZjJsMjh5Vk5Ua2dsYzQ2YkQvK1hndmx2NS9U?=
 =?utf-8?B?QnlIT1d6MVU4SnB2dGtiU256WlFPWDhIenRZUDg2ZG16bzNDb20xTEE4ZnhJ?=
 =?utf-8?B?RmhQSHRYMVlIVVpKTGNPNnowbUxtaHJtUjVXcTZEdmhMSThuVXduOWRCeDVH?=
 =?utf-8?B?QjdMaDVhZ0xvdGN3Y1E0NVJmSWdBSDA3T05QTFdGWE9EMHVSTFU4NUJQdW1u?=
 =?utf-8?B?bjN1Z2dRTUc5d1ZGc1pIVWNZYTduaDRKWjdOS0FlUFRxaWViSyt2ZWdoeWo3?=
 =?utf-8?B?ZWlVVm9aaytIUVJNU1cxWlAxcmFxZWlSTUU2ekl6enVRNU5oaXlDNExaRC9o?=
 =?utf-8?B?dGRBQndPNWdmbkx1MHB2cDhlekFsdTcyZzJ4UDNOeFdobDZ5a1NDVEVaNmdx?=
 =?utf-8?B?OGNxdkxsbTlKWVQ3OWVBSE1XYW9LbmVQWms2YjJ6THhXT0hWS2VWY1NuN3lU?=
 =?utf-8?B?Uzh4N2t2STlEc2VDYkFlaXNub1I4dU50S1BUUCsyeTN1NytYc2NUeG5IT09S?=
 =?utf-8?B?TFZoeHlEcC90NTFpVWxNZXdpcWM2dWFlTW56T0lQZ29UNFF2VVhzV21uMzAw?=
 =?utf-8?B?UUt1cTZ5SjZIbG9Oa3VZWjcrdkhZSVpkMEYzOGZOWGMyazFQcWRKanp1LzF3?=
 =?utf-8?B?YlZHUXdGV0Z5ZkRiRWw2YW1WUU9GUlVvRUF6Y2R3aExOMkpWcnF1ZkNBak5H?=
 =?utf-8?B?Nk9SSTZxNjk0WnR6cjZ6TFQrTW1SdGFTUXA3UXNUTmVFeHl6eFJodGhjKzFO?=
 =?utf-8?B?N1h1V2VVS0toODRSUWJZZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3RWbjFyaW4xa3FpbjEvYnpYVUN6TGNDaEdCbXVGTGd0cWRWMUkrTSsyVC9i?=
 =?utf-8?B?anV2K2g1U2Evc0U5ejJIZE5kZXovemw2TWdyaml4UzhSNW5hbDBLeDVqUVg0?=
 =?utf-8?B?em9JZUExNWF6K2Naa1hCOG5nRU5mMHlVbUZ2UDhvUW85TG83eWlqSWxqbTd0?=
 =?utf-8?B?QzZLbDFRc1h1MUNVZEpyODhhTUZiZjFsL2prd3FkcEdrZHpsZnlKQUYyMkJs?=
 =?utf-8?B?UjlteWpFTkk4Y0MwMWZLWVBxbUpLTVYrLytLRXhTQkZ1OWpLWitIUENkNHF2?=
 =?utf-8?B?Vkdnc09aRjE2Smp0QkZhendFNDNGNGVYOUhRdDZJV1ptdExwYlRtRlo5U3VW?=
 =?utf-8?B?WHc0QytlNUVyVTlHdFlzYkdsVkoxS1RndHhHUGVXNW95bytKWlRMMmhISGZv?=
 =?utf-8?B?Tlp0ZmRNc1BNdVlzUC9ZR0xKRVpSRnQwbzhCbER1K0dLRGZHcGRpYzhLU211?=
 =?utf-8?B?Snd5TkNiL1QxVkZkcXdNQ1hqUlNVcVlucXBRcjZBdHZjeHBlNjFlMVN1Ky9y?=
 =?utf-8?B?dGpuZFZJbHdwQXd2QVhZSm1vS2NyL0pqVlBGNDgvd01XZjlsZmtnRDFJT2xB?=
 =?utf-8?B?dGtNQXRjYjVhVGxqVlR1WWkrVUkvQWlncDZCbGNxVTZVL3BKTlF6SFJmZjU2?=
 =?utf-8?B?dXJvSTNYMmJ1UTJDR1FFSU1IOSt1ckdsTWRsaVB4NlQwSDVaMkFtaTFlMS92?=
 =?utf-8?B?NnljNHFtNGFKY05JSzY5Zk8vcmIzTWxBM2dyTXA4RGplMGxsNFhsd2txVkdI?=
 =?utf-8?B?UEM0RndxeThnSkZ3RC9QcHZLU25jaTdyeUk0ZEU5OEJkcEJtOWZMREtJRFBz?=
 =?utf-8?B?aW5jR0RBOFd2bnM1UmhqV2ZoUU53TDQyVlVhN0xNLzhtc2FvT1ZXL041N3FF?=
 =?utf-8?B?UGJ3b3FZYnZPZ095RXN1eWNyd1pKelVvR2RXWnQ1UnVnQ3BKOENFN3JTRzdh?=
 =?utf-8?B?dTZxTHlEVS9xWTYrZmp6WXhaSVlSRHpacjRVbVVEcDlEZU9FMlBlZUM3amth?=
 =?utf-8?B?aEV0STVMYzljOTBrTHdENWorSTdSZEwzK2l3eE0rdVVtNUozTy9vUHZtSlpu?=
 =?utf-8?B?NHBscFhicTE3L3JISTh5VmVYaEhyc253NHJLTFNzNGxEUzA1NU44QzQ5U3J1?=
 =?utf-8?B?SVFNM2U5SnRpeXhOVDRMU25WL2VzYWVoMTNHa3ZqTEFxWVNobGpDUXBPQlJI?=
 =?utf-8?B?MWJmUEcwSUIyb0V6cDJrT2NTL2JIK0FqeWhJOW9SOHN3bEV1RVFCeUJ2eVNV?=
 =?utf-8?B?WkNlRTJLRG5PQjM2eVRNa3J3SXVVSUhWRFNiUzJIZjBlUTBldlpzQ2NxZGxP?=
 =?utf-8?B?UzJUNWg3YlYvNzYyNVJQVGUySk92K29BSXZpejgvVUpnTzdSS3V4YzV4c0kv?=
 =?utf-8?B?TENIc3FGbFNBRUhNamMzZFVEenk5WS9WTmVkbXprbURuZWUrL3pLOFo0NjVP?=
 =?utf-8?B?SlM4b0dsT0NOaEdtcEtJUmw5anVBSDZ5UWM1VENrM05KYlZSZlZpQnJxWDds?=
 =?utf-8?B?REVWZUJsOTAwbStFSVdyZjZXL2Q2MGdtTDlGWTgwRUhEN242ZS9UYTdpaXZY?=
 =?utf-8?B?WXNleTJWR3ZDS1ROK3l2a09CekczbVA0U092Skkyb2JqLy9WZ2hveFFZckJQ?=
 =?utf-8?B?SHkrRDZ2M2ZnNU1ReEpGMlZnb3EyZDhsMFdNelBxU1E1MXp5ZTNkOWhZb2M1?=
 =?utf-8?B?aWZoZ1ZQZ0hKczFqN3JQVjYyUHZhQXdOL2ljRndiZk45bWtVa1lFVkdGVWlo?=
 =?utf-8?B?a254ZGliYmlabDhjMkd5amZsbE5jK2YxTUhWMkFGRjBUbU5sRkNNcjZGQytY?=
 =?utf-8?B?empoWlIzdTZzUngzL1ZmbDl2V1NOSUl6QUZXc2pHUmZFUnM4T1hZTk1zR0Fz?=
 =?utf-8?B?STloUTlLbVJKd1g3QlAvb0FLUXowTFU5aUo3S3BkT2pBSUZ0WWhnc281N0dJ?=
 =?utf-8?B?eXRQbDA5d3NveVlCYnh6Qjd3SFNGVHhUTjVrY1pSa0Z3aXlEcXc1dkROU0hG?=
 =?utf-8?B?VjljeW9Wd3RBa1gwN0JQS2k5MFE1OW90aGl4V0V6K05VUVF4UHNVRDk2ZkZK?=
 =?utf-8?B?Q2FCRk1aV3VtMFVwTjR1eDdhcmRETGpEeHFGZlMzMURVZDFWRFN6akc5Z0pK?=
 =?utf-8?B?MktNUmpiNmd2bWJmVXFLeDRldEZRbVpnWG1MdGJmZVVLU1NMeGc2b28yWXN2?=
 =?utf-8?Q?PYqPbBUM5Zn5xIr/W0jqdMI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DTCSD/FLCSyikepfCAD2cNUCQ+rdUnxl+ltsdC3oa8j1kpsVKB59IzxjWM37GJl6B+nRmQHwSsaAXUIP4XuMynRKBYAWxzv+gGYd2nRgwC7q0Ml9w3s80eIDMr3ENrXv2p5sSqm0vNi+vRscK87/JRWky3ZPDqiLSrA9Dw1DBjB6CBM2/KPn8926pAvV8VVrM/qpQUCAlbyUtS7V50XWRgsTqFheyD7D6gMqAFPW5EZfMA/j8qkEUB+yB49GkfXyx2Fu7QuNzq+OaIKT+vCrP20qNMOc6Whw9W/jUqP+eTp+VCDVwZXMvMvIQ4SP61hNH5Hi4iq4rFuA/ygvmoBt/s39gUnsl0dTbeh9apSE0psOLkYQSLbpayf7Mh0DIDHc/uUjpp4mVEIROraXb9myeCrX08jqZbf17PjNlYSDr8/Y/fzO6XRVLv4R0NH0QQwfVmeuNhrkD5CLnpsXc1Km0na6Yn7oFiL5m4WzvxA2I//NbR/X+JHFQFX5725gmnUKqdz6mhghE7DO5oKZEywVSx89Vw4sVEHQv9QRKLNn6XNRUNnwzq3L+VDRwCyZaI6fP2P8MqtZ2Pg0XYpYFRWpNtsIpLYFssIVRq7lfzBXpiE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a452b5b-646b-437d-c2c1-08dd4bc2b4b6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 00:09:38.5809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AR5bRDZGUL3AaSuGnMCKEE2LGP280LVGC19mSoPytEZsFZYmHODIf0OMpxFrhDI1hsrQnKLv4BOQuNEq2yzZZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_07,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502120170
X-Proofpoint-ORIG-GUID: 6uJJ_28S-dGftdh4g0Uwp8OJPWK7zzsH
X-Proofpoint-GUID: 6uJJ_28S-dGftdh4g0Uwp8OJPWK7zzsH

On 2/12/25 3:32 PM, Song Liu wrote:
> I run some tests with this set and my RFC set [1]. Most of
> the test is done with kpatch-build. I tested both Puranjay's
> version [3] and my version [4].
> 
> For gcc 14.2.1, I have seen the following issue with this
> test [2]. This happens with both upstream and 6.13.2.
> The livepatch loaded fine, but the system spilled out the
> following warning quickly.
> 

In presence of the issue 
https://sourceware.org/bugzilla/show_bug.cgi?id=32666, I'd expect bad 
data in SFrame section.  Which may be causing this symptom?

To be clear, the issue affects loaded kernel modules.  I cannot tell for 
certain - is there module loading involved in your test ?

> On the other hand, the same test works with LLVM and
> my RFC set (LLVM doesn't support SFRAME, and thus
> doesn't work with this set yet).
> 
> Thanks,
> Song
> 
> 
> [   81.250437] ------------[ cut here ]------------
> [   81.250818] refcount_t: saturated; leaking memory.
> [   81.251201] WARNING: CPU: 0 PID: 95 at lib/refcount.c:22
> refcount_warn_saturate+0x6c/0x140
> [   81.251841] Modules linked in: livepatch_special_static(OEK)
> [   81.252277] CPU: 0 UID: 0 PID: 95 Comm: bash Tainted: G
> OE K    6.13.2-00321-g52d2813b4b07 #49
> [   81.253003] Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [K]=LIVEPATCH
> [   81.253503] Hardware name: linux,dummy-virt (DT)
> [   81.253856] pstate: 634000c5 (nZCv daIF +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
> [   81.254383] pc : refcount_warn_saturate+0x6c/0x140
> [   81.254748] lr : refcount_warn_saturate+0x6c/0x140
> [   81.255114] sp : ffff800085a6fc00
> [   81.255371] x29: ffff800085a6fc00 x28: 0000000001200000 x27: ffff0000c2966180
> [   81.255918] x26: 0000000000000000 x25: ffff8000829c0000 x24: ffff0000c2e9b608
> [   81.256462] x23: ffff800083351000 x22: ffff0000c2e9af80 x21: ffff0000c062e140
> [   81.257006] x20: ffff0000c1c10c00 x19: ffff800085a6fd80 x18: ffffffffffffffff
> [   81.257544] x17: 0000000000000001 x16: ffffffffffffffff x15: 0000000000000006
> [   81.258083] x14: 0000000000000000 x13: 2e79726f6d656d20 x12: 676e696b61656c20
> [   81.258625] x11: ffff8000829f7d70 x10: 0000000000000147 x9 : ffff8000801546b4
> [   81.259165] x8 : 00000000fffeffff x7 : 00000000ffff0000 x6 : ffff800082f77d70
> [   81.259709] x5 : 80000000ffff0000 x4 : 0000000000000000 x3 : 0000000000000001
> [   81.260257] x2 : ffff8000829f7a88 x1 : ffff8000829f7a88 x0 : 0000000000000026
> [   81.260824] Call trace:
> [   81.261015]  refcount_warn_saturate+0x6c/0x140 (P)
> [   81.261387]  __refcount_add.constprop.0+0x60/0x70
> [   81.261748]  copy_process+0xfdc/0xfd58 [livepatch_special_static]
> [   81.262217]  kernel_clone+0x80/0x3e0
> [   81.262499]  __do_sys_clone+0x5c/0x88
> [   81.262786]  __arm64_sys_clone+0x24/0x38
> [   81.263085]  invoke_syscall+0x4c/0x108
> [   81.263378]  el0_svc_common.constprop.0+0x44/0xe8
> [   81.263734]  do_el0_svc+0x20/0x30
> [   81.263993]  el0_svc+0x34/0xf8
> [   81.264231]  el0t_64_sync_handler+0x104/0x130
> [   81.264561]  el0t_64_sync+0x184/0x188
> [   81.264846] ---[ end trace 0000000000000000 ]---
> [   82.335559] ------------[ cut here ]------------
> [   82.335931] refcount_t: underflow; use-after-free.
> [   82.336307] WARNING: CPU: 1 PID: 0 at lib/refcount.c:28
> refcount_warn_saturate+0xec/0x140
> [   82.336949] Modules linked in: livepatch_special_static(OEK)
> [   82.337389] CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Tainted: G
> W  OE K    6.13.2-00321-g52d2813b4b07 #49
> [   82.338148] Tainted: [W]=WARN, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE,
> [K]=LIVEPATCH
> [   82.338721] Hardware name: linux,dummy-virt (DT)
> [   82.339083] pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
> [   82.339617] pc : refcount_warn_saturate+0xec/0x140
> [   82.340007] lr : refcount_warn_saturate+0xec/0x140
> [   82.340378] sp : ffff80008370fe40
> [   82.340637] x29: ffff80008370fe40 x28: 0000000000000000 x27: 0000000000000000
> [   82.341188] x26: 000000000000000a x25: ffff0000fdaf7ab8 x24: 0000000000000014
> [   82.341737] x23: ffff8000829c8d30 x22: ffff80008370ff28 x21: ffff0000fe020000
> [   82.342286] x20: ffff0000c062e140 x19: ffff0000c2e9af80 x18: ffffffffffffffff
> [   82.342839] x17: ffff80007b7a0000 x16: ffff800083700000 x15: 0000000000000006
> [   82.343389] x14: 0000000000000000 x13: 2e656572662d7265 x12: 7466612d65737520
> [   82.343944] x11: ffff8000829f7d70 x10: 000000000000016a x9 : ffff8000801546b4
> [   82.344499] x8 : 00000000fffeffff x7 : 00000000ffff0000 x6 : ffff800082f77d70
> [   82.345051] x5 : 80000000ffff0000 x4 : 0000000000000000 x3 : 0000000000000001
> [   82.345604] x2 : ffff8000829f7a88 x1 : ffff8000829f7a88 x0 : 0000000000000026
> [   82.346163] Call trace:
> [   82.346359]  refcount_warn_saturate+0xec/0x140 (P)
> [   82.346736]  __put_task_struct+0x130/0x170
> [   82.347063]  delayed_put_task_struct+0xbc/0xe8
> [   82.347411]  rcu_core+0x20c/0x5f8
> [   82.347680]  rcu_core_si+0x14/0x28
> [   82.347952]  handle_softirqs+0x124/0x308
> [   82.348260]  __do_softirq+0x18/0x20
> [   82.348536]  ____do_softirq+0x14/0x28
> [   82.348828]  call_on_irq_stack+0x24/0x30
> [   82.349137]  do_softirq_own_stack+0x20/0x38
> [   82.349465]  __irq_exit_rcu+0xcc/0x108
> [   82.349764]  irq_exit_rcu+0x14/0x28
> [   82.350038]  el1_interrupt+0x34/0x50
> [   82.350321]  el1h_64_irq_handler+0x14/0x20
> [   82.350642]  el1h_64_irq+0x6c/0x70
> [   82.350911]  default_idle_call+0x30/0xd0 (P)
> [   82.351248]  do_idle+0x1d0/0x200
> [   82.351506]  cpu_startup_entry+0x38/0x48
> [   82.351818]  secondary_start_kernel+0x124/0x150
> [   82.352176]  __secondary_switched+0xac/0xb0
> [   82.352505] ---[ end trace 0000000000000000 ]---
> 
> 
> 
> [1] SFRAME-less livepatch RFC
> https://lore.kernel.org/live-patching/20250129232936.1795412-1-song@kernel.org/
> [2] special-static test from kpatch
> https://github.com/dynup/kpatch/blob/master/test/integration/linux-6.2.0/special-static.patch
> [3] Puranjay's kpatch with arm64 support
> https://github.com/puranjaymohan/kpatch/tree/arm64
> [4] My version of kpatch with arm64 and LTO support
> https://github.com/liu-song-6/kpatch/tree/fb-6.13-v2
> 
> On Mon, Jan 27, 2025 at 1:33 PM Weinan Liu <wnliu@google.com> wrote:
>>
>> This patchset implements a generic kernel sframe-based [1] unwinder.
>> The main goal is to support reliable stacktraces on arm64.
>>
>> On x86 orc unwinder provides reliable stacktraces. But arm64 misses the
>> required support from objtool: it cannot generate orc unwind tables for
>> arm64.
>>
>> Currently, there's already a sframe unwinder proposed for userspace: [2].
>> Since the sframe unwind table algorithm is similar, these two proposal
>> could integrate common functionality in the future.
>>
>> There are some incomplete features or challenges:
>>    - The unwinder doesn't yet work with kernel modules. The `start_addr` of
>>      FRE from kernel modules doesn't appear correct, preventing us from
>>      unwinding functions from kernel modules.
>>    - Currently, only GCC supports sframe.
>>
>> Ref:
>> [1]: https://sourceware.org/binutils/docs/sframe-spec.html
>> [2]: https://lore.kernel.org/lkml/cover.1730150953.git.jpoimboe@kernel.org/
>>
>> Madhavan T. Venkataraman (1):
>>    arm64: Define TIF_PATCH_PENDING for livepatch
>>
>> Weinan Liu (7):
>>    unwind: build kernel with sframe info
>>    arm64: entry: add unwind info for various kernel entries
>>    unwind: add sframe v2 header
>>    unwind: Implement generic sframe unwinder library
>>    unwind: arm64: Add sframe unwinder on arm64
>>    unwind: arm64: add reliable stacktrace support for arm64
>>    arm64: Enable livepatch for ARM64
>>
>>   Makefile                                   |   6 +
>>   arch/Kconfig                               |   8 +
>>   arch/arm64/Kconfig                         |   3 +
>>   arch/arm64/Kconfig.debug                   |  10 +
>>   arch/arm64/include/asm/stacktrace/common.h |   6 +
>>   arch/arm64/include/asm/thread_info.h       |   4 +-
>>   arch/arm64/kernel/entry-common.c           |   4 +
>>   arch/arm64/kernel/entry.S                  |  10 +
>>   arch/arm64/kernel/setup.c                  |   2 +
>>   arch/arm64/kernel/stacktrace.c             | 102 ++++++++++
>>   include/asm-generic/vmlinux.lds.h          |  12 ++
>>   include/linux/sframe_lookup.h              |  43 +++++
>>   kernel/Makefile                            |   1 +
>>   kernel/sframe.h                            | 215 +++++++++++++++++++++
>>   kernel/sframe_lookup.c                     | 196 +++++++++++++++++++
>>   15 files changed, 621 insertions(+), 1 deletion(-)
>>   create mode 100644 include/linux/sframe_lookup.h
>>   create mode 100644 kernel/sframe.h
>>   create mode 100644 kernel/sframe_lookup.c
>>
>> --
>> 2.48.1.262.g85cc9f2d1e-goog
>>
>>


