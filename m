Return-Path: <live-patching+bounces-1266-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C425FA584F6
	for <lists+live-patching@lfdr.de>; Sun,  9 Mar 2025 15:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C1E87A4E1C
	for <lists+live-patching@lfdr.de>; Sun,  9 Mar 2025 14:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 309521DDC1D;
	Sun,  9 Mar 2025 14:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PrOogkU1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g1WamlZS"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6D01C2DC8;
	Sun,  9 Mar 2025 14:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741531467; cv=fail; b=qh93QlDQ47ZSYVADc4qmcrwGpgMuf98urLGQpwQ87fnIL0HhEp0s2VsWFLfQqC2RdIpWIQiB++FNb0FlMc2U2jNxGfu5S/X3UrlM8yGzq31vncteL1ZMoQ7s4vYTE3OPJmGSHRpVH6whCVuK8bqNJt8CRUNX7tVAWWJeqkaTJ3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741531467; c=relaxed/simple;
	bh=RhUx0S0ECJ/GrmR+ZnlvZPeLouJJdk2No0uQNvloNdI=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bHkV7mX+5aenhn9H6iXai+OjDciMCM5cHBFVAp2koSozfYIfNDN+rZcjqQHWYwZF990iE7QkW/0XJgYk7DIrni3fkz+DmAigb9nXS6mz99kriA6INhgK1D8t6GEsHHAdoJvZjC5eP2qBdR3YqE1IdA0VHslD9fuu/s3PQJn3q8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PrOogkU1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g1WamlZS; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 529DfcnF026646;
	Sun, 9 Mar 2025 14:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=3Azn7+6YNmsfauuLWmi4KsRejcAYOZC0zGopwK6oFYw=; b=
	PrOogkU1xqbdF42oT/izdnkmFPqZSTXGfUCRCk2WBUDmwRaREkQkzVYROYhKqqVI
	MGSjz5o3z596A1TL90N0uZs6RI9flvGms9xhpfGiEv8FEqgcYpH3JIU9gE+VWEUR
	FvWsKI6pqxBRsXEEQDBPyoiHS1QbDviDfIb2bGMu3A/RPAWQRFgEYV8tItVVUftS
	78ZzRzxbXoRIYIrKKFjA6IIS0TLXom8AAL5bbyslbw75wbnVugJ0wZ+cExXzhwGy
	dHPd1fAW+SafVzWe1kafszFO+potb1QQp3kLKoMWz9qlZe9HG/50jb2/NxU6XYNX
	mQpRZ9uIELqylr8rEPYKZg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458ds9h7g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 Mar 2025 14:43:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 529DD6rw019263;
	Sun, 9 Mar 2025 14:43:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbd7a2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 Mar 2025 14:43:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S8+RHMP8QRQfvFoTFqZgAyQBx/fLlRxqgen3ccU8dpJmQQDq99Y63hHMeao/41qC7gVcnTocreiFqq74xYTwbGdE/fc/eYdshR5W5f4qI2dJSo5yV9p9Yv9Qzlq/XlUP2ASxA0joM+jCc//qJII0oXsSf4pN64pEyrm5bVgRYpbmWEbRk4X1/8f1UP2hYKMEliVUkMI8dATHfGbO0eM8rIBLXVZcfi3IsU6ordpGamTDEv04rdWSq1rsXYu6jJMNKN0bFpj4rfQvFgLiR1LVYn8NMMWxtc7LC5vN7Qv/1PlEk+YjPbmdLf2D1M+CL4VVvBDzUSa2sDEbFiU03D2WIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Azn7+6YNmsfauuLWmi4KsRejcAYOZC0zGopwK6oFYw=;
 b=XaEiDJcM47DpGyTlJdKNfJXa2jfZbYiJIWKtuSWuvjJ6FoKVUS94bIscTHs3B12bDqorF0qqKCf531Gp8OXNwS20PMiDvFw3dA2Pr0mft5av5WRlLBHZqMwHElrDS/0V0ekm0wV+hsAFj1VeRvKQVCyfvEevwQszgK3qabwvVAvVkr1/seHC1vG6zV/6lT7k5bRlDvqlaIHCzIKb32Tto/yDJx+EdMibz5Fe5ZaWr5WJSplmwo2uNnvusVTQWY3h0maIjNWU9y/1UlPXyIR96X7PmanIk03rMazCoRivNFi0T8VPYWxuQY8NIhxpuzgnwTGW8yp+DqnTv9UMpGaEaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Azn7+6YNmsfauuLWmi4KsRejcAYOZC0zGopwK6oFYw=;
 b=g1WamlZSaSC3SrL+OldqSrGgvq2g82IzH7Ef4PioiiYq8MyeV+2qarTeOU+GSuLlEJlLBh9zpQK9WsoqRoGAopB/fYsRqQAbbcZweduTqXhiSksdcNXDJ7PfzaIZUksHYyk993z84y3mU4RXyE+5DOycoLx4snStn0/pV1FG4s8=
Received: from SA1PR10MB6365.namprd10.prod.outlook.com (2603:10b6:806:255::12)
 by PH7PR10MB6649.namprd10.prod.outlook.com (2603:10b6:510:208::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Sun, 9 Mar
 2025 14:43:54 +0000
Received: from SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515]) by SA1PR10MB6365.namprd10.prod.outlook.com
 ([fe80::81bb:1fc4:37c7:a515%5]) with mapi id 15.20.8511.025; Sun, 9 Mar 2025
 14:43:54 +0000
Message-ID: <ed1bf8ce-6685-48d0-bf48-7db943fc8c13@oracle.com>
Date: Sun, 9 Mar 2025 07:43:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
From: Indu Bhagat <indu.bhagat@oracle.com>
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
 <9debc20e-1460-4400-a9ca-50b407948976@oracle.com>
Content-Language: en-US
In-Reply-To: <9debc20e-1460-4400-a9ca-50b407948976@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:303:b7::29) To SA1PR10MB6365.namprd10.prod.outlook.com
 (2603:10b6:806:255::12)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB6365:EE_|PH7PR10MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f51be3-315c-439c-69a2-08dd5f18d0a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXMwV040S3J1VHk1KzdBNDFvUUxmbkxoUktJMUxEU3NNTmpWUnNScDd0VXlp?=
 =?utf-8?B?d0hYdFQ2a0QrSFN1M2lQUzZDSWRLOFNTRjZaL2grVnowcU1ZZVpPM2pCQ2Zs?=
 =?utf-8?B?Y29idFVScmFjMU0rM3N1ZVQxM2hKN1QvMEJ5VHNuazl0MXZORVhVMkZ2OGRU?=
 =?utf-8?B?K2U3ODdEdTEvSEFITUZxVjByeEhSMkFXVithOUZyYmU1MWFHYjEyLzZ4YWUz?=
 =?utf-8?B?c3hyczdRSnlOeWdET0h3Q1pyZ3o4Nm11RnhmQlVhQkZ0YzJvb1gvTzc3RWdh?=
 =?utf-8?B?eWpCaENvc2loVXc4NTlObElMOUFkUlVoNGp5SjUrTFRlYzJnWEZ2aDhTd3dB?=
 =?utf-8?B?dk13RTZNN0VNWnhtYTlIMjdEZzg0UVNGZ2o3RmU0RjlHOFdRK0hwZnlIaDdu?=
 =?utf-8?B?VDZNUlZYS2F4ejNZR0lrWXp4WGlCSnMwRmdCTC9pN2h5bjRlb1VPaUVMb3Vx?=
 =?utf-8?B?Nk5EWGg0cWcwSFFoYU9BcE04bXZZaGZLbXRTdkJza3hiL3VNb0IrRkRvWHhz?=
 =?utf-8?B?aGlOb0JNK09SK0g2MnVXMWxHQ0NxT3BLR3dhMFJtdkJZM3cwbytsMnUrVEFl?=
 =?utf-8?B?eGd3a3B1UzRSM1p3WEIwWEg4Y2xOMXFsN09Cb21ib2xpOWR0a0E2dy81OTNJ?=
 =?utf-8?B?OHF4MW01enlDa09hU2MvRXY4UnJPTHY2UHlUV09xQXRYNno0c1pFUUxOaGtO?=
 =?utf-8?B?WkFTQ095bHJ2dU1HMk5uN002MW10MDhGK0IreVhIbHRablV6SGh2S3NIMWJ0?=
 =?utf-8?B?RUpsQ2l6WVdJTlE4bVJGQUVKZG9FbHFteitlMmFOajlLdXBhaDBDR1FpcGtE?=
 =?utf-8?B?b2grRGxrK2dXMkhnU0ptbWVOQms1SUpBTDNpUVZTOHo2RVBTbzZaQXVNaGJv?=
 =?utf-8?B?S01BaGMzaVNzMDNIOXhvVng5RmJrQ0Vqa3J2VnpEbEpWMlBnUEhCc0FWM010?=
 =?utf-8?B?NndpUTRzK2dqeWJlckZFNlVFQnVJdzZpbDVoMmVhMnpTK2FzbE41V051dktH?=
 =?utf-8?B?L2pVdWxzK1g2R0FuOEl5d3FoREFwWXJpSDJnZkdlV3JZSEh2cm0yOTY5RHQx?=
 =?utf-8?B?UGd1cENoN05tOHVrWU5XRjZrUHZtaHdlbUJlODcvRFJ3MEp0Q3NGMFV5eXZB?=
 =?utf-8?B?Rk94cml4VDhscXlPM2paMXEzZjBZWm1CazU0NzNBdW4ydnNXd2hxRUE1Q3lY?=
 =?utf-8?B?UitTSnZpOUQ5VFJmNUpMOWpQY202RE1IZEdhK0dCaG9yUFJVU3JBVGFNUE01?=
 =?utf-8?B?emQvNGR5azhsNHpSMUNrZVpIVkIzeisvc01FMnNTTmtUdlpML1lVMlgzU1d6?=
 =?utf-8?B?TXE1QkJwRktMT2hWdFd0SVhIdHJieTNYdU45ZG1CQWhjYXhpNGRpRGdhdWdW?=
 =?utf-8?B?MWdML0dGUncvODJDR0t5bkxqVERnQTllRk1jOHJjbkpuWmcwaEkyaU5FVkRE?=
 =?utf-8?B?NS9XTUVORTNsMHNMOGVXVGJsK0pHQTFqNTVBby9kSFI2cStXYmpYekJoODJU?=
 =?utf-8?B?ZEp5elIyNFpVdVVGREExQ3JRcjNOVEVRNm1NdUZ2VmJ6cEhHSEhRUmV0YlFZ?=
 =?utf-8?B?VjZNWC9xTzAyTm0zNktPUmJYd20wOVEyWUdJL24rSmg3d2NxUXZiWmZOUGkv?=
 =?utf-8?B?STJ0bUdIdXc1VHN3a3RHVXFQTTc4eEc5MjJUNE5EVTJ2RkJ2bXhHRk9qR3N3?=
 =?utf-8?B?MmpiazNwZDRPelBWcGhnSDNOU05pZEFkR2EwY0MwQWFVUHd0QktXYjJKeHVr?=
 =?utf-8?B?WTlNbWdLckYzVGlnc1RZRXluK0tLaWR1eUIvYW5XRmRXTEp2aHYzZFVEeEdY?=
 =?utf-8?B?M01tRnhzWU12bG1VWUxIamNaTXJOMlhzQmZFSGtkOG1pRi9MZnRHSVRjbHRT?=
 =?utf-8?B?S29heTZJS21VNVFXNlM0RjJWNVlSS1ZPMjRBRk4rY1NnRkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB6365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUZrK1pjVWJ2ZmN4SWtubExQeEVPeTAycnZRZjd3T09kalJmSjRoendPQ0NQ?=
 =?utf-8?B?TlZPSVdLeEZwSXRldk9ta1BQZlAwK3RXNnVZUS9ZUE15QXVXWVBGNDFFbWtj?=
 =?utf-8?B?MkFZOVNwdFBrazE1aWxabE85SWNTMGgwQURmYXdxZ05UVXFHMnhIQklNcDZ1?=
 =?utf-8?B?N0dDM1gxNE9rYzY0ajlJdlVFZkpuNlFrcU1IZUY4TkVjN0JsWEpZb0szS05t?=
 =?utf-8?B?SnZuNUhoM0k1eGZUOEFZcmUrYmluV2tlRmRzSWg3ZFlhL3AxdnpmWm5rQ2ZC?=
 =?utf-8?B?UGJrc3dEVDVWMWt1TENkR3ZQcEx2YVJUTlgrZ0tJbUtiK0ZMQ2YzM0MzK2U5?=
 =?utf-8?B?ekFHNTZLV2dHVzRIRzNHaU5GbU9vM01aRkZ6NDloamx4bXRna2Y5RFlBMFBC?=
 =?utf-8?B?Y0wrZjVDbWhpRFFIMk5XRnNKd1B6NThKTG5BUzZQRXJoMmZoeU1jazNlRzlT?=
 =?utf-8?B?OWNmejJ5Q1dRRXlhS045RWllc2trU2RzTXR6UEtrYWhyTkpRTTRPR2dYWkhE?=
 =?utf-8?B?T0J2dWRxUVZBWUJSaTNhVUJnYVlqMnhRRitWMG9TMXpnVHRybUFTUkdhNkw0?=
 =?utf-8?B?eWlOdGpjWkRDeWw2VGpiRHZaQlVYNjZHczhiN3JnRXdPYUFzQ0NQdVdPM2x1?=
 =?utf-8?B?ZEFhMmRvSldSSEhOWW03b2FtQWRQblM1RWZSbmJZeVZ4Z0h6TDJmTG13Uits?=
 =?utf-8?B?VWFlcWsvdXJCRjQ5SVp1MmNXMitnZ1B1RnI4ajlmNjVFQ2xpNVdnMFJ0MDZT?=
 =?utf-8?B?eUtvVDNGdjd0RDZVaTlKZ1VGR3NvWEw4YUs2NFdMSmVLMmJIcUJMWDB3RkJ3?=
 =?utf-8?B?ZGt0RENKWVhvOUkxOThEejQ0Y1VMejVBNURtbjJpcWVYNWp5Z1duR1U2U2Zx?=
 =?utf-8?B?MjRxR1ZIRTd3eHpHdms5alVuTkRRV2ZoQmx5UGU5VmJFR2VUeUVqTGQ0TmxG?=
 =?utf-8?B?Z2UxeXhsa1VRc1FlaWxMcXl5RTVSOVdQbE1FQTY4VSt1aTJIb21mY245eVg1?=
 =?utf-8?B?NDJvMVoyZy9ldHY1d3JKVWF2UGR2MG02VEp1S0VmMkpwT3B5OHdaU2czZHBU?=
 =?utf-8?B?Tk96QmhzZ3hwYlptVXpVOXB6UGtRVWVSaVkwd25Lc0d2b3NRc1R0U29zaXBr?=
 =?utf-8?B?THF5QW9kckMwOUlMTkFHSWZBL0ZQNTJEVFBlbW5nODJJbCtRUklwNERyYkNN?=
 =?utf-8?B?MlhwZjE4VTdseUJWbWFmMTl6QytmRm5IUlBJK05jSzlWaXY2NWlXQjdYMVQz?=
 =?utf-8?B?bVFyL3JIR25NUGJqT0ZDUFBTdHlwQi82eU9zK0dOWjI2UUtyeWtsSkJISFE2?=
 =?utf-8?B?eWtHNlNtZEwveHVmSVlPWVczcUhMYkF4cWRhbzYrdkxwSXpMMmhIMy9IZnFk?=
 =?utf-8?B?cnJoNzBwdHpQUTlIRlBwUHNsUllkUHY4SGhKT2g0a0VDNzd2ZXJ0K281ZHlu?=
 =?utf-8?B?TzNQcDdXVUFuWUJIRndMc2kvSUNyN3plQ29WT3dZYWVOYzAvcVcxaTM5ZURj?=
 =?utf-8?B?WHdMWEQvYmVjanpDV2RyUmxyYVVLNkFMWlpjZFlicHRMUFhVdEtGRUFnMm9H?=
 =?utf-8?B?TWo0RUplUi9RNE5lamFLNUdDOXlhYmw4TDZYbG8wcHQvbi9KeWVlR3FMNHNM?=
 =?utf-8?B?VGdFSFU3azhSdUpSQUVSd2w2OFl3SU5uOGdKcGFQMWlqaGxFbktYOGEzRitL?=
 =?utf-8?B?QVFYQVNoc2lPbTV2SXRYaUdCWWU5S0wxa0JDM3FFVWxRdkFtR3Zxb051WTgx?=
 =?utf-8?B?MWR4UW1FS1RtUVI3QlMzMURKVExOYWdmbDJndEpZZnB1T3JvdnhsWXBOL0N6?=
 =?utf-8?B?ckJSVXpCalhnUGJ3aTBrb3lPUThiYitMRGxyWXFGUk5KT29FVE1tUm1Ed1pm?=
 =?utf-8?B?M1lIcTdwTUNYTEJqcTQ5NkpVaFFXUUs2eHRDeFlaN295NHdLRGFMTml6M2tZ?=
 =?utf-8?B?QjN2bncwWjNCQlBucS9NSUVUeU5abmVEK0s1c0xQOWJUNENDVDVGSG5sdFJI?=
 =?utf-8?B?RWhMMUJsMXdtVUxNV0xBZkpoTlA0aitGK3hEVHRpWVE4d1RjQWpjbWNPSUtV?=
 =?utf-8?B?UmdlTHZGNmM5RmZLb3VEN1d4bTl2RzZFazJNemc5eVRwTWU2NlI0cTJJcVlp?=
 =?utf-8?B?MFk1blRRWWxkbGFOcGVHMzVxWEdmWGttL3Vpd1VOWDR2SGEvYkRISEg1dHJz?=
 =?utf-8?Q?8RGZClTJiNhww7cUCKKZvA4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UmH3UrYHwwMeS5PTugkOZi3/AZQXyYUZSBcB2Il0RFIhAgQ5LayZ+cpCrmCc3UQau5z4HA0FKLdH2SOAAHW+EvFwWvrQ91bOgEmL5E0kydxs4hOKSY1WVRsLcn63CXZg1e0S1WYjt7LHX8Cezxi9QpZZEd5U6vIX+V32fmg+F3oh/uXdGLOru9+wpoQdSd7L4yqQJ1qwDngI9rlfvlrFxLbfHx5Mpn4wj5QNVcZa+T/svPaN7Lmm9cuBip/XGVC5H2tj0Yp+EPs1fl9VY3g7QlJvLrAoCdKO3CzfWtDEw9xiIbZK4VbKUBZfjmH4XumFdOMvzbum3JktmkdcY8kl+PaUNePkOz5JHGpv23W109m8bfPaBivNV27gu9n9s0GGbEFnuISB0ToVNRobWu36EHh6b7qWmxjvCfwYUy4k05w253xhJAWGRkaF/ue8Tr95MTE/t8jMNgvIqYjlMOIM1fPrrHTaggRAVv6ZymFuYcAzypQIzujZEErYZ6KKWCUkN3Bb2+UAomqpGL6sodk1Ec5n+cVZJSLCX/nS+RAyvnzvmhPzQSj/VBAG+J8cGFoV7yPkf64ZcPQbHiRH6rtg4i3BA9QQyf5gKzF7NB0rNus=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f51be3-315c-439c-69a2-08dd5f18d0a9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB6365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2025 14:43:54.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fADV48I8p8V96bRWx9KVFx8kS6guscbRD+mCTdSOssNBTzPwSKzhKhyzeNpc9PM9wdDAYSJ/Xda4QCOSsfxUyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-09_05,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503090119
X-Proofpoint-GUID: QS99rYAVeRh-r9qSPIe_YhW10IVs9RbN
X-Proofpoint-ORIG-GUID: QS99rYAVeRh-r9qSPIe_YhW10IVs9RbN

On 2/27/25 10:47 PM, Indu Bhagat wrote:
> On 2/27/25 1:38 AM, Puranjay Mohan wrote:
>> Indu Bhagat <indu.bhagat@oracle.com> writes:
>>
>>> On 2/26/25 2:23 AM, Puranjay Mohan wrote:
>>>> Indu Bhagat <indu.bhagat@oracle.com> writes:
>>>>
>>>>> On 2/25/25 3:54 PM, Weinan Liu wrote:
>>>>>> On Tue, Feb 25, 2025 at 11:38 AM Indu Bhagat 
>>>>>> <indu.bhagat@oracle.com> wrote:
>>>>>>>
>>>>>>> On Mon, Feb 10, 2025 at 12:30 AM Weinan Liu <wnliu@google.com> 
>>>>>>> wrote:
>>>>>>>>> I already have a WIP patch to add sframe support to the kernel 
>>>>>>>>> module.
>>>>>>>>> However, it is not yet working. I had trouble unwinding frames 
>>>>>>>>> for the
>>>>>>>>> kernel module using the current algorithm.
>>>>>>>>>
>>>>>>>>> Indu has likely identified the issue and will be addressing it 
>>>>>>>>> from the
>>>>>>>>> toolchain side.
>>>>>>>>>
>>>>>>>>> https://sourceware.org/bugzilla/show_bug.cgi?id=32666
>>>>>>>>
>>>>>>>> I have a working in progress patch that adds sframe support for 
>>>>>>>> kernel
>>>>>>>> module.
>>>>>>>> https://github.com/heuza/linux/tree/sframe_unwinder.rfc
>>>>>>>>
>>>>>>>> According to the sframe table values I got during runtime 
>>>>>>>> testing, looks
>>>>>>>> like the offsets are not correct .
>>>>>>>>
>>>>>>>
>>>>>>> I hope to sanitize the fix for 32666 and post upstream soon (I 
>>>>>>> had to
>>>>>>> address other related issues).  Unless fixed, relocating .sframe
>>>>>>> sections using the .rela.sframe is expected to generate incorrect 
>>>>>>> output.
>>>>>>>
>>>>>>>> When unwind symbols init_module(0xffff80007b155048) from the kernel
>>>>>>>> module(livepatch-sample.ko), the start_address of the FDE 
>>>>>>>> entries in the
>>>>>>>> sframe table of the kernel modules appear incorrect.
>>>>>>>
>>>>>>> init_module will apply the relocations on the .sframe section, 
>>>>>>> isnt it ?
>>>>>>>
>>>>>>>> For instance, the first FDE's start_addr is reported as -20564. 
>>>>>>>> Adding
>>>>>>>> this offset to the module's sframe section address 
>>>>>>>> (0xffff80007b15a040)
>>>>>>>> yields 0xffff80007b154fec, which is not within the livepatch- 
>>>>>>>> sample.ko
>>>>>>>> memory region(It should be larger than 0xffff80007b155000).
>>>>>>>>
>>>>>>>
>>>>>>> Hmm..something seems off here.  Having tested a potential fix for 
>>>>>>> 32666
>>>>>>> locally, I do not expect the first FDE to show this symptom.
>>>>>>>
>>>>>>
>>>>
>>>> Hi,
>>>>
>>>> Sorry for not responding in the past few days.  I was on PTO and was
>>>> trying to improve my snowboarding technique, I am back now!!
>>>>
>>>> I think what we are seeing is expected behaviour:
>>>>
>>>>    | For instance, the first FDE's start_addr is reported as -20564. 
>>>> Adding
>>>>    | this offset to the module's sframe section address 
>>>> (0xffff80007b15a040)
>>>>    | yields 0xffff80007b154fec, which is not within the livepatch- 
>>>> sample.ko
>>>>    | memory region(It should be larger than 0xffff80007b155000).
>>>>
>>>>
>>>> Let me explain using a __dummy__ example.
>>>>
>>>> Assume Memory layout before relocation:
>>>>
>>>>    | Address | Element                                 | Relocation
>>>>    |  ....   | ....                                    |
>>>>    |   60    | init_module (start address)             |
>>>>    |   72    | init_module (end address)               |
>>>>    |  ....   | .....                                   |
>>>>    |   100   | Sframe section header start address     |
>>>>    |   128   | First FDE's start address               | 
>>>> RELOC_OP_PREL -> Put init_module address (60) - current address (128)
>>>>
>>>> So, after relocation First FDE's start address has value 60 - 128 = -68
>>>>
>>>
>>> For SFrame FDE function start address is :
>>>
>>> "Signed 32-bit integral field denoting the virtual memory address of the
>>> described function, for which the SFrame FDE applies.  The value encoded
>>> in the ‘sfde_func_start_address’ field is the offset in bytes of the
>>> function’s start address, from the SFrame section."
>>>
>>> So, in your case, after applying the relocations, you will get:
>>> S + A - P = 60 - 128 = -68
>>>
>>> This is the distance of the function start address (60) from the current
>>> location in SFrame section (128)
>>>
>>> But what we intend to store is the distance of the function start
>>> address from the start of the SFrame section.  So we need to do an
>>> additional step for SFrame FDE:  Value += r_offset
>>
>> Thanks for the explaination, now it makes sense.
>>
>> But I couldn't find a relocation type in AARCH64 that does this extra +=
>> r_offset along with PREL32.
>>
>> The kernel's module loader is only doing the R_AARCH64_PREL32 which is
>> why we see this issue.
>>
>> How is this working even for the kernel itself? or for that matter, any
>> other binary compiled with sframe?
>>
> 
> For the usual executables or shared objects, the calculations are 
> applied by ld.bfd at this time.  Hence, the issue manifests in 
> relocatable files.
> 
>>  From my limited undestanding, the way to fix this would be to hack the
>> relocator to do this additional step while relocating .sframe sections.
>> Or the 'addend' values in .rela.sframe should already have the +r_offset
>> added to it, then no change to the relocator would be needed.
>>
> 
> Of the two, adjusting the addend values in .rela.sframe may be a 
> reasonable way to go about it.  Let me try it out in GAS and ld.bfd.
> 

A fix for this is in the works (being discussed on the 
binutils@sourceware list).  I will keep you posted.

Thanks
Indu

