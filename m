Return-Path: <live-patching+bounces-1802-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 244A2C0774B
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 19:05:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39BA21C44BA1
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 17:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E14833FE29;
	Fri, 24 Oct 2025 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="jjGoCE6G"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36360264F9C;
	Fri, 24 Oct 2025 17:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761325437; cv=fail; b=APx6Um7Nuzxaa4Qf7S1iQKk4QqcrumnwRJZF+NcSDiFS7sAAIPO+2CPeno8IHKraI2yVeg8/tavzwTJGLGovv+kH78gyHZaNPVEt0YUkxDV1MUYH9ASR3+iMZtaUlXNDD57/nXJpeEFgQQZBl5VIOin4PJW+Z+lGQN77I4b4fcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761325437; c=relaxed/simple;
	bh=lOOQw+4uj24e0Q2Cseyteoj6qp62HV5vvPc4YDdvOCY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Sihn72OoTY//vgyBLEVdGD7OvpKqJCcsfDi5qaFd1NSY3sTc/txbsCI80Y3zeNcqK7B8Sr73hz5oTr90Cmj2swqk09HiofdJfZ/H7om797sdgFI/wnc7NfUacXke6HhbUOJswmJvPtskZAnqShWyte9cVMA66Ip688r9kVQ7WxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=jjGoCE6G; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 59O8CCQr3849941;
	Fri, 24 Oct 2025 10:03:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2025-q2; bh=lOOQw+4uj24e0Q2Cseyteoj6qp62HV5vvPc4YDdvOCY=; b=
	jjGoCE6GTbMA+R7G8aSDbxNelMy9Mc4I5l594mKOT9vPPjLT/ANRS5W+J1hNwEHY
	Nre9xxu6HqGGU+UKxrHLiDBS05rbTu5zPmFgh3lAbSbaOLTzsUNA3HQaT7XHT/Fb
	WJLUNhqNO8VXgRNpkjBUIk3WtD9DeV/R99l+MvDYXs4+VCXP0sCF01itwQDPxFnr
	qACYMeAg4Jd4O3fHxCsEfgGtvBeZB0c3Wo+mSMAQK6Cm+3ErYXNSHM1VXDZWL3d7
	+prPntLZVJbCSsSPhhIjoF/kRX1HTd9055sDUz3/jJHEnEgM95o210sLSYrRXsxm
	/5D0ZBZ63EN05IqEg+ZJiQ==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012026.outbound.protection.outlook.com [52.101.53.26])
	by m0089730.ppops.net (PPS) with ESMTPS id 4a05r0ua00-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Oct 2025 10:03:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sv9TbCFltH80UMUSzDIegdSr83tEDUvWehs0rK5yTGlhXjmEB5zbCa99gmJytBlSCc9XZlyQp1RWH0OHCNy6A6WgkzZh4y61ZuCNAn/otTnx2J5iGM15fd2j/+WGN73VDVlER3YvbZ5z5THhy+faS/cmHFDakI7xEzJtz2+oNrro/gAH+dEc15LKaDwxbFuC0nO7N556yoqFDLCS4rBOLjZScOyNqUK3l6RemdNBpGE2u4jzAU14wcf5IEFiRbw44A+4uz6XzyyguGMb9tp4Ft9JXd6yFk2CB5CSRKBRXTF8rOMU/WtnRZEoKQ2f0sJ7YWVhLF10t4J80sm0Lk1XAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOOQw+4uj24e0Q2Cseyteoj6qp62HV5vvPc4YDdvOCY=;
 b=dMwHaivEvuSz+koK5rzzUK8VYQHkNizZ+sWqF+Doi8AVQW8arGqcXMf4zEucgSG68TS4+VpiohwpTp73nmQ0selhnkkSUtw1OrgAYpuXTBlpPFETsYkw1NvRFpvATdMix0Rd7mAtp1sFD6rps6WbcKMuyRChixf6UQdW3BNlc6wW2pjPa6ICx3VRmD3DRNjDWypznV7BjBHWmZr3VV8mObvm7fo6QuXx5xepalZomNLLI0ik+oYV901PVse+WxDRkaS6OPDxToaQF8BHbxkrnIR/9PvVPaF9KcmWpJD0f/wBug7uPQXYj1pnZ2aom2LFRBZ+E1DfXPWEHzBBymC0DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4369.namprd15.prod.outlook.com (2603:10b6:806:190::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Fri, 24 Oct
 2025 17:03:51 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 17:03:51 +0000
From: Song Liu <songliubraving@meta.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net"
	<daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "andrey.grodzovsky@crowdstrike.com" <andrey.grodzovsky@crowdstrike.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        Kernel Team
	<kernel-team@meta.com>
Subject: Re: [PATCH bpf-next 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in
 modify_ftrace_direct()
Thread-Topic: [PATCH bpf-next 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in
 modify_ftrace_direct()
Thread-Index: AQHcRLWvu/MNXqWzDkWynsjJ4JqJhLTRLVMAgABEGQCAAAmwgIAAC8IA
Date: Fri, 24 Oct 2025 17:03:51 +0000
Message-ID: <204AA1FF-B23A-4FC9-92AE-DE97A7763736@meta.com>
References: <20251024071257.3956031-1-song@kernel.org>
 <20251024071257.3956031-3-song@kernel.org> <aPtmThVpiCrlKc0b@krava>
 <D4EEB2BC-E87F-4F85-B043-867D4E1ED573@meta.com>
 <20251024122135.3bc668e8@gandalf.local.home>
In-Reply-To: <20251024122135.3bc668e8@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB4369:EE_
x-ms-office365-filtering-correlation-id: c0c7e817-9573-49c0-842a-08de131f4e40
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cXljNy9nQlo0bnJPMmF5SktRd3BBRmtXVW1WbWc1V1ZQbng3Z3kyMWtIUVNU?=
 =?utf-8?B?VktObStLZkxaZ29nY0hhdnUxTEtNVmVDSXBRZE1qbnRXbE5UdmsyRGNuTWpN?=
 =?utf-8?B?QmVON1gyem9HWTVqMzhmV3R3QWtMT1VUZFhTdU8xMTloU2hzM3Y4aENrTWdh?=
 =?utf-8?B?NUtSYS9ic2J6MVFONE1XRFNRYTJyMWdVWFZjRUNsL1BvSGQyRjdYeS9GOWMy?=
 =?utf-8?B?TlZWT0J2ckMyTndtcUl2dkxlc25UM25ZRldsQXJpVUxtdjEwT3RhSHFHYkF0?=
 =?utf-8?B?QURqZHluQU9aUFBLWjg2ZnYyTnloUzNiTmZQYWJ1WkU3RWU5RUVJanZiWEkr?=
 =?utf-8?B?VSs3d0ZERXg3MXdxWVNOWmZ3MzZxMGZ1V0RGM2lpRDdZaWYyZHQxVi9UbnU0?=
 =?utf-8?B?WmU5S1N5WlFZRXR1SXEzS0tlZ2JyN0RoeUN0emRGWjhXdXJHVkRyU1RIMVpU?=
 =?utf-8?B?NDBBbWY3dk55UmhER0RGQmxIeUZzNTBpVFlDUE45NDVpN3BkU1VRY2ZXNkcw?=
 =?utf-8?B?Q085N0JHcEpqMXpQYUdmc2owYTBnR3NQNXN4Qm43cG8wZlJjUUlvT0VLZU1s?=
 =?utf-8?B?M0wya3FudjkwL0x5MFV1VnY2S3B2VlVQK3hnd0d2cnVmVG9hTDc1Q3hzaUFL?=
 =?utf-8?B?V1NBUnZLdmtOOFJjVHR4K2syNWp2NFUxQkNlTWZ0SW5QK0Q0eXRHWllLQk5X?=
 =?utf-8?B?K2hZMWpvaVZ3NlJVMlRuRlZqQkUzOHE5eWpKYUc2ZU43RHltYlRUNUtjcE1S?=
 =?utf-8?B?eXVSNEJhUFVqczAyaXBOQ0pzcnU5T1QzMjcxR0FNWFZFM2dtK00wQk5LalVH?=
 =?utf-8?B?cVdFVGQvdmVZaVhueWdkdCtTUWpHWjdwNFhIRlVEc2E1WUI5V0ttNXpiVldh?=
 =?utf-8?B?VXh5RGM0QjB0aXFVZlZFemw1bFY4VFNuNGZnaUt5OUMxbzZRRmdyQ0FqVzgz?=
 =?utf-8?B?TzdheWtRQjNjNXBKbHhMazBHV1htZkhmUFdnQXo1c29jYURXNDN3MWZWb1M0?=
 =?utf-8?B?cWpXQzRQRTlFWXZvSjErZjhQczZIeDk2cFUzYVdrRFNpR0g4bVRVNWt6dTIz?=
 =?utf-8?B?WlEvZkpHRG5EQlZRY3pvQ01FRURSVW9wbkR3YTcyc0hhT0dLdzFyU0RXKzEv?=
 =?utf-8?B?eGZCeE1zUDgzbFpaYmk1UEZMS3VGNE5Xd1BMeVEvYkRQSnlxenNpSUVBT0Na?=
 =?utf-8?B?QXVzcWlUM1VEZGFYSTc0YVBBYndNV0p0TkdJMW5wLzYybnV0ZVhmcWh1VmxW?=
 =?utf-8?B?R21qb1Vpb1o1UWRJdUpVdHRYaXNsSmFNUEdMcnpFU3RlR0VuUHdoaExiZ2VY?=
 =?utf-8?B?NDVkMVV0czJRUXNweUJFWTZJaGtuZ00zRjRvNGthY1RHN3M1RFFra3MxbUty?=
 =?utf-8?B?QmloVFpzYVlJUFlzM3UwYlAyZmFQQitaMDhnVkd5aE5RY3hSNS9IWmdoWFRx?=
 =?utf-8?B?RlpOS1dQYmUxR1RxWFR5Vk1pcjhYVHhIemk5QytHSm1GMFRBdGxuWlN0MmFh?=
 =?utf-8?B?dnowOSs5V1BUc3RWbmZYTHZvN1FDRTZpUXltV3poZ25HSzFld3ltVUdLcE1H?=
 =?utf-8?B?UkdxZmxUNWVva0hQR1J3NmJmQjBEZjgyamZJNTNUTXBSMXJUYk5VRlRRVlV3?=
 =?utf-8?B?VzFYTHZXREZQSVZaQnN5ZGRjdXFOZTUxQ0hyRnlJOGxEVWpqdGJDWU4wYW5G?=
 =?utf-8?B?Nk9BbHlhdURERzFaL2dsZng2amNPQTVFSmlnQTY5MjZvNThmWGNpekoxTTIx?=
 =?utf-8?B?WGxLUlRWMndTakxKbjZFektzYURveDNtNUVUb2NRcjVXN1IrV2ZSL1F6NDNJ?=
 =?utf-8?B?MnNaVkQrSHFPb3JNWjJZckFpMEtpaVhLMC8vWWh5ZUY2RFh1bFFHMUNMaHV2?=
 =?utf-8?B?YjZNZDg2UVphblBEWFRORHNDc0ZvRUNFbUhOa2VUaW9ZdUI1TmZ3OW4rd3Fs?=
 =?utf-8?B?QWhxRFhLYnFidkN3eXlpY0JrdWQ1VENHQjB1Nzh0TXVBTFROVzM0Ry9wQWpM?=
 =?utf-8?B?TGlHMUpWQmwySFJtaFIxbGs0dzVEc3RENTBJSGU4OWpRSDZza21paTFVUW5F?=
 =?utf-8?Q?IPtxpe?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QjNpSUUyMFFxR0pSV200QnB0SS9kZmgzV0RiNE91SGIxZWRQcGh4Tjh3ekR1?=
 =?utf-8?B?ckswc1VYL0s0c2VvZ1p0MnJqazg0aDkrcnE2Vmthdm9icHlBYmc1V2pjY0d6?=
 =?utf-8?B?VWw2a1k2VzlTVVRJYmhmOHFQMDFMZ1F6Y2U3Z0Uvb2JyN3dkRnhpMFpmaWph?=
 =?utf-8?B?YUxQTTBkeU1KYzEzTjFmOTByblpvaVlmNHRRbCtLdVVXRHI5Z2tyZHFCL2hu?=
 =?utf-8?B?UVBzUVdXYVVkenJndWNtMVZIV2ozV2xFaGVKcEFhZmQrZ240TVdkRGtnN2tD?=
 =?utf-8?B?L244ZGJPTVQ1WE5EanFycmpXRFcwOHgxT2d4YjNxWTBvSVNJeDdhNEZ3aTY5?=
 =?utf-8?B?eWVIVmJyeWd0Z3YyTFNCT3NhNnFLNlZRYVZiUk1ob05uaXZpRktHYlV5L1VJ?=
 =?utf-8?B?NGJmd3ZXV05tWk8wVzI2dUhSbmdWRFNOTHhNRjRLTmhxK0s4Y01SRjAwYnFt?=
 =?utf-8?B?Qk9SMnZGUFNUMm8rYnpNazNOencvN1pLNzd2ZDBIaUNEcG1Ydnp5SFN4RnA2?=
 =?utf-8?B?OHdwN3UwcWhRQzBiZGdQZWRpY2JHbXBNTk5XZHRkNHdmbDhiRnI1OGhuT3Nv?=
 =?utf-8?B?ajhIcGozb1MyNDhFcm1RUUJ0OFZSWXZiMStBL3ZGNzZzNWtycXVoV1BjRkM5?=
 =?utf-8?B?YU5TeTE0QUFBNC91NmsrME9TaG55S1RqdGpSWVdST1BGNW8yc2xCVVNmREQ5?=
 =?utf-8?B?ejVDMC9vaHVaWjVicy84VGRrVU9SNlhwdk4wOWNraHg1V3VkME00S0s1SURa?=
 =?utf-8?B?YXY1S2ZuMHJaY293QWN0Yk12dE5DcThGUlNVc2xLMGtEZko1ZVJwNy95NVFh?=
 =?utf-8?B?SXUvT1l5djdtaWpaNmZWVkFDQWUzUHR1V1M4VHp4NFhaVFhlRzhMZDVtK3Z0?=
 =?utf-8?B?N2ZCUGNBSUw4WTFsamt5dGhhUnlQek9ycVMvTmp1RVRaN0lPSjVzbTJXVUJD?=
 =?utf-8?B?Y1l0K1NyZ3lxdmJodTBMQm9JTjV1YzlKTDBwM0dPYkg4NmxsZ2JWNjdBNENJ?=
 =?utf-8?B?Yml0ZTVSaExOdHo4aVlhUGZzc2ZjWmgvYzZDb2J1d2VhNjB6TEpzRXRkS0hZ?=
 =?utf-8?B?aXlHQitKZ0h6SXZaT1ljdW82aHNuZjJYS3FReDM4WHd0UjJYNTFFeGxVZlM3?=
 =?utf-8?B?VEtLRlJTYUgwYzBrSUJxRUtrUmJWRzJHdk0wUnkvYVNiS3ZoWTBvSzR5MEZr?=
 =?utf-8?B?SHNmOFNqUWhObmUzamtWMThwV0tkRHU2Sy9DM0RWUUVSUVpyM09mK0RLWGx3?=
 =?utf-8?B?Rzdpdmh4Q2dZODI0aWNTVWw4emdBUGZSUTN3QS84WURsNy81SmRlUlo5SDVB?=
 =?utf-8?B?NWUvRldWTitOZzk1L1RXcC9sRjBmQzdoQ3dvL3VwTkovWmdjQkorYXdYNFh4?=
 =?utf-8?B?a3d5RkxXajlmNnV3bmtEaHh3Zm5zQlNqQi90emZJdUlRV3FBUlJVUjdTT2lC?=
 =?utf-8?B?OGZiQU1LNE5CMnNKU1grejhxV3dIaWI5NFJpeUNiT2FzVUR4SjdDdUZIa2h0?=
 =?utf-8?B?Mm40L29PTXNEdy9WU1Y3ZS8rQ1BpKzVGUEl0a3hvUTJZaVpJaDN1bHJIY2dL?=
 =?utf-8?B?VEhGbVA1UTdxVUl1NDV1ODA2UlloNVdRb0Q1blRjbm9jWStxT2RmNm5PeDNL?=
 =?utf-8?B?Y3g4ZDBoOENwalhWUkNnSk10YnZPL2hjQUprUXJpeW5wR2dLcTA1TFBFdWFF?=
 =?utf-8?B?WUhsSkdwOHVId0RHZWpuS3doMFVObXZXdmROMkRXeWRLM0VtZ1dwaEFabVdI?=
 =?utf-8?B?TDA4VjFJRmpSc1pPcjYwb04xNHJEVnIvb1h6Y05ZNC80M3hUZW9WRjhxU1Zj?=
 =?utf-8?B?UzlhUGdzYzVTTFUxNE0remZ4WlVLcUFCZzZ6b21uVjRzalFoRFNQRDBDVmhl?=
 =?utf-8?B?dUlvL0o4bGpCb0JENWt6STBEZHVlV1RremR1M3RUbEdpTzZRNU51c3c0UnJG?=
 =?utf-8?B?Nk5INi9OVkxxaEx1QUpqTmVqaXZMbm9wN2F1cGJYNjh3NUNZVk5BM01rZDBD?=
 =?utf-8?B?OTdWaUZyS2VuWmpKc3JsNFI1OHFsajNQZm5TMjg4QmIvakErWjM0dzlVYTNZ?=
 =?utf-8?B?NU96TTB0SmhSNi9EQ0s4a0I0RThsYkRWMHk4QXZ1RTkwVkx5cFd3MFdlbjJk?=
 =?utf-8?B?NnVXWG8zSnY1bW5ZdFJYRVNPZlEreGN4QkkveVZ5eHUzL2dNV0xJalhET0R0?=
 =?utf-8?Q?yCaZRxA+OgkiAhhT9v4CwBSvzXTyLxvjEp2DbDBEKiYX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2352A9959C2388479B354F7281A42DD7@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c7e817-9573-49c0-842a-08de131f4e40
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 17:03:51.0405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LN6A+YIs25lIpjpPRADKYP2Q5NM1SghubzRZzbSy42dIEaIvi578fb/Nnyn7R63m5pD0Ck2Dlqmhaw32rzwkQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4369
X-Proofpoint-GUID: fKxYk_tJKlGY0pifEXzwITKnVIsJLtJ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI0MDE1NCBTYWx0ZWRfXz6xrn9yT3/4H
 6M86QbmqL2GrrSHYS55+2C9MGwQ5Pk5b1gBAtKwInn7n+RB/J6M4eFholuIAiULGJovj8uZAwSP
 lnn2/kIHh3RZvf6oGuJD69ZNz9fqNOzzkTtpQeTZMa8oj/7N/mk+RWIgIr+RKz2iFMXVADeNcrJ
 yTdNh+8BiqTMiBdh104aLNnsuAyDPrIG+dbXqSkHekHIhkVza/nlNmtf9g65N7lYjc9dEtSKz8Z
 sz5Kf0uPB8X/XPF598/PBoeM1evIBsSjYVDknVAEd7AEelVrg7XjTNHOZC+SEE0l52dqYEWZfvb
 5EDLdIPxIE29+Dv5EWBbPNqJgQYxYVsTp+ASxocTcn+bA5PNL0R62Kq4P3+TyekHRF6kpXoPc9r
 J1tB05vXFS2CX/HfXVNT0FFQfJYhrw==
X-Authority-Analysis: v=2.4 cv=F5Rat6hN c=1 sm=1 tr=0 ts=68fbb179 cx=c_pps
 a=Rzgcbe2yxP2fEJMfMKkCcw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=meVymXHHAAAA:8 a=VabnemYjAAAA:8
 a=8kGBJsgqBmNMGdTerZwA:9 a=QEXdDO2ut3YA:10 a=2JgSa4NbpEOStq-L5dxp:22
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: fKxYk_tJKlGY0pifEXzwITKnVIsJLtJ7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_03,2025-10-22_01,2025-03-28_01

DQoNCj4gT24gT2N0IDI0LCAyMDI1LCBhdCA5OjIx4oCvQU0sIFN0ZXZlbiBSb3N0ZWR0IDxyb3N0
ZWR0QGdvb2RtaXMub3JnPiB3cm90ZToNCj4gDQo+IE9uIEZyaSwgMjQgT2N0IDIwMjUgMTU6NDc6
MDQgKzAwMDANCj4gU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQG1ldGEuY29tPiB3cm90ZToNCj4g
DQo+Pj4+IC0tLSBhL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KPj4+PiArKysgYi9rZXJuZWwvdHJh
Y2UvZnRyYWNlLmMNCj4+Pj4gQEAgLTIwMjAsOCArMjAyMCw2IEBAIHN0YXRpYyBpbnQgX19mdHJh
Y2VfaGFzaF91cGRhdGVfaXBtb2RpZnkoc3RydWN0IGZ0cmFjZV9vcHMgKm9wcywNCj4+Pj4gaWYg
KGlzX2lwbW9kaWZ5KQ0KPj4+PiBnb3RvIHJvbGxiYWNrOw0KPj4+PiANCj4+Pj4gLSBGVFJBQ0Vf
V0FSTl9PTihyZWMtPmZsYWdzICYgRlRSQUNFX0ZMX0RJUkVDVCk7ICANCj4+PiANCj4+PiB3aHkg
aXMgdGhpcyBuZWVkZWQ/ICANCj4+IA0KPj4gVGhpcyBpcyBuZWVkZWQgZm9yIHRoZSBtb2RpZnlf
ZnRyYWNlX2RpcmVjdCBjYXNlLCBiZWNhdXNlIA0KPj4gdGhlIHJlY29yZCBhbHJlYWR5IGhhdmUg
YSBkaXJlY3QgZnVuY3Rpb24gKEJQRiB0cmFtcG9saW5lKQ0KPj4gYXR0YWNoZWQuDQo+IA0KPiBJ
IGRvbid0IGxpa2UgdGhlIGZhY3QgdGhhdCBpdCdzIHJlbW92aW5nIGEgY2hlY2sgZm9yIG90aGVy
IGNhc2VzLg0KDQpBY2tlZCB0aGF0IHJlbW92aW5nIGNoZWNrIGZvciBvdGhlciBjYXNlcyBpcyBu
b3QgaWRlYWwuIA0KDQpJIGxvb2tlZCBhdCB0aGUgY29kZSBhIGJpdCBtb3JlIGFuZCBnb3QgYSBz
bGlnaHRseSBkaWZmZXJlbnQNCnZlcnNpb24gKGF0dGFjaGVkIGJlbG93KS4gDQoNClRoZSBiYXNp
YyBpZGVhIGlzIHRvIGxlYXZlIGV4aXN0aW5nIGZ0cmFjZV9oYXNoX2lwbW9kaWZ5XyogDQpsb2dp
Y2FsbHkgdGhlIHNhbWUsIGFuZCBjYWxsIF9fZnRyYWNlX2hhc2hfdXBkYXRlX2lwbW9kaWZ5IA0K
ZGlyZWN0bHkgZnJvbSBfX21vZGlmeV9mdHJhY2VfZGlyZWN0KCkuIA0KDQpJIHRoaW5rIHRoaXMg
aXMgbG9naWNhbGx5IGNsZWFuZXIuIA0KDQpEb2VzIHRoaXMgbWFrZSBzZW5zZT8gDQoNClRoYW5r
cywNClNvbmcNCg0KDQoNCg0KDQpkaWZmIC0tZ2l0IGkva2VybmVsL3RyYWNlL2Z0cmFjZS5jIHcv
a2VybmVsL3RyYWNlL2Z0cmFjZS5jDQppbmRleCAzNzBmNjIwNzM0Y2YuLjRmNjc0NWRkZGMzNSAx
MDA2NDQNCi0tLSBpL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KKysrIHcva2VybmVsL3RyYWNlL2Z0
cmFjZS5jDQpAQCAtMTk3MSw3ICsxOTcxLDggQEAgc3RhdGljIHZvaWQgZnRyYWNlX2hhc2hfcmVj
X2VuYWJsZV9tb2RpZnkoc3RydWN0IGZ0cmFjZV9vcHMgKm9wcykNCiAgKi8NCiBzdGF0aWMgaW50
IF9fZnRyYWNlX2hhc2hfdXBkYXRlX2lwbW9kaWZ5KHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMsDQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBmdHJhY2VfaGFz
aCAqb2xkX2hhc2gsDQotICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0
cnVjdCBmdHJhY2VfaGFzaCAqbmV3X2hhc2gpDQorICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHN0cnVjdCBmdHJhY2VfaGFzaCAqbmV3X2hhc2gsDQorICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJvb2wgdXBkYXRlX3RhcmdldCkNCiB7DQogICAg
ICAgIHN0cnVjdCBmdHJhY2VfcGFnZSAqcGc7DQogICAgICAgIHN0cnVjdCBkeW5fZnRyYWNlICpy
ZWMsICplbmQgPSBOVUxMOw0KQEAgLTIwMDYsMTAgKzIwMDcsMTMgQEAgc3RhdGljIGludCBfX2Z0
cmFjZV9oYXNoX3VwZGF0ZV9pcG1vZGlmeShzdHJ1Y3QgZnRyYWNlX29wcyAqb3BzLA0KICAgICAg
ICAgICAgICAgIGlmIChyZWMtPmZsYWdzICYgRlRSQUNFX0ZMX0RJU0FCTEVEKQ0KICAgICAgICAg
ICAgICAgICAgICAgICAgY29udGludWU7DQoNCi0gICAgICAgICAgICAgICAvKiBXZSBuZWVkIHRv
IHVwZGF0ZSBvbmx5IGRpZmZlcmVuY2VzIG9mIGZpbHRlcl9oYXNoICovDQorICAgICAgICAgICAg
ICAgLyoNCisgICAgICAgICAgICAgICAgKiBVbmxlc3Mgd2UgYXJlIHVwZGF0aW5nIHRoZSB0YXJn
ZXQgb2YgYSBkaXJlY3QgZnVuY3Rpb24sDQorICAgICAgICAgICAgICAgICogd2Ugb25seSBuZWVk
IHRvIHVwZGF0ZSBkaWZmZXJlbmNlcyBvZiBmaWx0ZXJfaGFzaA0KKyAgICAgICAgICAgICAgICAq
Lw0KICAgICAgICAgICAgICAgIGluX29sZCA9ICEhZnRyYWNlX2xvb2t1cF9pcChvbGRfaGFzaCwg
cmVjLT5pcCk7DQogICAgICAgICAgICAgICAgaW5fbmV3ID0gISFmdHJhY2VfbG9va3VwX2lwKG5l
d19oYXNoLCByZWMtPmlwKTsNCi0gICAgICAgICAgICAgICBpZiAoaW5fb2xkID09IGluX25ldykN
CisgICAgICAgICAgICAgICBpZiAoIXVwZGF0ZV90YXJnZXQgJiYgKGluX29sZCA9PSBpbl9uZXcp
KQ0KICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQoNCiAgICAgICAgICAgICAgICBp
ZiAoaW5fbmV3KSB7DQpAQCAtMjAyMCw2ICsyMDI0LDE3IEBAIHN0YXRpYyBpbnQgX19mdHJhY2Vf
aGFzaF91cGRhdGVfaXBtb2RpZnkoc3RydWN0IGZ0cmFjZV9vcHMgKm9wcywNCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgaWYgKGlzX2lwbW9kaWZ5KQ0KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGdvdG8gcm9sbGJhY2s7DQoNCisgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgLyoNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogSWYg
dGhpcyBpcyBjYWxsZWQgYnkgX19tb2RpZnlfZnRyYWNlX2RpcmVjdCgpDQorICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAqIHRoZW4gaXQgaXMgb25seSBjaGFuaW5nIHdoZXJlIHRoZSBk
aXJlY3QNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogcG9pbnRlciBpcyBqdW1w
aW5nIHRvLCBhbmQgdGhlIHJlY29yZCBhbHJlYWR5DQorICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAqIHBvaW50cyB0byBhIGRpcmVjdCB0cmFtcG9saW5lLiBJZiBpdCBpc24ndA0KKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKiB0aGVuIGl0IGlzIGEgYnVnIHRvIHVwZGF0
ZSBpcG1vZGlmeSBvbiBhIGRpcmVjdA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
KiBjYWxsZXIuDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqLw0KKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBGVFJBQ0VfV0FSTl9PTighdXBkYXRlX3RhcmdldCAmJg0K
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAocmVjLT5mbGFn
cyAmIEZUUkFDRV9GTF9ESVJFQ1QpKTsNCisNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgLyoNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogQW5vdGhlciBvcHMgd2l0
aCBJUE1PRElGWSBpcyBhbHJlYWR5DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAq
IGF0dGFjaGVkLiBXZSBhcmUgbm93IGF0dGFjaGluZyBhIGRpcmVjdA0KQEAgLTIwNzQsNyArMjA4
OSw3IEBAIHN0YXRpYyBpbnQgZnRyYWNlX2hhc2hfaXBtb2RpZnlfZW5hYmxlKHN0cnVjdCBmdHJh
Y2Vfb3BzICpvcHMpDQogICAgICAgIGlmIChmdHJhY2VfaGFzaF9lbXB0eShoYXNoKSkNCiAgICAg
ICAgICAgICAgICBoYXNoID0gTlVMTDsNCg0KLSAgICAgICByZXR1cm4gX19mdHJhY2VfaGFzaF91
cGRhdGVfaXBtb2RpZnkob3BzLCBFTVBUWV9IQVNILCBoYXNoKTsNCisgICAgICAgcmV0dXJuIF9f
ZnRyYWNlX2hhc2hfdXBkYXRlX2lwbW9kaWZ5KG9wcywgRU1QVFlfSEFTSCwgaGFzaCwgZmFsc2Up
Ow0KIH0NCg0KIC8qIERpc2FibGluZyBhbHdheXMgc3VjY2VlZHMgKi8NCkBAIC0yMDg1LDcgKzIx
MDAsNyBAQCBzdGF0aWMgdm9pZCBmdHJhY2VfaGFzaF9pcG1vZGlmeV9kaXNhYmxlKHN0cnVjdCBm
dHJhY2Vfb3BzICpvcHMpDQogICAgICAgIGlmIChmdHJhY2VfaGFzaF9lbXB0eShoYXNoKSkNCiAg
ICAgICAgICAgICAgICBoYXNoID0gTlVMTDsNCg0KLSAgICAgICBfX2Z0cmFjZV9oYXNoX3VwZGF0
ZV9pcG1vZGlmeShvcHMsIGhhc2gsIEVNUFRZX0hBU0gpOw0KKyAgICAgICBfX2Z0cmFjZV9oYXNo
X3VwZGF0ZV9pcG1vZGlmeShvcHMsIGhhc2gsIEVNUFRZX0hBU0gsIGZhbHNlKTsNCiB9DQoNCiBz
dGF0aWMgaW50IGZ0cmFjZV9oYXNoX2lwbW9kaWZ5X3VwZGF0ZShzdHJ1Y3QgZnRyYWNlX29wcyAq
b3BzLA0KQEAgLTIwOTksNyArMjExNCw3IEBAIHN0YXRpYyBpbnQgZnRyYWNlX2hhc2hfaXBtb2Rp
ZnlfdXBkYXRlKHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMsDQogICAgICAgIGlmIChmdHJhY2VfaGFz
aF9lbXB0eShuZXdfaGFzaCkpDQogICAgICAgICAgICAgICAgbmV3X2hhc2ggPSBOVUxMOw0KDQot
ICAgICAgIHJldHVybiBfX2Z0cmFjZV9oYXNoX3VwZGF0ZV9pcG1vZGlmeShvcHMsIG9sZF9oYXNo
LCBuZXdfaGFzaCk7DQorICAgICAgIHJldHVybiBfX2Z0cmFjZV9oYXNoX3VwZGF0ZV9pcG1vZGlm
eShvcHMsIG9sZF9oYXNoLCBuZXdfaGFzaCwgZmFsc2UpOw0KIH0NCg0KIHN0YXRpYyB2b2lkIHBy
aW50X2lwX2lucyhjb25zdCBjaGFyICpmbXQsIGNvbnN0IHVuc2lnbmVkIGNoYXIgKnApDQpAQCAt
NjEwNiw3ICs2MTIxLDcgQEAgRVhQT1JUX1NZTUJPTF9HUEwodW5yZWdpc3Rlcl9mdHJhY2VfZGly
ZWN0KTsNCiBzdGF0aWMgaW50DQogX19tb2RpZnlfZnRyYWNlX2RpcmVjdChzdHJ1Y3QgZnRyYWNl
X29wcyAqb3BzLCB1bnNpZ25lZCBsb25nIGFkZHIpDQogew0KLSAgICAgICBzdHJ1Y3QgZnRyYWNl
X2hhc2ggKmhhc2g7DQorICAgICAgIHN0cnVjdCBmdHJhY2VfaGFzaCAqaGFzaCA9IG9wcy0+ZnVu
Y19oYXNoLT5maWx0ZXJfaGFzaDsNCiAgICAgICAgc3RydWN0IGZ0cmFjZV9mdW5jX2VudHJ5ICpl
bnRyeSwgKml0ZXI7DQogICAgICAgIHN0YXRpYyBzdHJ1Y3QgZnRyYWNlX29wcyB0bXBfb3BzID0g
ew0KICAgICAgICAgICAgICAgIC5mdW5jICAgICAgICAgICA9IGZ0cmFjZV9zdHViLA0KQEAgLTYx
MzEsNyArNjE0Niw3IEBAIF9fbW9kaWZ5X2Z0cmFjZV9kaXJlY3Qoc3RydWN0IGZ0cmFjZV9vcHMg
Km9wcywgdW5zaWduZWQgbG9uZyBhZGRyKQ0KICAgICAgICAgKiBvcHMtPm9wc19mdW5jIGZvciB0
aGUgb3BzLiBUaGlzIGlzIG5lZWRlZCBiZWNhdXNlIHRoZSBhYm92ZQ0KICAgICAgICAgKiByZWdp
c3Rlcl9mdHJhY2VfZnVuY3Rpb25fbm9sb2NrKCkgd29ya2VkIG9uIHRtcF9vcHMuDQogICAgICAg
ICAqLw0KLSAgICAgICBlcnIgPSBmdHJhY2VfaGFzaF9pcG1vZGlmeV9lbmFibGUob3BzKTsNCisg
ICAgICAgZXJyID0gX19mdHJhY2VfaGFzaF91cGRhdGVfaXBtb2RpZnkob3BzLCBoYXNoLCBoYXNo
LCB0cnVlKTsNCiAgICAgICAgaWYgKGVycikNCiAgICAgICAgICAgICAgICBnb3RvIG91dDsNCg0K
QEAgLTYxNDEsNyArNjE1Niw2IEBAIF9fbW9kaWZ5X2Z0cmFjZV9kaXJlY3Qoc3RydWN0IGZ0cmFj
ZV9vcHMgKm9wcywgdW5zaWduZWQgbG9uZyBhZGRyKQ0KICAgICAgICAgKi8NCiAgICAgICAgbXV0
ZXhfbG9jaygmZnRyYWNlX2xvY2spOw0KDQotICAgICAgIGhhc2ggPSBvcHMtPmZ1bmNfaGFzaC0+
ZmlsdGVyX2hhc2g7DQogICAgICAgIHNpemUgPSAxIDw8IGhhc2gtPnNpemVfYml0czsNCiAgICAg
ICAgZm9yIChpID0gMDsgaSA8IHNpemU7IGkrKykgew0KICAgICAgICAgICAgICAgIGhsaXN0X2Zv
cl9lYWNoX2VudHJ5KGl0ZXIsICZoYXNoLT5idWNrZXRzW2ldLCBobGlzdCkgew0KDQoNCg0KDQo=

