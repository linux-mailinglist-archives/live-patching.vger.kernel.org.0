Return-Path: <live-patching+bounces-1332-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B841CA70271
	for <lists+live-patching@lfdr.de>; Tue, 25 Mar 2025 14:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C233517A4FB
	for <lists+live-patching@lfdr.de>; Tue, 25 Mar 2025 13:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D52E20311;
	Tue, 25 Mar 2025 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="fzl2YuA7"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E4981732;
	Tue, 25 Mar 2025 13:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742909866; cv=fail; b=HQS7ATvW4KCX0Nl1vC3vMtYz8nWA2lmsgIwRy5lmNKXGuVXnraPlhWk8TUGm00dTcyC9ScW5hWR4/KxyO46ZK2ai/pE4OaR2tPnh4N1b3A4X66jX6j4eRd5MPQPaa8uyCBuJ7O6s8L/9pIX+rel3hjOF0wBvh3JjnX4AMDgq7Ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742909866; c=relaxed/simple;
	bh=w4rIgnw4D2IUbwkQGkjC0ORwXpDeVLB3Kl30w7ED6vs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a4L+ZtCcyagAMAQ/+CqKzwooCTuL8iYkidWIpyTNW2vCj8UvpMkd1ty0EjxtpprN7U87avf6zAAQLitRMnrEw5LIHpiBoaPKyjDuhZV/Kvbv8aq4h5Gz9UKXZIB67F3EHILapxLqBEXMNk+8enFbcE0DditZjMt4hmGzfGuRnhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=fzl2YuA7; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52PCosFo010211;
	Tue, 25 Mar 2025 06:37:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=w4rIgnw4D2IUbwkQGkjC0ORwXpDeVLB3Kl30w7ED6vs=; b=
	fzl2YuA7MM11byeqcCtdiggy08Q9x76tm1UDuF30NEBn5GiU0qr2EFIeeOc3/w+p
	hw9PRoE5IoTX03Vimq1NAxkdKAtKX/+2lAq5ZkLHnR+X86qr/hJtaPXl27HtXy+q
	Dz2JwLErIx6CzsO2ynqAMbSOX2srkpZaJi6SKbBOl3h5rs8k0fz/uozjlYk4F70j
	y85l4mXQMCriXwPCQLg5Y1R3IZ/H6gA6sAWxbL8Zei8kN8Lje2o8m9VgCpCf6SY9
	irnFBcPfD00uSwr2XDH1pBTKKmUP5fHw/sJg3XjwhDG8tzXXGpL8kXEDy95uaBfn
	n825qHTZygtzklWKAyEtOg==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 45jxg63tmq-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Mar 2025 06:37:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nATkLLGRMhVLzst3Gi46+hZgMi5BLj+vicFj8tZTx3HUEp0wYQf0+0o54PpZXKiiSXU0mIBh+PB0spoxpz3XsdcTa1vBgHsPXGFQeh9VzbivlRduN4n+WqPSFzvlO/md922rApc/9PA+DNG9pvjplN8pvFeSzx8XmRaItTgoASVGeLEl23xmJHOjdEibnwjGV7Q8fd9Wn+Ouurgj/EKIFjN5c+ENDjMK3FozWdz95BsrIPaqGA0Ps3w3UrMYisdRvAX7mCfMRddUCKq6Nz6WQC3HDoRGd3yPXCXsAQR3CXJi5MKZCBkm+KdEOGe2gjkeBoU0hd4fUbVvjHQbd6Mvsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4rIgnw4D2IUbwkQGkjC0ORwXpDeVLB3Kl30w7ED6vs=;
 b=ICMFSMwV75WGjenZmIYoHQUcfrJc1tYukvjyUqnBhM+UZQ6x2xbILzPHlqI/edp0NuSJp2KO77EU95pBkuLrp/C7QflY0D2vE2ZmT0zGM7Y9lehHXm+0g3lqj5L37Lqm0FzLOKcqNmbKVU72h4FGOHmpwHnCsUKCs11GliI8IGVoxhYG2/6T400wYzrpuiA8ISk3Ovpy1ImyzfEvQltLKLjzc7MPTZi5DvYQKAqqePRdCCG2BUIYZSZDHUKc8Rec9MTR+RyY1CE2EE506kUHEXsc2VQbDTC0jFRvimfnafAa7tTdPnY84nAFxj7Tj1+87+7Y/g4oz2LARNncVoVN4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM4PR15MB5432.namprd15.prod.outlook.com (2603:10b6:8:be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Tue, 25 Mar
 2025 13:37:38 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 13:37:38 +0000
From: Song Liu <songliubraving@meta.com>
To: Petr Mladek <pmladek@suse.com>
CC: Song Liu <song@kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "linux-toolchains@vger.kernel.org"
	<linux-toolchains@vger.kernel.org>,
        "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>,
        "indu.bhagat@oracle.com"
	<indu.bhagat@oracle.com>,
        "puranjay@kernel.org" <puranjay@kernel.org>,
        "wnliu@google.com" <wnliu@google.com>,
        "irogers@google.com"
	<irogers@google.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "mark.rutland@arm.com"
	<mark.rutland@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
        "rostedt@goodmis.org"
	<rostedt@goodmis.org>,
        "will@kernel.org" <will@kernel.org>,
        Kernel Team
	<kernel-team@meta.com>
Subject: Re: [PATCH v3 0/2] arm64: livepatch: Enable livepatch without sframe
Thread-Topic: [PATCH v3 0/2] arm64: livepatch: Enable livepatch without sframe
Thread-Index: AQHbmbvJo+J+zAD5HEG1iXvXUPzjmLOD1kCAgAAMYgA=
Date: Tue, 25 Mar 2025 13:37:38 +0000
Message-ID: <574A91AA-7FF9-4BB7-A7E9-2D4C3FE805F1@fb.com>
References: <20250320171559.3423224-1-song@kernel.org>
 <Z-KnNU2A_kwwYdXU@pathway.suse.cz>
In-Reply-To: <Z-KnNU2A_kwwYdXU@pathway.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DM4PR15MB5432:EE_
x-ms-office365-filtering-correlation-id: b1a71502-c025-459f-abb9-08dd6ba235a8
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RTI5QkIwbHZROWxIWmF2U0huaDhQSkFTUGZSRnRuRk1sZFU2YUJHVGR0TG4z?=
 =?utf-8?B?bGVPaGw3Ukx1ZHUvWnhwd041Rm5taGF3R213Wm0vWmxSakJaRGRQNW41UEdv?=
 =?utf-8?B?OHZObWQyYWlvcmIwejJUa0RKZ3gycFRhK1BxZ2xIUkk5bEY0TVg0TTh1WTRE?=
 =?utf-8?B?amljOGVrWkVpQ2s0aEVtUzhVUDlIK0MvWDVEUWpVZlpkTXRRYkhtb2MxYWN3?=
 =?utf-8?B?ZFJ5MjlVT0FZWk1FY0k5d2JUTEdIMG5oQUZJNXpvcDIxSi82QXFOQVFKY01n?=
 =?utf-8?B?bnIyVmd6VWwxdEYvL0I2RjFXZW9TckZyZjZqSDNyV0hGQ2hURTBnOWtvTEpW?=
 =?utf-8?B?NUU4V0l2azhaNXZCWnJZYlkybGNMZzY5QmxwZ0krOWR5NE5RaDhJYUJyMVEy?=
 =?utf-8?B?Y2lwbkNvcDBYc1ZkWHFWcnpaSitSM0FYUWwyMW1FcEdtUUNWVXlieS84Qmxi?=
 =?utf-8?B?K0c0R1VnaEJYaW1jeU1CWWlYOGt0cm9ia1hwTmFUaUZDNGxORmZnN1V1cFpG?=
 =?utf-8?B?MmsvQm81RFc5MzNBYi9aU0hCdjRhVGY5M29UNnRlZW9sa3Vud0hSY0hpZmhl?=
 =?utf-8?B?bUM0cEhJa3N6bmtXeldrTStLSTQya1RxSEUrdmM3QTN3UzRRUmpBRkZLVUdv?=
 =?utf-8?B?S1ppYUo3TVJQNit0aGFJNThOMmdDb1gzNm85TTYxd2ZLQjRuQndTTFhXZDBV?=
 =?utf-8?B?MGVXR203dUpnd2hhdlZOaFFUVkQyb1RFUTRHWlhHQnZTWFM4Y3RMVURxbUlr?=
 =?utf-8?B?Y0JDN3h5R08ycndlM2c4aUxYczBzdy8vaUdVdGZQYlczT1ZKQVhEcmdRNzRw?=
 =?utf-8?B?azZSUHFMSHh0R2RRelcrUUlNYWYvdFdXTU5SWFZLalIrNkxwWUc2aVNjVUEr?=
 =?utf-8?B?QmJvZTZLYmtJMVhCWm5yZEFNc2dTRlY2TEpVNjk1YXQrYW5lN2dJaFpOOWxx?=
 =?utf-8?B?MlpwRm44RERJUmE0MFpTZWo5RnBLNGxqOWNZRC9ZZEZiZ0ZnVWxlS1ZLdXZB?=
 =?utf-8?B?K1hUMGp4Z0RGMFVFZVErTDBOdTl0blpNMTJRZlM3WTJTVkowT1dCVytvcjJN?=
 =?utf-8?B?MEFXbVAvdEJkTmx4M2U0c1RURFVrWll6Ni9zSG9HWTZPMnVXL29NaEZ3WHVW?=
 =?utf-8?B?MWR1d215dVg3dFM3cldaMUgxVFBPTWVJM2hrZW9vNVc2am9JbjRwUXFvZlc5?=
 =?utf-8?B?d0hsSmpGR1pRK3NFd293d3FaUG80aFB2ZXNDN3RIQmFoWnpFeWtsVlgyK3VJ?=
 =?utf-8?B?d1NxZllZYzhHRGRIcGZCenA0TVpkRDl5NTNXZDA0cHJmN1UwOHQyckxib2ZE?=
 =?utf-8?B?djAyS0dqKzRZaThDaGZkVjY4aU1naWx1Qk8rUzg2ZTJaKzB3M3NobDNNai90?=
 =?utf-8?B?bFVVNlI3QmJpU2ZINitLNGdlOXZSY2g5Y01aeWJHemdObXRONFl0REEvTXBt?=
 =?utf-8?B?QTNvaFFLc0RlcXcrVVZ6TW9LMlRDaGUydnBtdFlWcC9rdVZ2K1I1a1FPak44?=
 =?utf-8?B?T0VsNFFNczNzZEpBa2xrV2VmSmlMcjFrQ0RYSlk1OXdCUjRBaXphV1d3TlZn?=
 =?utf-8?B?c3o0bTZUbGN6U3NoNk9Idk1hOVVTMk5RVmxyay9xSXBkM1FYVFJ0K2swNXFE?=
 =?utf-8?B?MGJCZEZpdys3NDJoR0lMZmRwalJ2eHlKQ3hqYlZURlZBSUYxVnV0WS9lVmVG?=
 =?utf-8?B?NVJRbGxMUEl4V2RBQjBQbW5STC8zNk5pcVA4YThKaFpGRjlKYjZYam55WUNN?=
 =?utf-8?B?SDh5V2Juc1YyL0Q4b2V1RkF0VU12dUVaY3dDU3A0TktteUFHK2JNRjlsaEhm?=
 =?utf-8?B?aDJVdXloRTJjRWpkV21qLzNpR2sva1lwWXI0Um9GUGN4SGgzU0tsSVVVeDYv?=
 =?utf-8?B?bndlSEtmdEVUbXA2bE5mTnV2SldPcXAzT0pMODlOQ25IRXc3OUhuK3J5ZXNm?=
 =?utf-8?Q?kqVmegxDxP+pYpUxMXDCw4mHlowBZEkF?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VEwxUFJ2MnRHelUxa2h5dXQ3ckdHQkE3MEJhMzBwOG5kZXdkOE9JcEJ0Qml0?=
 =?utf-8?B?bVdxQVl1Q2tzMmRubWFaSW9lSm5SVkRHV3ArT3NaVjBZdnZGV3MwMzRCVnJV?=
 =?utf-8?B?dnVuSEdpcVkzSU5tMWpyNC9TU3E3OFZlL3FCZHNSM3lDeHhZUEwwaU9Mc1lk?=
 =?utf-8?B?d0RlV1YzNlFJZUgxS0kwa29mL3RxSFdQbVl3OEo3WDV1K29vSS9qbkloWG5x?=
 =?utf-8?B?Y1FzcnQ2RjJBZUwwWEMzQVdSMW9aVHVXU096L0JUSmJqV3BWZ2lIZStHcEI4?=
 =?utf-8?B?bGRtbFdhSDVIRTJlWTdGUzBwK1lnRXh6T0V6K1FYRFM0OXVhcjBWNDFuWEZL?=
 =?utf-8?B?eUw1SXhTeVBza0pCZVJsOUN4T0JiaW1HT01jRkRTclR2a1RkSXFhcVBEY2tM?=
 =?utf-8?B?ZjFiRVNweWxzZ2RXRmxMUEZyQzhnTXlEby9pUkNXclpSS09kb2d1WHlyand4?=
 =?utf-8?B?VjhLdEZDYnZGN0VRSjYyL2U5ZXorZFhwZThyaFRHYkdneDZ0RXpwT2pIeElR?=
 =?utf-8?B?ekE3Q3E1MlM0MUQweFhGVVNMSjZETXJQTHlBSjdSMEM5ZTVYdnF6bVFtQ00x?=
 =?utf-8?B?M2ZMektXb1hrb2VlQnU2TlZ6V3g4VHRQMmMvNUx3TFNCdVZvbWszdFlKVk42?=
 =?utf-8?B?TXVKdTgvYlo5SGNqT3BVQjNaR1QwTFhvcHM1RW4vaEloTE5FL3dIeHl5WUpm?=
 =?utf-8?B?ZjJQZENRUnNKR28yVWMwRnhhcHBZVXV3OGNJVVdLRmRtYU5RaTg3RUtVUHVL?=
 =?utf-8?B?Q3BuMktBWTFYMG1FVzYybkJubks4SkdvSlIrdFVtZEZKUy9yNkFNbE5uYnhH?=
 =?utf-8?B?VjlYRjFkLzRWK084WEtPS1JJRFBvdFZsZjFmRkdraDJVT0Q3RnAzRUR4S0hq?=
 =?utf-8?B?MjdYekxUQnVKTHhOQXNkQ3l5b0N6L0V2WnI2bTNqaUpVWVlQV0hoZkRuQ3Vs?=
 =?utf-8?B?OWtLZndkanlaQlNvWGtEbnh2cENHcEtlSTZ3RFJGN01CSUtWMHlUcTJ5MmRM?=
 =?utf-8?B?bGRHWEF1RTh4dmdoc1pkV1NZQm9NT3ZUMFBYZnYrYzVxdUxLU3Q0c1NIVkxE?=
 =?utf-8?B?R0Q2TzVYSDhRWjFCY3ZXTXg3bWYrWDlzbys1VTRzVHdaRFkvbjNlN2ZsRXZS?=
 =?utf-8?B?U1JhWXFybmN0R3B5Tkd3VWJ0MllaMW9HZjBacHBlZmtSSXZiR09ucE44ZWpi?=
 =?utf-8?B?akM5azF5eUdrV1kwTFNsdkpSN21KcEdTblpxbjVDMmlOMUh5STZnMHZEUldI?=
 =?utf-8?B?bkRsVDY1UHVRR21NdkRudWEvTmp1ZUJoQUlhV05HODFaZkQ0cVdGSTZ5bFN3?=
 =?utf-8?B?US9lM3lHYnJXS3QwVVFNU0I2ZGZzbVo4Snc5Y3B6MXJxSmdYbDNDck5kQUhI?=
 =?utf-8?B?bGV3MEtTVmIxcGsvOElmdm8wdDFkWlVBMEJlZlVKdTVSM09DOXVJL0J5K3lR?=
 =?utf-8?B?OFR4dEVKL2toTC9oR1BMNzl6Q0NodUNGUXJWOFFjdEE1S3o1SlVCb2xKOEJt?=
 =?utf-8?B?ajE2Ym1XbENTQVdUOUt6RDc2RUpZNlRFMHdoOEFaQ2gvZWxFd2YvWWhSOXRy?=
 =?utf-8?B?a3NuNXJJQU1zV1JnRHRrZS9MUmVEb005SDBING4rMmxlRnREY3JHYjNtQi9L?=
 =?utf-8?B?TkhYUmI0aDFteVJVdGdwNWdiekNRZXl6VmdPYUhrSDRyMGlTN3ZleVBocFBD?=
 =?utf-8?B?ak9QZkF0Vll2UlRSWWpsSnY0aGRrdmQ1ZEI4azV4bFBNeTIwSmtQWXJCbkdL?=
 =?utf-8?B?Y2xPYXdBNXZHUkNrMEVyNXllTFU1ZWo2c04xSHQ2UzNZdlpXODN5WjR3aFJH?=
 =?utf-8?B?dlpUOVlxK0NPYXN0QmRTK2E5ZWpicXcxZTZLWUdqZW9LM3owaytaZTZ5SFBD?=
 =?utf-8?B?S2svdzY3UHZWUzVPZFlwb1o2Q1hwSHRpRjE4dE1OOFl0b3pFVW44enV5NWda?=
 =?utf-8?B?K2ZDbzk5WllEai8zVGNIZlVxSmhZYmllZkw5YU56RzNObGh6ZmVNcUpqaFIz?=
 =?utf-8?B?QzNxVEorWUpYYXVoNG5vV004aEtCbWpsdE1qNS95VmVFZEY2Y0taQ1NPK1lB?=
 =?utf-8?B?aVdFSXVxenZZUnVPN3ljU2w1ZHhkZnpvaUZ3aDRVNXhPQ1FSUTM3STh1R0pj?=
 =?utf-8?B?VFJqc0cra1JGeGxkZm11RS9QbHhOWEoyN0VqSk1rbStpUTZZRmFrOFpQU0dX?=
 =?utf-8?B?MEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5EF092A5ADA1B4399C174C953EAFE6A@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a71502-c025-459f-abb9-08dd6ba235a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2025 13:37:38.5500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AOSwnWaAYCI92QrerfQX7u9gXWknW9GoqAT8kbUCwyz0jLaQLytF6Hc28UUDMcCweFB+wDfsjw4BYewQX7243Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5432
X-Proofpoint-GUID: 5PViiBxGuyCVvcdkZKER9ns6PT9JmcZL
X-Proofpoint-ORIG-GUID: 5PViiBxGuyCVvcdkZKER9ns6PT9JmcZL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-25_05,2025-03-25_02,2024-11-22_01

SGkgUGV0ciwNCg0KPiBPbiBNYXIgMjUsIDIwMjUsIGF0IDg6NTPigK9BTSwgUGV0ciBNbGFkZWsg
PHBtbGFkZWtAc3VzZS5jb20+IHdyb3RlOg0KDQpbLi4uXQ0KDQo+PiANCj4+IEdpdmVuIHRoZSBp
bmNyZWFzaW5nIG5lZWQgb2YgbGl2ZXBhdGNoaW5nLCBhbmQgcmVsYXRpdmVseSBsb25nIHRpbWUg
YmVmb3JlDQo+PiBzZnJhbWUgaXMgZnVsbHkgcmVhZHkgKGZvciBib3RoIGdjYyBhbmQgY2xhbmcp
LCB3ZSB3b3VsZCBsaWtlIHRvIGVuYWJsZQ0KPj4gbGl2ZXBhdGNoIHdpdGhvdXQgc2ZyYW1lLg0K
Pj4gDQo+PiBUaGFua3MhDQo+PiANCj4+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saXZl
LXBhdGNoaW5nLzIwMjUwMTI3MjEzMzEwLjI0OTYxMzMtMS13bmxpdUBnb29nbGUuY29tLyANCj4+
IFsyXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saXZlLXBhdGNoaW5nLzIwMjUwMTI5MjMyOTM2
LjE3OTU0MTItMS1zb25nQGtlcm5lbC5vcmcvIA0KPj4gWzNdIGh0dHBzOi8vdXJsZGVmZW5zZS5j
b20vdjMvX19odHRwczovL3NvdXJjZXdhcmUub3JnL2J1Z3ppbGxhL3Nob3dfYnVnLmNnaT9pZD0z
MjU4OV9fOyEhQnQ4UlpVbTlhdyE4Q0I5QnlvcmN5VHhEVzNyUTZfR0VlTVRKTjlySFdDeWROZElX
MUZSYl8yLUxRNlJUclNlclpxOUUtczhrWEVCMTJKSl92MDd4a3ljMnckIA0KPj4gWzRdIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWFybS1rZXJuZWwvMjAyNDEwMTcwOTI1MzguMTg1OTg0
MS0xLW1hcmsucnV0bGFuZEBhcm0uY29tLw0KPiANCj4gSGksIEkgYW0gc29ycnkgYnV0IEkgaGF2
ZW4ndCBmb3VuZCB0aW1lIHRvIGxvb2sgYXQgdGhpcyBpbiB0aW1lIGJlZm9yZQ0KPiB0aGUgbWVy
Z2Ugd2luZG93LiBJcyBpdCBhY2NlcHRhYmxlIHRvIHBvc3Rwb25lIHRoaXMgY2hhbmdlIHRvIDYu
MTYsDQo+IHBsZWFzZT8NCg0KWWVzLCB3ZSBjYW4gcG9zdHBvbmUgdGhpcyB0byA2LjE2LiBJIHdp
bGwgcmVzZW5kIHRoZSBwYXRjaHNldCBhZnRlciANCnRoZSBtZXJnZSB3aW5kb3cuDQoNClRoYW5r
cywNClNvbmcNCg0K

