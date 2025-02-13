Return-Path: <live-patching+bounces-1187-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1234EA35219
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 00:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A662416AEC0
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 23:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E4522D794;
	Thu, 13 Feb 2025 23:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VsxG/Z+Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l4kCBYC6"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13DA2753F5;
	Thu, 13 Feb 2025 23:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739489024; cv=fail; b=BDJZX7/arW6vvnTy81Q1tUgjFpdmbc9fPyXgQuucza8QIBf7/vFkp3MD/tY79M5PkQ30RlhmKqTpyLf+SZUH+wnJv/CLnEi/3IXWNgJ+XyWbCNPQoPT4knSdR//MG89MwX0FnzIdDuKyV0EuoviY+OyJDlByI/b0Y8Xu9zFI30k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739489024; c=relaxed/simple;
	bh=OKmEXcjHSnW+sXqLFthrdbDubbMb9EZ30yS4LsNK928=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kT7PxpKlTX0PDcEzECB9zVz+6FTLghWKiaNdHIjuptB5xCE1Bw0MhaiOhVeum7NBLL8NUyuY0bAKEZwHruOUcmRzT8xfME1efzkJdFbWT0jfyCUpwNirZry6bKD3SzNJ1F7OFZ2cW045cUJd6mzxuqKgqnL3VZgkK8QIUQV6i8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VsxG/Z+Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l4kCBYC6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51DLswWC023650;
	Thu, 13 Feb 2025 23:23:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=3qJ/2y1iFjoLI+oa4Y3c13g7ynhE81SdUjoXJEv/9OE=; b=
	VsxG/Z+Q+pgtj2cFF8p6uDR/RFx/vn+Z1go4kRthfGS9XmMpZQdH7bEmcMwf/jP7
	HNeYn1nJcbOvgGgyfcFKWAfHzAZQW2ZCEFJgb1AUyGNPQXLb5hlF2oCWzV4jN6Mb
	ifU630fWmacPBATP/pRZPxhC+VUll2Ubz1WpWBHNWSWZhv4qc81ZlsteFoZb+wxN
	iA2R989LAO/E0tVFGW7A2kH6qWyKLzFrB2r2e18DMTzpBCO8U5mb4WNKGvqd5aMS
	nR5WGcYLyVkJz68vZPsVdVu3wwQ6hMxaxYwp+veFNPNxPwLNu74I6KxFhKCxqoYm
	k8lL5mDQ6Sw3IEB13lXSjg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sqaw07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 23:23:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51DLtCd8025243;
	Thu, 13 Feb 2025 23:23:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2046.outbound.protection.outlook.com [104.47.55.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqk0gtp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 23:23:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFNEqZ7+Ho9BgYaDjHc8rylL7lYR53IxJBpRO7+0nyg71RKNdRIjpYW+c9mZQlssWibnzQ5u2oYHIOxnaTUeEkHDKZEJbSSb4mtvFoNgTdEBUL/MGXq8ZmY4zpz744z+PPwvxdbdLTxrxeL68/gO+Mz2jPG8JCVB7SIswYU2KXRDCY37kmeD3LC4XVkUEHDaXRC1u34UpogqTWzrmS/yHGXXsnMZHLpn1DdHM4Il6qk9D+It3x4NG8z3Y+lNSUFOfxPfyNvEMRwIy2D6j3GYarIB/cRLYV0R0eSnWrbleVRfKzM91a3WnbKQqiftLKP3gm39CugrT3J/t3LllMde2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3qJ/2y1iFjoLI+oa4Y3c13g7ynhE81SdUjoXJEv/9OE=;
 b=TUVaQr+db1FZ4ZdoSVZnx8hOkKmbcI4Pe6o9+kVllOjIhcOsmWWzebu6eC83gMUzt1g2Y2JbKaE73hMQCgkCTyjfBaQ0fSmD+6wHrd5TDDFOBUVxHWORE5ScrjSk33dU/3z7ZW8kGOZrXLo+JWV4AQrYxUj2CeF57q/3iPXC2CJ+08lsrXM4wLGjlCORp5w0uowZUE2OlwmQWkJ4RZOvUn+NMduwVspn2exT4I41yNfPcaG3RxL6kXzotCI5NN0cAyo2lVE3vN1qBuFiPji9xqQVxNIpVvQCS0fdnF4h7sxNvvje+6ehRru4tqPqMDN813zOseMQHYZ38gTAVZlBdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qJ/2y1iFjoLI+oa4Y3c13g7ynhE81SdUjoXJEv/9OE=;
 b=l4kCBYC6EbdqLYLJgLXuC8qoKaNGo82dgtSsZMVgAo1CFGKaF3rnbjADayKkUqdNQo9vOBkMytaDvVX6Z2QDVHj/LdmouCUFRSaW9xmqJLRfi26AJ7o1xuFp6beaMfTk2JA6SQoHOkewQ9nPpaVgtEx5tP5EnQWI6MvyST9OT/8=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by DM4PR10MB6256.namprd10.prod.outlook.com (2603:10b6:8:b5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.16; Thu, 13 Feb 2025 23:22:51 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%5]) with mapi id 15.20.8445.015; Thu, 13 Feb 2025
 23:22:51 +0000
Message-ID: <3069bb9c-6245-4754-a187-ac8253103d32@oracle.com>
Date: Thu, 13 Feb 2025 15:22:47 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Song Liu <song@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Weinan Liu <wnliu@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
        Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
        linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, joe.lawrence@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        Puranjay Mohan <puranjay@kernel.org>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
 <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe>
 <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
Content-Language: en-US
From: Indu Bhagat <indu.bhagat@oracle.com>
In-Reply-To: <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:303:8f::16) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|DM4PR10MB6256:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aafc589-3443-4c71-7f30-08dd4c8555f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NE84dUpNaGR2Yng1OUI2T0dsSnhRUzk0eDhXbGdEMmNKWW50VVZzNHRoMTRS?=
 =?utf-8?B?UGlMNWVCZzVSckNnTjhORnNGUDhDN1FrUXhSNmErai9zcWh0UlNVcUNQbEtX?=
 =?utf-8?B?b2NZMjR5VzBxTUNsR1ZIUXc5L2Nma0UvMm1TM3FKMVRiMmtscmFNVlFLcWgv?=
 =?utf-8?B?WENkVnpLNk9yQk1jTk9RRmp2ZlBFOEE3a3lkVERuMzhZZTJKRWlxNmkxVUNr?=
 =?utf-8?B?MDBDTnBiZWwrTXo5VU5wSUJTNVBSNms2dnQ0U1dHUkZ6Q25mTjhuL0FCM0FR?=
 =?utf-8?B?M3NGQTlmQkxOMkRVd2VybER3cUtkcUlmNmt4ajJhWG9kbkRTaUdkS3ZCdDM0?=
 =?utf-8?B?N2RvcUI1UlVyaDhHeWxTZjh6OEEzTGZ4dE5VVnorVjRYMDN0a20rY09BVWY1?=
 =?utf-8?B?NmlUTHRVYzNJcnRMbGJ1VWgzK095NkQ0TlJhcHJLbG1YenVYemxRQmxpTFZo?=
 =?utf-8?B?OWxDa3RmSmZvRXlwdTM1RThDS3RHS0p3aWhpSWpMYjY3K2VJYURKbEMrOXM0?=
 =?utf-8?B?OWJXRXVhNGoycDIwZEhTMHJYa0k5NzBYM3VXWXZFYno0QTU0aE1JdnRHVzlH?=
 =?utf-8?B?MTJadTBoMDV2TUp0SEQrNzA5Zmx2eDFCQlFRdlZob3NxZEdSNTZQMTNZYzFi?=
 =?utf-8?B?bVRvNkp4ZnpwRC80NVBmQnp2Zk1sNUJZV0RWNWJQeTEvZ1NXcWs5VERXckdW?=
 =?utf-8?B?SjRmUzl3R1pxcmhMYVZYT09wZUlqc29XekNwa01SN080bTdVVDYzS1d1OWdk?=
 =?utf-8?B?R3ZZREFBeUFWbXJTanZiaWxNSk1WcUlBdkw5Y2FlSWtOeWt2UjRHU0RrYlZ3?=
 =?utf-8?B?TUJiMzhJeURUMXlPTzIvV1JuU2JqcHZERWV0ZExTQzI3aFMrbnFoam9SSWJu?=
 =?utf-8?B?VmcwSmRHOVRyWGw0NldNZENMaUc1cTdLMkJqQ3VhQlVzTGNkS2huUllycFNr?=
 =?utf-8?B?SFNmUWZ0MlRWUU9vN1pEUEtMd1l4U0RzNWwwamlGcW1oWkYyZXk1ZkFOQ2xn?=
 =?utf-8?B?NURnY2lBZnJHQ0U0cEpyRXZubndRNEZITExRUnNoZGJTeEsxeTVBUndRR2dn?=
 =?utf-8?B?UUt6UDVIdWhGOWtVbmszWGpxRjJIdWpHTENzT25wNGdsNkpLT0NxdWtITWFP?=
 =?utf-8?B?aXZIeGwwaXd0eUVUdVp0YXN5N09iL2ZiQmFtUmhYVjd2c1laODZVMS9Pa0Jx?=
 =?utf-8?B?aXhJeFd6bk50cFEvMm8vSFNsdndvc2tuSS9rUG1EQi9FN3FSY3dQYlFvSmkr?=
 =?utf-8?B?R011QnRva3JkNDJZTUFqaFFGWkdtZ3RCNkx0ZkVLaWJPa0FIQnA4V250alhO?=
 =?utf-8?B?Tkx4UVQ0Ni9KY0dCOEpLY29YTUtjemdhOHY1dW5PQzVmWUQvR3Fjd2NOUDJP?=
 =?utf-8?B?cXVFUnZ0MzBvU1VSUHVzRUN1Uk1jdUV4a05mQ2RmSXBjVXQ0L2VGM2NvNGNR?=
 =?utf-8?B?MXZXVEJyV044N0ZWbXNEQ21VTEVSY24wZkZ6Q3o4UVE2OGVXd3R6SGtIQzR4?=
 =?utf-8?B?Sm9xbDkrQTFNd0NuQ204RGhNRVFCSnU5RjlQKzVMUXJjZCtPUHladTFJb1hD?=
 =?utf-8?B?WTlxaFRHdjcyZmJxdG1NM1pvZGNBSXJHclVOY0lzWFk0SDNNUXcyeDhTVkZJ?=
 =?utf-8?B?SC9EWUkwTHV5YWd2RHdXbklGemdDa09CSHdjVjZ5THRDLzNubUZzR241anlX?=
 =?utf-8?B?ZWVqay82SlVJczdiWlpadmovWTFDVkk2L05XNmJVbWJsK1lTK3YwTzNkUVJo?=
 =?utf-8?B?czViK1VXYUQyb2V5bkFzZytOR0VnYld2V2ZucnVrblkwOHAzVmdoN1o2ZTMv?=
 =?utf-8?B?ZG1Gby9Zc0ZzSDJENXdPYk1oOXlzWS9RTU4xclJwNmd4MTB4U0N6SEJDZHZF?=
 =?utf-8?Q?P9xclXUeUVhFz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEFOUVhjWTJIUnlucytTcno0aVBXZE9lclVrbnJhZys3U2IvVG04Sm0rUUxC?=
 =?utf-8?B?c0s4a2IzMUYvV2JPNExXdzZBTEJMcmt3dXRpc3JORVhjdUtPeFlZU2RHbU5O?=
 =?utf-8?B?eVF4YWNXY2NmV1MwRkxNcFVTUFNISDgveThlTXZIc1UwN0tLck1iNUkzcG5r?=
 =?utf-8?B?ZEtmMUxSak9sTGVHZEM1VXovZ3pFWU94WUlHai92QmluYjQ5cWovVUc0N2F5?=
 =?utf-8?B?K0tjdHhoQkhSL0dFdUZDZVVId3gwQ2V0K092QWlBTGZOQllPbkRDVHZpTjUx?=
 =?utf-8?B?YmR6V1FVWGV2OHg4UTZKeUd3VUFLY2ZLbkxXdnV0djFwRytrWlIzYjd5TXJT?=
 =?utf-8?B?akl0UDEyU0lmVVF3SnhPYUdFZEFhNHJ0SHRlYmxBK2h0RjNFc2dhTVVGUE5V?=
 =?utf-8?B?YUFCMGFuczc4eFhrOHVZdStTZXRLUjlxVi9sZHlNLzQ5MWUvMW5SbDZ0MmxE?=
 =?utf-8?B?dVZSTVBOMkFob0pONWRCN1dJMVhZVkRwL0o1bWcvNENDNVc3Sm9QSnlPajFj?=
 =?utf-8?B?U2sxd3dQT05TNHVVL0VXV2Z3aDRZeFJiMm5waW1VLzhLOHhrVzRtMzFpWXhN?=
 =?utf-8?B?SEdmZlU4cVRhYTd0VUM2MHpjZGJKYlJ6VVBoODlObitJbFd0dmNKU0ljcDlN?=
 =?utf-8?B?V2NGNFg1elBBMUFMalNFQzNzM21EOUhCOW4wL0wveU1vVnB0aFI3UzBIRUt2?=
 =?utf-8?B?WU9pK0FCNEVpZ0JpY2docXNLcUxjOWJqbmpVRWVRWUVvYTZWZ1JFckpJbFBl?=
 =?utf-8?B?aEhDVkh0bmFCbVlRaUFzc2swZkl0bXV2eVJVRVVTaW5jNkZQUVF3eFdPYlBu?=
 =?utf-8?B?ekVRTHc1bDIyMllQZm1TU0N3VUswRncvbFB1YnhYM0tXTk1aKzJQMlNCSlh6?=
 =?utf-8?B?MkVLRDBOQWxSQkI4TXhnUFF4cFA0UDVSK1lPdXB5MmF5U3R1SmFKOTg4NVdx?=
 =?utf-8?B?Z2Q0dnFqYjlQOXZJNWhzM1MrNnU2MC9BbG9vWFI4Vi9COUhkUFRmNUhxQnJW?=
 =?utf-8?B?QmlSQjNkOWF1RU1iZndVU2MxUWJwRHpaWjFPYVdvV3phcVZvSVVaRi9GMUtP?=
 =?utf-8?B?S0tETDd4eWJlSnVncUdHeCt5NnVkaU9EcXFic0Y4UDFhR01BOVZMOFBtamVU?=
 =?utf-8?B?YXdOd3E5cy9aUXhJVXRhNmNkR0tUUDM4TkNJY0xpSFpwS3V1UlR6Nlo3L0NC?=
 =?utf-8?B?Vkd0aVk5bml5a2pWOURycSsvUVExQU41N2lJUTNWRXZOQS9nUnNacmNSNVl1?=
 =?utf-8?B?ZGIvaGxwWU8xdVl3dy9za0RsLzNBNG55bll2dW1SU1QzbjlwY08xUEo5bnNW?=
 =?utf-8?B?YmE5bmpCQmlkNXk1Y1l3QmdGck9xeXpMU3ZjSzhlaW5qbmxkcjBMakJKcjla?=
 =?utf-8?B?U0pXeERyNE10bm0zK1JQbWw3alRHMDJIaldNdWFaNHdsZWdhUzczOGJiZjVu?=
 =?utf-8?B?eDJHSW1sMFg3eXhtV2tidnp6OTdLZGY0dW5QVGl6MGh6TG8rV3dsdTIzYWxt?=
 =?utf-8?B?aXNqYlc0UzFXQllYaTl3QUFIZnhjUE44U0dUZ3RUL0sybXgvRmRLTTViblB5?=
 =?utf-8?B?eXprQlp3Zm1wSkhNWW43OGZzWjY4L0kxajM3WnM0bjJrdG5LVGlXakhHbW5q?=
 =?utf-8?B?U0IzSTVuUGVTWVZGbktac2NpVTQ0M0w0QkxqOVFUMUs4Q1MrbjNIYnhPLzB4?=
 =?utf-8?B?S2J3Ym1SY09CTm5DRlRmaXNmdzJmaWJvdTR3NHQvWm5YYjVVNVZXbXZHWFVG?=
 =?utf-8?B?bkE5VmdQYWhLMnZuaWhTVU1Sc1BPaWpHMDFpbldKKzFrV2MxT28rcVpLbkRP?=
 =?utf-8?B?dkxWaHR0bHdNbHlWRlV2bXkyTkFxVmpNcU55SlllcVhqS204K3dsNlo1Y2xt?=
 =?utf-8?B?c1d2b1lWVEtESGY1RDYwYkxGclZsejRzNFBCZmlvQVhZc0RYVStRZHFRRDly?=
 =?utf-8?B?UlRQZ0IxNUd5dlBTbnNFSUZzNXIwbUF5S0pNdW5wKzhUUVhxTkN5OU02RE4r?=
 =?utf-8?B?ZC8zTTQ3MmZyb3ZkT1RWZDhOMWFiREwyQU56OEZUdlEwZG56SFhlYk5rdWty?=
 =?utf-8?B?YjNJQXhzc2FwVXpQSEZ4bmxnbXFGNzVCcDFnMm9PYlY5SEZnb2RUVyswSEV1?=
 =?utf-8?B?WHRWendJazRYSnNtcmpLa1pkQmpXZGlnRnVnV3J5MEkrcFpuQkV1RlVIaDVj?=
 =?utf-8?Q?KZxWYDGT1AB6RZVkG7SNUw0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	um63jIPKLZg2zHnyutOPoJzWt/sBmLHDPPgWSPYINtiFmQ8bduy82JzyThLcZWUIp35Bplq2uLsGjQUdYV89HNPUipo5ClwgFH4t4KthtfNoUhtCKQIfI2WK9J9s4PQeytvD25slf0DDzBowGiqMPfp0sOeLVax72AGUl++TFtHGKyB3SK1/zWU9nQp4K0PHgioEeEbuDZeDrDOOa22ACWtpxbxMOTFD4gSVFwF6xQaj3iSddsVtgFwyV2z6u9DflKd0XtFknpOF0afAHQ1t22br7ahSlRWOCT6JBdCGBWSJVZftlEwVa+A8K2LKmn3NtcSsrkaBHUgCoPY1nf/JUZJwsrfG2gJOUeqegt1hPjvu3pb7cN0sZIECk7Zqa4a+cM9sqzOUqKolrify/uiR68Um3MAfhd9QZhf+Bh7DIVuQ85eJPb8/d+x7ysQE69iazqsckPhkwCkeOAkyyR14Q7JRxt3h/GFmcLCY+xlNQawOOsiLds3ysuAZ4GZLdDInKxwwYbOa4LOIDfiDhmopb8nF1pcQrWOQPn0t988GZeISpKVARwXQLRPnpfyJdlJQkBXalYjPHxt7BNb2+w1IbTzucpd16lUxJnlIEykBy20=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aafc589-3443-4c71-7f30-08dd4c8555f4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 23:22:51.5698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMGAIfFUoViqsKNa1VqDELQFQcsPWoTdAswjdSu6GrALC9RjV2hHUJ+UuMFqrkX7P41WD+pJ6FY19ddv6CZahQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6256
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_09,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130165
X-Proofpoint-ORIG-GUID: 0jb8TPGaXXK3sAifVD9O1CsKMYpf-9pC
X-Proofpoint-GUID: 0jb8TPGaXXK3sAifVD9O1CsKMYpf-9pC

On 2/12/25 11:25 PM, Song Liu wrote:
> On Wed, Feb 12, 2025 at 6:45 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>>
>> On Wed, Feb 12, 2025 at 06:36:04PM -0800, Song Liu wrote:
>>>>> [   81.261748]  copy_process+0xfdc/0xfd58 [livepatch_special_static]
>>>>
>>>> Does that copy_process+0xfdc/0xfd58 resolve to this line in
>>>> copy_process()?
>>>>
>>>>                          refcount_inc(&current->signal->sigcnt);
>>>>
>>>> Maybe the klp rela reference to 'current' is bogus, or resolving to the
>>>> wrong address somehow?
>>>
>>> It resolves the following line.
>>>
>>> p->signal->tty = tty_kref_get(current->signal->tty);
>>>
>>> I am not quite sure how 'current' should be resolved.
>>
>> Hm, on arm64 it looks like the value of 'current' is stored in the
>> SP_EL0 register.  So I guess that shouldn't need any relocations.
>>
>>> The size of copy_process (0xfd58) is wrong. It is only about
>>> 5.5kB in size. Also, the copy_process function in the .ko file
>>> looks very broken. I will try a few more things.
> 
> When I try each step of kpatch-build, the copy_process function
> looks reasonable (according to gdb-disassemble) in fork.o and
> output.o. However, copy_process looks weird in livepatch-special-static.o,
> which is generated by ld:
> 
> ld -EL  -maarch64linux -z norelro -z noexecstack
> --no-warn-rwx-segments -T ././kpatch.lds  -r -o
> livepatch-special-static.o ./patch-hook.o ./output.o
> 
> I have attached these files to the email. I am not sure whether
> the email server will let them through.
> 
> Indu, does this look like an issue with ld?
> 

Sorry for the delay.

Looks like there has been progress since and issue may be elsewhere, but:

FWIW, I looked at the .sframe and .rela.sframe sections here, the data 
does look OK.  I noted that there is no .sframe for copy_process () in 
output.o... I will take a look into it.

